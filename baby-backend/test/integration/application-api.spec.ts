import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { AppModule } from '../../src/app.module';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';

describe('Application API + PostgreSQL + real ES256/session verification', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  const userIds = [randomUUID(), randomUUID(), randomUUID()];
  const familyId = randomUUID();
  const sessionId = randomUUID();
  const successorId = randomUUID();
  const outsiderSessionId = randomUUID();
  const planIds = [randomUUID(), randomUUID()];
  const versionId = randomUUID();
  const licenseId = randomUUID();
  const suffix = randomUUID().replaceAll('-', '').slice(0, 16);
  const planCode = `API_PLAN_${suffix}`;
  const inactiveCode = `API_HIDDEN_${suffix}`;
  const policyCode = `API_TRIAL_${suffix}`;
  const actorId = userIds[0]!;
  const future = () => new Date(Date.now() + 24 * 60 * 60 * 1000);
  const past = () => new Date(Date.now() - 60 * 1000);

  async function token(
    userId = actorId,
    sid = sessionId,
    ver = 1,
    extra: Record<string, unknown> = {},
  ) {
    const issued = Math.floor(Date.now() / 1000);
    return new SignJWT({
      ...extra,
      sub: userId,
      sid,
      ver,
      iat: issued,
      exp: issued + 900,
      iss: 'baby-family',
      aud: 'baby-family-app',
    })
      .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
      .sign(keys.privateKey);
  }

  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (!database.endsWith('_test'))
      throw new Error(
        'Application integration requires a dedicated *_test database.',
      );
    keys = await generateKeyPair('ES256');
    const pem = await exportSPKI(keys.publicKey);
    // Override this testing module only; do not alter environment/keys of other suites.
    const configuration = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: pem,
      AUTH_JWT_ISSUER: 'baby-family',
      AUTH_JWT_AUDIENCE: 'baby-family-app',
    });
    const module = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(ConfigService)
      .useValue(configuration)
      .compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
    prisma = app.get(PrismaService);

    await prisma.user.createMany({
      data: userIds.map((id) => ({
        id,
        displayName: 'Synthetic API fixture',
        status: 'ACTIVE',
        tokenVersion: 1,
      })),
    });
    await prisma.userSession.createMany({
      data: [
        {
          id: sessionId,
          userId: actorId,
          refreshTokenHash: randomBytes(32),
          expiresAt: future(),
          absoluteExpiresAt: future(),
        },
        {
          id: successorId,
          userId: actorId,
          refreshTokenHash: randomBytes(32),
          expiresAt: future(),
          absoluteExpiresAt: future(),
        },
        {
          id: outsiderSessionId,
          userId: userIds[2]!,
          refreshTokenHash: randomBytes(32),
          expiresAt: future(),
          absoluteExpiresAt: future(),
        },
      ],
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic API family',
        createdBy: actorId,
        status: 'ACTIVE',
        activatedAt: past(),
      },
    });
    await prisma.familyParent.createMany({
      data: [
        {
          familyId,
          userId: actorId,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Parent A',
        },
        {
          familyId,
          userId: userIds[1]!,
          slot: 'B',
          kind: 'FATHER',
          callName: 'Parent B',
        },
      ],
    });
    await prisma.plan.createMany({
      data: [
        {
          id: planIds[0]!,
          code: planCode,
          displayNameI18n: { vi: 'Synthetic extensible plan' },
          purchaseEnabled: true,
          active: true,
        },
        {
          id: planIds[1]!,
          code: inactiveCode,
          displayNameI18n: { vi: 'Hidden fixture' },
          purchaseEnabled: true,
          active: false,
        },
      ],
    });
    const availableFrom = new Date(Date.now() - 120000);
    await prisma.planVersion.createMany({
      data: [
        {
          id: versionId,
          planId: planIds[0]!,
          version: 1,
          quotas: { storageBytes: 1000 },
          features: { 'circle.enabled': true },
          availableFrom,
        },
        {
          planId: planIds[0]!,
          version: 2,
          quotas: { storageBytes: 2000 },
          features: {},
          availableFrom: future(),
        },
        {
          planId: planIds[0]!,
          version: 3,
          quotas: { storageBytes: 3000 },
          features: {},
          availableFrom,
          retiredAt: past(),
        },
        {
          planId: planIds[0]!,
          version: 4,
          quotas: { storageBytes: 4000 },
          features: {},
          availableFrom,
          deletedAt: past(),
        },
        {
          planId: planIds[1]!,
          version: 1,
          quotas: {},
          features: {},
          availableFrom,
        },
      ],
    });
    await prisma.trialPolicy.create({
      data: {
        code: policyCode,
        version: 2,
        planVersionId: versionId,
        durationSeconds: 864001n,
        reminderOffsetsSeconds: [86400],
        active: true,
        publishedAt: past(),
      },
    });
    await prisma.familyLicense.create({ data: { id: licenseId, familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: versionId,
        validUntil: future(),
        version: 9007199254740993n,
      },
    });
    await prisma.familyUsage.create({
      data: {
        familyId,
        storageBytes: 9007199254740993n,
        reservedStorageBytes: 10n,
      },
    });
  });

  beforeEach(async () => {
    await prisma.user.updateMany({
      where: { id: { in: userIds } },
      data: { status: 'ACTIVE', tokenVersion: 1, deletedAt: null },
    });
    await prisma.userSession.update({
      where: { id: sessionId },
      data: {
        revokedAt: null,
        replacedBy: null,
        deletedAt: null,
        expiresAt: future(),
        absoluteExpiresAt: future(),
      },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'PAID',
        validUntil: future(),
        trialStartedAt: null,
        trialEndsAt: null,
        deletedAt: null,
      },
    });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        // Cleanup only owned synthetic fixtures. Protected license history stays
        // soft-deleted until the caller disposes the entire isolated test DB.
        await prisma.userSession.updateMany({
          where: { userId: { in: userIds } },
          data: { replacedBy: null },
        });
        await prisma.userSession.deleteMany({
          where: { userId: { in: userIds } },
        });
        await prisma.child.deleteMany({ where: { familyId } });
        await prisma.pregnancy.deleteMany({ where: { familyId } });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
        await prisma.familyParent.deleteMany({ where: { familyId } });
        await prisma.familyLicense.updateMany({
          where: { id: licenseId, familyId },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt: new Date() },
        });
        await prisma.user.updateMany({
          where: { id: { in: userIds } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
        await prisma.trialPolicy.deleteMany({ where: { code: policyCode } });
        await prisma.planVersion.deleteMany({
          where: { planId: { in: planIds } },
        });
        await prisma.plan.deleteMany({ where: { id: { in: planIds } } });
      }
    } finally {
      if (app) await app.close();
    }
  });

  it('requires a Bearer token and derives /me exclusively from the verified subject', async () => {
    await request(app.getHttpServer()).get('/api/v1/me').expect(401);
    await request(app.getHttpServer())
      .get('/api/v1/me')
      .set('Authorization', 'Bearer malformed')
      .expect(401);
    const response = await request(app.getHttpServer())
      .get('/api/v1/me')
      .set(
        'Authorization',
        `Bearer ${await token(actorId, sessionId, 1, { role: 'SUPER_ADMIN', familyId: randomUUID() })}`,
      )
      .set('X-User-Id', userIds[2]!)
      .set('X-Role', 'SUPER_ADMIN')
      .expect(200);
    expect(response.body).toMatchObject({ id: actorId });
    expect(Object.keys(response.body as object).sort()).toEqual([
      'createdAt',
      'displayName',
      'id',
      'locale',
      'timezone',
      'updatedAt',
    ]);
  });

  it('rejects profile mass assignment and changes only allowed fields on the current actor', async () => {
    const authorization = `Bearer ${await token()}`;
    await request(app.getHttpServer())
      .patch('/api/v1/me')
      .set('Authorization', authorization)
      .send({
        displayName: 'Rejected mutation',
        id: userIds[2],
        tokenVersion: 999,
        status: 'SUSPENDED',
      })
      .expect(400);
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: actorId } }))
        .displayName,
    ).toBe('Synthetic API fixture');
    await request(app.getHttpServer())
      .patch('/api/v1/me')
      .set('Authorization', authorization)
      .set('X-User-Id', userIds[2]!)
      .send({ displayName: ' Updated actor ' })
      .expect(200);
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: actorId } }))
        .displayName,
    ).toBe('Updated actor');
    expect(
      (await prisma.user.findUniqueOrThrow({ where: { id: userIds[2]! } }))
        .displayName,
    ).toBe('Synthetic API fixture');
  });

  it.each([
    'revoked',
    'replaced',
    'expired',
    'absolute-expired',
    'session-deleted',
    'suspended',
    'user-deleted',
    'version-changed',
  ] as const)(
    'rejects an existing session after %s in PostgreSQL',
    async (reason) => {
      switch (reason) {
        case 'revoked':
          await prisma.userSession.update({
            where: { id: sessionId },
            data: { revokedAt: new Date() },
          });
          break;
        case 'replaced':
          await prisma.userSession.update({
            where: { id: sessionId },
            data: { replacedBy: successorId },
          });
          break;
        case 'expired':
          await prisma.userSession.update({
            where: { id: sessionId },
            data: { expiresAt: past() },
          });
          break;
        case 'absolute-expired':
          await prisma.userSession.update({
            where: { id: sessionId },
            data: { absoluteExpiresAt: past() },
          });
          break;
        case 'session-deleted':
          await prisma.userSession.update({
            where: { id: sessionId },
            data: { deletedAt: new Date() },
          });
          break;
        case 'suspended':
          await prisma.user.update({
            where: { id: actorId },
            data: { status: 'SUSPENDED' },
          });
          break;
        case 'user-deleted':
          await prisma.user.update({
            where: { id: actorId },
            data: { deletedAt: new Date() },
          });
          break;
        case 'version-changed':
          await prisma.user.update({
            where: { id: actorId },
            data: { tokenVersion: 2 },
          });
          break;
      }
      await request(app.getHttpServer())
        .get('/api/v1/me')
        .set('Authorization', `Bearer ${await token()}`)
        .expect(401);
    },
  );

  it('returns a dynamic catalog while hiding inactive/future/retired/deleted versions and using published policy duration', async () => {
    await request(app.getHttpServer()).get('/api/v1/billing/plans').expect(401);
    const response = await request(app.getHttpServer())
      .get('/api/v1/billing/plans')
      .set('Authorization', `Bearer ${await token()}`)
      .expect(200);
    const body = response.body as {
      plans: {
        code: string;
        version: number;
        quotas: Record<string, number>;
      }[];
      trialPolicies: { code: string; durationSeconds: string }[];
    };
    expect(body.plans.find((plan) => plan.code === planCode)).toMatchObject({
      version: 1,
      quotas: { storageBytes: 1000 },
    });
    expect(body.plans.some((plan) => plan.code === inactiveCode)).toBe(false);
    expect(
      body.trialPolicies.find((policy) => policy.code === policyCode)
        ?.durationSeconds,
    ).toBe('864001');
    expect(JSON.stringify(body)).not.toMatch(
      /passwordHash|refreshTokenHash|productId|providerRefreshTokenEnc/,
    );
  });

  it('enforces real parent access for children and preserves exact byte counters in billing', async () => {
    const authorization = `Bearer ${await token()}`;
    const created = await request(app.getHttpServer())
      .post(`/api/v1/families/${familyId}/children`)
      .set('Authorization', authorization)
      .send({ name: 'Synthetic child', birthDate: '2025-01-01', colorIndex: 1 })
      .expect(201);
    const child = created.body as { id: string };
    const page = await request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/children`)
      .set('Authorization', authorization)
      .expect(200);
    expect(page.body).toMatchObject({
      data: expect.arrayContaining([expect.objectContaining({ id: child.id })]),
    });
    const outsider = `Bearer ${await token(userIds[2], outsiderSessionId)}`;
    const denied = await request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/children`)
      .set('Authorization', outsider)
      .expect(404);
    expect(JSON.stringify(denied.body)).not.toContain('Synthetic child');
    const billing = await request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/billing`)
      .set('Authorization', authorization)
      .expect(200);
    expect(billing.body).toMatchObject({
      accessPhase: 'PAID',
      entitlementVersion: '9007199254740993',
      usage: { storageBytes: '9007199254740993', reservedStorageBytes: '10' },
    });
    expect(JSON.stringify(billing.body)).not.toMatch(
      /licenseId|sourceGrantId|purchaserUserId|refreshTokenHash/,
    );
  });

  it('keeps expired billing metadata readable while denying paid child operations', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { validUntil: past() },
    });
    const authorization = `Bearer ${await token()}`;
    const response = await request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/billing`)
      .set('Authorization', authorization)
      .expect(200);
    expect(response.body).toMatchObject({
      accessPhase: 'EXPIRED',
      plan: { code: planCode },
    });
    await request(app.getHttpServer())
      .post(`/api/v1/families/${familyId}/children`)
      .set('Authorization', authorization)
      .send({ name: 'Denied child', birthDate: '2025-01-01', colorIndex: 1 })
      .expect(402);
    expect(
      await prisma.child.count({ where: { familyId, name: 'Denied child' } }),
    ).toBe(0);
  });

  it('serializes concurrent pregnancy creation and never reuses a soft-deleted sequence', async () => {
    await prisma.pregnancy.create({
      data: {
        familyId,
        seqNo: 7,
        nickname: 'Removed synthetic pregnancy',
        createdBy: actorId,
        deletedAt: past(),
      },
    });
    const authorization = `Bearer ${await token()}`;
    const responses = await Promise.all(
      ['One', 'Two'].map((label) =>
        request(app.getHttpServer())
          .post(`/api/v1/families/${familyId}/pregnancies`)
          .set('Authorization', authorization)
          .set('X-User-Id', userIds[2]!)
          .send({
            nickname: `Synthetic ${label}`,
            dueDate: '2027-06-01',
            expectedCount: 1,
          }),
      ),
    );
    expect(responses.map((response) => response.status)).toEqual([201, 201]);
    const pregnancies = responses.map(
      (response) => response.body as { id: string; seqNo: number },
    );
    expect(
      pregnancies.map((pregnancy) => pregnancy.seqNo).sort((a, b) => a - b),
    ).toEqual([8, 9]);
    const stored = await prisma.pregnancy.findMany({
      where: {
        familyId,
        id: { in: pregnancies.map((pregnancy) => pregnancy.id) },
      },
    });
    expect(stored).toHaveLength(2);
    expect(stored.every((pregnancy) => pregnancy.createdBy === actorId)).toBe(
      true,
    );
    expect(new Set(stored.map((pregnancy) => pregnancy.seqNo)).size).toBe(2);
  });

  it('rejects client-supplied pregnancy sequence and creator without inserting a row', async () => {
    const before = await prisma.pregnancy.count({ where: { familyId } });
    await request(app.getHttpServer())
      .post(`/api/v1/families/${familyId}/pregnancies`)
      .set('Authorization', `Bearer ${await token()}`)
      .send({ nickname: 'Denied pregnancy', seqNo: 100, createdBy: userIds[2] })
      .expect(400);
    expect(await prisma.pregnancy.count({ where: { familyId } })).toBe(before);
  });
});
