import { Injectable } from '@nestjs/common';
import { createHash, randomUUID } from 'node:crypto';
import { PrismaService } from '../database/prisma.service';
import type {
  Prisma,
  Product,
  PlanVersion,
  Plan,
  PurchaseIntent,
} from '../generated/prisma/client';
import { DomainError } from '../common/errors/domain.error';
import type { IIapBillingRepository } from '../interfaces/repositories/iap-billing-repository.interface';
import type {
  VerifiedStorePurchase,
  VerifiedStoreNotification,
} from '../interfaces/services/store-verifier.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import {
  IapCurrentSubscriptionModel,
  IapIntentModel,
  IapNotificationModel,
  IapProductModel,
} from '../models/iap-billing.model';
import type { IapStore } from '../models/iap-billing.model';

type Tx = Prisma.TransactionClient;
type ProductRow = Product & { planVersion: PlanVersion & { plan: Plan } };
type IntentRow = PurchaseIntent & { product: ProductRow };
const productInclude = { planVersion: { include: { plan: true } } } as const;
const dbStore = (store: IapStore) =>
  store === 'APP_STORE' ? ('APPLE' as const) : ('GOOGLE' as const);
const hash = (value: string) => createHash('sha256').update(value).digest();
function fail(code: string, status = 409): never {
  throw new DomainError(code, code, status);
}
function product(row: ProductRow): IapProductModel {
  return new IapProductModel(
    row.id,
    row.productId,
    row.store === 'APPLE' ? 'APP_STORE' : 'PLAY',
    row.environment,
    row.appNamespace,
    row.planVersion.plan.code,
    row.planVersionId,
    row.planVersion.entitlementRank,
  );
}
function intent(row: IntentRow): IapIntentModel {
  return new IapIntentModel(
    row.id,
    row.familyId,
    row.licenseId,
    row.purchaserUserId,
    product(row.product),
    row.store === 'APPLE' ? row.appAccountToken : row.obfuscatedAccountId!,
    row.expiresAt,
    row.status,
  );
}

