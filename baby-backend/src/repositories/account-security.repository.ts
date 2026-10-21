import { enqueueTransactionalMail } from './transactional-mail-outbox';
import { Injectable } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import { ACCOUNT_SECURITY_POLICY as POLICY } from '../config/account-security-policy';
import { PrismaService } from '../database/prisma.service';
import { Prisma } from '../generated/prisma/client';
import type { IAccountSecurityRepository } from '../interfaces/repositories/account-security-repository.interface';
import { UserDevice } from '../models/user-device.model';
import { UserSession } from '../models/user-session.model';

const active = (now: Date) => ({
  deletedAt: null,
  revokedAt: null,
  replacedBy: null,
  expiresAt: { gt: now },
  absoluteExpiresAt: { gt: now },
});

@Injectable()
export class AccountSecurityRepository implements IAccountSecurityRepository {
  constructor(private readonly prisma: PrismaService) {}

  async listSessions(userId: string, now: Date) {
    const rows = await this.prisma.userSession.findMany({
      where: { userId, ...active(now) },
      include: { userDevice: true },
      orderBy: [{ lastUsedAt: 'desc' }, { id: 'desc' }],
    });
    return rows.map((row) => ({
      session: new UserSession({
        ...row,
        refreshTokenHash: new Uint8Array(row.refreshTokenHash),
      }),
      device:
        row.userDevice && row.userDevice.deletedAt === null
          ? new UserDevice(row.userDevice)
          : null,
    }));
  }

  async findSession(userId: string, sessionId: string, now: Date) {
    const row = await this.prisma.userSession.findFirst({
      where: { id: sessionId, userId, ...active(now) },
    });
    return row
      ? new UserSession({
          ...row,
          refreshTokenHash: new Uint8Array(row.refreshTokenHash),
        })
      : null;
  }

  async isPhoneUsedByAnother(userId: string, phone: string) {
    // The schema's global identity unique constraint also reserves soft-deleted identities.
    return !!(await this.prisma.authIdentity.findFirst({
      where: { provider: 'PHONE', providerUid: phone, userId: { not: userId } },
      select: { id: true },
    }));
  }

  revokeOthers(actor: AuthPrincipal, now: Date) {
    return this.transaction(async (tx) => {
      await this.lockSessions(tx, actor, now);
      return this.revokeOthersInTransaction(tx, actor, now, 'REMOTE_LOGOUT');
    });
  }

  async changePhone(
    actor: AuthPrincipal,
    phone: string,
    now: Date,
  ): Promise<void> {
    try {
      await this.transaction(async (tx) => {
        await this.lockSessions(tx, actor, now);
        // Same user lock as sign-in/deletion: identity ownership and lifecycle stay consistent.
        await tx.$queryRaw`SELECT id FROM app.users WHERE id = ${actor.userId}::uuid FOR UPDATE`;
        const user = await tx.user.findFirst({
          where: {
            id: actor.userId,
            deletedAt: null,
            status: 'ACTIVE',
            tokenVersion: actor.tokenVersion,
          },
          select: { id: true },
        });
        if (!user)
          throw new DomainError(
            'The session is no longer active.',
            'UNAUTHORIZED',
            401,
          );
        const occupied = await tx.authIdentity.findFirst({
          where: { provider: 'PHONE', providerUid: phone },
        });
        if (occupied && occupied.userId !== actor.userId)
          throw this.phoneUsed();
        const identity = await tx.authIdentity.findFirst({
          where: { provider: 'PHONE', userId: actor.userId, deletedAt: null },
          orderBy: { createdAt: 'asc' },
        });
        if (!identity)
          throw new DomainError(
            'A verified phone is required.',
            'REAUTH_PHONE_REQUIRED',
            403,
          );
        if (occupied && occupied.id !== identity.id) throw this.phoneUsed();
        await tx.authIdentity.update({
          where: { id: identity.id },
          data: { providerUid: phone, lastUsedAt: now },
        });
        const revokedCount = await this.revokeOthersInTransaction(
          tx,
          actor,
          now,
          'PHONE_CHANGED',
        );
        await enqueueTransactionalMail(
          tx,
          'PHONE_CHANGED',
          actor.userId,
          identity.id,
          `${identity.id}:${now.toISOString()}`,
        );
        // Existing audit supports non-admin actors via nullable adminId. Never persist either phone or OTP.
        await tx.adminAuditEvent.create({
          data: {
            action: 'account.phone.changed',
            entityType: 'User',
            entityId: actor.userId,
            reasonCode: 'USER_REQUEST',
            redactedChanges: {
              actorUserId: actor.userId,
              policyVersion: POLICY.version,
              revokedCount,
            },
          },
        });
      });
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      )
        throw this.phoneUsed();
      throw error;
    }
  }

  private async lockSessions(
    tx: Prisma.TransactionClient,
    actor: AuthPrincipal,
    now: Date,
  ) {
    // Rotation locks the old session before it inserts its successor. Lock all rows,
    // then a fresh READ COMMITTED statement sees and revokes any committed successor.
    await tx.$queryRaw`SELECT id FROM app.user_sessions WHERE user_id = ${actor.userId}::uuid AND deleted_at IS NULL ORDER BY id FOR UPDATE`;
    const current = await tx.userSession.findFirst({
      where: {
        id: actor.sessionId,
        userId: actor.userId,
        ...active(now),
        user: {
          deletedAt: null,
          status: 'ACTIVE',
          tokenVersion: actor.tokenVersion,
        },
      },
      select: { id: true },
    });
    if (!current)
      throw new DomainError(
        'The session is no longer active.',
        'UNAUTHORIZED',
        401,
      );
  }

  private async revokeOthersInTransaction(
    tx: Prisma.TransactionClient,
    actor: AuthPrincipal,
    now: Date,
    reason: string,
  ) {
    const sessions = await tx.userSession.findMany({
      where: {
        userId: actor.userId,
        id: { not: actor.sessionId },
        ...active(now),
      },
      select: { id: true, deviceId: true },
    });
    // Include old refresh-chain links so a paused rotation cannot resurrect a remote session.
    await tx.userSession.updateMany({
      where: {
        userId: actor.userId,
        id: { not: actor.sessionId },
        deletedAt: null,
        revokedAt: null,
      },
      data: { revokedAt: now, revokeReason: reason },
    });
    const current = await tx.userSession.findUniqueOrThrow({
      where: { id: actor.sessionId },
      select: { deviceId: true },
    });
    const deviceIds = [
      ...new Set(
        sessions
          .map((s) => s.deviceId)
          .filter((id): id is string => id !== null && id !== current.deviceId),
      ),
    ];
    if (deviceIds.length)
      await tx.userDevice.updateMany({
        where: { userId: actor.userId, id: { in: deviceIds }, deletedAt: null },
        data: { pushToken: null, pushEnabled: false },
      });
    return sessions.length;
  }

  /** Retry PostgreSQL deadlock/serialization aborts; the whole unit (including audit) rolls back. */
  private async transaction<T>(
    operation: (tx: Prisma.TransactionClient) => Promise<T>,
  ): Promise<T> {
    for (let attempt = 1; ; attempt++) {
      try {
        return await this.prisma.$transaction(operation);
      } catch (error) {
        if (
          !(error instanceof Prisma.PrismaClientKnownRequestError) ||
          error.code !== 'P2034' ||
          attempt >= POLICY.transactionAttempts
        )
          throw error;
      }
    }
  }

  private phoneUsed() {
    return new DomainError(
      'This phone number is unavailable.',
      'PHONE_ALREADY_USED',
      409,
    );
  }
}
