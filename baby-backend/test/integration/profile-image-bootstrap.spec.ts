import { randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { UnauthorizedException } from '@nestjs/common';
import type { ExecutionContext, INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { AUTH_PRINCIPAL } from '../../src/common/auth/auth-principal';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import type { AuthenticatedRequest } from '../../src/common/auth/current-actor.decorator';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { MEDIA_POLICY } from '../../src/config/media-policy';
import { CircleController } from '../../src/controllers/circle.controller';
import { FamilyOnboardingController } from '../../src/controllers/family-onboarding.controller';
import { PrismaService } from '../../src/database/prisma.service';
import type { FamilyBootstrapResponseDto } from '../../src/dto/onboarding/onboarding-response.dto';
import type { CircleBootstrapProfileResponse } from '../../src/dto/circle/circle-profile-response.dto';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { FAMILY_CIRCLE_REPOSITORY } from '../../src/interfaces/repositories/family-circle-repository.interface';
import { MEMORY_LIBRARY_REPOSITORY } from '../../src/interfaces/repositories/memory-library-repository.interface';
import { ONBOARDING_REPOSITORY } from '../../src/interfaces/repositories/onboarding-repository.interface';
import { PROFILE_IMAGE_REPOSITORY } from '../../src/interfaces/repositories/profile-image-repository.interface';
import { USER_REPOSITORY } from '../../src/interfaces/repositories/user-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTH_TOKEN_SERVICE } from '../../src/interfaces/services/auth-token-service.interface';
import { FAMILY_BILLING_SERVICE } from '../../src/interfaces/services/family-billing-service.interface';
import { FAMILY_CIRCLE_SERVICE } from '../../src/interfaces/services/family-circle-service.interface';
import { IMAGE_PROCESSOR_SERVICE } from '../../src/interfaces/services/image-processor-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../../src/interfaces/services/object-storage-service.interface';
import type {
  DownloadUrlInput,
  ObjectStorageBucket,
  PresignedRequest,
} from '../../src/interfaces/services/object-storage-service.interface';
import { ONBOARDING_SERVICE } from '../../src/interfaces/services/onboarding-service.interface';
import { PROFILE_IMAGE_SERVICE } from '../../src/interfaces/services/profile-image-service.interface';
import type { IProfileImageService } from '../../src/interfaces/services/profile-image-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { FamilyCircleRepository } from '../../src/repositories/family-circle.repository';
import { MemoryLibraryRepository } from '../../src/repositories/memory-library.repository';
import { OnboardingRepository } from '../../src/repositories/onboarding.repository';
import { ProfileImageRepository } from '../../src/repositories/profile-image.repository';
import { UserRepository } from '../../src/repositories/user.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { AuthTokenService } from '../../src/services/auth-token.service';
import { FamilyCircleService } from '../../src/services/family-circle.service';
import { OnboardingService } from '../../src/services/onboarding.service';
import { ProfileImageService } from '../../src/services/profile-image.service';

const payload = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;

describe('Profile image bootstrap (focused Nest module + PostgreSQL)', () => {
  const familyId = randomUUID();
  const parent = randomUUID(),
    partner = randomUUID(),
    relative = randomUUID(),
    stranger = randomUUID();
  const users: string[] = [parent, partner, relative, stranger];
  const childA = randomUUID(),
    childB = randomUUID(),
    memberId = randomUUID(),
    grantId = randomUUID();
  const avatarA = randomUUID(),
    coverA = randomUUID(),
    avatarB = randomUUID(),
    userAvatar = randomUUID();
  const planId = randomUUID(),
    planVersionId = randomUUID();
  const principal = (userId: string): AuthPrincipal => ({
    userId,
    sessionId: randomUUID(),
    tokenVersion: 1,
  });
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let images: IProfileImageService;
  const signed = jest.fn((input: DownloadUrlInput): Promise<PresignedRequest> =>
    Promise.resolve({
      method: 'GET',
      url: `https://images.example.test/${input.bucket}/${input.key}?signed=1`,
      headers: {},
      expiresAt: new Date(Date.now() + input.expiresInSeconds! * 1000),
    }),
  );
  const storage = {
    isConfigured: () => true,
    bucketOf: (bucket: string): ObjectStorageBucket | null =>
      bucket === 'bf-media'
        ? 'media'
        : bucket === 'bf-user-media'
          ? 'userMedia'
          : null,
    createDownloadUrl: signed,
  };
  const get = (route: string, userId = parent) =>
    request(app.getHttpServer())
      .get(`/api/v1${route}`)
      .set('x-spec-user', userId);
  const circles = async () =>
    payload<{ items: CircleBootstrapProfileResponse[] }>(
      await get('/me/circles', relative).expect(200),
    ).items;

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('This spec requires baby_family_test.');
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [FamilyOnboardingController, CircleController],
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 2,
          }),
        },
        { provide: ONBOARDING_SERVICE, useClass: OnboardingService },
        { provide: ONBOARDING_REPOSITORY, useClass: OnboardingRepository },
        { provide: PROFILE_IMAGE_SERVICE, useClass: ProfileImageService },
        { provide: PROFILE_IMAGE_REPOSITORY, useClass: ProfileImageRepository },
        { provide: FAMILY_CIRCLE_SERVICE, useClass: FamilyCircleService },
        { provide: FAMILY_CIRCLE_REPOSITORY, useClass: FamilyCircleRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        {
          provide: MEMORY_LIBRARY_REPOSITORY,
          useClass: MemoryLibraryRepository,
        },
        { provide: AUTH_TOKEN_SERVICE, useClass: AuthTokenService },
        { provide: USER_REPOSITORY, useClass: UserRepository },
        {
          provide: FAMILY_BILLING_SERVICE,
          useValue: {
            get: jest.fn().mockResolvedValue({ familyId, accessPhase: 'PAID' }),
          },
        },
        { provide: OBJECT_STORAGE_SERVICE, useValue: storage },
        { provide: IMAGE_PROCESSOR_SERVICE, useValue: { process: jest.fn() } },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    })
      .overrideGuard(AccessTokenGuard)
      .useValue({
        // Synthetic actors are allowed only in this isolated testing module.
        canActivate(context: ExecutionContext) {
          const req = context.switchToHttp().getRequest<AuthenticatedRequest>();
          const userId = req.header('x-spec-user');
          if (!userId || !users.includes(userId))
            throw new UnauthorizedException();
          req[AUTH_PRINCIPAL] = principal(userId);
          return true;
        },
      })
      .compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    await app.init();
    prisma = module.get(PrismaService);
    images = module.get<IProfileImageService>(PROFILE_IMAGE_SERVICE);
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: 'Synthetic profile image fixture',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        createdBy: parent,
        name: 'Synthetic profile image family',
        status: 'ACTIVE',
        activatedAt: new Date(),
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
    await prisma.plan.create({
      data: {
        id: planId,
        code: `PROFILE_${randomUUID().slice(0, 20)}`,
        displayNameI18n: { vi: 'Synthetic profile images' },
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        features: { 'circle.enabled': true },
        quotas: { circleMax: 10 },
        availableFrom: new Date(),
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
    await prisma.userAsset.create({
      data: {
        id: userAvatar,
        ownerUserId: parent,
        purpose: 'AVATAR',
        status: 'READY',
        mime: 'image/jpeg',
        declaredSize: 10n,
        sizeBytes: 10n,
        storageKey: `usr/${parent}/avatar/${userAvatar}/raw`,
        readyAt: new Date(),
      },
    });
    await prisma.user.update({
      where: { id: parent },
      data: { avatarAssetId: userAvatar },
    });
    for (const [id, purpose] of [
      [avatarA, 'AVATAR'],
      [coverA, 'COVER'],
      [avatarB, 'AVATAR'],
    ] as const) {
      await prisma.asset.create({
        data: {
          id,
          familyId,
          uploaderUserId: parent,
          kind: 'IMAGE',
          purpose,
          status: 'READY',
          mime: 'image/jpeg',
          declaredSize: 10n,
          sizeBytes: 10n,
          storageKey: `fam/${familyId}/a/${id}/raw`,
        },
      });
      await prisma.assetVariant.create({
        data: {
          familyId,
          assetId: id,
          variantCode: 't320',
          storageBucket: 'bf-media',
          storageKey: `fam/${familyId}/a/${id}/t320.webp`,
          mime: 'image/webp',
          sizeBytes: 5n,
        },
      });
    }
    await prisma.child.createMany({
      data: [
        {
          id: childA,
          familyId,
          createdBy: parent,
          name: 'Synthetic shared child',
          birthDate: new Date('2025-01-01'),
          colorIndex: 1,
          avatarAssetId: avatarA,
          coverAssetId: coverA,
        },
        {
          id: childB,
          familyId,
          createdBy: parent,
          name: 'Synthetic unshared child',
          birthDate: new Date('2025-02-01'),
          colorIndex: 2,
          avatarAssetId: avatarB,
        },
      ],
    });
    await prisma.circleMember.create({
      data: {
        id: memberId,
        familyId,
        userId: relative,
        displayName: 'Synthetic relative',
        relation: 'OTHER',
        invitedBy: parent,
      },
    });
    await prisma.circleGrant.create({
      data: {
        id: grantId,
        familyId,
        circleMemberId: memberId,
        childId: childA,
        createdBy: parent,
        permission: 'VIEW',
        allowDownload: false,
      },
    });
  });

  afterAll(async () => {
    if (prisma) {
      // Every write is limited to IDs created by this spec; no shared DB sweep.
      const deletedAt = new Date();
      await prisma.circleGrant.updateMany({
        where: { familyId },
        data: { deletedAt, status: 'REVOKED' },
      });
      await prisma.circleMember.updateMany({
        where: { familyId },
        data: { deletedAt, endedAt: deletedAt, status: 'LEFT' },
      });
      await prisma.child.updateMany({
        where: { familyId },
        data: { deletedAt },
      });
      await prisma.assetVariant.updateMany({
        where: { familyId },
        data: { deletedAt },
      });
      await prisma.asset.updateMany({
        where: { familyId },
        data: { deletedAt },
      });
      await prisma.familyParent.updateMany({
        where: { familyId },
        data: { deletedAt, leftAt: deletedAt },
      });
      await prisma.familyEntitlement.updateMany({
        where: { familyId },
        data: { deletedAt },
      });
      await prisma.familyLicense.updateMany({
        where: { familyId },
        data: { deletedAt },
      });
      await prisma.family.updateMany({
        where: { id: familyId },
        data: { deletedAt },
      });
      await prisma.userAsset.updateMany({
        where: { ownerUserId: { in: users } },
        data: { deletedAt },
      });
      await prisma.user.updateMany({
        where: { id: { in: users } },
        data: { deletedAt, avatarAssetId: null },
      });
      await prisma.planVersion.updateMany({
        where: { planId },
        data: { deletedAt },
      });
      await prisma.plan.updateMany({
        where: { id: planId },
        data: { deletedAt },
      });
    }
    await app?.close();
  });

  it('adds processed image URLs and expiries to parent bootstrap without exposing raw object keys', async () => {
    const data = payload<FamilyBootstrapResponseDto>(
      await get(`/families/${familyId}/bootstrap`).expect(200),
    );
    expect(data.parents.find((p) => p.userId === parent)).toMatchObject({
      avatarUrl: `https://images.example.test/userMedia/usr/${parent}/avatar/${userAvatar}/raw/avatar.webp?signed=1`,
      avatarUrlExpiresAt: expect.any(String),
    });
    expect(data.me.avatarUrl).toBe(
      data.parents.find((p) => p.userId === parent)?.avatarUrl,
    );
    const child = data.subjects.find((s) => s.id === childA)!;
    expect(child.avatarUrl).toBe(
      `https://images.example.test/media/fam/${familyId}/a/${avatarA}/t320.webp?signed=1`,
    );
    expect(child.coverUrl).toBe(
      `https://images.example.test/media/fam/${familyId}/a/${coverA}/t320.webp?signed=1`,
    );
    for (const expiry of [child.avatarUrlExpiresAt, child.coverUrlExpiresAt]) {
      const remaining = Date.parse(expiry!) - Date.now();
      expect(remaining).toBeGreaterThan(
        (MEDIA_POLICY.viewUrlTtlSeconds - 10) * 1000,
      );
      expect(remaining).toBeLessThanOrEqual(
        MEDIA_POLICY.viewUrlTtlSeconds * 1000,
      );
    }
    expect(JSON.stringify(data.subjects)).not.toContain('/raw');
    expect(data.subjects.find((s) => s.id === childB)?.coverUrl).toBeNull();
    expect(signed).toHaveBeenCalledWith(
      expect.objectContaining({
        expiresInSeconds: MEDIA_POLICY.viewUrlTtlSeconds,
      }),
    );
    await get(`/families/${familyId}/bootstrap`, stranger).expect(404);
  });

  it('shows Circle only its granted child and never signs the ungranted child', async () => {
    const callsBefore = signed.mock.calls.length;
    const denied = await images.childImages(
      principal(relative),
      familyId,
      childB,
    );
    expect(denied).toEqual({
      avatarUrl: null,
      avatarUrlExpiresAt: null,
      coverUrl: null,
      coverUrlExpiresAt: null,
    });
    expect(signed.mock.calls).toHaveLength(callsBefore);
    const mine = (await circles()).find((item) => item.familyId === familyId)!;
    expect(mine.status).toBe('ACTIVE');
    expect(mine.children).toHaveLength(1);
    expect(mine.children[0]).toMatchObject({
      id: childA,
      permission: 'VIEW',
      allowDownload: false,
      avatarUrl: expect.stringContaining(avatarA),
      coverUrl: expect.stringContaining(coverA),
    });
    expect(JSON.stringify(mine)).not.toContain(childB);
    expect(JSON.stringify(mine)).not.toContain(avatarB);
  });

  it('stops signing after grant revocation and hides paused membership subjects', async () => {
    await prisma.circleGrant.update({
      where: { id: grantId },
      data: { status: 'REVOKED', deletedAt: new Date() },
    });
    try {
      expect(
        (await circles()).find((item) => item.familyId === familyId)?.children,
      ).toEqual([]);
      expect(
        (await images.childImages(principal(relative), familyId, childA))
          .avatarUrl,
      ).toBeNull();
    } finally {
      await prisma.circleGrant.update({
        where: { id: grantId },
        data: { status: 'ACTIVE', deletedAt: null },
      });
    }
    await prisma.circleMember.update({
      where: { id: memberId },
      data: { status: 'PAUSED' },
    });
    try {
      expect(
        (await circles()).find((item) => item.familyId === familyId),
      ).toMatchObject({ status: 'PAUSED', children: [] });
    } finally {
      await prisma.circleMember.update({
        where: { id: memberId },
        data: { status: 'ACTIVE' },
      });
    }
  });

  it('returns null for a deleted processed variant rather than signing the original', async () => {
    await prisma.assetVariant.updateMany({
      where: { familyId, assetId: avatarA },
      data: { deletedAt: new Date() },
    });
    try {
      const data = payload<FamilyBootstrapResponseDto>(
        await get(`/families/${familyId}/bootstrap`).expect(200),
      );
      expect(data.subjects.find((s) => s.id === childA)).toMatchObject({
        avatarUrl: null,
        avatarUrlExpiresAt: null,
        coverUrl: expect.stringContaining(coverA),
      });
    } finally {
      await prisma.assetVariant.updateMany({
        where: { familyId, assetId: avatarA },
        data: { deletedAt: null },
      });
    }
  });
});
