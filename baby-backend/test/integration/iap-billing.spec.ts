import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import {
  ValidationPipe,
  type INestApplication,
  type ExecutionContext,
} from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import request from 'supertest';
import { IapBillingController } from '../../src/controllers/iap-billing.controller';
import { IapWebhookController } from '../../src/controllers/iap-webhook.controller';
import { IAP_BILLING_SERVICE } from '../../src/interfaces/services/iap-billing-service.interface';
import { JOB_RUNNER_SERVICE } from '../../src/interfaces/services/job-runner-service.interface';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { AUTH_PRINCIPAL } from '../../src/common/auth/auth-principal';
import type { AuthenticatedRequest } from '../../src/common/auth/current-actor.decorator';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { ConfigService } from '@nestjs/config';
import { Test, type TestingModule } from '@nestjs/testing';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import { validateEnvironment } from '../../src/config/environment';
import { JobLease } from '../../src/models/job-lease.model';
import type { JobHandler } from '../../src/interfaces/services/job-runner-service.interface';
import type { JobPolicy } from '../../src/config/jobs';
import { IAP_BILLING_CONFIG } from '../../src/config/iap-billing-policy';
import { PrismaService } from '../../src/database/prisma.service';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { CATALOG_QUERY_REPOSITORY } from '../../src/interfaces/repositories/catalog-query-repository.interface';
import { IAP_BILLING_REPOSITORY } from '../../src/interfaces/repositories/iap-billing-repository.interface';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { FAMILY_BILLING_SERVICE } from '../../src/interfaces/services/family-billing-service.interface';
import {
  STORE_VERIFIER,
  type IStoreVerifier,
  type PurchaseStore,
  type VerifiedStorePurchase,
  type VerifiedStoreNotification,
  type VerifyStorePurchaseInput,
} from '../../src/interfaces/services/store-verifier.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { CatalogQueryRepository } from '../../src/repositories/catalog-query.repository';
import { IapBillingRepository } from '../../src/repositories/iap-billing.repository';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { FamilyBillingService } from '../../src/services/family-billing.service';
import { IapBillingService } from '../../src/services/iap-billing.service';
import { JobRunnerService } from '../../src/services/job-runner.service';

/** No live Store SDK/network; PostgreSQL persistence and authorization are real. */
class FakeStoreVerifier implements IStoreVerifier {
  purchases = new Map<string, VerifiedStorePurchase>();
  notifications = new Map<string, VerifiedStoreNotification>();
  verifyPurchase(
    input: VerifyStorePurchaseInput,
  ): Promise<VerifiedStorePurchase> {
    const result = this.purchases.get(
      input.signedTransaction ?? input.purchaseToken ?? '',
    );
    if (!result) return Promise.reject(new Error('Synthetic invalid receipt'));
    return Promise.resolve(result);
  }
  verifyAppStoreNotification(
    signedPayload: string,
  ): Promise<VerifiedStoreNotification> {
    const result = this.notifications.get(signedPayload);
    if (!result)
      return Promise.reject(new Error('Synthetic invalid notification'));
    return Promise.resolve(result);
  }
  verifyPlayNotification(input: {
    authorization: string | undefined;
    body: unknown;
  }): Promise<VerifiedStoreNotification> {
    if (
      input.authorization !== 'Bearer fixture-secret' ||
      typeof input.body !== 'string'
    )
      return Promise.reject(new Error('Synthetic unauthorized push'));
    return this.verifyAppStoreNotification(input.body);
  }
}

