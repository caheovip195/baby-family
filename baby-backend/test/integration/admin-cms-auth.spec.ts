import { randomBytes, randomUUID, createHash } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { SignJWT } from 'jose';
import { PrismaService } from '../../src/database/prisma.service';
import { AdminCmsAuthRepository } from '../../src/repositories/admin-cms-auth.repository';
import { AdminCmsAuthService } from '../../src/services/admin-cms-auth.service';
import { ADMIN_CMS_AUTH_REPOSITORY } from '../../src/interfaces/repositories/admin-cms-auth-repository.interface';
import {
  ADMIN_CMS_AUDIENCE,
  ADMIN_CMS_ISSUER,
  adminTokenHash,
  adminTotpCode,
  encryptAdminTotpSecret,
  hashAdminPassword,
} from '../../src/common/auth/admin-cms-crypto';
describe('Admin CMS durable lock and session boundaries', () => {
  let prisma: PrismaService,
    repository: AdminCmsAuthRepository,
    service: AdminCmsAuthService;
  const id = randomUUID(),
    email = `cms-auth-${id}@example.invalid`,
    password = 'Synthetic-long-password-1498!',
    secret = 'JBSWY3DPEHPK3PXP';
  const identity = createHash('sha256').update(email).digest('hex');
  const client = `fixture:${id}`;
  const oldToken = process.env.ADMIN_CMS_TOKEN_SECRET,
    oldTotp = process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY;
  const key = randomBytes(32);
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    process.env.ADMIN_CMS_TOKEN_SECRET = key.toString('base64');
    process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY = key.toString('base64');
    const module = await Test.createTestingModule({
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 2,
          }),
        },
        AdminCmsAuthRepository,
        {
          provide: ADMIN_CMS_AUTH_REPOSITORY,
          useExisting: AdminCmsAuthRepository,
        },
        AdminCmsAuthService,
      ],
    }).compile();
    prisma = module.get(PrismaService);
    // Login throttling counts recent attempts per client IP; earlier admin specs
    // in the same run share 127.0.0.1, so retire their attempts (test DB only).
    await prisma.adminAuditEvent.updateMany({
      where: {
        action: { in: ['ADMIN_LOGIN_ATTEMPT', 'ADMIN_LOGIN_THROTTLED'] },
        deletedAt: null,
      },
      data: { deletedAt: new Date() },
    });
    repository = module.get(AdminCmsAuthRepository);
    service = module.get(AdminCmsAuthService);
    await prisma.$connect();
    await prisma.adminUser.create({
      data: {
        id,
        email,
        passwordHash: await hashAdminPassword(password),
        totpSecretEnc: encryptAdminTotpSecret(secret),
        roles: ['SUPPORT'],
      },
    });
  });
  afterAll(async () => {
    if (prisma) {
      await prisma.adminAuditEvent.deleteMany({
        where: { OR: [{ adminId: id }, { entityId: identity }] },
      });
      await prisma.adminSession.deleteMany({ where: { adminId: id } });
      await prisma.adminUser.deleteMany({ where: { id } });
      await prisma.$disconnect();
    }
    if (oldToken === undefined) delete process.env.ADMIN_CMS_TOKEN_SECRET;
    else process.env.ADMIN_CMS_TOKEN_SECRET = oldToken;
    if (oldTotp === undefined) delete process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY;
    else process.env.ADMIN_CMS_TOTP_ENCRYPTION_KEY = oldTotp;
  });
  it('stores a revocable token hash, uses short expiry and fresh RBAC', async () => {
    const login = await service.login(
      email,
      password,
      adminTotpCode(secret),
      client,
    );
    expect(Date.parse(login.expiresAt) - Date.now()).toBeLessThanOrEqual(
      900000,
    );
    await expect(
      service.login(email, password, adminTotpCode(secret), client),
    ).rejects.toMatchObject({ code: 'ADMIN_CREDENTIALS_INVALID' });
    const actor = await service.authenticate(login.accessToken);
    const row = await prisma.adminSession.findUniqueOrThrow({
      where: { id: actor.sessionId },
    });
    expect(Buffer.from(row.refreshTokenHash)).toEqual(
      adminTokenHash(login.accessToken),
    );
    await prisma.adminUser.update({
      where: { id },
      data: { roles: ['MODERATOR'] },
    });
    expect((await service.authenticate(login.accessToken)).roles).toEqual([
      'MODERATOR',
    ]);
    await service.logout(actor);
    await expect(service.authenticate(login.accessToken)).rejects.toMatchObject(
      { code: 'ADMIN_UNAUTHORIZED' },
    );
  });
  it('rejects different issuer/audience and expired signed tokens', async () => {
    for (const [issuer, audience, expiration] of [
      ['app', ADMIN_CMS_AUDIENCE, 900],
      [ADMIN_CMS_ISSUER, 'app', 900],
      [ADMIN_CMS_ISSUER, ADMIN_CMS_AUDIENCE, -30],
    ] as const) {
      const sid = randomUUID();
      const token = await new SignJWT({ sid })
        .setProtectedHeader({ alg: 'HS256' })
        .setSubject(id)
        .setIssuer(issuer)
        .setAudience(audience)
        .setExpirationTime(Math.floor(Date.now() / 1000) + expiration)
        .sign(key);
      await repository.createSession({
        id: sid,
        adminId: id,
        tokenHash: adminTokenHash(token),
        expiresAt: new Date(Date.now() + 900000),
      });
      await expect(service.authenticate(token)).rejects.toMatchObject({
        code: 'ADMIN_UNAUTHORIZED',
      });
    }
  });
  it('serializes concurrent attempt reservations and persists lock across instances', async () => {
    const attempts = await Promise.all(
      Array.from({ length: 8 }, () =>
        repository.reserveAttempt(identity, client),
      ),
    );
    expect(attempts.filter(Boolean)).toHaveLength(3);
    expect(
      await new AdminCmsAuthRepository(prisma).reserveAttempt(identity, client),
    ).toBe(false);
    await expect(
      service.login(email, password, adminTotpCode(secret), client),
    ).rejects.toMatchObject({ code: 'ADMIN_LOGIN_LOCKED', statusCode: 429 });
    expect(
      await prisma.adminAuditEvent.count({
        where: { entityId: identity, action: 'ADMIN_LOGIN_THROTTLED' },
      }),
    ).toBeGreaterThan(0);
  });
});
