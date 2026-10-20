import { randomBytes, randomUUID } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import type { Server } from 'node:http';
import path from 'node:path';
import type { INestApplication, ModuleMetadata } from '@nestjs/common';
import { MODULE_METADATA } from '@nestjs/common/constants';
import { TIMELINE_CARD_REPOSITORY } from '../../src/interfaces/repositories/timeline-card-repository.interface';
import { TimelineCardRepository } from '../../src/repositories/timeline-card.repository';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { parse } from 'dotenv';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';
import type { MemoryKind } from '../../src/common/database.enums';
interface MemoryBody {
  id: string;
  occurredAt: string;
  childIds: string[];
  assets: { assetId: string; urls: Record<string, string> }[];
}
type TimelineItem =
  | { type: 'MEMORY'; memory: MemoryBody }
  | {
      type: 'SYSTEM';
      id: string;
      kind: string;
      childId: string;
      monthIndex?: number;
      date: string;
      coverUrl?: string | null;
      coverUrlExpiresAt?: string | null;
      memoryCount?: number;
      firstsCount?: number;
      quotesCount?: number;
    }
  | {
      type: 'RECAP';
      id: string;
      kind: 'WEEKLY_RECAP';
      childId: string | null;
      date: string;
      periodStart: string;
    };
interface GridItem {
  assetId: string;
  memoryId: string;
  kind: string;
  occurredAt: string;
  width: number;
  height: number;
  durationMs: number | null;
  blurhash: string | null;
  urls: Record<string, string>;
  urlsExpireAt: string;
}
interface Page<T> {
  data: T[];
  nextCursor: string | null;
}
const page = <T>(response: { body: unknown }) => response.body as Page<T>;
const memoryIds = (items: TimelineItem[]) =>
  items.flatMap((item) => (item.type === 'MEMORY' ? [item.memory.id] : []));
// Dedicated PostgreSQL (*_test) and real S3 URL-signing configuration, matching memory-api.spec.ts.
const S3_VARIABLES = [
  'S3_ENDPOINT',
  'S3_PUBLIC_ENDPOINT',
  'S3_ACCESS_KEY_ID',
  'S3_SECRET_ACCESS_KEY',
] as const;
const envFile = path.resolve(__dirname, '../../.env');
const fileValues = existsSync(envFile)
  ? parse(readFileSync(envFile, 'utf8'))
  : {};
const s3 = Object.fromEntries(
  S3_VARIABLES.map((name) => [
    name,
    process.env[`TEST_${name}`] ?? fileValues[name] ?? '',
  ]),
);
const describeStack = s3.S3_ENDPOINT ? describe : describe.skip;

