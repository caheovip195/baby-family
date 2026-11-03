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

interface BookItem {
  memoryId: string;
  kind: string;
  caption: string;
  assetIds: string[];
  selectedAssetIds: string[];
  included: boolean;
  photos: { assetId: string; url: string | null }[];
}
interface BookView {
  childId: string;
  year: number;
  title: string | null;
  canExport: boolean;
  canShare?: boolean;
  sharedWithCircle?: boolean;
  readOnly?: boolean;
  saved: boolean;
  chapters: { month: number; title: string | null; items: BookItem[] }[];
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;

/** BF-20261028-013: REC-04 Sách của con — chương theo tháng, chỉ Parent. */
describe('Year book API (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const year = new Date().getUTCFullYear() - 1;
  const parentA = randomUUID(),
    parentB = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID(),
    granted = randomUUID();
  const users = [parentA, parentB, circle, outsider, granted];
  const sessions = new Map(users.map((id) => [id, randomUUID()]));
  const tokens = new Map<string, string>();
  const familyId = randomUUID(),
    coupleSpaceId = randomUUID(),
    childId = randomUUID(),
    planId = randomUUID(),
    planVersionId = randomUUID(),
    licenseId = randomUUID();
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);
  const book = (userId: string, y = year, id = childId) =>
    request(app.getHttpServer())
      .get(`/api/v1/children/${id}/year-book/${y}`)
      .set('Authorization', tokens.get(userId) ?? '');
  const save = (userId: string, body: object) =>
    request(app.getHttpServer())
      .put(`/api/v1/children/${childId}/year-book/${year}`)
      .set('Authorization', tokens.get(userId) ?? '')
      .send(body);

  const familyBook = (userId: string, y = year) =>
    request(app.getHttpServer())
      .get(`/api/v1/families/${familyId}/year-book/${y}`)
      .set('Authorization', tokens.get(userId) ?? '');
  const saveFamily = (userId: string, body: object) =>
    request(app.getHttpServer())
      .put(`/api/v1/families/${familyId}/year-book/${year}`)
      .set('Authorization', tokens.get(userId) ?? '')
      .send(body);

