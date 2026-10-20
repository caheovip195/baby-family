import type { AuthPrincipal } from '../common/auth/auth-principal';
import { Injectable } from '@nestjs/common';
import { ACCOUNT_SECURITY_POLICY } from '../config/account-security-policy';
import { Prisma } from '../generated/prisma/client';
import type {
  User as UserRow,
  UserSession as UserSessionRow,
} from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import type {
  IAuthSessionRepository,
  PhoneSignInInput,
  PhoneSignInResult,
  RotateSessionInput,
  RotateSessionResult,
} from '../interfaces/repositories/auth-session-repository.interface';
import { User } from '../models/user.model';
import { UserSession } from '../models/user-session.model';

type Tx = Prisma.TransactionClient;

function mapUser(row: UserRow): User {
  return new User({ ...row });
}

function mapSession(row: UserSessionRow): UserSession {
  return new UserSession({
    ...row,
    refreshTokenHash: new Uint8Array(row.refreshTokenHash),
  });
}

/** Bounds the reuse-revocation walk; real chains are far shorter. */
const MAX_CHAIN = 10_000;

@Injectable()
export class AuthSessionRepository implements IAuthSessionRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findReauthPhone(
    actor: AuthPrincipal,
    now: Date,
  ): Promise<string | null> {
    return this.prisma.$transaction(
      async (tx) => {
        const session = await tx.userSession.findFirst({
          where: {
            id: actor.sessionId,
            userId: actor.userId,
            deletedAt: null,
            revokedAt: null,
            replacedBy: null,
            expiresAt: { gt: now },
            absoluteExpiresAt: { gt: now },
            user: {
              deletedAt: null,
              tokenVersion: actor.tokenVersion,
              status: { in: ['ACTIVE', 'DELETION_PENDING'] },
            },
          },
          select: { user: { select: { status: true } } },
        });
        if (!session) return null;
        if (
          session.user.status === 'DELETION_PENDING' &&
          !(await tx.deletionRequest.findFirst({
            where: {
              userId: actor.userId,
              status: 'SCHEDULED',
              deletedAt: null,
              executeAfter: { gt: now },
            },
            select: { id: true },
          }))
        )
          return null;
        const identity = await tx.authIdentity.findFirst({
          where: { userId: actor.userId, provider: 'PHONE', deletedAt: null },
          orderBy: { createdAt: 'asc' },
          select: { providerUid: true },
        });
        return identity?.providerUid ?? null;
      },
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
  }

  async signInWithPhone(input: PhoneSignInInput): Promise<PhoneSignInResult> {
    for (let attempt = 1; ; attempt++) {
      try {
        return await this.signInOnce(input);
      } catch (error) {
        // Concurrent identity creation and phone-change lock inversions both
        // require retrying the entire rolled-back sign-in transaction.
        if (
          !(error instanceof Prisma.PrismaClientKnownRequestError) ||
          !['P2002', 'P2034'].includes(error.code) ||
          attempt >= ACCOUNT_SECURITY_POLICY.transactionAttempts
        )
          throw error;
      }
    }
  }

  private signInOnce(input: PhoneSignInInput): Promise<PhoneSignInResult> {
    return this.prisma.$transaction(async (tx) => {
      let created = false;
      let identity = await tx.authIdentity.findFirst({
        where: {
          provider: 'PHONE',
          providerUid: input.phoneE164,
          deletedAt: null,
        },
        include: { user: true },
      });
      if (!identity) {
        // Unique (provider, provider_uid) serialises concurrent first sign-ins.
        const user = await tx.user.create({
          data: {
            displayName: input.initialDisplayName,
            locale: input.locale,
            timezone: input.timezone,
          },
        });
        identity = await tx.authIdentity.create({
          data: {
            userId: user.id,
            provider: 'PHONE',
            providerUid: input.phoneE164,
            lastUsedAt: input.now,
          },
          include: { user: true },
        });
        created = true;
      } else {
        await tx.authIdentity.update({
          where: { id: identity.id },
          data: { lastUsedAt: input.now },
        });
      }
      const user = identity.user;
      // Serialize grace sign-in with deletion scheduling/execution/cancellation.
      await tx.$queryRaw`SELECT id FROM app.users WHERE id = ${user.id}::uuid FOR UPDATE`;
      const freshUser = await tx.user.findUniqueOrThrow({
        where: { id: user.id },
      });
      Object.assign(user, freshUser);
      // A phone replacement can commit after the initial identity lookup. Do not
      // mint a session for its former owner using proof for the old number.
      const currentIdentity = await tx.authIdentity.findFirst({
        where: {
          id: identity.id,
          userId: user.id,
          provider: 'PHONE',
          providerUid: input.phoneE164,
          deletedAt: null,
        },
        select: { id: true },
      });
      if (!currentIdentity) return { kind: 'USER_UNAVAILABLE' };
      const grace =
        user.status === 'DELETION_PENDING' &&
        (await tx.deletionRequest.findFirst({
          where: {
            userId: user.id,
            status: 'SCHEDULED',
            deletedAt: null,
            executeAfter: { gt: input.now },
          },
        }));
      if ((user.status !== 'ACTIVE' && !grace) || user.deletedAt !== null)
        return { kind: 'USER_UNAVAILABLE' };
      const session = await tx.userSession.create({
        data: {
          userId: user.id,
          refreshTokenHash: new Uint8Array(input.session.refreshTokenHash),
          platform: input.session.platform,
          appVersion: input.session.appVersion,
          ipCreated: input.session.ip,
          lastUsedAt: input.now,
          expiresAt: input.session.expiresAt,
          absoluteExpiresAt: input.session.absoluteExpiresAt,
        },
      });
      await tx.user.update({
        where: { id: user.id },
        data: { lastActiveAt: input.now },
      });
      return {
        kind: 'SIGNED_IN',
        user: mapUser(user),
        session: mapSession(session),
        created,
      };
    });
  }

  rotateSession(input: RotateSessionInput): Promise<RotateSessionResult> {
    return this.prisma.$transaction(async (tx) => {
      const hash = new Uint8Array(input.refreshTokenHash);
      // Row lock: two concurrent refreshes of the same token cannot both rotate.
      const locked = await tx.$queryRaw<{ id: string }[]>`
        SELECT id FROM app.user_sessions
        WHERE refresh_token_hash = ${hash} AND deleted_at IS NULL
        FOR UPDATE`;
      const id = locked[0]?.id;
      if (!id) return { kind: 'INVALID' };
      const current = await tx.userSession.findUniqueOrThrow({
        where: { id },
        include: { user: true },
      });
      if (current.replacedBy !== null) {
        await this.revokeChain(tx, current.id, 'REFRESH_REUSE', input.now);
        return { kind: 'REUSED' };
      }
      const user = current.user;
      if (
        current.revokedAt !== null ||
        current.expiresAt <= input.now ||
        current.absoluteExpiresAt <= input.now ||
        (user.status !== 'ACTIVE' &&
          !(
            user.status === 'DELETION_PENDING' &&
            (await tx.deletionRequest.findFirst({
              where: {
                userId: user.id,
                status: 'SCHEDULED',
                deletedAt: null,
                executeAfter: { gt: input.now },
              },
            }))
          )) ||
        user.deletedAt !== null
      )
        return { kind: 'INVALID' };
      const expiresAt =
        input.slidingExpiresAt < current.absoluteExpiresAt
          ? input.slidingExpiresAt
          : current.absoluteExpiresAt;
      const next = await tx.userSession.create({
        data: {
          userId: current.userId,
          deviceId: current.deviceId,
          refreshTokenHash: new Uint8Array(input.newRefreshTokenHash),
          platform: current.platform,
          appVersion: current.appVersion,
          ipCreated: current.ipCreated,
          lastUsedAt: input.now,
          expiresAt,
          absoluteExpiresAt: current.absoluteExpiresAt,
        },
      });
      await tx.userSession.update({
        where: { id: current.id },
        data: { replacedBy: next.id, lastUsedAt: input.now },
      });
      if (current.deviceId)
        await tx.userDevice.updateMany({
          where: { id: current.deviceId, userId: current.userId },
          data: { lastSeenAt: input.now },
        });
      await tx.user.update({
        where: { id: user.id },
        data: { lastActiveAt: input.now },
      });
      return {
        kind: 'ROTATED',
        user: mapUser(user),
        session: mapSession(next),
      };
    });
  }

  async revokeSession(
    userId: string,
    sessionId: string,
    reason: string,
    now: Date,
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const session = await tx.userSession.findFirst({
        where: { id: sessionId, userId, deletedAt: null },
      });
      if (!session) return;
      await this.revokeChain(tx, session.id, reason, now);
      // Spec §5.5: a signed-out device must not keep receiving pushes.
      if (session.deviceId)
        await tx.userDevice.updateMany({
          where: { id: session.deviceId, userId },
          data: { pushToken: null, pushEnabled: false },
        });
    });
  }

  /** Revokes the given session and every successor reached through replaced_by. */
  private async revokeChain(
    tx: Tx,
    startId: string,
    reason: string,
    now: Date,
  ): Promise<void> {
    const ids: string[] = [];
    let cursor: string | null = startId;
    while (cursor && ids.length < MAX_CHAIN && !ids.includes(cursor)) {
      ids.push(cursor);
      // Lock each link before reading its successor: a rotation of this session
      // running concurrently either committed (its successor is seen and revoked)
      // or waits and then finds the session revoked.
      const rows: { replaced_by: string | null }[] = await tx.$queryRaw`
        SELECT replaced_by FROM app.user_sessions
        WHERE id = ${cursor}::uuid FOR UPDATE`;
      await tx.userSession.updateMany({
        where: { id: cursor, revokedAt: null },
        data: { revokedAt: now, revokeReason: reason },
      });
      cursor = rows[0]?.replaced_by ?? null;
    }
  }
}
