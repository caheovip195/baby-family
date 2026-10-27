import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { PregnancyNameCipher } from '../../src/common/crypto/pregnancy-name-cipher';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { PREGNANCY_NAMING_POLICY } from '../../src/config/pregnancy-naming-policy';
import { PregnancyNamingController } from '../../src/controllers/pregnancy-naming.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { PREGNANCY_NAMING_REPOSITORY } from '../../src/interfaces/repositories/pregnancy-naming-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { PREGNANCY_NAMING_SERVICE } from '../../src/interfaces/services/pregnancy-naming-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { PregnancyNamingRepository } from '../../src/repositories/pregnancy-naming.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { AuthenticationService } from '../../src/services/authentication.service';
import { PregnancyNamingService } from '../../src/services/pregnancy-naming.service';

interface NameItem {
  id: string;
  name: string;
  meaning: string | null;
  addedByUserId: string;
  likedByMe: boolean;
  likedByPartner: boolean;
  chosen: boolean;
  createdAt: string;
}
interface NameList {
  items: NameItem[];
  chosenLimit: number;
}
const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const errorCode = (response: { body: unknown }): string =>
  (response.body as { error: { code: string } }).error.code;

describe('Pregnancy naming API (focused module + PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let encryptionKey: string;
  let config: ConfigService;
  const parentA = randomUUID(),
    parentB = randomUUID(),
    circle = randomUUID(),
    outsider = randomUUID();
  const users = [parentA, parentB, circle, outsider];
  const tokens = new Map<string, string>();
  const familyId = randomUUID(),
    pregnancyId = randomUUID(),
    coupleSpaceId = randomUUID(),
    planId = randomUUID(),
    planVersionId = randomUUID(),
    licenseId = randomUUID();
  const path = `/pregnancies/${pregnancyId}/names`;
  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);

  function call(
    method: 'get' | 'post' | 'put' | 'delete',
    route: string,
    who = parentA,
    body?: Record<string, unknown>,
  ) {
    const client = request(app.getHttpServer());
    const result = client[method](`/api/v1${route}`).set(
      'Authorization',
      tokens.get(who) ?? '',
    );
    return body === undefined ? result : result.send(body);
  }
  const list = (who = parentA) => call('get', path, who);
  const create = (body: Record<string, unknown>, who = parentA) =>
    call('post', path, who, body);
  const itemPath = (id: string) => `/pregnancy-names/${id}`;
  const like = (id: string, who = parentA) =>
    call('put', `${itemPath(id)}/like`, who);
  const unlike = (id: string, who = parentA) =>
    call('delete', `${itemPath(id)}/like`, who);
  const choose = (id: string, who = parentA) =>
    call('post', `${itemPath(id)}/choose`, who);
  const unchoose = (id: string, who = parentA) =>
    call('delete', `${itemPath(id)}/choose`, who);
  const remove = (id: string, who = parentA) =>
    call('delete', itemPath(id), who);
  const add = async (name: string, who = parentA) =>
    data<NameItem>(await create({ name }, who).expect(201));
  const milestone = () =>
    prisma.milestone.findFirstOrThrow({
      where: {
        familyId,
        pregnancyId,
        templateCode: 'name_chosen',
        deletedAt: null,
      },
      include: { memory: true },
    });

  async function clearOwnContent() {
    await prisma.pregnancyNameVote.deleteMany({ where: { familyId } });
    await prisma.pregnancyNameCandidate.deleteMany({ where: { familyId } });
    await prisma.milestone.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    await prisma.outboxEvent.deleteMany({ where: { familyId } });
    await prisma.idempotencyRecord.deleteMany({
      where: { scopeKey: { in: users } },
    });
    await prisma.familyUsage.deleteMany({ where: { familyId } });
  }

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error(
        'Pregnancy naming requires the baby_family_test database.',
      );
    const keys = await generateKeyPair('ES256', { extractable: true });
    encryptionKey = randomBytes(32).toString('base64');
    config = new ConfigService({
      ...validateEnvironment({ ...process.env }),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
      COUPLE_CHECKIN_ENCRYPTION_KEY: encryptionKey,
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [PregnancyNamingController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        { provide: PREGNANCY_NAMING_SERVICE, useClass: PregnancyNamingService },
        {
          provide: PREGNANCY_NAMING_REPOSITORY,
          useClass: PregnancyNamingRepository,
        },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    await app.init();
    prisma = module.get(PrismaService);
    if (
      !(await prisma.milestoneTemplate.findFirst({
        where: { code: 'name_chosen', status: 'ACTIVE', deletedAt: null },
      }))
    )
      throw new Error(
        'Requires the seeded name_chosen milestone catalog; this spec does not modify shared catalog rows.',
      );
    for (const userId of users) {
      const sessionId = randomUUID();
      await prisma.user.create({
        data: { id: userId, displayName: 'Synthetic naming fixture' },
      });
      await prisma.userSession.create({
        data: {
          id: sessionId,
          userId,
          refreshTokenHash: randomBytes(32),
          expiresAt: future(),
          absoluteExpiresAt: future(),
        },
      });
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sid: sessionId, ver: 1 })
          .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
          .setSubject(userId)
          .setIssuer(config.get<string>('AUTH_JWT_ISSUER')!)
          .setAudience(config.get<string>('AUTH_JWT_AUDIENCE')!)
          .setIssuedAt()
          .setExpirationTime('15m')
          .sign(keys.privateKey)}`,
      );
    }
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic naming family',
        createdBy: parentA,
        status: 'ACTIVE',
        activatedAt: past(),
      },
    });
    const a = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    const b = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
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
        relation: 'OTHER',
        displayName: 'Synthetic Circle',
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `NAMING_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic naming plan' },
        purchaseEnabled: false,
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: { memoryCount: 20 },
        features: {},
        availableFrom: past(),
      },
    });
    await prisma.familyLicense.create({ data: { id: licenseId, familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: future(),
      },
    });
    await prisma.pregnancy.create({
      data: {
        id: pregnancyId,
        familyId,
        seqNo: 1,
        nickname: 'Synthetic twins',
        expectedCount: 2,
        createdBy: parentA,
      },
    });
  });

  beforeEach(async () => {
    config.set('COUPLE_CHECKIN_ENCRYPTION_KEY', encryptionKey);
    await clearOwnContent();
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { status: 'ACTIVE', expectedCount: 2, completedAt: null },
    });
  });

  afterAll(async () => {
    try {
      if (prisma) {
        await clearOwnContent();
        const deletedAt = new Date();
        await prisma.pregnancy.updateMany({
          where: { id: pregnancyId },
          data: { deletedAt },
        });
        await prisma.coupleSpace.updateMany({
          where: { id: coupleSpaceId },
          data: { status: 'DISABLED', disabledAt: deletedAt, deletedAt },
        });
        await prisma.circleMember.updateMany({
          where: { familyId },
          data: { deletedAt },
        });
        await prisma.familyEntitlement.updateMany({
          where: { familyId },
          data: { deletedAt },
        });
        await prisma.familyParent.updateMany({
          where: { familyId },
          data: { deletedAt },
        });
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { status: 'DELETED', deletedAt },
        });
        await prisma.userSession.updateMany({
          where: { userId: { in: users } },
          data: {
            revokedAt: deletedAt,
            revokeReason: 'TEST_CLEANUP',
            deletedAt,
          },
        });
        await prisma.user.updateMany({
          where: { id: { in: users } },
          data: { status: 'DELETED', deletedAt },
        });
        // Keep the retained license and its fixture family/catalog identities.
        await prisma.planVersion.updateMany({
          where: { id: planVersionId },
          data: { retiredAt: deletedAt, deletedAt },
        });
        await prisma.plan.updateMany({
          where: { id: planId },
          data: { active: false, purchaseEnabled: false, deletedAt },
        });
      }
    } finally {
      await app?.close();
    }
  });

  it('lists an empty pregnancy with its twin choice limit', async () => {
    expect(data<NameList>(await list().expect(200))).toEqual({
      items: [],
      chosenLimit: 2,
    });
  });

  it('creates encrypted candidates, projects their author and lists by createdAt', async () => {
    const first = data<NameItem>(
      await create({
        name: '  An Nhiên  ',
        meaning: '  Bình an và tự nhiên  ',
      }).expect(201),
    );
    const second = await add('Minh Anh', parentB);
    expect(first).toEqual({
      id: expect.any(String),
      name: 'An Nhiên',
      meaning: 'Bình an và tự nhiên',
      addedByUserId: parentA,
      likedByMe: false,
      likedByPartner: false,
      chosen: false,
      createdAt: expect.any(String),
    });
    expect(second.meaning).toBeNull();
    expect(second.addedByUserId).toBe(parentB);
    expect(Number.isNaN(Date.parse(first.createdAt))).toBe(false);
    const rows = data<NameList>(await list(parentB).expect(200)).items;
    expect(rows.map(({ id }) => id)).toEqual([first.id, second.id]);
    const stored = await prisma.pregnancyNameCandidate.findUniqueOrThrow({
      where: { id: first.id },
    });
    expect(stored.createdAt).toBeInstanceOf(Date);
    expect(stored.updatedAt).toBeInstanceOf(Date);
    expect(stored.deletedAt).toBeNull();
    expect(Buffer.from(stored.nameEnc).includes(Buffer.from(first.name))).toBe(
      false,
    );
    expect(
      Buffer.from(stored.meaningEnc!).includes(Buffer.from(first.meaning!)),
    ).toBe(false);
    expect(stored.familyId).toBe(familyId);
    expect(stored.coupleSpaceId).toBe(coupleSpaceId);
    expect(JSON.stringify(stored)).not.toContain(first.name);
  });

  it('rejects case, whitespace and Unicode-normalized duplicate names', async () => {
    await add('Hòa An');
    for (const name of [' hÒA   aN ', 'Ho\u0300a An'])
      expect(errorCode(await create({ name }, parentB).expect(409))).toBe(
        'NAME_DUPLICATE',
      );
    expect(
      await prisma.pregnancyNameCandidate.count({ where: { familyId } }),
    ).toBe(1);
  });

  it('serializes simultaneous duplicate creation without leaking a database error', async () => {
    const responses = await Promise.all([
      create({ name: 'Thiên Ân' }),
      create({ name: ' THIÊN    ÂN ' }, parentB),
    ]);
    expect(responses.map(({ status }) => status).sort()).toEqual([201, 409]);
    expect(errorCode(responses.find(({ status }) => status === 409)!)).toBe(
      'NAME_DUPLICATE',
    );
    expect(data<NameList>(await list().expect(200)).items).toHaveLength(1);
  });

  it('also rejects a duplicate of a legacy encrypted candidate with no name key', async () => {
    const cipher = new PregnancyNameCipher(encryptionKey, coupleSpaceId);
    await prisma.pregnancyNameCandidate.create({
      data: {
        familyId,
        pregnancyId,
        coupleSpaceId,
        addedBy: parentA,
        nameEnc: new Uint8Array(
          cipher.encrypt('Legacy Synthetic Name', 'name'),
        ),
        nameKey: null,
      },
    });
    expect(
      errorCode(
        await create({ name: ' LEGACY   synthetic name ' }).expect(409),
      ),
    ).toBe('NAME_DUPLICATE');
    expect(data<NameList>(await list().expect(200)).items[0]?.name).toBe(
      'Legacy Synthetic Name',
    );
  });

  it('allows the configured final candidate then rejects list overflow', async () => {
    const cipher = new PregnancyNameCipher(encryptionKey, coupleSpaceId);
    await prisma.pregnancyNameCandidate.createMany({
      data: Array.from(
        { length: PREGNANCY_NAMING_POLICY.maxNames - 1 },
        (_, index) => {
          const name = `Synthetic limit ${index}`;
          return {
            familyId,
            pregnancyId,
            coupleSpaceId,
            addedBy: parentA,
            nameEnc: new Uint8Array(cipher.encrypt(name, 'name')),
            nameKey: cipher.fingerprint(name.toLowerCase()),
          };
        },
      ),
    });
    await create({ name: 'Final allowed synthetic name' }, parentB).expect(201);
    expect(
      errorCode(await create({ name: 'Overflow synthetic name' }).expect(409)),
    ).toBe('NAME_LIMIT');
    expect(data<NameList>(await list().expect(200)).items).toHaveLength(
      PREGNANCY_NAMING_POLICY.maxNames,
    );
  });

  it('keeps each Parent heart idempotent and projects likes relative to the viewer', async () => {
    const item = await add('Gia Hân');
    expect(data<NameItem>(await like(item.id).expect(200))).toMatchObject({
      likedByMe: true,
      likedByPartner: false,
    });
    await like(item.id).expect(200);
    expect(
      data<NameList>(await list(parentB).expect(200)).items[0],
    ).toMatchObject({
      likedByMe: false,
      likedByPartner: true,
    });
    expect(
      data<NameItem>(await like(item.id, parentB).expect(200)),
    ).toMatchObject({
      likedByMe: true,
      likedByPartner: true,
    });
    expect(data<NameList>(await list().expect(200)).items[0]).toMatchObject({
      likedByMe: true,
      likedByPartner: true,
    });
    expect(await prisma.pregnancyNameVote.count({ where: { familyId } })).toBe(
      2,
    );
    expect(data<NameItem>(await unlike(item.id).expect(200))).toMatchObject({
      likedByMe: false,
      likedByPartner: true,
    });
    await unlike(item.id).expect(200);
    const removed = await prisma.pregnancyNameVote.findUniqueOrThrow({
      where: { candidateId_userId: { candidateId: item.id, userId: parentA } },
    });
    expect(removed.deletedAt).toBeInstanceOf(Date);
    expect(removed.updatedAt).toBeInstanceOf(Date);
    expect(data<NameItem>(await like(item.id).expect(200))).toMatchObject({
      likedByMe: true,
      likedByPartner: true,
    });
    expect(await prisma.pregnancyNameVote.count({ where: { familyId } })).toBe(
      2,
    );
    expect(
      await prisma.pregnancyNameVote.count({
        where: { familyId, deletedAt: null },
      }),
    ).toBe(2);
  });

  it('allows only the author to soft delete and releases its duplicate key', async () => {
    const item = await add('Bảo An');
    await like(item.id, parentB).expect(200);
    expect(errorCode(await remove(item.id, parentB).expect(403))).toBe(
      'NAME_DELETE_FORBIDDEN',
    );
    expect((await remove(item.id).expect(204)).text).toBe('');
    expect(data<NameList>(await list().expect(200)).items).toEqual([]);
    expect(
      (
        await prisma.pregnancyNameCandidate.findUniqueOrThrow({
          where: { id: item.id },
        })
      ).deletedAt,
    ).toBeInstanceOf(Date);
    await like(item.id).expect(404);
    await unlike(item.id).expect(404);
    await choose(item.id).expect(404);
    await unchoose(item.id).expect(404);
    await remove(item.id).expect(404);
    expect((await add('bảo an', parentB)).id).not.toBe(item.id);
  });

  it('creates one private milestone, updates all chosen names and retains it when cleared', async () => {
    const first = await add('Khánh An');
    const second = await add('Khánh Linh', parentB);
    expect(
      data<NameItem>(await choose(first.id, parentB).expect(200)).chosen,
    ).toBe(true);
    const initial = await milestone();
    expect(initial.memory).toMatchObject({
      familyId,
      pregnancyId,
      kind: 'MILESTONE',
      visibility: 'PARENTS',
      title: 'Chọn được tên',
      body: first.name,
    });
    await choose(first.id).expect(200);
    await choose(second.id).expect(200);
    const both = await milestone();
    expect(both.id).toBe(initial.id);
    expect(both.memoryId).toBe(initial.memoryId);
    expect(both.memory.body).toBe(`${first.name}\n${second.name}`);
    expect(
      await prisma.milestone.count({ where: { familyId, deletedAt: null } }),
    ).toBe(1);
    expect(
      await prisma.memory.count({ where: { familyId, deletedAt: null } }),
    ).toBe(1);
    expect(
      (await prisma.familyUsage.findUniqueOrThrow({ where: { familyId } }))
        .memoryCount,
    ).toBe(1);
    expect(data<NameItem>(await unchoose(first.id).expect(200)).chosen).toBe(
      false,
    );
    expect((await milestone()).memory.body).toBe(second.name);
    await unchoose(first.id).expect(200);
    await unchoose(second.id, parentB).expect(200);
    const empty = await milestone();
    expect(empty.id).toBe(initial.id);
    expect(empty.memory.body).toBe('');
    expect(empty.memory.visibility).toBe('PARENTS');
    const outbox = JSON.stringify(
      await prisma.outboxEvent.findMany({
        where: { familyId },
        select: { eventType: true, payload: true },
      }),
    );
    expect(outbox).not.toContain(first.name);
    expect(outbox).not.toContain(second.name);
  });

  it('enforces a twin choice limit and leaves failed choices unchosen', async () => {
    const names = await Promise.all(
      ['An', 'Bình', 'Chi'].map((name) => add(name)),
    );
    await choose(names[0]!.id).expect(200);
    await choose(names[1]!.id, parentB).expect(200);
    expect(errorCode(await choose(names[2]!.id).expect(409))).toBe(
      'NAME_CHOICE_LIMIT',
    );
    const view = data<NameList>(await list().expect(200));
    expect(view.chosenLimit).toBe(2);
    expect(view.items.filter(({ chosen }) => chosen)).toHaveLength(2);
    expect(view.items.find(({ id }) => id === names[2]!.id)?.chosen).toBe(
      false,
    );
    expect((await milestone()).memory.body).not.toContain(names[2]!.name);
  });

  it('serializes concurrent twin choices and persists only the successful names', async () => {
    const names = await Promise.all(
      ['Đông', 'Xuân', 'Hạ'].map((name) => add(name)),
    );
    const responses = await Promise.all(
      names.map(({ id }, index) => choose(id, index % 2 ? parentB : parentA)),
    );
    expect(responses.map(({ status }) => status).sort()).toEqual([
      200, 200, 409,
    ]);
    expect(errorCode(responses.find(({ status }) => status === 409)!)).toBe(
      'NAME_CHOICE_LIMIT',
    );
    const selected = data<NameList>(await list().expect(200)).items.filter(
      ({ chosen }) => chosen,
    );
    expect(selected).toHaveLength(2);
    expect((await milestone()).memory.body?.split('\n').sort()).toEqual(
      selected.map(({ name }) => name).sort(),
    );
  });

  it('allows unchoosing every name after expectedCount falls below the chosen count', async () => {
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { expectedCount: 4 },
    });
    const names: NameItem[] = [];
    for (const name of [
      'Synthetic An',
      'Synthetic Bình',
      'Synthetic Chi',
      'Synthetic Dũng',
    ]) {
      const item = await add(name);
      names.push(item);
      await choose(item.id).expect(200);
    }
    await prisma.pregnancy.update({
      where: { id: pregnancyId },
      data: { expectedCount: 1 },
    });
    for (const [index, item] of names.entries()) {
      expect(data<NameItem>(await unchoose(item.id).expect(200)).chosen).toBe(
        false,
      );
      const view = data<NameList>(await list().expect(200));
      expect(view.chosenLimit).toBe(1);
      expect(view.items.filter(({ chosen }) => chosen)).toHaveLength(3 - index);
      expect((await milestone()).memory.body).toBe(
        names
          .slice(index + 1)
          .map(({ name }) => name)
          .join('\n'),
      );
    }
  });

  it('lets a memory writer holding usage finish while naming holds lifecycle locks', async () => {
    const item = await add('Synthetic concurrent memory name');
    await prisma.familyUsage.create({ data: { familyId } });
    const repository = app.get<PregnancyNamingRepository>(
      PREGNANCY_NAMING_REPOSITORY,
    );
    const originalMutate = repository.mutate.bind(repository);
    let signalUsageLocked!: () => void;
    const usageLocked = new Promise<void>((resolve) => {
      signalUsageLocked = resolve;
    });
    let signalNamingDecided!: () => void;
    const namingDecided = new Promise<void>((resolve) => {
      signalNamingDecided = resolve;
    });
    const spy = jest
      .spyOn(repository, 'mutate')
      .mockImplementation((id, actor, decide) =>
        originalMutate(id, actor, (state) => {
          const mutation = decide(state);
          // The real transaction already holds the family/pregnancy/couple locks.
          signalNamingDecided();
          return mutation;
        }),
      );
    const ordinaryWrite = prisma.$transaction(
      async (tx) => {
        await tx.$queryRaw`
        SELECT family_id FROM billing.family_usage
        WHERE family_id = ${familyId}::uuid FOR UPDATE
      `;
        signalUsageLocked();
        await namingDecided;
        // These real FK checks take KEY SHARE on the naming lifecycle rows.
        const memory = await tx.memory.create({
          data: {
            familyId,
            pregnancyId,
            authorUserId: parentA,
            authorRole: 'PARENT',
            kind: 'MOMENT',
            body: 'Synthetic concurrent ordinary memory',
            occurredAt: new Date(),
            occurredLocalDate: new Date('2026-10-27T00:00:00Z'),
            visibility: 'PARENTS',
            status: 'PUBLISHED',
          },
        });
        await tx.outboxEvent.create({
          data: {
            familyId,
            aggregateId: memory.id,
            eventType: 'test.memory.created',
            payload: { memoryId: memory.id, familyId },
          },
        });
        await tx.familyUsage.update({
          where: { familyId },
          data: { memoryCount: { increment: 1 } },
        });
        return memory.id;
      },
      { timeout: 10000 },
    );
    // Propagate an early transaction failure instead of leaving the barrier pending.
    void ordinaryWrite.catch(() => signalUsageLocked());
    await usageLocked;
    const namingWrite = choose(item.id).then(
      (response) => {
        signalNamingDecided();
        expect(response.status).toBe(200);
        return data<NameItem>(response);
      },
      (error: unknown) => {
        signalNamingDecided();
        throw error;
      },
    );
    try {
      const [ordinaryMemoryId, chosen] = await Promise.all([
        ordinaryWrite,
        namingWrite,
      ]);
      expect(chosen.chosen).toBe(true);
      expect((await milestone()).memory.body).toBe(item.name);
      expect(
        await prisma.memory.count({ where: { familyId, deletedAt: null } }),
      ).toBe(2);
      expect(
        await prisma.memory.count({
          where: { id: ordinaryMemoryId, familyId },
        }),
      ).toBe(1);
      expect(
        await prisma.outboxEvent.count({
          where: {
            familyId,
            eventType: 'test.memory.created',
            aggregateId: ordinaryMemoryId,
          },
        }),
      ).toBe(1);
      expect(
        (await prisma.familyUsage.findUniqueOrThrow({ where: { familyId } }))
          .memoryCount,
      ).toBe(2);
    } finally {
      signalNamingDecided();
      await Promise.allSettled([ordinaryWrite, namingWrite]);
      spy.mockRestore();
    }
  });

  it('updates an existing milestone when a chosen candidate is deleted', async () => {
    const first = await add('Lan');
    const second = await add('Mai', parentB);
    await choose(first.id).expect(200);
    await choose(second.id).expect(200);
    const before = await milestone();
    await remove(first.id).expect(204);
    expect((await milestone()).memory.body).toBe(second.name);
    await remove(second.id, parentB).expect(204);
    const after = await milestone();
    expect(after.id).toBe(before.id);
    expect(after.memoryId).toBe(before.memoryId);
    expect(after.memory.body).toBe('');
    expect(data<NameList>(await list().expect(200)).items).toEqual([]);
  });

  it('rolls back choosing when the family catalog memory quota is exhausted', async () => {
    const item = await add('Quota synthetic name');
    await prisma.familyUsage.create({ data: { familyId, memoryCount: 20 } });
    expect(errorCode(await choose(item.id).expect(402))).toBe(
      'QUOTA_MEMORY_COUNT_EXCEEDED',
    );
    expect(data<NameList>(await list().expect(200)).items[0]?.chosen).toBe(
      false,
    );
    expect(await prisma.milestone.count({ where: { familyId } })).toBe(0);
    expect(await prisma.memory.count({ where: { familyId } })).toBe(0);
    expect(
      (await prisma.familyUsage.findUniqueOrThrow({ where: { familyId } }))
        .memoryCount,
    ).toBe(20);
  });

  it('does not widen or overwrite an existing private name milestone', async () => {
    const item = await add('Private milestone candidate');
    const memory = await prisma.memory.create({
      data: {
        familyId,
        pregnancyId,
        authorUserId: parentA,
        authorRole: 'PARENT',
        kind: 'MILESTONE',
        title: 'Private synthetic milestone',
        body: 'Private synthetic memory body',
        occurredAt: new Date(),
        occurredLocalDate: new Date('2026-10-27T00:00:00Z'),
        visibility: 'PRIVATE',
        status: 'PUBLISHED',
        version: 7,
      },
    });
    await prisma.milestone.create({
      data: {
        familyId,
        pregnancyId,
        memoryId: memory.id,
        templateCode: 'name_chosen',
        occurredOn: memory.occurredLocalDate,
        createdBy: parentA,
      },
    });
    const before = await prisma.outboxEvent.count({ where: { familyId } });
    expect(errorCode(await choose(item.id, parentB).expect(409))).toBe(
      'NAME_MILESTONE_UNAVAILABLE',
    );
    expect(data<NameList>(await list().expect(200)).items[0]?.chosen).toBe(
      false,
    );
    const after = await milestone();
    expect(after.memory).toMatchObject({
      id: memory.id,
      title: memory.title,
      body: memory.body,
      visibility: 'PRIVATE',
      version: 7,
    });
    expect(after.memory.updatedAt).toEqual(memory.updatedAt);
    expect(await prisma.outboxEvent.count({ where: { familyId } })).toBe(
      before,
    );
  });

  it.each(['missing', 'wrong'] as const)(
    'rejects likes and choices without side effects when encryption is %s',
    async (mode) => {
      const item = await add('Synthetic cipher failure');
      config.set(
        'COUPLE_CHECKIN_ENCRYPTION_KEY',
        mode === 'missing' ? '' : randomBytes(32).toString('base64'),
      );
      for (const response of [
        await like(item.id).expect(503),
        await choose(item.id).expect(503),
      ])
        expect(errorCode(response)).toBe(
          mode === 'missing'
            ? 'NAME_ENCRYPTION_UNAVAILABLE'
            : 'NAME_UNREADABLE',
        );
      expect(
        await prisma.pregnancyNameVote.count({ where: { familyId } }),
      ).toBe(0);
      expect(
        (
          await prisma.pregnancyNameCandidate.findUniqueOrThrow({
            where: { id: item.id },
          })
        ).chosenAt,
      ).toBeNull();
      expect(await prisma.memory.count({ where: { familyId } })).toBe(0);
      expect(await prisma.outboxEvent.count({ where: { familyId } })).toBe(0);
      config.set('COUPLE_CHECKIN_ENCRYPTION_KEY', encryptionKey);
      expect(data<NameList>(await list().expect(200)).items[0]).toMatchObject({
        likedByMe: false,
        chosen: false,
      });
    },
  );

  it.each([circle, outsider])(
    'hides every naming route from a non-Parent (%s)',
    async (who) => {
      const item = await add('Private synthetic name');
      const before = await prisma.outboxEvent.count({ where: { familyId } });
      await list(who).expect(404);
      await create({ name: 'Invisible' }, who).expect(404);
      await like(item.id, who).expect(404);
      await unlike(item.id, who).expect(404);
      await choose(item.id, who).expect(404);
      await unchoose(item.id, who).expect(404);
      await remove(item.id, who).expect(404);
      expect(await prisma.outboxEvent.count({ where: { familyId } })).toBe(
        before,
      );
      expect(
        await prisma.pregnancyNameCandidate.count({
          where: { familyId, deletedAt: null },
        }),
      ).toBe(1);
      expect(
        await prisma.pregnancyNameVote.count({ where: { familyId } }),
      ).toBe(0);
    },
  );

  it('requires Bearer authentication on all routes and hides unknown identifiers', async () => {
    const item = await add('Synthetic auth name');
    for (const [method, route] of [
      ['get', path],
      ['post', path],
      ['put', `${itemPath(item.id)}/like`],
      ['delete', `${itemPath(item.id)}/like`],
      ['post', `${itemPath(item.id)}/choose`],
      ['delete', `${itemPath(item.id)}/choose`],
      ['delete', itemPath(item.id)],
    ] as const)
      await request(app.getHttpServer())[method](`/api/v1${route}`).expect(401);
    const unknown = randomUUID();
    await call('get', `/pregnancies/${unknown}/names`).expect(404);
    await call('post', `/pregnancies/${unknown}/names`, parentA, {
      name: 'Unknown',
    }).expect(404);
    await like(unknown).expect(404);
    await unlike(unknown).expect(404);
    await choose(unknown).expect(404);
    await unchoose(unknown).expect(404);
    await remove(unknown).expect(404);
  });

  it.each(['COMPLETED', 'ARCHIVED', 'PAUSED', 'ENDED_PRIVATE'] as const)(
    'keeps %s pregnancies readable while rejecting every write',
    async (status) => {
      const item = await add('Existing synthetic name');
      await prisma.pregnancy.update({
        where: { id: pregnancyId },
        data: { status },
      });
      expect(data<NameList>(await list().expect(200)).items).toHaveLength(1);
      for (const response of [
        await create({ name: 'New name' }).expect(409),
        await like(item.id).expect(409),
        await unlike(item.id).expect(409),
        await choose(item.id).expect(409),
        await unchoose(item.id).expect(409),
        await remove(item.id).expect(409),
      ])
        expect(errorCode(response)).toBe('PREGNANCY_READ_ONLY');
      expect(
        await prisma.pregnancyNameCandidate.count({
          where: { familyId, deletedAt: null },
        }),
      ).toBe(1);
      expect(
        await prisma.pregnancyNameVote.count({ where: { familyId } }),
      ).toBe(0);
      expect(await prisma.milestone.count({ where: { familyId } })).toBe(0);
    },
  );

  it('accepts boundary lengths and rejects invalid or unknown input', async () => {
    for (const body of [
      {},
      { name: '' },
      { name: '   ' },
      { name: 'x'.repeat(61) },
      { name: 42 },
      { name: null },
      { name: 'Valid', meaning: 'x'.repeat(201) },
      { name: 'Valid', meaning: 42 },
      { name: 'Valid', meaning: null },
      { name: 'Valid', addedByUserId: parentB },
      { name: 'Valid', chosen: true },
    ])
      await create(body).expect(400);
    expect(data<NameList>(await list().expect(200)).items).toEqual([]);
    const boundary = data<NameItem>(
      await create({ name: 'x'.repeat(60), meaning: 'm'.repeat(200) }).expect(
        201,
      ),
    );
    expect(boundary.name).toHaveLength(60);
    expect(boundary.meaning).toHaveLength(200);
    expect((await add('A')).name).toBe('A');
    expect((await add('🍼'.repeat(60))).name).toBe('🍼'.repeat(60));
    await create({ name: '🍼'.repeat(61) }).expect(400);
    await call('get', '/pregnancies/not-a-uuid/names').expect(400);
    await like('not-a-uuid').expect(400);
  });
});
