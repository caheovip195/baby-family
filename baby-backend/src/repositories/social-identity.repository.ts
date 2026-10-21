import {
  enqueueTransactionalMail,
  recordVerifiedIdentityEmail,
} from './transactional-mail-outbox';
import { Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import type { AuthProvider } from '../common/database.enums';
import { DomainError } from '../common/errors/domain.error';
import { ACCOUNT_SECURITY_POLICY } from '../config/account-security-policy';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { ISocialIdentityRepository } from '../interfaces/repositories/social-identity-repository.interface';
import type {
  NewSessionInput,
  PhoneSignInResult,
} from '../interfaces/repositories/auth-session-repository.interface';
import type { VerifiedExternalIdentity } from '../interfaces/services/external-identity-verifier.interface';
import { AuthIdentity } from '../models/auth-identity.model';
import { User } from '../models/user.model';
import { UserSession } from '../models/user-session.model';
type Tx = Prisma.TransactionClient;
@Injectable()
export class SocialIdentityRepository implements ISocialIdentityRepository {
  constructor(private readonly prisma: PrismaService) {}
  private async retry<T>(run: () => Promise<T>): Promise<T> {
    for (let attempt = 0; ; attempt++) {
      try {
        return await run();
      } catch (error) {
        if (
          !(error instanceof Prisma.PrismaClientKnownRequestError) ||
          !['P2002', 'P2034'].includes(error.code) ||
          attempt + 1 >= ACCOUNT_SECURITY_POLICY.transactionAttempts
        )
          throw error;
      }
    }
  }
  private async lockActor(tx: Tx, actor: AuthPrincipal) {
    await tx.$queryRaw`SELECT id FROM app.users WHERE id = ${actor.userId}::uuid FOR UPDATE`;
    const now = new Date();
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
          status: 'ACTIVE',
          tokenVersion: actor.tokenVersion,
        },
      },
    });
    if (!session)
      throw new DomainError(
        'An active account and session are required.',
        'AUTH_ACCOUNT_UNAVAILABLE',
        403,
      );
  }
  signIn(
    identity: VerifiedExternalIdentity,
    displayName: string,
    session: NewSessionInput,
    now: Date,
  ): Promise<PhoneSignInResult> {
    return this.retry(() =>
      this.prisma.$transaction(async (tx) => {
        let row = await tx.authIdentity.findUnique({
          where: {
            provider_providerUid: {
              provider: identity.provider,
              providerUid: identity.subject,
            },
          },
          include: { user: true },
        });
        let created = false;
        if (!row) {
          const user = await tx.user.create({
            data: { displayName, locale: 'vi', timezone: 'Asia/Ho_Chi_Minh' },
          });
          row = await tx.authIdentity.create({
            data: {
              userId: user.id,
              provider: identity.provider,
              providerUid: identity.subject,
              email: identity.email,
              lastUsedAt: now,
            },
            include: { user: true },
          });
          created = true;
        }
        await tx.$queryRaw`SELECT id FROM app.users WHERE id = ${row.userId}::uuid FOR UPDATE`;
        const fresh = await tx.authIdentity.findUniqueOrThrow({
          where: { id: row.id },
          include: { user: true },
        });
        const user = fresh.user;
        const grace =
          user.status === 'DELETION_PENDING' &&
          (await tx.deletionRequest.findFirst({
            where: {
              userId: user.id,
              status: 'SCHEDULED',
              deletedAt: null,
              executeAfter: { gt: now },
            },
          }));
        if (
          fresh.deletedAt ||
          user.deletedAt ||
          (user.status !== 'ACTIVE' && !grace)
        )
          return { kind: 'USER_UNAVAILABLE' };
        const saved = await tx.userSession.create({
          data: {
            userId: user.id,
            refreshTokenHash: new Uint8Array(session.refreshTokenHash),
            expiresAt: session.expiresAt,
            absoluteExpiresAt: session.absoluteExpiresAt,
            platform: session.platform,
            appVersion: session.appVersion,
            ipCreated: session.ip,
            lastUsedAt: now,
          },
        });
        await tx.authIdentity.update({
          where: { id: fresh.id },
          data: { lastUsedAt: now, email: identity.email },
        });
        await recordVerifiedIdentityEmail(tx, fresh.id, identity.email);
        await tx.user.update({
          where: { id: user.id },
          data: { lastActiveAt: now },
        });
        return {
          kind: 'SIGNED_IN',
          user: new User({ ...user }),
          session: new UserSession({
            ...saved,
            refreshTokenHash: new Uint8Array(saved.refreshTokenHash),
          }),
          created,
        };
      }),
    );
  }
  list(actor: AuthPrincipal) {
    return this.prisma.$transaction(async (tx) => {
      await this.lockActor(tx, actor);
      const rows = await tx.authIdentity.findMany({
        where: { userId: actor.userId, deletedAt: null },
        orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      });
      return rows.map(
        (row) =>
          new AuthIdentity({
            ...row,
            providerRefreshTokenEnc: row.providerRefreshTokenEnc
              ? new Uint8Array(row.providerRefreshTokenEnc)
              : null,
          }),
      );
    });
  }
  link(
    actor: AuthPrincipal,
    identity: VerifiedExternalIdentity,
  ): Promise<void> {
    return this.retry(() =>
      this.prisma.$transaction(async (tx) => {
        await this.lockActor(tx, actor);
        const existing = await tx.authIdentity.findUnique({
          where: {
            provider_providerUid: {
              provider: identity.provider,
              providerUid: identity.subject,
            },
          },
        });
        if (existing && existing.userId !== actor.userId)
          throw new DomainError(
            'This identity belongs to another account.',
            'IDENTITY_IN_USE',
            409,
          );
        const other = await tx.authIdentity.findFirst({
          where: {
            userId: actor.userId,
            provider: identity.provider,
            deletedAt: null,
            providerUid: { not: identity.subject },
          },
        });
        if (other)
          throw new DomainError(
            'This provider is already linked.',
            'IDENTITY_PROVIDER_ALREADY_LINKED',
            409,
          );
        if (existing && !existing.deletedAt) {
          await recordVerifiedIdentityEmail(tx, existing.id, identity.email);
          return;
        }
        if (existing)
          await tx.authIdentity.update({
            where: { id: existing.id },
            data: {
              deletedAt: null,
              email: identity.email,
              lastUsedAt: new Date(),
            },
          });
        else
          await tx.authIdentity.create({
            data: {
              userId: actor.userId,
              provider: identity.provider,
              providerUid: identity.subject,
              email: identity.email,
              lastUsedAt: new Date(),
            },
          });
        const linked = await tx.authIdentity.findUniqueOrThrow({
          where: {
            provider_providerUid: {
              provider: identity.provider,
              providerUid: identity.subject,
            },
          },
        });
        await recordVerifiedIdentityEmail(tx, linked.id, identity.email);
        await enqueueTransactionalMail(
          tx,
          'SIGN_IN_METHOD_ADDED',
          actor.userId,
          actor.userId,
          `${identity.provider}:${identity.subject}:${new Date().toISOString()}`,
        );
      }),
    );
  }
  unlink(actor: AuthPrincipal, provider: AuthProvider): Promise<void> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockActor(tx, actor);
      const rows = await tx.authIdentity.findMany({
        where: { userId: actor.userId, deletedAt: null },
      });
      const targets = rows.filter((row) => row.provider === provider);
      if (!targets.length) return;
      if (rows.length === targets.length)
        throw new DomainError(
          'The last sign-in method cannot be removed.',
          'LAST_SIGN_IN_METHOD',
          409,
        );
      await tx.authIdentity.updateMany({
        where: { userId: actor.userId, provider, deletedAt: null },
        data: { deletedAt: new Date() },
      });
    });
  }
  assertOwned(
    actor: AuthPrincipal,
    identity: VerifiedExternalIdentity,
  ): Promise<void> {
    return this.prisma.$transaction(async (tx) => {
      await this.lockActor(tx, actor);
      const owned = await tx.authIdentity.findFirst({
        where: {
          userId: actor.userId,
          provider: identity.provider,
          providerUid: identity.subject,
          deletedAt: null,
        },
      });
      if (!owned)
        throw new DomainError(
          'Use a linked sign-in method.',
          'REAUTH_IDENTITY_REQUIRED',
          401,
        );
    });
  }
}