describe('IAP billing SUB-01/02/04 + Store notifications (PostgreSQL)', () => {
  let module: TestingModule;
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let service: IapBillingService;
  let runner: JobRunnerService;
  const verifier = new FakeStoreVerifier();
  const namespace = `test.iap.${randomUUID()}`;
  const users = [randomUUID(), randomUUID(), randomUUID()];
  const familyIds: string[] = [];
  const familyActors = new Map<string, AuthPrincipal>();
  const actorOf = (fid: string) => familyActors.get(fid)!;
  const planIds = [randomUUID(), randomUUID(), randomUUID()];
  const versionIds = planIds.map(() => randomUUID());
  const planCodes = planIds.map((id) => `IAP_${id.slice(0, 8)}`);
  const startsAt = new Date(Date.now() - 60_000);
  const expiresAt = new Date(Date.now() + 30 * 86400_000);
  const actor: AuthPrincipal = {
    userId: users[0]!,
    sessionId: randomUUID(),
    tokenVersion: 1,
  };
  const outsider: AuthPrincipal = { ...actor, userId: users[2]! };
  const jobPolicy: JobPolicy = {
    queue: 'maintenance',
    name: 'billing.store-notification',
    maxAttempts: 3,
    backoffMs: 10000,
    leaseMs: 120000,
  };
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('This spec requires baby_family_test.');
    module = await Test.createTestingModule({
      controllers: [IapBillingController, IapWebhookController],
      providers: [
        PrismaService,
        {
          provide: ConfigService,
          useValue: new ConfigService({
            ...validateEnvironment(process.env),
          }),
        },
        {
          provide: IAP_BILLING_CONFIG,
          useValue: {
            environment: 'PRODUCTION',
            appStoreBundleId: namespace,
            playPackageName: namespace,
            payloadEncryptionKey: randomBytes(32).toString('base64'),
          },
        },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
        { provide: FAMILY_BILLING_SERVICE, useClass: FamilyBillingService },
        { provide: IAP_BILLING_REPOSITORY, useClass: IapBillingRepository },
        { provide: STORE_VERIFIER, useValue: verifier },
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        IapBillingService,
        JobRunnerService,
        { provide: IAP_BILLING_SERVICE, useExisting: IapBillingService },
        { provide: JOB_RUNNER_SERVICE, useExisting: JobRunnerService },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    })
      .overrideGuard(AccessTokenGuard)
      .useValue({
        canActivate: (context: ExecutionContext) => {
          const req = context.switchToHttp().getRequest<AuthenticatedRequest>();
          req[AUTH_PRINCIPAL] = actorOf(String(req.params.familyId));
          return true;
        },
      })
      .compile();
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
    service = module.get(IapBillingService);
    runner = module.get(JobRunnerService);
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: 'Synthetic IAP parent',
        status: 'ACTIVE',
      })),
    });
    for (let index = 0; index < 3; index++) {
      await prisma.plan.create({
        data: {
          id: planIds[index]!,
          code: planCodes[index]!,
          displayNameI18n: { vi: 'Synthetic IAP' },
        },
      });
      await prisma.planVersion.create({
        data: {
          id: versionIds[index]!,
          planId: planIds[index]!,
          version: 1,
          entitlementRank: (index + 1) * 10,
          quotas: { 'storage.maxBytes': (index + 1) * 1000 },
          features: { 'circle.enabled': index > 0 },
          availableFrom: startsAt,
        },
      });
      for (const store of ['APP_STORE', 'PLAY'] as const)
        await prisma.product.create({
          data: {
            productId: `${namespace}.${index}.${store}`,
            store: store === 'APP_STORE' ? 'APPLE' : 'GOOGLE',
            basePlanId: store === 'PLAY' ? 'monthly' : null,
            environment: 'PRODUCTION',
            appNamespace: namespace,
            planVersionId: versionIds[index]!,
            period: 'P1M',
          },
        });
    }
  });
  afterEach(() => {
    jest.restoreAllMocks();
  });
  afterAll(async () => {
    try {
      if (prisma) {
        // Immutable billing/grant ledgers stay intact; retire only owned fixtures.
        await prisma.jobRun.updateMany({
          where: {
            familyId: { in: familyIds },
            status: { in: ['PENDING', 'RUNNING', 'RETRY_WAIT'] },
          },
          data: {
            status: 'FAILED',
            finishedAt: new Date(),
            leaseOwner: null,
            leaseExpiresAt: null,
          },
        });
        await prisma.family.updateMany({
          where: { id: { in: familyIds } },
          data: { status: 'DELETED', deletedAt: new Date() },
        });
        await prisma.user.updateMany({
          where: { id: { in: users } },
          data: { status: 'DELETED', deletedAt: new Date() },
        });
        await prisma.plan.updateMany({
          where: { id: { in: planIds } },
          data: { active: false, purchaseEnabled: false },
        });
      }
    } finally {
      if (app) await app.close();
      else await module?.close();
    }
  });
  async function family() {
    const id = randomUUID();
    familyIds.push(id);
    const parents = [randomUUID(), randomUUID()];
    users.push(...parents);
    await prisma.user.createMany({
      data: parents.map((id) => ({
        id,
        displayName: 'Synthetic IAP parent',
        status: 'ACTIVE',
      })),
    });
    familyActors.set(id, { ...actor, userId: parents[0]! });
    await prisma.family.create({
      data: {
        id,
        name: 'Synthetic IAP family',
        status: 'ACTIVE',
        createdBy: actorOf(id).userId,
      },
    });
    await prisma.familyParent.createMany({
      data: parents.map((userId, index) => ({
        familyId: id,
        userId,
        slot: index ? 'B' : 'A',
        kind: index ? 'MOTHER' : 'FATHER',
        callName: 'Parent',
        joinedAt: startsAt,
      })),
    });
    const license = await prisma.familyLicense.create({
      data: { familyId: id },
    });
    await prisma.familyEntitlement.create({
      data: { familyId: id, licenseId: license.id, accessPhase: 'EXPIRED' },
    });
    return id;
  }
  async function purchase(
    familyId: string,
    store: PurchaseStore = 'APP_STORE',
    index = 0,
  ) {
    const intent = await service.createIntent(
      actorOf(familyId),
      familyId,
      { planCode: planCodes[index]!, store },
      randomUUID(),
    );
    const row = await prisma.purchaseIntent.findUniqueOrThrow({
      where: { id: intent.intentId },
    });
    const proof = randomUUID();
    const verified: VerifiedStorePurchase = {
      store,
      transactionId: randomUUID(),
      originalTransactionId: randomUUID(),
      productId: `${namespace}.${index}.${store}`,
      accountToken:
        store === 'APP_STORE' ? row.appAccountToken : row.obfuscatedAccountId!,
      appNamespace: namespace,
      environment: 'PRODUCTION',
      startsAt: new Date(),
      expiresAt,
      autoRenew: true,
      raw: { synthetic: true },
      ...(store === 'PLAY' ? { purchaseToken: proof } : {}),
    };
    verifier.purchases.set(proof, verified);
    const input = {
      store,
      intentId: intent.intentId,
      ...(store === 'APP_STORE'
        ? { signedTransaction: proof }
        : { purchaseToken: proof }),
    };
    return { intent, verified, input };
  }
  async function notification(
    familyId: string,
    verified: VerifiedStorePurchase,
    type: VerifiedStoreNotification['type'],
    options: Partial<VerifiedStoreNotification> = {},
  ) {
    const proof = randomUUID();
    const event: VerifiedStoreNotification = {
      store: verified.store,
      eventId: randomUUID(),
      type,
      occurredAt: new Date(Date.now() + 1000),
      purchase: verified,
      raw: { synthetic: true },
      ...options,
    };
    verifier.notifications.set(proof, event);
    const accepted =
      verified.store === 'APP_STORE'
        ? await service.receiveAppStore(proof)
        : await service.receivePlay('Bearer fixture-secret', proof);
    const row = await prisma.storeNotification.findFirstOrThrow({
      where: { notificationId: event.eventId, appNamespace: namespace },
    });
    const execute = (handler?: JobHandler) =>
      runner.execute(
        jobPolicy,
        {
          familyId,
          scopeKey: row.id,
          scheduledFor: row.receivedAt,
          idempotencyKey: `iap-spec:${row.id}`,
        },
        handler ?? ((context) => service.processNotification(row.id, context)),
      );
    return { row, event, accepted, execute, proof };
  }
  it.each(['APP_STORE', 'PLAY'] as const)(
    'purchases %s and preserves a single transaction/grant on repeated concurrent verification',
    async (store) => {
      const fid = await family();
      const { input } = await purchase(fid, store);
      const results = await Promise.all([
        service.verify(actorOf(fid), fid, input),
        service.verify(actorOf(fid), fid, input),
      ]);
      for (const result of results)
        expect(result).toMatchObject({
          familyId: fid,
          accessPhase: 'PAID',
          plan: { code: planCodes[0] },
        });
      await service.verify(actorOf(fid), fid, input);
      expect(
        await prisma.subscription.count({ where: { familyId: fid } }),
      ).toBe(1);
      expect(
        await prisma.subscriptionTransaction.count({
          where: { familyId: fid },
        }),
      ).toBe(1);
      expect(
        await prisma.licenseGrant.count({
          where: { familyId: fid, source: 'STORE' },
        }),
      ).toBe(1);
    },
  );
  it('keeps intent idempotency scoped to family, purchaser and requested product', async () => {
    const fid = await family(),
      other = await family(),
      key = randomUUID();
    const request = { planCode: planCodes[0]!, store: 'APP_STORE' as const };
    const one = await service.createIntent(actorOf(fid), fid, request, key);
    expect(await service.createIntent(actorOf(fid), fid, request, key)).toEqual(
      one,
    );
    expect(
      (await service.createIntent(actorOf(other), other, request, key))
        .intentId,
    ).not.toBe(one.intentId);
    await expect(
      service.createIntent(
        actorOf(fid),
        fid,
        { ...request, planCode: planCodes[1]! },
        key,
      ),
    ).rejects.toMatchObject({ code: 'IDEMPOTENCY_CONFLICT', statusCode: 409 });
    await expect(
      service.createIntent(outsider, fid, request, randomUUID()),
    ).rejects.toThrow();
  });
  it('rejects wrong family, unknown intent, wrong account and wrong provider product without grants', async () => {
    const fid = await family(),
      other = await family();
    const { input, verified } = await purchase(fid);
    await expect(
      service.verify(actorOf(other), other, input),
    ).rejects.toThrow();
    await expect(
      service.verify(actorOf(fid), fid, { ...input, intentId: randomUUID() }),
    ).rejects.toThrow();
    verified.accountToken = randomUUID();
    await expect(service.verify(actorOf(fid), fid, input)).rejects.toThrow();
    const row = await prisma.purchaseIntent.findUniqueOrThrow({
      where: { id: input.intentId },
    });
    verified.accountToken = row.appAccountToken;
    verified.productId = `${namespace}.unknown`;
    await expect(service.verify(actorOf(fid), fid, input)).rejects.toThrow();
    expect(
      await prisma.subscriptionTransaction.count({ where: { familyId: fid } }),
    ).toBe(0);
    expect(await prisma.licenseGrant.count({ where: { familyId: fid } })).toBe(
      0,
    );
  });
  it('upgrades by catalog rank to a third plan immediately, preserving family content', async () => {
    const fid = await family();
    const initial = await purchase(fid);
    await service.verify(actorOf(fid), fid, initial.input);
    const child = await prisma.child.create({
      data: {
        familyId: fid,
        nickname: 'Synthetic',
        birthDate: new Date('2025-01-01'),
        colorIndex: 1,
        createdBy: actorOf(fid).userId,
      },
    });
    const options = await service.upgradeOptions(actorOf(fid), fid);
    expect(options).toMatchObject({
      requiresPayerAction: false,
      currentSubscription: {
        store: 'APP_STORE',
        purchaserUserId: actorOf(fid).userId,
        autoRenew: true,
      },
    });
    const partner = await prisma.familyParent.findFirstOrThrow({
      where: { familyId: fid, userId: { not: actorOf(fid).userId } },
    });
    expect(
      await service.upgradeOptions(
        { ...actorOf(fid), userId: partner.userId },
        fid,
      ),
    ).toMatchObject({ requiresPayerAction: true });
    expect(JSON.stringify(options)).toContain(planCodes[2]!);
    expect(JSON.stringify(options)).not.toContain(planCodes[0]!);
    const upgrade = await purchase(fid, 'APP_STORE', 2);
    upgrade.verified.originalTransactionId =
      initial.verified.originalTransactionId;
    upgrade.verified.startsAt = new Date();
    const billing = await service.verify(actorOf(fid), fid, upgrade.input);
    expect(billing).toMatchObject({
      accessPhase: 'PAID',
      plan: { code: planCodes[2], features: { 'circle.enabled': true } },
    });
    expect(
      await prisma.child.findFirst({
        where: { id: child.id, familyId: fid, deletedAt: null },
      }),
    ).not.toBeNull();
  });
  it.each(['APP_STORE', 'PLAY'] as const)(
    'stores raw %s notifications durably and deduplicates processing with history',
    async (store) => {
      const fid = await family();
      const bought = await purchase(fid, store);
      await service.verify(actorOf(fid), fid, bought.input);
      const renewed = {
        ...bought.verified,
        transactionId: randomUUID(),
        expiresAt: new Date(expiresAt.getTime() + 30 * 86400_000),
      };
      const received = await notification(fid, renewed, 'RENEWED');
      expect(received.row.payloadEnc?.length).toBeGreaterThan(0);
      expect(received.row.processedAt).toBeNull();
      expect(
        await module
          .get<IapBillingRepository>(IAP_BILLING_REPOSITORY)
          .pendingNotifications(new Date(Date.now() + 10_000), fid),
      ).toContain(received.row.id);
      if (store === 'APP_STORE') await service.receiveAppStore(received.proof);
      else await service.receivePlay('Bearer fixture-secret', received.proof);
      expect(
        await prisma.storeNotification.count({
          where: {
            notificationId: received.event.eventId,
            appNamespace: namespace,
          },
        }),
      ).toBe(1);
      expect(await received.execute()).toBe('SUCCEEDED');
      expect(await received.execute()).toBe('ALREADY_FINISHED');
      expect(
        await prisma.subscriptionTransaction.count({
          where: { familyId: fid },
        }),
      ).toBe(2);
      expect(
        await prisma.jobAttempt.count({
          where: { jobRun: { familyId: fid }, status: 'SUCCEEDED' },
        }),
      ).toBe(1);
      expect(
        await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
      ).toMatchObject({ accessPhase: 'PAID', validUntil: renewed.expiresAt });
    },
  );
  it('applies grace then expires without deleting content, and ignores an older renewal', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    await service.verify(actorOf(fid), fid, bought.input);
    const graceUntil = new Date(expiresAt.getTime() + 3 * 86400_000);
    const grace = await notification(
      fid,
      { ...bought.verified, graceUntil },
      'GRACE',
    );
    await grace.execute();
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'PAID', inGrace: true });
    const ended = await notification(
      fid,
      { ...bought.verified, expiresAt: new Date(Date.now() - 1000) },
      'EXPIRED',
      { occurredAt: new Date(Date.now() + 3000) },
    );
    await ended.execute();
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'EXPIRED', inGrace: false });
    const stale = await notification(
      fid,
      { ...bought.verified, transactionId: randomUUID() },
      'RENEWED',
      { occurredAt: new Date(Date.now() - 1000) },
    );
    await stale.execute();
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'EXPIRED' });
  });
  it('cancels auto-renew without withdrawing current access', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    await service.verify(actorOf(fid), fid, bought.input);
    const received = await notification(
      fid,
      { ...bought.verified, autoRenew: false },
      'AUTO_RENEW_CHANGED',
      { autoRenew: false },
    );
    await received.execute();
    expect(
      await prisma.subscription.findFirst({ where: { familyId: fid } }),
    ).toMatchObject({ autoRenew: false });
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'PAID' });
  });
  it('refund/revoke blocks the family license, retains immutable payment and grants history', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    await service.verify(actorOf(fid), fid, bought.input);
    const received = await notification(
      fid,
      { ...bought.verified, revokedAt: new Date() },
      'REVOKED',
    );
    await received.execute();
    expect(
      await prisma.familyLicense.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ blockedAt: expect.any(Date) });
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'BLOCKED' });
    expect(
      await prisma.subscriptionTransaction.count({ where: { familyId: fid } }),
    ).toBeGreaterThanOrEqual(1);
    expect(
      await prisma.licenseGrant.count({ where: { familyId: fid } }),
    ).toBeGreaterThanOrEqual(1);
  });
  it('rejects stale fencing, preserves pending event and retries with durable attempt history', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    await service.verify(actorOf(fid), fid, bought.input);
    const received = await notification(
      fid,
      bought.verified,
      'AUTO_RENEW_CHANGED',
      { autoRenew: false },
    );
    await expect(
      received.execute((context) =>
        service.processNotification(received.row.id, {
          ...context,
          lease: new JobLease(
            context.lease.runId,
            context.lease.attemptNumber,
            context.lease.fencingToken + 1n,
            context.lease.maxAttempts,
            context.lease.workerId,
          ),
        }),
      ),
    ).rejects.toMatchObject({ code: 'JOB_LEASE_LOST' });
    expect(
      await prisma.storeNotification.findUnique({
        where: { id: received.row.id },
      }),
    ).toMatchObject({ status: 'PENDING', processedAt: null });
    expect(
      await prisma.subscription.findFirst({ where: { familyId: fid } }),
    ).toMatchObject({ autoRenew: true });
    const run = await prisma.jobRun.findFirstOrThrow({
      where: { familyId: fid, scopeKey: received.row.id },
    });
    expect(run.status).toBe('RETRY_WAIT');
    await prisma.jobRun.update({
      where: { id: run.id },
      data: { nextAttemptAt: new Date(Date.now() - 1000) },
    });
    expect(await received.execute()).toBe('SUCCEEDED');
    const attempts = await prisma.jobAttempt.findMany({
      where: { runId: run.id },
      orderBy: { attemptNumber: 'asc' },
    });
    expect(attempts.map((a) => a.status)).toEqual(['FAILED', 'SUCCEEDED']);
    expect(
      await prisma.storeNotification.findUnique({
        where: { id: received.row.id },
      }),
    ).toMatchObject({ status: 'PROCESSED' });
  });
  it('retires the granted seven-day trial on purchase and does not fall back after paid expiry', async () => {
    const fid = await family();
    const license = await prisma.familyLicense.findUniqueOrThrow({
      where: { familyId: fid },
    });
    const policy = await prisma.trialPolicy.create({
      data: {
        code: `IAP_POLICY_${fid.slice(0, 8)}`,
        version: 1,
        planVersionId: versionIds[0]!,
        durationSeconds: 604800n,
        reminderOffsetsSeconds: [86400],
        active: false,
      },
    });
    const trialEnd = new Date(startsAt.getTime() + 604800000);
    const trial = await prisma.licenseGrant.create({
      data: {
        familyId: fid,
        licenseId: license.id,
        planVersionId: versionIds[0]!,
        source: 'TRIAL',
        trialPolicyId: policy.id,
        provenanceKey: `iap-spec:trial:${fid}`,
        validFrom: startsAt,
        validUntil: trialEnd,
      },
    });
    await prisma.familyEntitlement.update({
      where: { familyId: fid },
      data: {
        accessPhase: 'TRIAL',
        sourceGrantId: trial.id,
        effectivePlanVersionId: versionIds[0]!,
        validUntil: trialEnd,
        trialStartedAt: startsAt,
        trialEndsAt: trialEnd,
      },
    });
    const bought = await purchase(fid);
    await service.verify(actorOf(fid), fid, bought.input);
    expect(
      await prisma.licenseGrant.findUnique({ where: { id: trial.id } }),
    ).toMatchObject({ revokedAt: expect.any(Date), validUntil: trialEnd });
    const expired = await notification(fid, bought.verified, 'EXPIRED');
    await expired.execute();
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'EXPIRED', sourceGrantId: null });
    expect(
      await prisma.trialPolicy.findUnique({ where: { id: policy.id } }),
    ).toMatchObject({ durationSeconds: 604800n, version: 1 });
  });
  it.each(['APP_STORE', 'PLAY'] as const)(
    'recovers %s webhook before client verification and keeps later verification idempotent',
    async (store) => {
      const fid = await family();
      const bought = await purchase(fid, store);
      const received = await notification(fid, bought.verified, 'RENEWED');
      await received.execute();
      expect(
        await prisma.subscription.count({ where: { familyId: fid } }),
      ).toBe(1);
      expect(
        await prisma.subscriptionTransaction.count({
          where: { familyId: fid },
        }),
      ).toBe(1);
      expect(
        await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
      ).toMatchObject({ accessPhase: 'PAID' });
      expect(
        await service.verify(actorOf(fid), fid, bought.input),
      ).toMatchObject({ accessPhase: 'PAID' });
      expect(
        await prisma.subscriptionTransaction.count({
          where: { familyId: fid },
        }),
      ).toBe(1);
    },
  );
  it('retains a purchase on its original family when its purchaser has left before the webhook', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    await prisma.familyParent.updateMany({
      where: { familyId: fid, userId: actorOf(fid).userId },
      data: { leftAt: new Date() },
    });
    await prisma.family.update({
      where: { id: fid },
      data: { status: 'PARTNER_LEFT' },
    });
    const received = await notification(fid, bought.verified, 'RENEWED');
    await received.execute();
    expect(
      await prisma.subscription.findFirst({ where: { familyId: fid } }),
    ).toMatchObject({ familyId: fid });
    expect(
      await prisma.licenseGrant.count({
        where: { familyId: fid, source: 'STORE' },
      }),
    ).toBe(1);
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'INCOMPLETE' });
  });
  it('reconciliation bounds poison event retries without starving a valid later event', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    await service.verify(actorOf(fid), fid, bought.input);
    const second = await purchase(fid, 'APP_STORE', 1);
    await service.verify(actorOf(fid), fid, second.input);
    const poison = await notification(
      fid,
      bought.verified,
      'AUTO_RENEW_CHANGED',
      { autoRenew: false },
    );
    const repository = module.get<IapBillingRepository>(IAP_BILLING_REPOSITORY);
    const apply = repository.applyNotification.bind(repository);
    jest
      .spyOn(repository, 'applyNotification')
      .mockImplementation((...args) => {
        if (args[0] === poison.row.id)
          return Promise.reject(
            new Error('Synthetic temporary dependency outage'),
          );
        return apply(...args);
      });
    const valid = await notification(
      fid,
      second.verified,
      'AUTO_RENEW_CHANGED',
      { autoRenew: false, occurredAt: new Date(Date.now() + 2000) },
    );
    let result: Record<string, number> = {};
    const scan = async () => {
      await runner.execute(
        jobPolicy,
        {
          familyId: fid,
          scopeKey: fid,
          scheduledFor: new Date(),
          idempotencyKey: `iap-scan:${randomUUID()}`,
        },
        async (context) => {
          result = await service.reconcileNotifications(
            new Date(),
            context,
            fid,
          );
          return result;
        },
      );
    };
    await scan();
    expect(result).toEqual({ processed: 1, failed: 1 });
    expect(
      await prisma.storeNotification.findUnique({
        where: { id: valid.row.id },
      }),
    ).toMatchObject({ status: 'PROCESSED' });
    for (let index = 0; index < 3; index++) {
      await prisma.jobRun.updateMany({
        where: { familyId: fid, scopeKey: poison.row.id, status: 'RETRY_WAIT' },
        data: { nextAttemptAt: new Date(Date.now() - 1000) },
      });
      await scan();
    }
    const failed = await prisma.jobRun.findFirstOrThrow({
      where: { familyId: fid, scopeKey: poison.row.id },
    });
    expect(failed.status).toBe('FAILED');
    expect(await prisma.jobAttempt.count({ where: { runId: failed.id } })).toBe(
      3,
    );
    expect(
      await prisma.storeNotification.findUnique({
        where: { id: poison.row.id },
      }),
    ).toMatchObject({ status: 'PENDING', processedAt: null });
    expect(result).toEqual({ processed: 0, failed: 0 });
  });
  it('serves purchase, verification, upgrade and Apple webhook HTTP contracts in the focused Nest module', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    const client = request(app.getHttpServer());
    const response = await client
      .post(`/api/v1/families/${fid}/purchase-intents`)
      .set('Idempotency-Key', randomUUID())
      .send({ planCode: planCodes[0], store: 'APP_STORE' })
      .expect(201);
    const body = response.body as {
      data: { intentId: string; appAccountToken: string; productId: string };
    };
    expect(body.data).toEqual({
      intentId: expect.any(String),
      appAccountToken: expect.any(String),
      productId: `${namespace}.0.APP_STORE`,
    });
    bought.verified.accountToken = body.data.appAccountToken;
    const paid = await client
      .post(`/api/v1/families/${fid}/purchases/verify`)
      .send({ ...bought.input, intentId: body.data.intentId })
      .expect(200);
    expect(paid.body).toMatchObject({
      data: {
        familyId: fid,
        accessPhase: 'PAID',
        plan: { code: planCodes[0] },
      },
    });
    const upgrades = await client
      .get(`/api/v1/families/${fid}/billing/upgrade-options`)
      .expect(200);
    expect(upgrades.body).toMatchObject({
      data: { options: expect.any(Array) },
    });
    await client
      .post(`/api/v1/families/${fid}/purchase-intents`)
      .set('Idempotency-Key', randomUUID())
      .send({ planCode: planCodes[1], store: 'BAD' })
      .expect(400);
    const proof = randomUUID();
    verifier.notifications.set(proof, {
      store: 'APP_STORE',
      eventId: randomUUID(),
      type: 'AUTO_RENEW_CHANGED',
      occurredAt: new Date(Date.now() + 1000),
      purchase: bought.verified,
      autoRenew: false,
      raw: { synthetic: true },
    });
    const webhook = await client
      .post('/api/v1/webhooks/app-store')
      .send({ signedPayload: proof })
      .expect(200);
    expect(webhook.body).toMatchObject({
      data: { received: true, notificationId: expect.any(String) },
    });
    await client
      .post('/api/v1/webhooks/app-store')
      .send({ signedPayload: '' })
      .expect(400);
  });
  it('blocks a refund webhook received before first verification and rejects the original proof', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    const refund = await notification(
      fid,
      { ...bought.verified, revokedAt: new Date() },
      'REVOKED',
    );
    await refund.execute();
    expect(
      await prisma.familyLicense.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({
      blockedAt: expect.any(Date),
      blockReasonCode: 'STORE_REVOKED',
    });
    expect(
      await prisma.familyEntitlement.findUnique({ where: { familyId: fid } }),
    ).toMatchObject({ accessPhase: 'BLOCKED' });
    await expect(
      service.verify(actorOf(fid), fid, bought.input),
    ).rejects.toMatchObject({ code: 'LICENSE_BLOCKED', statusCode: 403 });
    expect(
      await prisma.licenseGrant.count({
        where: { familyId: fid, revokedAt: null },
      }),
    ).toBe(0);
  });
  it('marks a permanently invalid grace event failed after one durable attempt', async () => {
    const fid = await family();
    const bought = await purchase(fid);
    await service.verify(actorOf(fid), fid, bought.input);
    const invalid = await notification(fid, bought.verified, 'GRACE');
    await expect(invalid.execute()).rejects.toMatchObject({
      code: 'INVALID_GRACE_PERIOD',
    });
    const run = await prisma.jobRun.findFirstOrThrow({
      where: { familyId: fid, scopeKey: invalid.row.id },
    });
    expect(run.status).toBe('FAILED');
    expect(await prisma.jobAttempt.count({ where: { runId: run.id } })).toBe(1);
    expect(
      await prisma.storeNotification.findUnique({
        where: { id: invalid.row.id },
      }),
    ).toMatchObject({ status: 'PENDING' });
  });
});