  async function memory(
    day: string,
    options: {
      kind?: string;
      title?: string;
      photos?: number;
      visibility?: string;
      /** false = khoảnh khắc chung của gia đình (không gắn bé). */
      child?: boolean;
    } = {},
  ) {
    const row = await prisma.memory.create({
      data: {
        familyId,
        kind: (options.kind ?? 'MOMENT') as never,
        title: options.title ?? null,
        body: 'Một khoảnh khắc tổng hợp',
        authorUserId: parentA,
        authorRole: 'PARENT',
        occurredAt: new Date(`${day}T03:00:00.000Z`),
        occurredLocalDate: new Date(`${day}T00:00:00.000Z`),
        visibility: (options.visibility ?? 'FAMILY') as never,
        familyMoment: options.child === false,
        status: 'PUBLISHED',
        publishedAt: new Date(),
      },
    });
    if (options.child !== false)
      await prisma.memoryChild.create({
        data: { memoryId: row.id, childId, familyId, ageMonth: 1 },
      });
    const assets: string[] = [];
    for (let index = 0; index < (options.photos ?? 0); index++) {
      const asset = await prisma.asset.create({
        data: {
          familyId,
          uploaderUserId: parentA,
          kind: 'IMAGE',
          status: 'READY',
          storageKey: `fam/${familyId}/a/${randomUUID()}/orig`,
          mime: 'image/jpeg',
          declaredSize: 1000n,
        },
      });
      await prisma.memoryAsset.create({
        data: {
          memoryId: row.id,
          assetId: asset.id,
          familyId,
          sortOrder: index,
        },
      });
      assets.push(asset.id);
    }
    return { id: row.id, assets };
  }
  async function clean() {
    await prisma.outboxEvent.deleteMany({
      where: { familyId, eventType: 'yearbook.shared' },
    });
    await prisma.recap.deleteMany({ where: { familyId } });
    await prisma.memoryAsset.deleteMany({ where: { familyId } });
    await prisma.memoryChild.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    await prisma.asset.deleteMany({ where: { familyId } });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Year book integration requires a *_test database.');
    const keys = await generateKeyPair('ES256');
    const configuration = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
      COUPLE_CHECKIN_ENCRYPTION_KEY: randomBytes(32).toString('base64'),
    });
    const { AppModule } = await import('../../src/app.module.js');
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
      data: users.map((id) => ({
        id,
        displayName: 'Synthetic year book fixture',
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
    for (const userId of users) {
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
      tokens.set(userId, `Bearer ${token}`);
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic year book family',
        createdBy: parentA,
        status: 'ACTIVE',
        activatedAt: past(),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });
    const a = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'A',
      },
    });
    const b = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'B',
      },
    });
    await prisma.coupleSpace.create({
      data: {
        id: coupleSpaceId,
        familyId,
        parentAUserId: parentA,
        parentBUserId: parentB,
        parentAMembershipId: a.id,
        parentBMembershipId: b.id,
      },
    });
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'CAREGIVER',
        displayName: 'Synthetic Circle',
        invitedBy: parentA,
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `YEARBOOK_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic year book plan' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: {},
        features: { 'circle.enabled': true },
        availableFrom: past(),
      },
    });
    await prisma.familyLicense.create({ data: { id: licenseId, familyId } });
    const birth = new Date(Date.UTC(year, 0, 1));
    await prisma.child.create({
      data: {
        id: childId,
        familyId,
        name: 'Synthetic year book child',
        birthDate: birth,
        colorIndex: 1,
        createdBy: parentA,
      },
    });
    const viewer = await prisma.circleMember.create({
      data: {
        familyId,
        userId: granted,
        relation: 'CAREGIVER',
        displayName: 'Synthetic granted relative',
        invitedBy: parentA,
      },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: viewer.id,
        childId,
        createdBy: parentA,
        permission: 'VIEW',
      },
    });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: future(),
      },
    });
  });
  beforeEach(async () => {
    await clean();
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await clean();
        await prisma.circleGrant.deleteMany({ where: { familyId } });
        await prisma.coupleSpace.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.child.updateMany({
          where: { familyId },
          data: { deletedAt: new Date() },
        });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        await prisma.familyParent.deleteMany({ where: { familyId } });
        await prisma.familyLicense.updateMany({
          where: { id: licenseId },
          data: { deletedAt: new Date() },
        });
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt: new Date() },
        });
        await prisma.userSession.deleteMany({
          where: { userId: { in: users } },
        });
        await prisma.user.updateMany({
          where: { id: { in: users } },
          data: { deletedAt: new Date(), status: 'DELETED' },
        });
        await prisma.planVersion.deleteMany({ where: { planId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
      }
    } finally {
      if (app) await app.close();
    }
  });

  it('suggests monthly chapters, milestones first, only visible memories', async () => {
    const day = (month: number, date = 10) =>
      `${year}-${String(month).padStart(2, '0')}-${String(date).padStart(2, '0')}`;
    const moments = [];
    for (let index = 0; index < 5; index++)
      moments.push(await memory(day(3, 2 + index), { photos: 2 }));
    const milestone = await memory(day(3, 20), {
      kind: 'MILESTONE',
      title: 'Lẫy lần đầu',
      photos: 1,
    });
    const textMilestone = await memory(day(3, 21), {
      kind: 'MILESTONE',
      title: 'Biết cười',
    });
    await memory(day(5), { photos: 1, visibility: 'PARENTS' });
    await memory(day(6), { kind: 'LETTER', photos: 1 });
    await memory(`${year + 1}-01-02`, { photos: 1 });

    const view = data<BookView>(await book(parentB).expect(200));
    expect(view).toMatchObject({
      year,
      title: null,
      saved: false,
      canExport: true,
    });
    expect(view.chapters.map((chapter) => chapter.month)).toEqual([3, 5]);
    const march = view.chapters[0]!.items;
    expect(march.map((item) => item.memoryId)).toEqual([
      ...moments.map((item) => item.id),
      milestone.id,
      textMilestone.id,
    ]);
    const included = march.filter((item) => item.included);
    // Cột mốc trước, tối đa 4 ký ức có ảnh (mỗi ký ức một ảnh đầu) + cột mốc chữ.
    expect(included.map((item) => item.memoryId)).toEqual([
      moments[0]!.id,
      moments[1]!.id,
      moments[2]!.id,
      milestone.id,
      textMilestone.id,
    ]);
    expect(included[0]!.selectedAssetIds).toEqual([moments[0]!.assets[0]]);
    expect(march[5]!.caption).toBe('Lẫy lần đầu');
    expect(march[0]!.photos.map((photo) => photo.assetId)).toEqual(
      moments[0]!.assets,
    );

    // Circle / người được xem: không có quyền (Parent only).
    for (const userId of [circle, granted, outsider])
      expect([403, 404]).toContain((await book(userId)).status);
    await book(parentA, year - 2).expect(400);
  });

  it('saves selections, captions and title; validates ownership', async () => {
    const a = await memory(`${year}-04-03`, { photos: 3 });
    const b = await memory(`${year}-04-09`, { photos: 1 });
    const other = await memory(`${year}-07-01`, { photos: 1 });
    const saved = data<BookView>(
      await save(parentA, {
        title: '  Năm đầu của con  ',
        chapters: [
          {
            month: 4,
            title: 'Tháng tư',
            items: [
              {
                memoryId: a.id,
                assetIds: [a.assets[2], a.assets[0]],
                caption: '  Đi chơi  ',
              },
            ],
          },
        ],
      }).expect(200),
    );
    expect(saved).toMatchObject({ saved: true, title: 'Năm đầu của con' });
    const april = saved.chapters.find((chapter) => chapter.month === 4);
    expect(april?.title).toBe('Tháng tư');
    expect(april?.items[0]).toMatchObject({
      memoryId: a.id,
      included: true,
      caption: 'Đi chơi',
      selectedAssetIds: [a.assets[2], a.assets[0]],
    });
    expect(april?.items[1]).toMatchObject({ memoryId: b.id, included: false });
    // Chương chưa lưu (tháng 7) → không có ký ức nào được chọn.
    expect(
      saved.chapters.find((chapter) => chapter.month === 7)?.items[0]!.included,
    ).toBe(false);
    const recap = await prisma.recap.findFirstOrThrow({
      where: { familyId, period: 'YEAR' },
    });
    expect(recap.coverAssetId).toBe(a.assets[2]);
    expect(data<BookView>(await book(parentB).expect(200)).title).toBe(
      'Năm đầu của con',
    );

    // Lưu lại → đè cùng một bản.
    await save(parentB, { chapters: [] }).expect(200);
    expect(await prisma.recap.count({ where: { familyId } })).toBe(1);

    const item = (memoryId: string, assetIds: string[]) => ({
      chapters: [{ month: 4, items: [{ memoryId, assetIds }] }],
    });
    await save(parentA, item(other.id, [])).expect(400);
    await save(parentA, item(a.id, [b.assets[0]!])).expect(400);
    await save(parentA, item(randomUUID(), [])).expect(400);
    await save(parentA, {
      chapters: [
        { month: 4, items: [] },
        { month: 4, items: [] },
      ],
    }).expect(400);
    await save(parentA, { chapters: [{ month: 13, items: [] }] }).expect(400);
    expect([403, 404]).toContain((await save(circle, { chapters: [] })).status);
  });

  it('BF-20261030-001: the family book has every family memory and is saved apart from the child book', async () => {
    const own = await memory(`${year}-02-03`, { photos: 1 });
    const together = await memory(`${year}-02-14`, {
      photos: 2,
      child: false,
    });
    await memory(`${year}-03-01`, { photos: 1, visibility: 'PARENTS' });

    const view = data<BookView & { scope: string; childId: string | null }>(
      await familyBook(parentB).expect(200),
    );
    expect(view).toMatchObject({
      scope: 'FAMILY',
      familyId,
      childId: null,
      childName: 'Synthetic year book family',
      saved: false,
    });
    expect(view.chapters.map((chapter) => chapter.month)).toEqual([2, 3]);
    expect(view.chapters[0]!.items.map((item) => item.memoryId)).toEqual([
      own.id,
      together.id,
    ]);
    // Sách của bé không có khoảnh khắc chung.
    const childView = data<BookView>(await book(parentA).expect(200));
    expect(
      childView.chapters.flatMap((c) => c.items.map((i) => i.memoryId)),
    ).not.toContain(together.id);

    await saveFamily(parentA, {
      title: 'Nhà mình năm nay',
      chapters: [
        {
          month: 2,
          items: [{ memoryId: together.id, assetIds: [together.assets[1]] }],
        },
      ],
    }).expect(200);
    await save(parentA, { chapters: [] }).expect(200);
    // Lưu lại sách cả nhà → đè cùng bản (child_id NULL vẫn một bản).
    await Promise.all([
      saveFamily(parentA, { title: 'Nhà mình', chapters: [] }).expect(200),
      saveFamily(parentB, { title: 'Nhà mình', chapters: [] }).expect(200),
    ]);
    expect(
      await prisma.recap.count({
        where: { familyId, scope: 'FAMILY', period: 'YEAR' },
      }),
    ).toBe(1);
    expect(
      await prisma.recap.count({
        where: { familyId, scope: 'CHILD', period: 'YEAR' },
      }),
    ).toBe(1);
    expect(data<BookView>(await familyBook(parentB).expect(200)).title).toBe(
      'Nhà mình',
    );
    // Không gắn với một bé chỉ được xem riêng: chỉ Parent.
    for (const userId of [circle, granted, outsider])
      expect([403, 404]).toContain((await familyBook(userId)).status);
    await familyBook(parentA, year - 2).expect(400);
    await saveFamily(parentA, {
      chapters: [{ month: 3, items: [{ memoryId: own.id, assetIds: [] }] }],
    }).expect(400);
  });

  it('gates export by the plan feature, falling back to the access phase', async () => {
    const phase = (
      accessPhase: 'TRIAL' | 'PAID',
      versionId: string = planVersionId,
    ) =>
      prisma.familyEntitlement.update({
        where: { familyId },
        data: {
          accessPhase,
          effectivePlanVersionId: versionId,
          trialEndsAt: new Date(Date.now() + 86_400_000),
        },
      });
    const version = async (number: number, exportable: boolean) =>
      (
        await prisma.planVersion.create({
          data: {
            planId,
            version: number,
            quotas: {},
            features: { 'circle.enabled': true, 'yearbook.export': exportable },
            availableFrom: past(),
          },
        })
      ).id;
    const canExport = async () =>
      data<BookView>(await book(parentA).expect(200)).canExport;
    try {
      // Bản gói chưa khai báo cờ: dùng thử chỉ xem trước.
      await phase('TRIAL');
      expect(await canExport()).toBe(false);
      await phase('TRIAL', await version(2, true));
      expect(await canExport()).toBe(true);
      await phase('PAID', await version(3, false));
      expect(await canExport()).toBe(false);
    } finally {
      await phase('PAID');
    }
  });

  it('BF-20261030-002: Parents share a book with relatives, who read only the chosen memories they may see', async () => {
    const picked = await memory(`${year}-05-03`, { photos: 2 });
    const left = await memory(`${year}-05-09`, { photos: 1 });
    const together = await memory(`${year}-06-01`, {
      photos: 1,
      child: false,
    });
    const parentsOnly = await memory(`${year}-06-02`, {
      photos: 1,
      visibility: 'PARENTS',
    });
    // Chưa chia sẻ: người thân không thấy (không lộ bản riêng).
    expect(data<BookView>(await book(parentA).expect(200))).toMatchObject({
      canShare: true,
      sharedWithCircle: false,
      readOnly: false,
    });
    await save(parentA, {
      title: 'Sách riêng',
      chapters: [{ month: 5, items: [{ memoryId: picked.id, assetIds: [] }] }],
    }).expect(200);
    expect([403, 404]).toContain((await book(granted)).status);

    const shared = data<BookView>(
      await save(parentA, {
        title: 'Năm của con',
        sharedWithCircle: true,
        chapters: [
          {
            month: 5,
            title: 'Tháng năm',
            items: [
              {
                memoryId: picked.id,
                assetIds: [picked.assets[1]],
                caption: 'Đi công viên',
              },
            ],
          },
        ],
      }).expect(200),
    );
    expect(shared.sharedWithCircle).toBe(true);
    // BF-20261030-003: một thông báo cho người thân khi mới chia sẻ.
    const sharedEvents = () =>
      prisma.outboxEvent.count({
        where: { familyId, eventType: 'yearbook.shared' },
      });
    expect(await sharedEvents()).toBe(1);
    await save(parentA, {
      title: 'Năm của con',
      sharedWithCircle: true,
      chapters: [
        {
          month: 5,
          title: 'Tháng năm',
          items: [
            {
              memoryId: picked.id,
              assetIds: [picked.assets[1]],
              caption: 'Đi công viên',
            },
          ],
        },
      ],
    }).expect(200);
    expect(await sharedEvents()).toBe(1);
    const view = data<BookView>(await book(granted).expect(200));
    expect(view).toMatchObject({
      readOnly: true,
      canShare: false,
      sharedWithCircle: true,
      title: 'Năm của con',
    });
    expect(view.chapters).toHaveLength(1);
    expect(view.chapters[0]!.items).toEqual([
      expect.objectContaining({
        memoryId: picked.id,
        caption: 'Đi công viên',
        selectedAssetIds: [picked.assets[1]],
      }),
    ]);
    expect(JSON.stringify(view)).not.toContain(left.id);
    // Người thân không có quyền xem bé này / người ngoài: không thấy.
    for (const userId of [circle, outsider])
      expect([403, 404]).toContain((await book(userId)).status);
    // Người thân không sửa được.
    expect([403, 404]).toContain(
      (await save(granted, { chapters: [] })).status,
    );

    // Sách cả nhà chia sẻ: người thân chỉ thấy ký ức họ được xem.
    expect([403, 404]).toContain((await familyBook(granted)).status);
    await saveFamily(parentA, {
      sharedWithCircle: true,
      chapters: [
        {
          month: 6,
          items: [
            { memoryId: together.id, assetIds: [] },
            { memoryId: parentsOnly.id, assetIds: [] },
          ],
        },
      ],
    }).expect(200);
    const familyView = data<BookView>(await familyBook(granted).expect(200));
    const ids = familyView.chapters.flatMap((c) =>
      c.items.map((i) => i.memoryId),
    );
    expect(ids).toEqual([together.id]);

    const list = (userId: string) =>
      request(app.getHttpServer())
        .get(`/api/v1/families/${familyId}/year-books`)
        .set('Authorization', tokens.get(userId) ?? '');
    const forRelative = data<{
      items: { scope: string; childId: string | null; year: number }[];
    }>(await list(granted).expect(200));
    expect(forRelative.items.map((item) => item.scope).sort()).toEqual([
      'CHILD',
      'FAMILY',
    ]);
    // Chuyển về riêng tư → người thân mất quyền xem.
    await save(parentA, { chapters: [] }).expect(200);
    expect([403, 404]).toContain((await book(granted)).status);
    expect(
      data<{ items: unknown[] }>(await list(granted).expect(200)).items,
    ).toHaveLength(1);
    expect(
      data<{ items: unknown[] }>(await list(parentB).expect(200)).items,
    ).toHaveLength(2);
    expect([403, 404]).toContain((await list(outsider)).status);

    // Gói không có Family Circle: không chia sẻ được.
    const noCircle = await prisma.planVersion.create({
      data: {
        planId,
        version: 9,
        quotas: {},
        features: {},
        availableFrom: past(),
      },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { effectivePlanVersionId: noCircle.id },
    });
    try {
      expect(data<BookView>(await book(parentA).expect(200)).canShare).toBe(
        false,
      );
      const refused = await save(parentA, {
        sharedWithCircle: true,
        chapters: [],
      }).expect(402);
      expect((refused.body as { error?: { code?: string } }).error?.code).toBe(
        'PLAN_REQUIRED_FAMILY',
      );
    } finally {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { effectivePlanVersionId: planVersionId },
      });
    }
  });
});
