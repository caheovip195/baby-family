import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';

/**
 * Technical spec §6.4 (release blocker) as route sweeps over the real AppModule:
 * 1. an unrelated user gets 404 (never 403/200) on every family resource even
 *    with correct UUIDs; 2. Circle cannot reach Papa & Mama, missions, Hearts or
 *    purchases; 3. Circle cannot reach an ungranted child; 4. a removed relative
 *    is refused on the next request and cannot get a new upload intent.
 * Invariants 5–10 are covered by the focused specs listed in
 * docs/security-invariants.md.
 */
describe('Security invariants §6.4 (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID(),
    parent = randomUUID(),
    partner = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const childId = randomUUID(),
    hiddenChildId = randomUUID(),
    pregnancyId = randomUUID(),
    albumId = randomUUID(),
    memoryId = randomUUID(),
    hiddenMemoryId = randomUUID();
  let circleMemberId = '';
  const tokens = new Map<string, string>();
  const at = new Date('2026-10-01T00:00:00Z');
  const future = () => new Date(Date.now() + 86400000);
  const call = (method: 'get' | 'post', route: string, user: string) => {
    const client = request(app.getHttpServer());
    const pending =
      method === 'get'
        ? client.get(`/api/v1${route}`)
        : client.post(`/api/v1${route}`);
    return pending.set('Authorization', tokens.get(user)!);
  };

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Requires *_test database');
    const keys = await generateKeyPair('ES256');
    const config = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const { AppModule } = await import('../../src/app.module.js');
    const module = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(ConfigService)
      .useValue(config)
      .compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
    prisma = app.get(PrismaService);
    for (const userId of [parent, partner, circle, outsider]) {
      const sid = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic', status: 'ACTIVE' },
      });
      await prisma.userSession.create({
        data: {
          id: sid,
          userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: future(),
          absoluteExpiresAt: future(),
        },
      });
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid, ver: 1 }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).setSubject(userId).setIssuer('baby-family').setAudience('baby-family-app').setIssuedAt().setExpirationTime('15m').sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic invariants family',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: at,
      },
    });
    await prisma.familyParent.createMany({
      data: [
        {
          familyId,
          userId: parent,
          slot: 'A',
          kind: 'FATHER',
          callName: 'Papa',
        },
        {
          familyId,
          userId: partner,
          slot: 'B',
          kind: 'MOTHER',
          callName: 'Mama',
        },
      ],
    });
    for (const id of [childId, hiddenChildId])
      await prisma.child.create({
        data: {
          id,
          familyId,
          nickname: 'Synthetic child',
          birthDate: new Date('2026-01-01'),
          colorIndex: 1,
          createdBy: parent,
        },
      });
    await prisma.pregnancy.create({
      data: {
        id: pregnancyId,
        familyId,
        seqNo: 1,
        nickname: 'Synthetic pregnancy',
        status: 'ACTIVE',
        createdBy: parent,
      },
    });
    const member = await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'OTHER',
        displayName: 'Synthetic relative',
      },
    });
    circleMemberId = member.id;
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId,
        permission: 'CONTRIBUTE',
        allowDownload: true,
        createdBy: parent,
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `INV_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic invariants plan' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        quotas: { storageBytes: 10000000 },
        features: { 'circle.enabled': true },
        availableFrom: at,
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: version.id,
        validUntil: future(),
      },
    });
    await prisma.album.create({
      data: { id: albumId, familyId, ownerUserId: parent, name: 'Album' },
    });
    for (const [id, child] of [
      [memoryId, childId],
      [hiddenMemoryId, hiddenChildId],
    ] as const) {
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: parent,
          authorRole: 'PARENT',
          kind: 'MOMENT',
          body: 'Synthetic memory',
          visibility: 'FAMILY',
          status: 'PUBLISHED',
          occurredAt: at,
          occurredLocalDate: at,
          publishedAt: at,
        },
      });
      await prisma.memoryChild.create({
        data: { memoryId: id, familyId, childId: child, ageMonth: 9 },
      });
    }
  });

  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt: new Date() },
        });
        const users = [parent, partner, circle, outsider];
        await prisma.userSession.updateMany({
          where: { userId: { in: users } },
          data: { deletedAt: new Date() },
        });
        await prisma.user.updateMany({
          where: { id: { in: users } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
      }
    } finally {
      await app?.close();
    }
  });

  const familyRoutes = () => [
    `/families/${familyId}`,
    `/families/${familyId}/bootstrap`,
    `/families/${familyId}/settings`,
    `/families/${familyId}/privacy-overview`,
    `/families/${familyId}/billing`,
    `/families/${familyId}/billing/upgrade-options`,
    `/families/${familyId}/children`,
    `/families/${familyId}/children/${childId}`,
    `/families/${familyId}/pregnancies`,
    `/families/${familyId}/pregnancies/${pregnancyId}`,
    `/families/${familyId}/feed`,
    `/families/${familyId}/timeline`,
    `/families/${familyId}/media-grid`,
    `/families/${familyId}/search?query=Synthetic`,
    `/families/${familyId}/on-this-day`,
    `/families/${familyId}/trash`,
    `/families/${familyId}/albums`,
    `/families/${familyId}/favorites`,
    `/families/${familyId}/calendar?from=2026-10-01&to=2026-10-31`,
    `/families/${familyId}/circle`,
    `/families/${familyId}/overview`,
    `/families/${familyId}/invites/circle`,
    `/families/${familyId}/invites/partner`,
    `/families/${familyId}/deletion`,
    `/families/${familyId}/people-suggestions`,
    `/families/${familyId}/memory-prompts`,
    `/families/${familyId}/memories/pending-review`,
    `/families/${familyId}/recaps/weekly`,
    `/families/${familyId}/home/week-stats`,
    `/families/${familyId}/missions/board?tab=MINE`,
    `/families/${familyId}/missions/templates`,
    `/families/${familyId}/mission-settings`,
    `/families/${familyId}/mission-series`,
    `/families/${familyId}/hearts/me`,
    `/families/${familyId}/badges`,
    `/families/${familyId}/family-tree`,
    `/families/${familyId}/us/checkins/today`,
    `/families/${familyId}/us/requests`,
    `/families/${familyId}/us/journal`,
    `/families/${familyId}/us/appreciations`,
    `/memories/${memoryId}`,
    `/memories/${memoryId}/comments`,
    `/memories/${memoryId}/perspectives`,
    `/albums/${albumId}/memories`,
    `/children/${childId}/profile-stats`,
    `/children/${childId}/letters`,
    `/children/${childId}/milestones`,
    `/children/${childId}/monthly-photos`,
    `/children/${childId}/today-story`,
    `/pregnancies/${pregnancyId}/journey`,
    `/pregnancies/${pregnancyId}/memories`,
    `/pregnancies/${pregnancyId}/milestones`,
    `/pregnancies/${pregnancyId}/prep-items`,
  ];

  it('1. an unrelated user gets 404 on every family resource, even with real UUIDs', async () => {
    const leaks: string[] = [];
    for (const route of familyRoutes()) {
      const response = await call('get', route, outsider);
      // 400 = query validation before access; never reveals the family.
      if (![404, 400].includes(response.status))
        leaks.push(`${route} → ${response.status}`);
    }
    expect(leaks).toEqual([]);
  });

  it('2. Circle cannot reach Papa & Mama, missions, Hearts or purchases', async () => {
    const reached: string[] = [];
    const routes = [
      `/families/${familyId}/us/checkins/today`,
      `/families/${familyId}/us/checkins`,
      `/families/${familyId}/us/requests`,
      `/families/${familyId}/us/journal`,
      `/families/${familyId}/us/appreciations`,
      `/families/${familyId}/missions/board?tab=MINE`,
      `/families/${familyId}/missions/templates`,
      `/families/${familyId}/missions`,
      `/families/${familyId}/mission-settings`,
      `/families/${familyId}/mission-series`,
      `/families/${familyId}/hearts/me`,
      `/families/${familyId}/badges`,
    ];
    for (const route of routes) {
      const response = await call('get', route, circle);
      if (response.status < 400) reached.push(`${route} → ${response.status}`);
    }
    const purchase = await call(
      'post',
      `/families/${familyId}/purchase-intents`,
      circle,
    )
      .set('Idempotency-Key', randomUUID())
      .send({ planCode: 'FAMILY', store: 'APP_STORE' });
    if (purchase.status < 400)
      reached.push(`purchase-intents → ${purchase.status}`);
    expect(reached).toEqual([]);
  });

  it('3. Circle cannot reach an ungranted child through any read path', async () => {
    for (const route of [
      `/families/${familyId}/children/${hiddenChildId}`,
      `/children/${hiddenChildId}/profile-stats`,
      `/children/${hiddenChildId}/milestones`,
      `/children/${hiddenChildId}/letters`,
      `/memories/${hiddenMemoryId}`,
    ])
      expect([route, (await call('get', route, circle)).status]).toEqual([
        route,
        404,
      ]);
    const story = await call(
      'get',
      `/children/${hiddenChildId}/today-story`,
      circle,
    );
    if (story.status === 200)
      expect(JSON.stringify(story.body)).not.toContain(hiddenMemoryId);
    else expect(story.status).toBe(404);
    for (const route of [
      `/families/${familyId}/timeline?childId=${hiddenChildId}`,
      `/families/${familyId}/timeline`,
      `/families/${familyId}/feed`,
      `/families/${familyId}/media-grid`,
      `/families/${familyId}/search?query=Synthetic`,
      `/families/${familyId}/on-this-day`,
      `/families/${familyId}/children`,
    ]) {
      const response = await call('get', route, circle);
      if (response.status === 200) {
        const body = JSON.stringify(response.body);
        expect([route, body.includes(hiddenMemoryId)]).toEqual([route, false]);
        expect([route, body.includes(hiddenChildId)]).toEqual([route, false]);
      } else
        expect([route, [400, 403, 404].includes(response.status)]).toEqual([
          route,
          true,
        ]);
    }
    // The granted child stays reachable (the sweep is not vacuous).
    await call('get', `/memories/${memoryId}`, circle).expect(200);
  });

  it('7. Parent B never receives Parent A Hearts on any family route', async () => {
    const localDate = new Date(new Date().toISOString().slice(0, 10));
    await prisma.heartLedger.create({
      data: {
        familyId,
        userId: parent,
        sourceType: 'MISSION',
        sourceId: randomUUID(),
        reason: 'DAILY_MISSION',
        amount: 73,
        localDate,
      },
    });
    await prisma.heartDailyCounter.create({
      data: { familyId, userId: parent, localDate, total: 73 },
    });
    const hearts =
      /"[A-Za-z]*(hearts|Hearts|total|Total|balance)[A-Za-z]*"\s*:\s*73\b/;
    // Not vacuous: A sees their own Hearts.
    const own = await call('get', `/families/${familyId}/hearts/me`, parent);
    expect(own.status).toBe(200);
    expect(JSON.stringify(own.body)).toMatch(hearts);
    const leaks: string[] = [];
    for (const route of familyRoutes()) {
      const response = await call('get', route, partner);
      if (response.status < 400 && hearts.test(JSON.stringify(response.body)))
        leaks.push(route);
    }
    expect(leaks).toEqual([]);
  });

  it('4. a removed relative is refused next request and gets no new presign', async () => {
    await call('get', `/families/${familyId}/feed`, circle).expect(200);
    await prisma.circleMember.update({
      where: { id: circleMemberId },
      data: { status: 'REMOVED' },
    });
    const next = await call('get', `/families/${familyId}/feed`, circle);
    expect([403, 404]).toContain(next.status);
    const presign = await call('post', '/media/upload-intents', circle)
      .set('Idempotency-Key', randomUUID())
      .send({
        familyId,
        kind: 'IMAGE',
        purpose: 'MEMORY',
        mime: 'image/jpeg',
        size: 1024,
        sha256: 'a'.repeat(64),
      });
    expect([403, 404]).toContain(presign.status);
  });
});