@Injectable()
export class IapBillingRepository implements IIapBillingRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findCurrentSubscription(
    familyId: string,
    now: Date,
  ): Promise<IapCurrentSubscriptionModel | null> {
    const state = await this.prisma.familyEntitlement.findFirst({
      where: {
        familyId,
        deletedAt: null,
        accessPhase: 'PAID',
        validUntil: { gt: now },
        licenseGrant: {
          deletedAt: null,
          revokedAt: null,
          validFrom: { lte: now },
          validUntil: { gt: now },
        },
      },
      include: { licenseGrant: { include: { subscription: true } } },
    });
    const sub = state?.licenseGrant?.subscription;
    if (
      !sub ||
      sub.deletedAt ||
      sub.familyId !== familyId ||
      !['ACTIVE', 'CANCELED_ACTIVE', 'GRACE'].includes(sub.status)
    )
      return null;
    return new IapCurrentSubscriptionModel(
      sub.store === 'APPLE' ? 'APP_STORE' : 'PLAY',
      sub.purchaserUserId,
      sub.autoRenew,
      sub.currentPeriodEnd,
    );
  }
  async listProducts(
    now: Date,
    store?: IapStore,
    environment?: string,
    appNamespace?: string,
  ): Promise<IapProductModel[]> {
    const rows = await this.prisma.product.findMany({
      where: {
        active: true,
        deletedAt: null,
        ...(store ? { store: dbStore(store) } : {}),
        ...(environment ? { environment } : {}),
        ...(appNamespace ? { appNamespace } : {}),
        planVersion: {
          deletedAt: null,
          availableFrom: { lte: now },
          OR: [{ retiredAt: null }, { retiredAt: { gt: now } }],
          plan: { active: true, purchaseEnabled: true, deletedAt: null },
        },
      },
      include: productInclude,
      orderBy: [{ planVersion: { entitlementRank: 'asc' } }, { id: 'asc' }],
    });
    return rows.map(product);
  }
  async listUpgradeProducts(
    familyId: string,
    now: Date,
  ): Promise<IapProductModel[]> {
    const state = await this.prisma.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: { planVersion: true },
    });
    const rank =
      state?.accessPhase === 'PAID' &&
      !!state.validUntil &&
      state.validUntil > now
        ? (state.planVersion?.entitlementRank ?? -1)
        : -1;
    return (await this.listProducts(now)).filter(
      (p) => p.entitlementRank > rank,
    );
  }
  async createIntent(input: {
    familyId: string;
    userId: string;
    product: IapProductModel;
    idempotencyKey: string;
    now: Date;
    expiresAt: Date;
  }): Promise<IapIntentModel> {
    // UUID column stores a deterministic scope hash. Reusing a key for a different
    // product is rejected, rather than silently buying the previous selection.
    const bytes = hash(
      JSON.stringify([input.familyId, input.userId, input.idempotencyKey]),
    ).subarray(0, 16);
    bytes[6] = (bytes[6]! & 15) | 80;
    bytes[8] = (bytes[8]! & 63) | 128;
    const hex = bytes.toString('hex');
    const key = `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
    return this.prisma.$transaction(async (tx) => {
      await tx.$queryRaw`SELECT id FROM app.families WHERE id=${input.familyId}::uuid FOR UPDATE`;
      const previous = await tx.purchaseIntent.findUnique({
        where: { clientIdempotencyKey: key },
        include: { product: { include: productInclude } },
      });
      if (previous) {
        if (previous.deletedAt || previous.productId !== input.product.id)
          fail('IDEMPOTENCY_CONFLICT');
        return intent(previous);
      }
      const family = await tx.family.findFirst({
        where: { id: input.familyId, status: 'ACTIVE', deletedAt: null },
      });
      const parents = await tx.familyParent.count({
        where: {
          familyId: input.familyId,
          status: 'ACTIVE',
          leftAt: null,
          deletedAt: null,
          user: { status: 'ACTIVE', deletedAt: null },
        },
      });
      if (!family || parents !== 2) fail('FAMILY_NOT_ACTIVE');
      const member = await tx.familyParent.findFirst({
        where: {
          familyId: input.familyId,
          userId: input.userId,
          status: 'ACTIVE',
          leftAt: null,
          deletedAt: null,
        },
      });
      if (!member) fail('PARENT_REQUIRED', 403);
      const license = await tx.familyLicense.findFirst({
        where: { familyId: input.familyId, deletedAt: null },
      });
      if (!license) fail('LICENSE_NOT_FOUND', 404);
      if (license.blockedAt || license.blockReasonCode)
        fail('LICENSE_BLOCKED', 403);
      const state = await tx.familyEntitlement.findFirst({
        where: { familyId: input.familyId, deletedAt: null },
        include: { planVersion: true },
      });
      if (
        state?.accessPhase === 'PAID' &&
        !!state.validUntil &&
        state.validUntil > input.now &&
        (state.planVersion?.entitlementRank ?? 0) >=
          input.product.entitlementRank
      )
        fail('PLAN_NOT_UPGRADE');
      const row = await tx.purchaseIntent.create({
        data: {
          familyId: input.familyId,
          licenseId: license.id,
          purchaserUserId: input.userId,
          productId: input.product.id,
          store: dbStore(input.product.store),
          environment: input.product.environment,
          appNamespace: input.product.appNamespace,
          clientIdempotencyKey: key,
          appAccountToken: randomUUID(),
          obfuscatedAccountId: randomUUID(),
          expiresAt: input.expiresAt,
        },
        include: { product: { include: productInclude } },
      });
      return intent(row);
    });
  }
  async findIntent(
    familyId: string,
    intentId: string,
  ): Promise<IapIntentModel | null> {
    const row = await this.prisma.purchaseIntent.findFirst({
      where: { id: intentId, familyId, deletedAt: null },
      include: { product: { include: productInclude } },
    });
    return row ? intent(row) : null;
  }
  private async recompute(
    tx: Tx,
    familyId: string,
    licenseId: string,
    now: Date,
  ): Promise<void> {
    const license = await tx.familyLicense.findUniqueOrThrow({
      where: { id: licenseId },
    });
    const grants = await tx.licenseGrant.findMany({
      where: {
        familyId,
        licenseId,
        deletedAt: null,
        revokedAt: null,
        validFrom: { lte: now },
        validUntil: { gt: now },
      },
      include: { planVersion: true, subscription: true },
    });
    grants.sort(
      (a, b) =>
        b.planVersion.entitlementRank - a.planVersion.entitlementRank ||
        b.validUntil.getTime() - a.validUntil.getTime(),
    );
    const grant = grants[0];
    const family = await tx.family.findUniqueOrThrow({
      where: { id: familyId },
    });
    const accessPhase =
      license.blockedAt || license.blockReasonCode
        ? ('BLOCKED' as const)
        : family.status !== 'ACTIVE' || family.deletedAt
          ? ('INCOMPLETE' as const)
          : grant
            ? grant.source === 'TRIAL'
              ? ('TRIAL' as const)
              : ('PAID' as const)
            : ('EXPIRED' as const);
    const data = {
      licenseId,
      accessPhase,
      effectivePlanVersionId: grant?.planVersionId ?? null,
      sourceGrantId: grant?.id ?? null,
      validUntil: grant?.validUntil ?? null,
      inGrace: grant?.subscription?.status === 'GRACE',
      computedAt: now,
    };
    const projection = await tx.familyEntitlement.upsert({
      where: { familyId },
      create: { familyId, ...data },
      update: { ...data, version: { increment: 1 } },
    });
    await tx.outboxEvent.create({
      data: {
        eventType: 'family.entitlement.changed',
        aggregateId: licenseId,
        familyId,
        payload: { familyId, version: projection.version.toString() },
      },
    });
  }
  private async persistPurchase(
    tx: Tx,
    row: IntentRow,
    p: VerifiedStorePurchase,
    now: Date,
    purchaseTokenEnc?: Uint8Array,
    notification = false,
  ): Promise<string> {
    const store = dbStore(p.store);
    if (
      row.store !== store ||
      row.environment !== p.environment ||
      row.appNamespace !== p.appNamespace ||
      row.product.productId !== p.productId ||
      (row.store === 'APPLE'
        ? row.appAccountToken
        : row.obfuscatedAccountId) !== p.accountToken
    )
      fail('STORE_BINDING_MISMATCH', 400);
    if (p.expiresAt <= p.startsAt || p.startsAt > now || p.revokedAt)
      fail('PURCHASE_NOT_ACTIVE', 400);
    const binding = hash(p.originalTransactionId);
    await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtextextended(${`${store}:${p.environment}:${p.appNamespace}:${p.originalTransactionId}`},0))`;
    const identity = {
      store,
      environment: p.environment,
      appNamespace: p.appNamespace,
    };
    const prior = await tx.subscriptionTransaction.findUnique({
      where: {
        store_environment_appNamespace_providerTransactionId: {
          ...identity,
          providerTransactionId: p.transactionId,
        },
      },
    });
    if (prior) {
      if (prior.familyId !== row.familyId || prior.productId !== row.productId)
        fail('TRANSACTION_ALREADY_BOUND');
      return prior.subscriptionId;
    }
    let sub = await tx.subscription.findUnique({
      where: {
        store_environment_appNamespace_storeBindingKey: {
          ...identity,
          storeBindingKey: binding,
        },
      },
    });
    if (
      sub &&
      (sub.familyId !== row.familyId ||
        sub.licenseId !== row.licenseId ||
        sub.deletedAt)
    )
      fail('TRANSACTION_ALREADY_BOUND');
    if (row.status !== 'VERIFIED') {
      if (
        notification
          ? p.startsAt < row.createdAt || p.startsAt >= row.expiresAt
          : row.expiresAt <= now
      )
        fail('PURCHASE_INTENT_EXPIRED', 400);
    }
    const license = await tx.familyLicense.findUniqueOrThrow({
      where: { id: row.licenseId },
    });
    if (license.deletedAt || license.blockedAt || license.blockReasonCode)
      fail('LICENSE_BLOCKED', 403);
    const state = {
      productId: row.productId,
      status: 'ACTIVE' as const,
      autoRenew: p.autoRenew,
      currentPeriodStart: p.startsAt,
      currentPeriodEnd: p.expiresAt,
      lastVerifiedAt: p.startsAt,
    };
    if (sub) {
      if (sub.status === 'REVOKED' || sub.status === 'REFUNDED')
        fail('PURCHASE_REVOKED', 403);
      if (sub.currentPeriodStart && sub.currentPeriodStart > p.startsAt)
        fail('STALE_PURCHASE', 409);
      sub = await tx.subscription.update({
        where: { id: sub.id },
        data: state,
      });
    } else {
      if (store === 'GOOGLE' && !purchaseTokenEnc)
        fail('STORE_TOKEN_REQUIRED', 400);
      sub = await tx.subscription.create({
        data: {
          ...identity,
          ...state,
          familyId: row.familyId,
          licenseId: row.licenseId,
          purchaseIntentId: row.id,
          purchaserUserId: row.purchaserUserId,
          storeBindingKey: binding,
          originalTransactionId:
            store === 'APPLE' ? p.originalTransactionId : null,
          purchaseTokenHash: store === 'GOOGLE' ? binding : null,
          purchaseTokenEnc:
            store === 'GOOGLE' && purchaseTokenEnc
              ? Uint8Array.from(purchaseTokenEnc)
              : null,
          appAccountToken: store === 'APPLE' ? row.appAccountToken : null,
        },
      });
    }
    const transaction = await tx.subscriptionTransaction.create({
      data: {
        ...identity,
        subscriptionId: sub.id,
        familyId: row.familyId,
        licenseId: row.licenseId,
        providerTransactionId: p.transactionId,
        kind: 'PURCHASE',
        productId: row.productId,
        planVersionId: row.product.planVersionId,
        periodStart: p.startsAt,
        periodEnd: p.expiresAt,
        purchasedAt: p.startsAt,
        verifiedAt: now,
        payloadHash: hash(JSON.stringify(p.raw)),
      },
    });
    await tx.licenseGrant.updateMany({
      where: {
        familyId: row.familyId,
        licenseId: row.licenseId,
        source: 'TRIAL',
        revokedAt: null,
        deletedAt: null,
      },
      data: { revokedAt: now, revokeReasonCode: 'PAID_SUBSCRIPTION' },
    });
    await tx.licenseGrant.updateMany({
      where: {
        subscriptionId: sub.id,
        provenanceKey: { startsWith: 'iap:grace:' },
        revokedAt: null,
        deletedAt: null,
      },
      data: { revokedAt: now, revokeReasonCode: 'STORE_RECOVERED' },
    });
    await tx.licenseGrant.create({
      data: {
        familyId: row.familyId,
        licenseId: row.licenseId,
        planVersionId: row.product.planVersionId,
        source: 'STORE',
        subscriptionId: sub.id,
        transactionId: transaction.id,
        provenanceKey: `iap:${transaction.id}`,
        validFrom: p.startsAt,
        validUntil: p.expiresAt,
      },
    });
    await tx.purchaseIntent.update({
      where: { id: row.id },
      data: { status: 'VERIFIED', verifiedAt: now },
    });
    await this.recompute(tx, row.familyId, row.licenseId, now);
    return sub.id;
  }
  async applyPurchase(
    intentId: string,
    purchase: VerifiedStorePurchase,
    now: Date,
    purchaseTokenEnc?: Uint8Array,
  ): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const row = await tx.purchaseIntent.findFirst({
        where: { id: intentId, deletedAt: null },
        include: { product: { include: productInclude } },
      });
      if (!row) fail('PURCHASE_INTENT_NOT_FOUND', 404);
      await tx.$queryRaw`SELECT id FROM app.families WHERE id=${row.familyId}::uuid FOR UPDATE`;
      const family = await tx.family.findFirst({
        where: { id: row.familyId, status: 'ACTIVE', deletedAt: null },
      });
      if (!family) fail('FAMILY_NOT_ACTIVE');
      const parents = await tx.familyParent.count({
        where: {
          familyId: row.familyId,
          status: 'ACTIVE',
          leftAt: null,
          deletedAt: null,
          user: { status: 'ACTIVE', deletedAt: null },
        },
      });
      if (parents !== 2) fail('FAMILY_NOT_ACTIVE');
      await this.persistPurchase(tx, row, purchase, now, purchaseTokenEnc);
    });
  }
  async storeNotification(
    event: VerifiedStoreNotification,
    payloadEnc: Uint8Array,
    payloadHash: Uint8Array,
    now: Date,
  ): Promise<{ id: string; created: boolean }> {
    const p = event.purchase;
    const environment = p?.environment ?? event.environment;
    const appNamespace = p?.appNamespace ?? event.appNamespace;
    if (!environment || !appNamespace)
      fail('NOTIFICATION_NAMESPACE_REQUIRED', 400);
    return this.prisma.$transaction(async (tx) => {
      const key = {
        store: dbStore(event.store),
        environment,
        appNamespace,
        notificationId: event.eventId,
      };
      await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtextextended(${JSON.stringify(key)},0))`;
      const existing = await tx.storeNotification.findUnique({
        where: { store_environment_appNamespace_notificationId: key },
      });
      if (existing) {
        if (
          Buffer.compare(
            Buffer.from(existing.payloadHash),
            Buffer.from(payloadHash),
          ) !== 0
        )
          fail('NOTIFICATION_ID_CONFLICT');
        return { id: existing.id, created: false };
      }
      const sub = p
        ? await tx.subscription.findUnique({
            where: {
              store_environment_appNamespace_storeBindingKey: {
                store: key.store,
                environment: key.environment,
                appNamespace: key.appNamespace,
                storeBindingKey: hash(p.originalTransactionId),
              },
            },
          })
        : null;
      const row = await tx.storeNotification.create({
        data: {
          ...key,
          type: event.type,
          payloadEnc: Uint8Array.from(payloadEnc),
          payloadHash: Uint8Array.from(payloadHash),
          receivedAt: now,
          nextAttemptAt: now,
          subscriptionId: sub?.id,
        },
      });
      await tx.outboxEvent.create({
        data: {
          eventType: 'billing.store-notification',
          aggregateId: row.id,
          familyId: sub?.familyId,
          payload: { notificationId: row.id },
        },
      });
      return { id: row.id, created: true };
    });
  }
  async findNotification(id: string): Promise<IapNotificationModel | null> {
    const row = await this.prisma.storeNotification.findFirst({
      where: { id, deletedAt: null },
    });
    return row
      ? new IapNotificationModel(row.id, row.payloadEnc, row.status)
      : null;
  }
  async pendingNotifications(now: Date, familyId?: string): Promise<string[]> {
    // Apply eligibility before LIMIT so terminal/poison runs cannot starve
    // later pending notifications. The durable run owns retry timing/counts.
    const rows = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT n.id FROM billing.store_notifications n
      LEFT JOIN billing.subscriptions s ON s.id=n.subscription_id AND s.deleted_at IS NULL
      LEFT JOIN ops.job_runs r ON r.idempotency_key=('iap-event:' || n.id::text) AND r.deleted_at IS NULL
      WHERE n.deleted_at IS NULL AND n.status IN ('PENDING','RETRY_WAIT')
        AND (n.next_attempt_at IS NULL OR n.next_attempt_at<=${now})
        AND (${familyId ?? null}::uuid IS NULL OR s.family_id=${familyId ?? null}::uuid)
        AND (r.id IS NULL OR (
          r.status NOT IN ('SUCCEEDED','FAILED','SKIPPED')
          AND (r.next_attempt_at IS NULL OR r.next_attempt_at<=${now})
          AND (r.status<>'RUNNING' OR r.lease_expires_at IS NULL OR r.lease_expires_at<=${now})
        ))
      ORDER BY n.received_at,n.id LIMIT 100`;
    return rows.map((r) => r.id);
  }
  private async fence(tx: Tx, context: JobContext): Promise<void> {
    context.signal.throwIfAborted();
    const { lease } = context;
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM ops.job_runs WHERE id=${lease.runId}::uuid AND status='RUNNING' AND fencing_token=${lease.fencingToken} AND lease_owner=${lease.workerId} AND deleted_at IS NULL AND lease_expires_at>clock_timestamp() FOR UPDATE`;
    if (!rows.length) fail('JOB_LEASE_LOST');
  }
  async applyNotification(
    id: string,
    event: VerifiedStoreNotification,
    context: JobContext,
    now: Date,
    purchaseTokenEnc?: Uint8Array,
  ): Promise<void> {
    await this.prisma.$transaction(
      async (tx) => {
        await this.fence(tx, context);
        const row = await tx.storeNotification.findFirst({
          where: { id, deletedAt: null },
        });
        if (!row || row.processedAt) return;
        const p = event.purchase;
        if (event.type === 'IGNORED') {
          await tx.storeNotification.update({
            where: { id },
            data: {
              status: 'PROCESSED',
              processedAt: now,
              attempts: { increment: 1 },
              nextAttemptAt: null,
            },
          });
          await this.fence(tx, context);
          return;
        }
        if (!p) fail('NOTIFICATION_PURCHASE_REQUIRED', 400);
        let sub = await tx.subscription.findUnique({
          where: {
            store_environment_appNamespace_storeBindingKey: {
              store: dbStore(event.store),
              environment: p.environment,
              appNamespace: p.appNamespace,
              storeBindingKey: hash(p.originalTransactionId),
            },
          },
        });
        if (!sub && (event.type === 'RENEWED' || event.type === 'REVOKED')) {
          const boundIntent = await tx.purchaseIntent.findFirst({
            where: {
              store: dbStore(event.store),
              environment: p.environment,
              appNamespace: p.appNamespace,
              deletedAt: null,
              ...(event.store === 'APP_STORE'
                ? { appAccountToken: p.accountToken }
                : { obfuscatedAccountId: p.accountToken }),
            },
            include: { product: { include: productInclude } },
          });
          if (!boundIntent) fail('NOTIFICATION_INTENT_NOT_FOUND', 404);
          await tx.$queryRaw`SELECT id FROM app.families WHERE id=${boundIntent.familyId}::uuid FOR UPDATE`;
          if (event.type === 'REVOKED') {
            const run = await tx.jobRun.findUniqueOrThrow({
              where: { id: context.lease.runId },
              select: { familyId: true },
            });
            if (run.familyId && run.familyId !== boundIntent.familyId)
              fail('JOB_FAMILY_SCOPE_MISMATCH', 403);
            await tx.familyLicense.update({
              where: { id: boundIntent.licenseId },
              data: {
                blockedAt: event.occurredAt,
                blockReasonCode: 'STORE_REVOKED',
              },
            });
            await this.recompute(
              tx,
              boundIntent.familyId,
              boundIntent.licenseId,
              now,
            );
            await tx.storeNotification.update({
              where: { id },
              data: {
                status: 'PROCESSED',
                processedAt: now,
                attempts: { increment: 1 },
                nextAttemptAt: null,
              },
            });
            await this.fence(tx, context);
            return;
          }
          const subId = await this.persistPurchase(
            tx,
            boundIntent,
            p,
            now,
            purchaseTokenEnc,
            true,
          );
          sub = await tx.subscription.findUniqueOrThrow({
            where: { id: subId },
          });
        }
        if (!sub || sub.deletedAt)
          fail('NOTIFICATION_SUBSCRIPTION_NOT_FOUND', 404);
        const run = await tx.jobRun.findUniqueOrThrow({
          where: { id: context.lease.runId },
          select: { familyId: true },
        });
        if (run.familyId && run.familyId !== sub.familyId)
          fail('JOB_FAMILY_SCOPE_MISMATCH', 403);
        await tx.$queryRaw`SELECT id FROM app.families WHERE id=${sub.familyId}::uuid FOR UPDATE`;
        sub = await tx.subscription.findUniqueOrThrow({
          where: { id: sub.id },
        });
        const terminal = sub.status === 'REVOKED' || sub.status === 'REFUNDED';
        if (
          (!terminal || event.type === 'REVOKED') &&
          (!sub.lastVerifiedAt ||
            event.occurredAt > sub.lastVerifiedAt ||
            (event.type === 'REVOKED' &&
              event.occurredAt.getTime() === sub.lastVerifiedAt.getTime()))
        ) {
          if (event.type === 'RENEWED') {
            const original = await tx.purchaseIntent.findFirst({
              where: {
                familyId: sub.familyId,
                licenseId: sub.licenseId,
                store: sub.store,
                environment: sub.environment,
                appNamespace: sub.appNamespace,
                deletedAt: null,
                ...(sub.store === 'APPLE'
                  ? { appAccountToken: p.accountToken }
                  : { obfuscatedAccountId: p.accountToken }),
              },
              include: { product: { include: productInclude } },
            });
            if (!original) fail('STORE_BINDING_MISMATCH', 400);
            const target = await tx.product.findFirst({
              where: {
                productId: p.productId,
                store: sub.store,
                environment: sub.environment,
                appNamespace: sub.appNamespace,
                deletedAt: null,
              },
              include: productInclude,
            });
            if (!target) fail('STORE_PRODUCT_NOT_FOUND', 400);
            // The subscription chain keeps its original intent binding. Renewal
            // products carry their own immutable version in the transaction ledger.
            const renewal = {
              ...original,
              productId: target.id,
              product: target,
            };
            await this.persistPurchase(
              tx,
              renewal,
              p,
              now,
              sub.purchaseTokenEnc ?? purchaseTokenEnc,
              true,
            );
          } else if (event.type === 'REVOKED') {
            await tx.subscription.update({
              where: { id: sub.id },
              data: { status: 'REVOKED', autoRenew: false },
            });
            await tx.licenseGrant.updateMany({
              where: {
                subscriptionId: sub.id,
                deletedAt: null,
                revokedAt: null,
              },
              data: {
                revokedAt: event.occurredAt,
                revokeReasonCode: 'STORE_REVOKED',
              },
            });
            await tx.subscriptionTransaction.updateMany({
              where: {
                subscriptionId: sub.id,
                deletedAt: null,
                revokedAt: null,
              },
              data: { revokedAt: event.occurredAt },
            });
            await tx.familyLicense.update({
              where: { id: sub.licenseId },
              data: {
                blockedAt: event.occurredAt,
                blockReasonCode: 'STORE_REVOKED',
              },
            });
          } else if (event.type === 'EXPIRED') {
            await tx.subscription.update({
              where: { id: sub.id },
              data: { status: 'EXPIRED', autoRenew: false, graceUntil: null },
            });
            await tx.licenseGrant.updateMany({
              where: {
                subscriptionId: sub.id,
                deletedAt: null,
                revokedAt: null,
              },
              data: {
                revokedAt: event.occurredAt,
                revokeReasonCode: 'STORE_EXPIRED',
              },
            });
          } else if (event.type === 'GRACE') {
            if (!p.graceUntil) fail('INVALID_GRACE_PERIOD', 400);
            if (p.graceUntil <= now) {
              await this.recompute(tx, sub.familyId, sub.licenseId, now);
              await tx.storeNotification.update({
                where: { id },
                data: {
                  subscriptionId: sub.id,
                  status: 'PROCESSED',
                  processedAt: now,
                  attempts: { increment: 1 },
                  nextAttemptAt: null,
                },
              });
              await this.fence(tx, context);
              return;
            }
            await tx.subscription.update({
              where: { id: sub.id },
              data: { status: 'GRACE', graceUntil: p.graceUntil },
            });
            const transaction = await tx.subscriptionTransaction.findUnique({
              where: {
                store_environment_appNamespace_providerTransactionId: {
                  store: sub.store,
                  environment: sub.environment,
                  appNamespace: sub.appNamespace,
                  providerTransactionId: p.transactionId,
                },
              },
            });
            if (!transaction) fail('GRACE_TRANSACTION_NOT_FOUND', 404);
            await tx.licenseGrant.upsert({
              where: { provenanceKey: `iap:grace:${id}` },
              create: {
                familyId: sub.familyId,
                licenseId: sub.licenseId,
                planVersionId: transaction.planVersionId,
                source: 'STORE',
                subscriptionId: sub.id,
                transactionId: transaction.id,
                provenanceKey: `iap:grace:${id}`,
                validFrom: p.expiresAt,
                validUntil: p.graceUntil,
              },
              update: {},
            });
          } else if (event.type === 'AUTO_RENEW_CHANGED') {
            await tx.subscription.update({
              where: { id: sub.id },
              data: {
                autoRenew: event.autoRenew ?? p.autoRenew,
                ...(sub.status === 'ACTIVE' || sub.status === 'CANCELED_ACTIVE'
                  ? {
                      status:
                        (event.autoRenew ?? p.autoRenew)
                          ? ('ACTIVE' as const)
                          : ('CANCELED_ACTIVE' as const),
                    }
                  : {}),
              },
            });
          }
          await tx.subscription.update({
            where: { id: sub.id },
            data: { lastVerifiedAt: event.occurredAt },
          });
          await this.recompute(tx, sub.familyId, sub.licenseId, now);
        }
        await tx.storeNotification.update({
          where: { id },
          data: {
            subscriptionId: sub.id,
            status: 'PROCESSED',
            processedAt: now,
            attempts: { increment: 1 },
            nextAttemptAt: null,
          },
        });
        await this.fence(tx, context);
      },
      { timeout: 15000 },
    );
  }
}
