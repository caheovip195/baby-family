import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { validateEnvironment } from '../../src/config/environment';
import { Test, type TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../src/database/prisma.service';
import { NotificationInboxRepository } from '../../src/repositories/notification-inbox.repository';

/** All writes are scoped to this spec's synthetic family/users. */
describe('Subscription inbox visibility (focused Nest module + PostgreSQL)', () => {
  let module: TestingModule;
  let prisma: PrismaService;
  let inbox: NotificationInboxRepository;
  const familyId = randomUUID();
  const parent = randomUUID();
  const circle = randomUUID();
  const former = randomUUID();
  const partner = randomUUID();
  const planId = randomUUID();
  const versionId = randomUUID();
  const noCircleVersionId = randomUUID();
  const users = [parent, partner, circle, former];
  const future = () => new Date(Date.now() + 86400000);

  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test database');
    module = await Test.createTestingModule({
      providers: [
        PrismaService,
        NotificationInboxRepository,
        {
          provide: ConfigService,
          useValue: new ConfigService(validateEnvironment(process.env)),
        },
      ],
    }).compile();
    prisma = module.get(PrismaService);
    inbox = module.get(NotificationInboxRepository);
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: 'Synthetic subscription inbox',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic inbox family',
        createdBy: parent,
        status: 'ACTIVE',
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: parent,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: former,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
        status: 'LEFT',
        leftAt: new Date(),
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: partner,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
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
        code: `SUB_INBOX_${planId.slice(0, 12)}`,
        displayNameI18n: { vi: 'Synthetic' },
      },
    });
    await prisma.planVersion.create({
      data: {
        id: versionId,
        planId,
        version: 1,
        quotas: {},
        features: { 'circle.enabled': true },
      },
    });
    await prisma.planVersion.create({
      data: {
        id: noCircleVersionId,
        planId,
        version: 2,
        quotas: {},
        features: { 'circle.enabled': false },
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: versionId,
        validUntil: future(),
      },
    });
  });

  beforeEach(async () => {
    await prisma.notification.deleteMany({
      where: { recipientUserId: { in: users } },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'PAID',
        effectivePlanVersionId: versionId,
        validUntil: future(),
        trialEndsAt: future(),
        deletedAt: null,
      },
    });
    await prisma.familyLicense.update({
      where: { familyId },
      data: { blockedAt: null, blockReasonCode: null },
    });
    await prisma.circleMember.updateMany({
      where: { familyId },
      data: { status: 'ACTIVE', endedAt: null, deletedAt: null },
    });
  });

  afterAll(async () => {
    if (prisma) {
      await prisma.notification.deleteMany({
        where: { recipientUserId: { in: users } },
      });
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.circleMember.deleteMany({ where: { familyId } });
      await prisma.familyEntitlement.deleteMany({ where: { familyId } });
      // License identifiers have mandatory retention; retire only this fixture.
      await prisma.family.update({
        where: { id: familyId },
        data: { status: 'DELETED', deletedAt: new Date() },
      });
      await prisma.planVersion.deleteMany({
        where: { id: { in: [versionId, noCircleVersionId] } },
      });
      await prisma.plan.deleteMany({ where: { id: planId } });
      await prisma.user.updateMany({
        where: { id: { in: users } },
        data: { status: 'DELETED', deletedAt: new Date() },
      });
    }
    await module?.close();
  });

  const add = (
    recipientUserId: string,
    category: string,
    global = false,
    createdAt = new Date(),
  ) =>
    prisma.notification.create({
      data: {
        familyId: global ? null : familyId,
        recipientUserId,
        eventId: randomUUID(),
        templateCode: 'SYNTHETIC_SUBSCRIPTION',
        category,
        createdAt,
      },
    });
  const ids = async (userId: string, limit = 20, cursor?: string) =>
    (await inbox.list(userId, { limit, cursor })).items.map((row) => row.id);

  it.each([
    'EXPIRED',
    'BLOCKED',
    'TRIAL_CLOCK',
    'PAID_CLOCK',
    'LICENSE_BLOCKED',
    'LICENSE_REASON',
  ] as const)(
    'keeps only Parent billing and global messages for %s before pagination/count/read',
    async (phase) => {
      if (phase === 'LICENSE_BLOCKED')
        await prisma.familyLicense.update({
          where: { familyId },
          data: { blockedAt: new Date() },
        });
      else if (phase === 'LICENSE_REASON')
        await prisma.familyLicense.update({
          where: { familyId },
          data: { blockReasonCode: 'SYNTHETIC' },
        });
      else
        await prisma.familyEntitlement.update({
          where: { familyId },
          data: {
            accessPhase:
              phase === 'TRIAL_CLOCK'
                ? 'TRIAL'
                : phase === 'PAID_CLOCK'
                  ? 'PAID'
                  : phase,
            ...(phase.endsWith('CLOCK')
              ? {
                  validUntil: new Date(Date.now() - 60000),
                  trialEndsAt: new Date(Date.now() - 60000),
                }
              : {}),
          },
        });
      const global = await add(
        parent,
        'ACCOUNT',
        true,
        new Date(Date.now() - 2000),
      );
      const billing = await add(
        parent,
        'BILLING',
        false,
        new Date(Date.now() - 1000),
      );
      const hidden = await add(parent, 'MEMORIES');
      await add(circle, 'BILLING');
      await add(circle, 'MEMORIES');
      const circleGlobal = await add(circle, 'ACCOUNT', true);
      await add(former, 'BILLING');
      expect(await ids(parent, 1)).toEqual([billing.id]);
      expect(await ids(parent, 1, billing.id)).toEqual([global.id]);
      expect(await inbox.unreadCount(parent)).toBe(2);
      expect(await inbox.markRead(parent, { ids: [hidden.id] })).toBe(0);
      expect(await inbox.markRead(parent, { all: true })).toBe(2);
      expect(await inbox.unreadCount(parent)).toBe(0);
      expect(await ids(circle)).toEqual([circleGlobal.id]);
      expect(await ids(former)).toEqual([]);
    },
  );

  it('retains ordinary Parent/Circle inbox while active and hides Circle after pause or capability removal', async () => {
    const own = await add(parent, 'MEMORIES');
    const shared = await add(circle, 'MEMORIES');
    const privateCircle = await add(circle, 'US');
    expect(await ids(parent)).toEqual([own.id]);
    expect(await ids(circle)).toEqual([shared.id]);
    expect(await ids(circle)).not.toContain(privateCircle.id);
    await prisma.circleMember.updateMany({
      where: { familyId },
      data: { status: 'PAUSED' },
    });
    expect(await ids(circle)).toEqual([]);
    await prisma.circleMember.updateMany({
      where: { familyId },
      data: { status: 'ACTIVE' },
    });
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { effectivePlanVersionId: noCircleVersionId },
    });
    expect(await ids(circle)).toEqual([]);
    expect(await ids(parent)).toEqual([own.id]);
  });

  it('fails closed when entitlement is soft deleted', async () => {
    await add(parent, 'MEMORIES');
    const bill = await add(parent, 'BILLING');
    await prisma.familyEntitlement.update({
      where: { familyId },
      data: { deletedAt: new Date() },
    });
    expect(await ids(parent)).toEqual([bill.id]);
  });
});
