import { Inject, Injectable } from '@nestjs/common';
import { ADMIN_CMS_AUTH_POLICY } from '../config/admin-cms-auth-policy';
import { createHash, randomUUID } from 'node:crypto';
import { SignJWT, jwtVerify } from 'jose';
import { ADMIN_CMS_AUTH_REPOSITORY } from '../interfaces/repositories/admin-cms-auth-repository.interface';
import type { IAdminCmsAuthRepository } from '../interfaces/repositories/admin-cms-auth-repository.interface';
import type { IAdminCmsAuthService } from '../interfaces/services/admin-cms-auth-service.interface';
import type { AdminCmsActor } from '../models/admin-cms-auth.model';
import { DomainError } from '../common/errors/domain.error';
import {
  ADMIN_CMS_AUDIENCE,
  ADMIN_CMS_ISSUER,
  adminCmsKey,
  adminTokenHash,
  decryptAdminTotpSecret,
  hashAdminPassword,
  verifyAdminPassword,
  adminTotpStep,
} from '../common/auth/admin-cms-crypto';
@Injectable()
export class AdminCmsAuthService implements IAdminCmsAuthService {
  private readonly dummyHash = hashAdminPassword('not-an-admin-password');
  constructor(
    @Inject(ADMIN_CMS_AUTH_REPOSITORY)
    private readonly repository: IAdminCmsAuthRepository,
  ) {}
  async login(
    email: string,
    password: string,
    totp?: string,
    clientKey = 'unknown',
  ): ReturnType<IAdminCmsAuthService['login']> {
    const digest = (value: string) =>
      createHash('sha256').update(value).digest('hex');
    const normalized = email.trim().toLowerCase();
    if (
      !(await this.repository.reserveAttempt(
        digest(normalized),
        digest(clientKey),
      ))
    )
      throw new DomainError(
        'Admin login is temporarily locked.',
        'ADMIN_LOGIN_LOCKED',
        429,
      );
    const user = await this.repository.findUser(normalized);
    const passwordValid = await verifyAdminPassword(
      password,
      user?.passwordHash ?? (await this.dummyHash),
    );
    let mfaStep: Date | null = null;
    if (user && passwordValid && user.status === 'ACTIVE') {
      try {
        mfaStep = adminTotpStep(
          decryptAdminTotpSecret(user.totpSecretEnc),
          totp ?? '',
        );
      } catch (error) {
        if (error instanceof DomainError) throw error;
      }
    }
    if (!user || !passwordValid || !mfaStep || user.status !== 'ACTIVE') {
      await this.repository.recordFailure(user?.id ?? null);
      throw new DomainError(
        'Admin credentials are invalid.',
        'ADMIN_CREDENTIALS_INVALID',
        401,
      );
    }
    const sessionId = randomUUID();
    const expiresAt = new Date(Date.now() + ADMIN_CMS_AUTH_POLICY.sessionTtlMs);
    const accessToken = await new SignJWT({ sid: sessionId })
      .setProtectedHeader({ alg: 'HS256', typ: 'JWT' })
      .setSubject(user.id)
      .setIssuer(ADMIN_CMS_ISSUER)
      .setAudience(ADMIN_CMS_AUDIENCE)
      .setIssuedAt()
      .setExpirationTime(Math.floor(expiresAt.getTime() / 1000))
      .sign(adminCmsKey('ADMIN_CMS_TOKEN_SECRET'));
    try {
      await this.repository.createSession({
        id: sessionId,
        adminId: user.id,
        tokenHash: adminTokenHash(accessToken),
        expiresAt,
        mfaStep,
      });
    } catch (error) {
      if (
        error instanceof DomainError &&
        error.code === 'ADMIN_CREDENTIALS_INVALID'
      )
        await this.repository.recordFailure(user.id);
      throw error;
    }
    return {
      accessToken,
      tokenType: 'Bearer',
      expiresAt: expiresAt.toISOString(),
      issuer: ADMIN_CMS_ISSUER,
      audience: ADMIN_CMS_AUDIENCE,
      admin: { id: user.id, roles: user.roles },
    };
  }
  async authenticate(token: string): Promise<AdminCmsActor> {
    const key = adminCmsKey('ADMIN_CMS_TOKEN_SECRET');
    try {
      const { payload } = await jwtVerify(token, key, {
        algorithms: ['HS256'],
        issuer: ADMIN_CMS_ISSUER,
        audience: ADMIN_CMS_AUDIENCE,
      });
      if (
        typeof payload.sid !== 'string' ||
        typeof payload.sub !== 'string' ||
        !/^[0-9a-f-]{36}$/i.test(payload.sid)
      )
        throw new Error('Invalid session.');
      const session = await this.repository.findSession(
        payload.sid,
        adminTokenHash(token),
      );
      if (!session || session.adminId !== payload.sub)
        throw new Error('Invalid session.');
      return {
        id: session.adminId,
        roles: session.roles,
        sessionId: session.id,
      };
    } catch {
      throw new DomainError(
        'Admin session is invalid or expired.',
        'ADMIN_UNAUTHORIZED',
        401,
      );
    }
  }
  recordDenied(actor: AdminCmsActor): Promise<void> {
    return this.repository.recordDenied(actor.id);
  }
  logout(actor: AdminCmsActor): Promise<void> {
    return this.repository.revokeSession(actor.id, actor.sessionId);
  }
}