describeStack('Parent timeline/media grid (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  const [parentA, parentB, circle] = [randomUUID(), randomUUID(), randomUUID()];
  const sessions = new Map<string, string>([
    [parentA, randomUUID()],
    [parentB, randomUUID()],
    [circle, randomUUID()],
  ]);
  const familyId = randomUUID();
  const otherFamilyId = randomUUID();
  const [childOne, childTwo, foreignChild] = [
    randomUUID(),
    randomUUID(),
    randomUUID(),
  ];
  const planId = randomUUID();
  const versionId = randomUUID();
  const licenseId = randomUUID();
  const suffix = randomUUID().replaceAll('-', '').slice(0, 16);
  const future = () => new Date(Date.now() + 24 * 60 * 60 * 1000);
  const past = () => new Date(Date.now() - 60 * 1000);
  const tokens = new Map<string, string>();

  async function bearer(userId: string) {
    const issued = Math.floor(Date.now() / 1000);
    const token = await new SignJWT({
      sub: userId,
      sid: sessions.get(userId),
      ver: 1,
      iat: issued,
      exp: issued + 900,
      iss: 'baby-family',
      aud: 'baby-family-app',
    })
      .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
      .sign(keys.privateKey);
    return `Bearer ${token}`;
  }

  function get(
    route: 'timeline' | 'media-grid',
    query: Record<string, string | number> = {},
    userId = parentA,
  ) {
    return request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/${route}`)
      .set('Authorization', tokens.get(userId) ?? '')
      .query(query);
  }
  async function all<T>(
    route: 'timeline' | 'media-grid',
    query: Record<string, string | number> = {},
  ): Promise<T[]> {
    const items: T[] = [];
    let cursor: string | null = null;
    for (let n = 0; n < 40; n++) {
      const response: request.Response = await get(route, {
        ...query,
        ...(cursor ? { cursor } : {}),
      }).expect(200);
      const current: Page<T> = page<T>(response);
      items.push(...current.data);
      if (!current.nextCursor) return items;
      expect(current.nextCursor).not.toBe(cursor);
      cursor = current.nextCursor;
    }
    throw new Error('Pagination did not terminate.');
  }
  const pregnancyId = randomUUID();
  const ids = Object.fromEntries(
    [
      'newest',
      'tied',
      'backdated',
      'milestone',
      'diary',
      'letter',
      'pregnancy',
      'private',
      'ownPrivate',
      'draft',
      'processing',
    ].map((name) => [name, randomUUID()]),
  );
  const assets = Object.fromEntries(
    [
      'image',
      'video',
      'processing',
      'private',
      'draft',
      'audio',
      'deleted',
      'detached',
    ].map((name) => [name, randomUUID()]),
  );
  const now = new Date();
  const birth = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth() - 3, 1),
  );
  const when = (day: number) => new Date(birth.getTime() + day * 86400000);
  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (database !== '/baby_family_test')
      throw new Error('Timeline integration requires baby_family_test.');
    keys = await generateKeyPair('ES256');
    const configuration = new ConfigService({
      ...validateEnvironment({ ...process.env, ...s3 }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const { AppModule } = await import('../../src/app.module.js');
    // Isolated composition: production's shared providers file is deliberately
    // unchanged. Add the new optional repository only to this test module.
    const metadata: ModuleMetadata = {
      imports: Reflect.getMetadata(
        MODULE_METADATA.IMPORTS,
        AppModule,
      ) as ModuleMetadata['imports'],
      controllers: Reflect.getMetadata(
        MODULE_METADATA.CONTROLLERS,
        AppModule,
      ) as ModuleMetadata['controllers'],
      providers: [
        ...(Reflect.getMetadata(
          MODULE_METADATA.PROVIDERS,
          AppModule,
        ) as NonNullable<ModuleMetadata['providers']>),
        { provide: TIMELINE_CARD_REPOSITORY, useClass: TimelineCardRepository },
      ],
    };
    const module = await Test.createTestingModule(metadata)
      .overrideProvider(ConfigService)
      .useValue(configuration)
      .compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
    prisma = app.get(PrismaService);
    for (const userId of sessions.keys())
      tokens.set(userId, await bearer(userId));

    await prisma.user.createMany({
      data: [...sessions.keys()].map((id) => ({
        id,
        displayName: 'Synthetic memory fixture',
        status: 'ACTIVE',
        tokenVersion: 1,
      })),
    });
    await prisma.userSession.createMany({
      data: [...sessions].map(([userId, id]) => ({
        id,
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: future(),
        absoluteExpiresAt: future(),
      })),
    });
    for (const [id, name] of [
      [familyId, 'Synthetic memory family'],
      [otherFamilyId, 'Synthetic other family'],
    ] as const)
      await prisma.family.create({
        data: {
          id,
          name,
          createdBy: parentA,
          status: 'ACTIVE',
          activatedAt: past(),
          timezone: 'Asia/Ho_Chi_Minh',
        },
      });
    await prisma.familyParent.createMany({
      data: [
        { familyId, userId: parentA, slot: 'A', kind: 'FATHER', callName: 'A' },
        { familyId, userId: parentB, slot: 'B', kind: 'MOTHER', callName: 'B' },
      ],
    });
    await prisma.child.createMany({
      data: [
        {
          id: childOne,
          familyId,
          nickname: 'One',
          birthDate: new Date('2026-01-20T00:00:00Z'),
          colorIndex: 1,
          createdBy: parentA,
        },
        {
          id: childTwo,
          familyId,
          nickname: 'Two',
          birthDate: new Date('2024-06-02T00:00:00Z'),
          colorIndex: 2,
          createdBy: parentA,
        },
        {
          id: foreignChild,
          familyId: otherFamilyId,
          nickname: 'Foreign',
          birthDate: new Date('2025-01-01T00:00:00Z'),
          colorIndex: 1,
          createdBy: parentA,
        },
      ],
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `MEMORY_PLAN_${suffix}`,
        displayNameI18n: { vi: 'Synthetic memory plan' },
        purchaseEnabled: false,
        active: true,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: versionId,
        planId,
        version: 1,
        quotas: { storageBytes: 1024 * 1024 * 1024, photosPerMemory: 2 },
        features: { 'circle.enabled': true },
        availableFrom: past(),
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
      },
    });

    await prisma.child.update({
      where: { id: childOne },
      data: { birthDate: birth },
    });
    await prisma.pregnancy.create({
      data: {
        id: pregnancyId,
        familyId,
        seqNo: 1,
        nickname: 'Synthetic pregnancy',
        createdBy: parentA,
      },
    });
    const rows: {
      name: string;
      kind: MemoryKind;
      day: number;
      author?: string;
      visibility?: 'PRIVATE';
      status?: 'DRAFT' | 'PROCESSING';
      pregnancyId?: string;
    }[] = [
      { name: 'newest', kind: 'MOMENT', day: 70 },
      { name: 'tied', kind: 'MOMENT', day: 70 },
      { name: 'milestone', kind: 'MILESTONE', day: 60 },
      { name: 'diary', kind: 'DIARY', day: 50 },
      { name: 'letter', kind: 'LETTER', day: 40 },
      { name: 'pregnancy', kind: 'BUMP', day: 30, pregnancyId },
      { name: 'backdated', kind: 'MOMENT', day: 1 },
      {
        name: 'private',
        kind: 'MOMENT',
        day: 71,
        author: parentB,
        visibility: 'PRIVATE',
      },
      { name: 'ownPrivate', kind: 'MOMENT', day: 20, visibility: 'PRIVATE' },
      { name: 'draft', kind: 'MOMENT', day: 72, status: 'DRAFT' },
      { name: 'processing', kind: 'MOMENT', day: 10, status: 'PROCESSING' },
    ];
    for (const [index, row] of rows.entries()) {
      const id = ids[row.name]!;
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: row.author ?? parentA,
          authorRole: 'PARENT',
          kind: row.kind,
          body: 'Synthetic timeline entry',
          occurredAt: when(row.day),
          occurredLocalDate: when(row.day),
          visibility: row.visibility ?? 'PARENTS',
          status: row.status ?? 'PUBLISHED',
          pregnancyId: row.pregnancyId,
          createdAt: new Date(birth.getTime() + index * 1000),
        },
      });
      await prisma.memoryChild.createMany({
        data: [childOne, ...(row.name === 'newest' ? [childTwo] : [])].map(
          (childId) => ({ memoryId: id, childId, familyId, ageMonth: 0 }),
        ),
      });
    }
    for (const [label, id] of Object.entries(assets)) {
      const kind =
        label === 'video' ? 'VIDEO' : label === 'audio' ? 'AUDIO' : 'IMAGE';
      await prisma.asset.create({
        data: {
          id,
          familyId,
          uploaderUserId: label === 'private' ? parentB : parentA,
          kind,
          purpose: 'MEMORY',
          status: label === 'processing' ? 'PROCESSING' : 'READY',
          storageKey: `test/${suffix}/${id}/raw`,
          mime:
            kind === 'VIDEO'
              ? 'video/mp4'
              : kind === 'AUDIO'
                ? 'audio/mp4'
                : 'image/jpeg',
          declaredSize: 1024n,
          sizeBytes: 1024n,
          width: 640,
          height: 480,
          durationMs: kind === 'VIDEO' ? 1234 : null,
          blurhash: 'synthetic',
          deletedAt: label === 'deleted' ? past() : null,
        },
      });
      await prisma.assetVariant.create({
        data: {
          familyId,
          assetId: id,
          variantCode: 't320',
          storageBucket: 'bf-media',
          storageKey: `test/${suffix}/${id}/t320.webp`,
          mime: 'image/webp',
          sizeBytes: 100n,
          width: 320,
          height: 240,
        },
      });
    }
    const links = [
      ['newest', 'image'],
      ['tied', 'video'],
      ['backdated', 'image'],
      ['processing', 'processing'],
      ['private', 'private'],
      ['draft', 'draft'],
      ['newest', 'audio'],
      ['newest', 'deleted'],
      ['newest', 'detached'],
    ];
    for (const [sortOrder, link] of links.entries())
      await prisma.memoryAsset.create({
        data: {
          familyId,
          memoryId: ids[link[0]!]!,
          assetId: assets[link[1]!]!,
          sortOrder,
          deletedAt: link[1] === 'detached' ? past() : null,
        },
      });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        const families = [familyId, otherFamilyId];
        await prisma.outboxEvent.deleteMany({
          where: { familyId: { in: families } },
        });
        await prisma.idempotencyRecord.deleteMany({
          where: { familyId: { in: families } },
        });
        // Running runs may not be deleted; settle them first.
        const runs = { scopeKey: `memory-test-${suffix}` };
        await prisma.jobRun.updateMany({
          where: { ...runs, status: { in: ['PENDING', 'RUNNING'] } },
          data: {
            status: 'SKIPPED',
            finishedAt: new Date(),
            leaseOwner: null,
            leaseExpiresAt: null,
          },
        });
        await prisma.jobRun.deleteMany({ where: runs });
        await prisma.comment.deleteMany({ where: { familyId } });
        await prisma.reaction.deleteMany({ where: { familyId } });
        await prisma.monthlyPhoto.deleteMany({ where: { familyId } });
        await prisma.recap.deleteMany({ where: { familyId } });
        await prisma.memoryAsset.deleteMany({ where: { familyId } });
        await prisma.memoryChild.deleteMany({ where: { familyId } });
        await prisma.memory.deleteMany({ where: { familyId } });
        await prisma.assetVariant.deleteMany({ where: { familyId } });
        await prisma.storageReservation.deleteMany({ where: { familyId } });
        await prisma.asset.deleteMany({ where: { familyId } });
        await prisma.familyUsage.deleteMany({ where: { familyId } });
        await prisma.circleGrant.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.child.deleteMany({
          where: { familyId: { in: families } },
        });
        await prisma.pregnancy.deleteMany({ where: { familyId } });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        await prisma.familyParent.deleteMany({ where: { familyId } });
        await prisma.familyLicense.updateMany({
          where: { id: licenseId },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: { in: families } },
          data: { deletedAt: new Date() },
        });
        await prisma.userSession.deleteMany({
          where: { userId: { in: [...sessions.keys()] } },
        });
        await prisma.user.updateMany({
          where: { id: { in: [...sessions.keys()] } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
        await prisma.planVersion.deleteMany({ where: { planId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
      }
    } finally {
      if (app) await app.close();
    }
  });

  it('orders by occurred_at then id, excludes drafts/private partner content, and pages without duplicates', async () => {
    const items = await all<TimelineItem>('timeline', { limit: 2 });
    const found = memoryIds(items);
    const expected = [ids.newest!, ids.tied!]
      .sort()
      .reverse()
      .concat([
        ids.milestone!,
        ids.diary!,
        ids.letter!,
        ids.pregnancy!,
        ids.ownPrivate!,
        ids.processing!,
        ids.backdated!,
      ]);
    expect(found).toEqual(expected);
    expect(new Set(found).size).toBe(found.length);
    expect(items.every((item) => item.type === 'MEMORY')).toBe(true);
    const first = page<TimelineItem>(
      await get('timeline', { limit: 2 }).expect(200),
    );
    expect(first.nextCursor).toEqual(expect.any(String));
    expect(
      first.data.find(
        (item) => item.type === 'MEMORY' && item.memory.id === ids.newest,
      ),
    ).toMatchObject({
      type: 'MEMORY',
      memory: {
        childIds: expect.arrayContaining([childOne, childTwo]),
        assets: expect.any(Array),
      },
    });
  });

  it.each([
    [
      'ALL',
      [
        'newest',
        'tied',
        'milestone',
        'diary',
        'letter',
        'pregnancy',
        'backdated',
        'ownPrivate',
        'processing',
      ],
    ],
    ['MILESTONE', ['milestone']],
    ['MEDIA', ['newest', 'tied', 'backdated', 'processing']],
    ['DIARY', ['diary']],
    ['LETTER', ['letter']],
    ['PREGNANCY', ['pregnancy']],
  ])('applies timeline filter %s', async (filter, expected) => {
    const found = memoryIds(await all<TimelineItem>('timeline', { filter }));
    expect(found.sort()).toEqual(expected.map((name) => ids[name]).sort());
  });

  it('filters child/pregnancy without duplicating multi-child memories', async () => {
    expect(
      memoryIds(await all<TimelineItem>('timeline', { childId: childTwo })),
    ).toEqual([ids.newest]);
    expect(
      memoryIds(await all<TimelineItem>('timeline', { pregnancyId })),
    ).toEqual([ids.pregnancy]);
    const found = memoryIds(
      await all<TimelineItem>('timeline', { childId: childOne, limit: 2 }),
    );
    expect(found.filter((id) => id === ids.newest)).toHaveLength(1);
  });

  it('merges birth/monthiversary cards once across date-range pages with stable ids and dates', async () => {
    const items = await all<TimelineItem>('timeline', {
      childId: childOne,
      limit: 2,
    });
    const cards = items.filter(
      (item): item is Extract<TimelineItem, { type: 'SYSTEM' }> =>
        item.type === 'SYSTEM' && item.kind !== 'CHAPTER',
    );
    expect(cards).toHaveLength(4);
    expect(new Set(cards.map((card) => card.id)).size).toBe(4);
    expect(cards).toContainEqual({
      type: 'SYSTEM',
      id: `sys:birth:${childOne}`,
      kind: 'BIRTH',
      childId: childOne,
      date: birth.toISOString().slice(0, 10),
    });
    for (let n = 1; n <= 3; n++) {
      const date = new Date(
        Date.UTC(birth.getUTCFullYear(), birth.getUTCMonth() + n, 1),
      )
        .toISOString()
        .slice(0, 10);
      expect(cards).toContainEqual({
        type: 'SYSTEM',
        id: `sys:monthiversary:${childOne}:${n}`,
        kind: 'MONTHIVERSARY',
        childId: childOne,
        monthIndex: n,
        date,
      });
    }
    const dates = items.map((item) =>
      item.type === 'MEMORY' ? item.memory.occurredAt.slice(0, 10) : item.date,
    );
    expect(dates).toEqual([...dates].sort().reverse());
  });

  it('adds unique monthly chapters with signed covers, ACL-filtered counts and null placeholders', async () => {
    await prisma.monthlyPhoto.create({
      data: {
        familyId,
        childId: childOne,
        monthIndex: 0,
        memoryId: ids.backdated!,
        assetId: assets.image!,
        setBy: parentA,
      },
    });
    try {
      const items = await all<TimelineItem>('timeline', {
        childId: childOne,
        limit: 1,
      });
      const chapters = items.filter(
        (item): item is Extract<TimelineItem, { type: 'SYSTEM' }> =>
          item.type === 'SYSTEM' && item.kind === 'CHAPTER',
      );
      expect(chapters).toHaveLength(4);
      expect(new Set(chapters.map((item) => item.id)).size).toBe(4);
      expect(chapters).toContainEqual(
        expect.objectContaining({
          id: `sys:chapter:${childOne}:0`,
          monthIndex: 0,
          coverUrl: expect.stringContaining('X-Amz-Signature='),
          coverUrlExpiresAt: expect.any(String),
        }),
      );
      expect(chapters).toContainEqual(
        expect.objectContaining({
          id: `sys:chapter:${childOne}:0`,
          // All fixtures currently use ageMonth=0. Draft and partner-private rows never count.
          memoryCount: 9,
          firstsCount: 1,
          quotesCount: 0,
        }),
      );
      expect(chapters).toContainEqual(
        expect.objectContaining({
          id: `sys:chapter:${childOne}:1`,
          coverUrl: null,
          memoryCount: 0,
        }),
      );
      await prisma.memory.update({
        where: { id: ids.backdated! },
        data: { visibility: 'PRIVATE' },
      });
      const partner = page<TimelineItem>(
        await get('timeline', { childId: childOne }, parentB).expect(200),
      );
      expect(partner.data).toContainEqual(
        expect.objectContaining({
          type: 'SYSTEM',
          id: `sys:chapter:${childOne}:0`,
          coverUrl: null,
        }),
      );
      await prisma.memory.update({
        where: { id: ids.backdated! },
        data: { visibility: 'PARENTS' },
      });
      await prisma.memoryAsset.update({
        where: {
          memoryId_assetId: {
            memoryId: ids.backdated!,
            assetId: assets.image!,
          },
        },
        data: { deletedAt: new Date() },
      });
      const detached = page<TimelineItem>(
        await get('timeline', { childId: childOne }).expect(200),
      );
      expect(detached.data).toContainEqual(
        expect.objectContaining({
          type: 'SYSTEM',
          id: `sys:chapter:${childOne}:0`,
          coverUrl: null,
        }),
      );
      await prisma.memoryAsset.update({
        where: {
          memoryId_assetId: {
            memoryId: ids.backdated!,
            assetId: assets.image!,
          },
        },
        data: { deletedAt: null },
      });
      await prisma.memory.update({
        where: { id: ids.backdated! },
        data: { occurredLocalDate: when(40) },
      });
      expect(
        page<TimelineItem>(
          await get('timeline', { childId: childOne }).expect(200),
        ).data,
      ).toContainEqual(
        expect.objectContaining({
          type: 'SYSTEM',
          id: `sys:chapter:${childOne}:0`,
          coverUrl: null,
        }),
      );
      await prisma.memory.update({
        where: { id: ids.backdated! },
        data: { occurredLocalDate: when(1) },
      });
      await prisma.memoryChild.update({
        where: {
          memoryId_childId: { memoryId: ids.backdated!, childId: childOne },
        },
        data: { childId: childTwo },
      });
      expect(
        page<TimelineItem>(
          await get('timeline', { childId: childOne }).expect(200),
        ).data,
      ).toContainEqual(
        expect.objectContaining({
          type: 'SYSTEM',
          id: `sys:chapter:${childOne}:0`,
          coverUrl: null,
        }),
      );
    } finally {
      await prisma.memoryChild.updateMany({
        where: { memoryId: ids.backdated!, familyId },
        data: { childId: childOne },
      });
      await prisma.memory.update({
        where: { id: ids.backdated! },
        data: { occurredLocalDate: when(1) },
      });
      await prisma.monthlyPhoto.deleteMany({ where: { familyId } });
      await prisma.memory.update({
        where: { id: ids.backdated! },
        data: { visibility: 'PARENTS' },
      });
      await prisma.memoryAsset.update({
        where: {
          memoryId_assetId: {
            memoryId: ids.backdated!,
            assetId: assets.image!,
          },
        },
        data: { deletedAt: null },
      });
    }
  });

  it('keeps chapter covers/counts within Circle grants and excludes hidden memories', async () => {
    const memberId = randomUUID();
    const recapId = randomUUID();
    await prisma.circleMember.create({
      data: {
        id: memberId,
        familyId,
        userId: circle,
        displayName: 'Synthetic Circle',
        relation: 'OTHER',
      },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: memberId,
        childId: childOne,
        permission: 'VIEW',
        createdBy: parentA,
      },
    });
    await prisma.memory.updateMany({
      where: { id: { in: [ids.newest!, ids.backdated!] }, familyId },
      data: { visibility: 'FAMILY' },
    });
    await prisma.monthlyPhoto.create({
      data: {
        familyId,
        childId: childOne,
        monthIndex: 2,
        memoryId: ids.newest!,
        assetId: assets.image!,
        setBy: parentA,
      },
    });
    try {
      await prisma.recap.create({
        data: {
          id: recapId,
          familyId,
          scope: 'FAMILY',
          period: 'WEEK',
          periodStart: when(30),
          periodEnd: when(36),
          visibility: 'PARENTS',
          content: { version: 1 },
          contentParentsOnly: { appreciationCount: 10 },
        },
      });
      expect(
        page<TimelineItem>(
          await get('timeline', {}, circle).expect(200),
        ).data.filter((item) => item.type === 'RECAP'),
      ).toEqual([]);
      await prisma.recap.update({
        where: { id: recapId },
        data: { visibility: 'FAMILY' },
      });
      expect(
        page<TimelineItem>(await get('timeline', {}, circle).expect(200)).data,
      ).toContainEqual({
        type: 'RECAP',
        id: recapId,
        kind: 'WEEKLY_RECAP',
        childId: null,
        date: when(30).toISOString().slice(0, 10),
        periodStart: when(30).toISOString().slice(0, 10),
      });
      const read = async () =>
        page<TimelineItem>(
          await get('timeline', { childId: childOne }, circle).expect(200),
        );
      const chapter = (items: TimelineItem[], monthIndex = 2) =>
        items.find(
          (item) =>
            item.type === 'SYSTEM' &&
            item.id === `sys:chapter:${childOne}:${monthIndex}`,
        );
      expect(chapter((await read()).data)).toMatchObject({ coverUrl: null });
      await prisma.monthlyPhoto.updateMany({
        where: { familyId },
        data: { memoryId: ids.backdated!, monthIndex: 0 },
      });
      expect(chapter((await read()).data, 0)).toMatchObject({
        coverUrl: expect.stringContaining('X-Amz-Signature='),
      });
      await prisma.reportHide.create({
        data: {
          userId: circle,
          targetType: 'MEMORY',
          targetId: ids.backdated!,
        },
      });
      const hidden = (await read()).data;
      expect(chapter(hidden, 0)).toMatchObject({ coverUrl: null });
      expect(hidden).toContainEqual(
        expect.objectContaining({
          type: 'SYSTEM',
          id: `sys:chapter:${childOne}:0`,
          memoryCount: 0,
        }),
      );
      await get('timeline', { childId: childTwo }, circle).expect(404);
    } finally {
      await prisma.recap.deleteMany({ where: { id: recapId, familyId } });
      await prisma.reportHide.deleteMany({
        where: { userId: circle, targetId: ids.backdated! },
      });
      await prisma.monthlyPhoto.deleteMany({ where: { familyId } });
      await prisma.memory.updateMany({
        where: { id: { in: [ids.newest!, ids.backdated!] }, familyId },
        data: { visibility: 'PARENTS' },
      });
      await prisma.circleGrant.deleteMany({
        where: { circleMemberId: memberId, familyId },
      });
      await prisma.circleMember.deleteMany({
        where: { id: memberId, familyId },
      });
    }
  });

  it('merges existing weekly recap metadata once per period across memory pages and omits deleted recaps', async () => {
    const recapId = randomUUID();
    const periodStart = when(30);
    await prisma.recap.create({
      data: {
        id: recapId,
        familyId,
        scope: 'FAMILY',
        period: 'WEEK',
        periodStart,
        periodEnd: when(36),
        visibility: 'PARENTS',
        content: { version: 1 },
      },
    });
    try {
      const recaps = (await all<TimelineItem>('timeline', { limit: 1 })).filter(
        (item) => item.type === 'RECAP',
      );
      expect(recaps).toEqual([
        {
          type: 'RECAP',
          id: recapId,
          kind: 'WEEKLY_RECAP',
          childId: null,
          periodStart: periodStart.toISOString().slice(0, 10),
          date: periodStart.toISOString().slice(0, 10),
        },
      ]);
      await prisma.recap.update({
        where: { id: recapId },
        data: { deletedAt: new Date() },
      });
      expect(
        (await all<TimelineItem>('timeline')).filter(
          (item) => item.type === 'RECAP',
        ),
      ).toEqual([]);
    } finally {
      await prisma.recap.deleteMany({ where: { id: recapId, familyId } });
    }
  });

  it('returns only visible READY image/video assets with metadata and signed thumbnail URLs', async () => {
    const items = await all<GridItem>('media-grid', { limit: 1 });
    expect(items.map((item) => item.assetId).sort()).toEqual(
      [assets.image, assets.video].sort(),
    );
    expect(new Set(items.map((item) => item.assetId)).size).toBe(items.length);
    for (const item of items) {
      expect(item).toMatchObject({
        width: 640,
        height: 480,
        blurhash: 'synthetic',
        occurredAt: when(70).toISOString(),
        urls: { t320: expect.stringContaining('X-Amz-Signature=') },
        urlsExpireAt: expect.any(String),
      });
      expect(new Date(item.urlsExpireAt).getTime()).toBeGreaterThan(Date.now());
    }
    expect(items.find((item) => item.assetId === assets.image)?.memoryId).toBe(
      ids.newest,
    );
    expect(items.find((item) => item.assetId === assets.video)).toMatchObject({
      kind: 'VIDEO',
      durationMs: 1234,
    });
  });

  it('filters grid by image/video kind and child', async () => {
    expect(
      (await all<GridItem>('media-grid', { kind: 'IMAGE' })).map(
        (item) => item.assetId,
      ),
    ).toEqual([assets.image]);
    expect(
      (await all<GridItem>('media-grid', { kind: 'VIDEO' })).map(
        (item) => item.assetId,
      ),
    ).toEqual([assets.video]);
    expect(
      (await all<GridItem>('media-grid', { childId: childTwo })).map(
        (item) => item.assetId,
      ),
    ).toEqual([assets.image]);
  });

  it('keeps private content visible only to its author in both routes', async () => {
    const timeline = page<TimelineItem>(
      await get('timeline', {}, parentB).expect(200),
    );
    expect(memoryIds(timeline.data)).toContain(ids.private);
    expect(memoryIds(timeline.data)).not.toContain(ids.ownPrivate);
    const grid = page<GridItem>(
      await get('media-grid', {}, parentB).expect(200),
    );
    expect(grid.data.map((item) => item.assetId)).toContain(assets.private);
  });

  it('does not reveal a sealed letter image to the other Parent', async () => {
    // This READY asset has only a soft-deleted link before this test.
    await prisma.memory.update({
      where: { id: ids.letter! },
      data: { unlockAt: future() },
    });
    await prisma.memoryAsset.create({
      data: {
        familyId,
        memoryId: ids.letter!,
        assetId: assets.detached!,
        sortOrder: 0,
      },
    });
    try {
      const author = await all<GridItem>('media-grid');
      expect(author.map((item) => item.assetId)).toContain(assets.detached);
      const partner = page<GridItem>(
        await get('media-grid', {}, parentB).expect(200),
      );
      expect(partner.data.map((item) => item.assetId)).not.toContain(
        assets.detached,
      );
    } finally {
      await prisma.memoryAsset.delete({
        where: {
          memoryId_assetId: {
            memoryId: ids.letter!,
            assetId: assets.detached!,
          },
        },
      });
      await prisma.memory.update({
        where: { id: ids.letter! },
        data: { unlockAt: null },
      });
    }
  });

  it('emits a local-midnight system card once when equal-time memories straddle pages', async () => {
    const anniversary = new Date(
      Date.UTC(birth.getUTCFullYear(), birth.getUTCMonth() + 2, 1),
    );
    const midnight = new Date(anniversary.getTime() - 7 * 60 * 60 * 1000);
    const tiedIds: string[] = [ids.newest!, ids.tied!];
    await prisma.memory.updateMany({
      where: { id: { in: tiedIds } },
      data: { occurredAt: midnight },
    });
    try {
      const items = await all<TimelineItem>('timeline', {
        childId: childOne,
        limit: 1,
      });
      expect(
        memoryIds(items)
          .filter((id) => tiedIds.includes(id))
          .sort(),
      ).toEqual([...tiedIds].sort());
      const cards = items.filter(
        (item): item is Extract<TimelineItem, { type: 'SYSTEM' }> =>
          item.type === 'SYSTEM' && item.kind !== 'CHAPTER',
      );
      expect(
        cards.filter((item) => item.id === `sys:monthiversary:${childOne}:2`),
      ).toEqual([
        {
          type: 'SYSTEM',
          id: `sys:monthiversary:${childOne}:2`,
          kind: 'MONTHIVERSARY',
          childId: childOne,
          monthIndex: 2,
          date: anniversary.toISOString().slice(0, 10),
        },
      ]);
      expect(new Set(cards.map((card) => card.id)).size).toBe(cards.length);
    } finally {
      await prisma.memory.updateMany({
        where: { id: { in: tiedIds } },
        data: { occurredAt: when(70) },
      });
    }
  });

  it('rejects unknown enums, malformed cursors and invalid limits with 400', async () => {
    await get('timeline', { filter: 'UNKNOWN' }).expect(400);
    await get('media-grid', { kind: 'AUDIO' }).expect(400);
    for (const route of ['timeline', 'media-grid'] as const) {
      await get(route, { cursor: 'not-a-valid-cursor' }).expect(400);
      await get(route, { limit: 0 }).expect(400);
      await get(route, { childId: 'not-a-uuid' }).expect(400);
      await request(app.getHttpServer())
        .get(`/api/v1/families/${familyId}/${route}`)
        .expect(401);
    }
  });

  it('keeps the media grid downloadable when EXPIRED while timeline returns 402', async () => {
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { accessPhase: 'EXPIRED', validUntil: past() },
    });
    try {
      await get('timeline').expect(402);
      const grid = page<GridItem>(await get('media-grid').expect(200));
      expect(grid.data).toHaveLength(2);
      expect(grid.data[0]?.urls.t320).toContain('X-Amz-Signature=');
    } finally {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { accessPhase: 'PAID', validUntil: future() },
      });
    }
  });
});
