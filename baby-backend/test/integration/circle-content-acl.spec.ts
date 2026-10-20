import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type { DownloadUrlInput } from '../../src/interfaces/services/object-storage-service.interface';
import { PrismaService } from '../../src/database/prisma.service';
import type {
  MemoryKind,
  MemoryStatus,
  Visibility,
} from '../../src/common/database.enums';

interface Item {
  id: string;
  memoryId?: string;
  assetId?: string;
  visibility?: string;
  status?: string;
  childIds?: string[];
  memory?: Item;
  type?: string;
}
const value = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const page = (response: { body: unknown }): Item[] => {
  const body = response.body as { data: Item[] | { data: Item[] } };
  return Array.isArray(body.data) ? body.data : body.data.data;
};

describe('Circle content ACL (PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const familyId = randomUUID(),
    parent = randomUUID(),
    partner = randomUUID(),
    circle = randomUUID();
  const childId = randomUUID(),
    hiddenChildId = randomUUID(),
    pregnancyId = randomUUID(),
    albumId = randomUUID();
  const tokens = new Map<string, string>();
  const ids = new Map<string, string>();
  const assetIds = new Map<string, string>();
  const at = new Date('2026-10-01T00:00:00Z');
  const future = () => new Date(Date.now() + 86400000);
  const get = (route: string, user = circle) =>
    request(app.getHttpServer())
      .get(`/api/v1${route}`)
      .set('Authorization', tokens.get(user)!);
  const families = (route: string, user = circle) =>
    get(`/families/${familyId}/${route}`, user);
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
      .overrideProvider(OBJECT_STORAGE_SERVICE)
      .useValue({
        isConfigured: () => true,
        bucketOf: (name: string) => (name === 'bf-media' ? 'media' : null),
        createDownloadUrl: (input: DownloadUrlInput) =>
          Promise.resolve({
            method: 'GET',
            url: `https://storage.invalid/${input.key}`,
            headers: {},
            expiresAt: future(),
          }),
      })
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
        data: {
          id: userId,
          displayName: 'Synthetic ACL fixture',
          status: 'ACTIVE',
        },
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
        name: 'Synthetic ACL family',
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
        nickname: 'Private ended pregnancy',
        status: 'ENDED_PRIVATE',
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
        childId,
        permission: 'CONTRIBUTE',
        allowDownload: true,
        createdBy: parent,
      },
    });
    const plan = await prisma.plan.create({
      data: {
        code: `ACL_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic ACL plan' },
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
      data: {
        id: albumId,
        familyId,
        ownerUserId: parent,
        name: 'Mixed visibility album',
      },
    });
    const rows: {
      name: string;
      visibility?: Visibility;
      status?: MemoryStatus;
      child?: string;
      pregnancy?: string;
      kind?: MemoryKind;
    }[] = [
      { name: 'visible' },
      { name: 'parents', visibility: 'PARENTS' },
      { name: 'private', visibility: 'PRIVATE' },
      { name: 'draft', status: 'DRAFT' },
      { name: 'processing', status: 'PROCESSING' },
      { name: 'pending', status: 'PENDING_REVIEW' },
      { name: 'ungranted', child: hiddenChildId },
      { name: 'ended', pregnancy: pregnancyId },
      { name: 'milestone', kind: 'MILESTONE' },
      { name: 'hiddenMilestone', kind: 'MILESTONE', visibility: 'PARENTS' },
      { name: 'letter', kind: 'LETTER' },
      { name: 'hiddenLetter', kind: 'LETTER', visibility: 'PRIVATE' },
    ];
    for (const row of rows) {
      const id = randomUUID(),
        assetId = randomUUID();
      ids.set(row.name, id);
      assetIds.set(row.name, assetId);
      await prisma.memory.create({
        data: {
          id,
          familyId,
          authorUserId: parent,
          authorRole: 'PARENT',
          kind: row.kind ?? 'MOMENT',
          body: `Synthetic ${row.name}`,
          visibility: row.visibility ?? 'FAMILY',
          status: row.status ?? 'PUBLISHED',
          occurredAt: at,
          occurredLocalDate: at,
          publishedAt: row.status ? null : at,
          pregnancyId: row.pregnancy,
        },
      });
      await prisma.memoryChild.create({
        data: {
          memoryId: id,
          familyId,
          childId: row.child ?? childId,
          ageMonth: 9,
        },
      });
      await prisma.asset.create({
        data: {
          id: assetId,
          familyId,
          uploaderUserId: parent,
          kind: 'IMAGE',
          purpose: 'MEMORY',
          status: 'READY',
          keepOriginal: true,
          storageKey: `test/acl/${familyId}/${assetId}`,
          mime: 'image/jpeg',
          declaredSize: 100n,
          sizeBytes: 100n,
        },
      });
      for (const variantCode of ['t320', 'orig'])
        await prisma.assetVariant.create({
          data: {
            familyId,
            assetId,
            variantCode,
            storageBucket: 'bf-media',
            storageKey: `test/acl/${familyId}/${assetId}/${variantCode}`,
            mime: 'image/jpeg',
            sizeBytes: 100n,
          },
        });
      await prisma.memoryAsset.create({
        data: { familyId, memoryId: id, assetId, sortOrder: 0, isCover: true },
      });
      await prisma.albumMemory.create({
        data: { familyId, albumId, memoryId: id, addedBy: parent },
      });
      await prisma.favorite.create({
        data: { familyId, userId: circle, memoryId: id },
      });
      await prisma.comment.create({
        data: {
          familyId,
          memoryId: id,
          authorUserId: parent,
          body: `Comment ${row.name}`,
        },
      });
      if (row.kind === 'MILESTONE')
        await prisma.milestone.create({
          data: {
            familyId,
            childId,
            memoryId: id,
            customTitle: row.name,
            occurredOn: at,
            createdBy: parent,
          },
        });
      if (row.kind === 'LETTER')
        await prisma.memoryLetter.create({
          data: {
            familyId,
            childId,
            memoryId: id,
            releaseVisibility: 'FAMILY',
            releaseRule: 'DATE',
          },
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

  const visibleNames = ['visible', 'milestone', 'letter'];
  const expected = () => visibleNames.map((name) => ids.get(name)!).sort();
  it.each(['feed', 'timeline', 'favorites'])(
    '%s contains only published FAMILY memories for granted children',
    async (route) => {
      const rows = page(await families(route).expect(200));
      const memories = rows
        .filter((item) => item.type !== 'SYSTEM')
        .map((item) => item.memory ?? item);
      expect(memories.map((item) => item.id).sort()).toEqual(expected());
      for (const item of memories)
        expect(item).toMatchObject({
          visibility: 'FAMILY',
          status: 'PUBLISHED',
          childIds: [childId],
        });
    },
  );
  it('media grid exposes only assets of visible memories', async () => {
    const rows = page(await families('media-grid').expect(200));
    expect(rows.map((item) => item.memoryId).sort()).toEqual(expected());
    expect(rows.map((item) => item.assetId).sort()).toEqual(
      visibleNames.map((name) => assetIds.get(name)!).sort(),
    );
  });
  it('detail, comments and reactions use the same ACL', async () => {
    for (const [name, id] of ids) {
      const status = visibleNames.includes(name) ? 200 : 404;
      const detail = await get(`/memories/${id}`).expect(status);
      if (status === 200)
        expect(
          value<{ assets: { assetId: string }[] }>(detail).assets.map(
            (asset) => asset.assetId,
          ),
        ).toEqual([assetIds.get(name)]);
      await get(`/memories/${id}/comments`).expect(status);
      await request(app.getHttpServer())
        .put(`/api/v1/memories/${id}/reaction`)
        .set('Authorization', tokens.get(circle)!)
        .send({ type: 'LOVE' })
        .expect(status);
    }
  });
  it('album contents, covers and counts exclude hidden memories', async () => {
    expect(
      page(await get(`/albums/${albumId}/memories`).expect(200))
        .map((item) => item.id)
        .sort(),
    ).toEqual(expected());
    const albums = value<{
      items: { id: string; memoryCount: number; coverMemoryId: string }[];
    }>(await families('albums').expect(200));
    expect(albums.items).toHaveLength(1);
    expect(albums.items[0]).toMatchObject({ id: albumId, memoryCount: 3 });
  });
  it('hides a memory if any tagged child is ungranted, including library and album projections', async () => {
    const memoryId = ids.get('visible')!;
    const link = await prisma.memoryChild.create({
      data: { familyId, memoryId, childId: hiddenChildId, ageMonth: 9 },
    });
    try {
      await get(`/memories/${memoryId}`).expect(404);
      await get(`/memories/${memoryId}/comments`).expect(404);
      for (const route of ['feed', 'favorites', 'timeline']) {
        const rows = page(await families(route).expect(200));
        expect(
          rows
            .filter((item) => item.type !== 'SYSTEM')
            .map((item) => (item.memory ?? item).id),
        ).not.toContain(memoryId);
      }
      expect(
        page(await get(`/albums/${albumId}/memories`).expect(200)).map(
          (item) => item.id,
        ),
      ).not.toContain(memoryId);
    } finally {
      await prisma.memoryChild.update({
        where: {
          memoryId_childId: { memoryId: link.memoryId, childId: link.childId },
        },
        data: { deletedAt: new Date() },
      });
    }
  });
  it('milestones, letters and profile stats share the granted-child visibility boundary', async () => {
    expect(
      page(await get(`/children/${childId}/milestones`).expect(200)).map(
        (item) => item.memoryId,
      ),
    ).toEqual([ids.get('milestone')]);
    expect(
      page(await get(`/children/${childId}/letters`).expect(200)).map(
        (item) => item.id,
      ),
    ).toEqual([ids.get('letter')]);
    expect(
      value(await get(`/children/${childId}/profile-stats`).expect(200)),
    ).toMatchObject({ memoryCount: 3, milestoneCount: 1, photoCount: 3 });
    for (const route of ['milestones', 'letters', 'profile-stats'])
      await get(`/children/${hiddenChildId}/${route}`).expect(404);
    await get(`/pregnancies/${pregnancyId}/milestones`).expect(404);
  });
  it('milestones and profile stats exclude every memory with an ungranted child tag', async () => {
    const memoryIds = [ids.get('milestone')!, ids.get('letter')!];
    const parentBefore = value(
      await get(`/children/${childId}/profile-stats`, parent).expect(200),
    );
    await prisma.memoryChild.createMany({
      data: memoryIds.map((memoryId) => ({
        familyId,
        memoryId,
        childId: hiddenChildId,
        ageMonth: 9,
      })),
    });
    try {
      expect(
        page(await get(`/children/${childId}/milestones`).expect(200)),
      ).toEqual([]);
      expect(
        page(await get(`/children/${childId}/letters`).expect(200)),
      ).toEqual([]);
      expect(
        value(await get(`/children/${childId}/profile-stats`).expect(200)),
      ).toMatchObject({ memoryCount: 1, milestoneCount: 0, photoCount: 1 });
      expect(
        page(
          await get(`/children/${childId}/milestones`, parent).expect(200),
        ).map((item) => item.memoryId),
      ).toContain(ids.get('milestone'));
      expect(
        value(
          await get(`/children/${childId}/profile-stats`, parent).expect(200),
        ),
      ).toEqual(parentBefore);
    } finally {
      await prisma.memoryChild.updateMany({
        where: {
          familyId,
          memoryId: { in: memoryIds },
          childId: hiddenChildId,
        },
        data: { deletedAt: new Date() },
      });
    }
    expect(
      page(await get(`/children/${childId}/milestones`).expect(200)).map(
        (item) => item.memoryId,
      ),
    ).toEqual([ids.get('milestone')]);
    expect(
      value(await get(`/children/${childId}/profile-stats`).expect(200)),
    ).toMatchObject({ memoryCount: 3, milestoneCount: 1, photoCount: 3 });
  });
  it('profile stats count released letters with null unlockAt and hide future letters from other viewers', async () => {
    const before = new Map<string, { memoryCount: number }>();
    for (const user of [parent, partner])
      before.set(
        user,
        value(
          await get(`/children/${childId}/profile-stats`, user).expect(200),
        ),
      );
    await prisma.memory.update({
      where: { id: ids.get('letter')! },
      data: { unlockAt: future() },
    });
    try {
      expect(
        value(await get(`/children/${childId}/profile-stats`).expect(200)),
      ).toMatchObject({ memoryCount: 2, photoCount: 2 });
      for (const user of [parent, partner]) {
        const stats = value<{ memoryCount: number }>(
          await get(`/children/${childId}/profile-stats`, user).expect(200),
        );
        expect(stats.memoryCount).toBe(
          before.get(user)!.memoryCount - (user === parent ? 0 : 1),
        );
      }
    } finally {
      await prisma.memory.update({
        where: { id: ids.get('letter')! },
        data: { unlockAt: null },
      });
    }
    expect(
      value(await get(`/children/${childId}/profile-stats`).expect(200)),
    ).toMatchObject({ memoryCount: 3, photoCount: 3 });
  });
  it.each(['EXPIRED', 'BLOCKED'] as const)(
    '%s pauses Circle content reads',
    async (accessPhase) => {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { accessPhase },
      });
      try {
        for (const route of [
          'feed',
          'timeline',
          'media-grid',
          'favorites',
          'albums',
        ]) {
          const response = await families(route).expect(403);
          expect(
            (response.body as { error: { code: string } }).error.code,
          ).toBe('CIRCLE_PAUSED');
        }
        const detail = await get(`/memories/${ids.get('visible')!}`).expect(
          403,
        );
        expect((detail.body as { error: { code: string } }).error.code).toBe(
          'CIRCLE_PAUSED',
        );
        const comments = await get(
          `/memories/${ids.get('visible')!}/comments`,
        ).expect(403);
        expect((comments.body as { error: { code: string } }).error.code).toBe(
          'CIRCLE_PAUSED',
        );
        for (const route of ['milestones', 'profile-stats', 'letters'])
          await get(`/children/${childId}/${route}`).expect(403);
        {
          await get(`/memories/${ids.get('visible')!}`, parent).expect(200);
          await families('media-grid', parent).expect(200);
          const downloads = await request(app.getHttpServer())
            .post(`/api/v1/memories/${ids.get('visible')!}/download-urls`)
            .set('Authorization', tokens.get(parent)!)
            .expect(200);
          expect(value<{ items: unknown[] }>(downloads).items).toHaveLength(1);
        }
      } finally {
        await prisma.familyEntitlement.update({
          where: { familyId },
          data: { accessPhase: 'PAID', validUntil: future() },
        });
      }
    },
  );
  it('pauses Circle sharing when the current catalog removes Circle capability', async () => {
    const entitlement = await prisma.familyEntitlement.findUniqueOrThrow({
      where: { familyId },
    });
    const version = await prisma.planVersion.findUniqueOrThrow({
      where: { id: entitlement.effectivePlanVersionId! },
    });
    const withoutCircle = await prisma.planVersion.create({
      data: {
        planId: version.planId,
        version: 2,
        quotas: { photosPerMemory: 10 },
        features: { 'circle.enabled': false },
        availableFrom: new Date(),
      },
    });
    try {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { effectivePlanVersionId: withoutCircle.id },
      });
      for (const route of [
        'feed',
        'timeline',
        'media-grid',
        'favorites',
        'albums',
      ]) {
        const response = await families(route).expect(403);
        expect((response.body as { error: { code: string } }).error.code).toBe(
          'CIRCLE_PAUSED',
        );
      }
      await get('/memories/' + ids.get('visible')!, parent).expect(200);
    } finally {
      await prisma.familyEntitlement.update({
        where: { familyId },
        data: { effectivePlanVersionId: version.id },
      });
    }
  });
});
