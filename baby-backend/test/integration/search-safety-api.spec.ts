import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import type { Visibility } from '../../src/common/database.enums';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';

interface Item {
  id: string;
}
interface Group {
  yearsAgo: number;
  date: string;
  memories: Item[];
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const list = (response: { body: unknown }): string[] => {
  const body = (response.body as { data: Item[] | { data: Item[] } }).data;
  return (Array.isArray(body) ? body : body.data).map((item) => item.id);
};
const code = (response: { body: unknown }) =>
  (response.body as { error: { code: string } }).error.code;

/** MEM-15/16, RPT-01/02 (BF-20261019-006): one synthetic family per run. */
describe('Search, on-this-day, reports & blocks (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID(),
    parent = randomUUID(),
    partner = randomUUID(),
    circle = randomUUID();
  const childA = randomUUID(),
    childB = randomUUID();
  const tokens = new Map<string, string>();
  const ids = new Map<string, string>();
  let partnerComment = '';
  const future = () => new Date(Date.now() + 86400000);
  const call = (
    method: 'get' | 'post' | 'delete',
    route: string,
    user = parent,
  ) => {
    const server = request(app.getHttpServer());
    const url = `/api/v1${route}`;
    const req =
      method === 'get'
        ? server.get(url)
        : method === 'post'
          ? server.post(url)
          : server.delete(url);
    return req.set('Authorization', tokens.get(user)!);
  };
  const search = (q: string, user = parent) =>
    call(
      'get',
      `/families/${familyId}/search?q=${encodeURIComponent(q)}`,
      user,
    );
  const ofNames = (...names: string[]) =>
    names.map((name) => ids.get(name)!).sort();

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
    for (const userId of [parent, partner, circle]) {
      const sid = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic search fixture' },
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
        name: 'Synthetic search family',
        createdBy: parent,
        status: 'ACTIVE',
        activatedAt: new Date('2023-01-01'),
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
    for (const id of [childA, childB])
      await prisma.child.create({
        data: {
          id,
          familyId,
          nickname: 'Synthetic child',
          birthDate: new Date('2023-01-01'),
          colorIndex: 1,
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
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId: childA,
        permission: 'COMMENT',
        createdBy: parent,
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `SEARCH_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic search plan' },
      },
    });
    const version = await prisma.planVersion.create({
      data: {
        planId: plan.id,
        version: 1,
        quotas: { storageBytes: 10000000 },
        features: { 'circle.enabled': true },
        availableFrom: new Date('2023-01-01'),
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
    const rows: {
      name: string;
      body: string;
      day: string;
      child: string;
      author?: string;
      visibility?: Visibility;
    }[] = [
      {
        name: 'walk',
        body: 'Bé tập đi những bước đầu tiên',
        day: '2025-10-19',
        child: childA,
      },
      {
        name: 'beach',
        body: 'Đi biển cùng ông bà',
        day: '2024-10-19',
        child: childB,
      },
      {
        name: 'meal',
        body: 'Bữa ăn dặm đầu tiên',
        day: '2026-10-01',
        child: childA,
        visibility: 'PARENTS',
      },
      {
        name: 'mama',
        body: 'Tập đi cùng Mama',
        day: '2023-10-19',
        child: childA,
        author: partner,
      },
    ];
    for (const row of rows) {
      const id = randomUUID();
      ids.set(row.name, id);
      const at = new Date(`${row.day}T03:00:00Z`);
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: row.author ?? parent,
          authorRole: 'PARENT',
          kind: 'MOMENT',
          body: row.body,
          visibility: row.visibility ?? 'FAMILY',
          status: 'PUBLISHED',
          occurredAt: at,
          occurredLocalDate: new Date(row.day),
          publishedAt: at,
        },
      });
      await prisma.memoryChild.create({
        data: { memoryId: id, familyId, childId: row.child, ageMonth: 9 },
      });
    }
    partnerComment = (
      await prisma.comment.create({
        data: {
          familyId,
          memoryId: ids.get('walk')!,
          authorUserId: partner,
          body: 'Giỏi quá con',
        },
      })
    ).id;
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt: new Date() },
        });
        await prisma.userSession.updateMany({
          where: { userId: { in: [parent, partner, circle] } },
          data: { deletedAt: new Date() },
        });
        await prisma.user.updateMany({
          where: { id: { in: [parent, partner, circle] } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
      }
    } finally {
      await app?.close();
    }
  });

  it('MEM-15 matches words as prefixes, without diacritics or case', async () => {
    expect(list(await search('tap di').expect(200)).sort()).toEqual(
      ofNames('walk', 'mama'),
    );
    expect(list(await search('BƯỚC').expect(200))).toEqual(ofNames('walk'));
    expect(list(await search('an dam').expect(200))).toEqual(ofNames('meal'));
    expect(list(await search('khong co').expect(200))).toEqual([]);
    await search('a').expect(400);
  });

  it('MEM-15 applies the feed ACL before paging', async () => {
    // Circle sees only FAMILY memories of the granted child.
    expect(list(await search('di', circle).expect(200)).sort()).toEqual(
      ofNames('walk', 'mama'),
    );
    expect(list(await search('an dam', circle).expect(200))).toEqual([]);
    const first = await call(
      'get',
      `/families/${familyId}/search?q=di&limit=1`,
    ).expect(200);
    expect(list(first)).toHaveLength(1);
    expect((first.body as { nextCursor: string | null }).nextCursor).toEqual(
      expect.any(String),
    );
  });

  it('MEM-16 groups the same day of earlier years, with the same ACL', async () => {
    const parentView = data<{ date: string; groups: Group[] }>(
      await call(
        'get',
        `/families/${familyId}/on-this-day?date=2026-10-19`,
      ).expect(200),
    );
    expect(parentView.date).toBe('2026-10-19');
    expect(
      parentView.groups.map((group) => [
        group.yearsAgo,
        group.date,
        group.memories.map((memory) => memory.id),
      ]),
    ).toEqual([
      [1, '2025-10-19', [ids.get('walk')]],
      [2, '2024-10-19', [ids.get('beach')]],
      [3, '2023-10-19', [ids.get('mama')]],
    ]);
    const circleView = data<{ groups: Group[] }>(
      await call(
        'get',
        `/families/${familyId}/on-this-day?date=2026-10-19`,
        circle,
      ).expect(200),
    );
    expect(circleView.groups.map((group) => group.yearsAgo)).toEqual([1, 3]);
  });

  it('MEM-25 lists one child’s day with the feed ACL', async () => {
    const story = data<{
      date: string;
      childId: string;
      memoryCount: number;
      slides: unknown[];
    }>(
      await call(
        'get',
        `/children/${childA}/today-story?date=2025-10-19`,
      ).expect(200),
    );
    expect(story).toMatchObject({
      date: '2025-10-19',
      childId: childA,
      memoryCount: 1,
    });
    // Ký ức không có ảnh: không có trang trình chiếu.
    expect(story.slides).toEqual([]);
    // Circle không được xem bé B: ngày đó trống với họ.
    const circleView = data<{ memoryCount: number }>(
      await call(
        'get',
        `/children/${childB}/today-story?date=2024-10-19`,
        circle,
      ).expect(200),
    );
    expect(circleView.memoryCount).toBe(0);
    await call('get', `/children/${randomUUID()}/today-story`).expect(404);
  });

  it('RPT-02 blocks hide the person’s memories and comments for the blocker', async () => {
    const parentBlocksPartner = await call('post', '/blocks')
      .send({ familyId, userId: partner })
      .expect(422);
    expect(code(parentBlocksPartner)).toBe('BLOCK_PARTNER_NOT_ALLOWED');
    await call('post', '/blocks', circle)
      .send({ familyId, userId: circle })
      .expect(422);
    await call('post', '/blocks', circle)
      .send({ familyId, userId: randomUUID() })
      .expect(404);

    await call('post', '/blocks', circle)
      .send({ familyId, userId: partner })
      .expect(204);
    // Blocking twice is a no-op.
    await call('post', '/blocks', circle)
      .send({ familyId, userId: partner })
      .expect(204);
    expect(list(await search('tap di', circle).expect(200))).toEqual(
      ofNames('walk'),
    );
    const comments = data<Item[]>(
      await call('get', `/memories/${ids.get('walk')}/comments`, circle).expect(
        200,
      ),
    );
    expect(comments.map((comment) => comment.id)).not.toContain(partnerComment);
    const blocked = data<{ items: { userId: string; displayName: string }[] }>(
      await call('get', `/me/blocks?familyId=${familyId}`, circle).expect(200),
    );
    expect(blocked.items.map((item) => item.userId)).toEqual([partner]);
    // The parent's view is unchanged.
    expect(list(await search('tap di').expect(200)).sort()).toEqual(
      ofNames('walk', 'mama'),
    );

    await call(
      'delete',
      `/blocks/${partner}?familyId=${familyId}`,
      circle,
    ).expect(204);
    expect(list(await search('tap di', circle).expect(200)).sort()).toEqual(
      ofNames('walk', 'mama'),
    );
  });

  it('RPT-01 reports only visible content, idempotently, and can hide it', async () => {
    const body = {
      familyId,
      targetType: 'MEMORY',
      targetId: ids.get('walk'),
      reason: 'PRIVACY',
      hideForMe: true,
    };
    const first = data<{ id: string; code: string; status: string }>(
      await call('post', '/reports', circle).send(body).expect(201),
    );
    expect(first.status).toBe('NEW');
    expect(first.code).toMatch(/^BC-\d{6}-[0-9A-F]{4}$/);
    const again = data<{ id: string }>(
      await call('post', '/reports', circle).send(body).expect(201),
    );
    expect(again.id).toBe(first.id);
    expect(
      await prisma.report.count({
        where: { reporterUserId: circle, targetId: ids.get('walk') },
      }),
    ).toBe(1);
    expect(list(await search('di', circle).expect(200))).toEqual(
      ofNames('mama'),
    );
    expect(
      list(await call('get', `/families/${familyId}/feed`, circle)),
    ).not.toContain(ids.get('walk'));

    // Hidden or missing look the same; own content cannot be reported.
    await call('post', '/reports', circle)
      .send({ ...body, targetId: ids.get('beach'), hideForMe: false })
      .expect(404);
    const own = await call('post', '/reports')
      .send({ ...body, targetId: ids.get('walk') })
      .expect(422);
    expect(code(own)).toBe('REPORT_SELF_NOT_ALLOWED');
    await call('post', '/reports')
      .send({ ...body, reason: 'NOT_A_REASON' })
      .expect(400);

    const commentReport = await call('post', '/reports')
      .send({
        familyId,
        targetType: 'COMMENT',
        targetId: partnerComment,
        reason: 'HARASSMENT',
        hideForMe: true,
      })
      .expect(201);
    expect(data<{ status: string }>(commentReport).status).toBe('NEW');
    const comments = data<Item[]>(
      await call('get', `/memories/${ids.get('walk')}/comments`).expect(200),
    );
    expect(comments.map((comment) => comment.id)).not.toContain(partnerComment);
  });
});
