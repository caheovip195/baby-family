import { Injectable } from '@nestjs/common';
import { ADMIN_CMS_AUTH_POLICY } from '../config/admin-cms-auth-policy';
import { DomainError } from '../common/errors/domain.error';
import { PrismaService } from '../database/prisma.service';
import type { IAdminCmsAuthRepository } from '../interfaces/repositories/admin-cms-auth-repository.interface';
import {
  AdminCmsAuthSession,
  AdminCmsAuthUser,
} from '../models/admin-cms-auth.model';
@Injectable()
export class AdminCmsAuthRepository implements IAdminCmsAuthRepository {
  constructor(private readonly prisma: PrismaService) {}
  reserveAttempt(identityKey: string, clientKey: string): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      for (const key of [identityKey, clientKey].sort())
        await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtextextended(${`admin-login:${key}`}, 0))`;
      const attempts = await tx.adminAuditEvent.findMany({
        where: {
          action: 'ADMIN_LOGIN_ATTEMPT',
          deletedAt: null,
          createdAt: {
            gte: new Date(Date.now() - ADMIN_CMS_AUTH_POLICY.loginWindowMs),
          },
          OR: [
            { entityId: identityKey },
            { redactedChanges: { path: ['clientKey'], equals: clientKey } },
          ],
        },
        select: { entityId: true, redactedChanges: true },
      });
      const allowed =
        attempts.filter((row) => row.entityId === identityKey).length <
          ADMIN_CMS_AUTH_POLICY.identityAttemptsPerWindow &&
        attempts.filter(
          (row) =>
            (row.redactedChanges as { clientKey?: string }).clientKey ===
            clientKey,
        ).length < ADMIN_CMS_AUTH_POLICY.clientAttemptsPerWindow;
      await tx.adminAuditEvent.create({
        data: {
          action: allowed ? 'ADMIN_LOGIN_ATTEMPT' : 'ADMIN_LOGIN_THROTTLED',
          entityType: 'ADMIN_AUTH',
          entityId: identityKey,
          redactedChanges: { clientKey },
        },
      });
      return allowed;
    });
  }
  async findUser(email: string): Promise<AdminCmsAuthUser | null> {
    const row = await this.prisma.adminUser.findFirst({
      where: { email, deletedAt: null },
    });
    return row
      ? new AdminCmsAuthUser(
          row.id,
          row.passwordHash,
          row.totpSecretEnc,
          row.roles,
          row.status,
        )
      : null;
  }
  async recordDenied(adminId: string): Promise<void> {
    await this.prisma.adminAuditEvent.create({
      data: {
        adminId,
        action: 'ADMIN_PERMISSION_DENIED',
        entityType: 'ADMIN_AUTH',
      },
    });
  }
  async recordFailure(adminId: string | null): Promise<void> {
    await this.prisma.adminAuditEvent.create({
      data: { adminId, action: 'ADMIN_LOGIN_FAILED', entityType: 'ADMIN_AUTH' },
    });
  }
  async createSession(
    input: Parameters<IAdminCmsAuthRepository['createSession']>[0],
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      if (input.mfaStep) {
        await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtextextended(${`admin-mfa:${input.adminId}`},0))`;
        const replay = await tx.adminSession.count({
          where: {
            adminId: input.adminId,
            mfaVerifiedAt: { gte: input.mfaStep },
          },
        });
        if (replay)
          throw new DomainError(
            'Admin credentials are invalid.',
            'ADMIN_CREDENTIALS_INVALID',
            401,
          );
      }
      await tx.adminSession.create({
        data: {
          id: input.id,
          adminId: input.adminId,
          refreshTokenHash: new Uint8Array(input.tokenHash),
          mfaVerifiedAt: input.mfaStep ?? new Date(),
          expiresAt: input.expiresAt,
        },
      });
      await tx.adminUser.update({
        where: { id: input.adminId },
        data: { lastLoginAt: new Date() },
      });
      await tx.adminAuditEvent.create({
        data: {
          adminId: input.adminId,
          action: 'ADMIN_LOGIN_SUCCEEDED',
          entityType: 'ADMIN_SESSION',
          entityId: input.id,
        },
      });
    });
  }
  async findSession(
    id: string,
    tokenHash: Uint8Array,
  ): Promise<AdminCmsAuthSession | null> {
    const row = await this.prisma.adminSession.findFirst({
      where: {
        id,
        refreshTokenHash: new Uint8Array(tokenHash),
        deletedAt: null,
        revokedAt: null,
        expiresAt: { gt: new Date() },
        adminUser: { deletedAt: null, status: 'ACTIVE' },
      },
      include: { adminUser: { select: { roles: true } } },
    });
    return row
      ? new AdminCmsAuthSession(row.id, row.adminId, row.adminUser.roles)
      : null;
  }
  async revokeSession(adminId: string, sessionId: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      await tx.adminSession.updateMany({
        where: { id: sessionId, adminId, deletedAt: null, revokedAt: null },
        data: { revokedAt: new Date() },
      });
      await tx.adminAuditEvent.create({
        data: {
          adminId,
          action: 'ADMIN_LOGOUT',
          entityType: 'ADMIN_SESSION',
          entityId: sessionId,
        },
      });
    });
  }
  createAdmin(
    input: Parameters<IAdminCmsAuthRepository['createAdmin']>[0],
  ): Promise<string> {
    return this.prisma.$transaction(async (tx) => {
      const user = await tx.adminUser.create({
        data: { ...input, totpSecretEnc: new Uint8Array(input.totpSecretEnc) },
      });
      await tx.adminAuditEvent.create({
        data: {
          adminId: user.id,
          action: 'ADMIN_CREATED_COMMAND',
          entityType: 'ADMIN_USER',
          entityId: user.id,
          redactedChanges: { roles: input.roles },
        },
      });
      return user.id;
    });
  }
}
