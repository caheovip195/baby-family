import {
  createCipheriv,
  createDecipheriv,
  createHash,
  randomBytes,
} from 'node:crypto';
import { Inject, Injectable, Logger, Optional } from '@nestjs/common';
import { z } from 'zod';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import { PermanentJobError } from '../common/errors/job.error';
import {
  IAP_BILLING_CONFIG,
  IAP_BILLING_POLICY,
  storedIapNotificationSchema,
} from '../config/iap-billing-policy';
import type { IapBillingConfig } from '../config/iap-billing-policy';
import { JOBS } from '../config/jobs';
import type {
  CreateIapIntentDto,
  VerifyIapPurchaseDto,
} from '../dto/billing/iap-billing.dto';
import { IAP_BILLING_REPOSITORY } from '../interfaces/repositories/iap-billing-repository.interface';
import type { IIapBillingRepository } from '../interfaces/repositories/iap-billing-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import type { IApplicationAccessService } from '../interfaces/services/application-access-service.interface';
import { FAMILY_BILLING_SERVICE } from '../interfaces/services/family-billing-service.interface';
import type { IFamilyBillingService } from '../interfaces/services/family-billing-service.interface';
import type { IIapBillingService } from '../interfaces/services/iap-billing-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../interfaces/services/job-runner-service.interface';
import { STORE_VERIFIER } from '../interfaces/services/store-verifier.interface';
import type {
  IStoreVerifier,
  VerifiedStoreNotification,
} from '../interfaces/services/store-verifier.interface';
import type { IapStore } from '../models/iap-billing.model';

@Injectable()
export class IapBillingService implements IIapBillingService {
  private readonly logger = new Logger(IapBillingService.name);
  constructor(
    @Inject(IAP_BILLING_REPOSITORY)
    private readonly repository: IIapBillingRepository,
    @Inject(APPLICATION_ACCESS_SERVICE)
    private readonly access: IApplicationAccessService,
    @Inject(FAMILY_BILLING_SERVICE)
    private readonly billing: IFamilyBillingService,
    @Inject(STORE_VERIFIER) private readonly verifier: IStoreVerifier,
    @Inject(IAP_BILLING_CONFIG) private readonly config: IapBillingConfig,
    @Optional()
    @Inject(JOB_RUNNER_SERVICE)
    private readonly runner?: IJobRunnerService,
  ) {}

  async createIntent(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateIapIntentDto,
    key: string | undefined,
  ) {
    await this.access.requireParent(actor, familyId, 'metadata');
    if (!z.uuid().safeParse(key).success)
      throw new ValidationError('Idempotency-Key must be a UUID.');
    if (!['APP_STORE', 'PLAY'].includes(input.store) || !input.planCode)
      throw new ValidationError('Invalid purchase request.');
    const now = new Date();
    const products = await this.repository.listProducts(
      now,
      input.store,
      this.config.environment,
      this.namespace(input.store),
    );
    const matches = products.filter(
      (product) => product.planCode === input.planCode,
    );
    if (!matches.length)
      throw new DomainError(
        'The requested product is unavailable.',
        'IAP_PRODUCT_UNAVAILABLE',
        422,
      );
    // Multiple periods/base plans require an explicit future contract; never silently choose a price.
    if (matches.length !== 1)
      throw new DomainError(
        'Product mapping is ambiguous.',
        'IAP_CATALOG_AMBIGUOUS',
        503,
      );
    const intent = await this.repository.createIntent({
      familyId,
      userId: actor.userId,
      product: matches[0]!,
      idempotencyKey: key!,
      now,
      expiresAt: new Date(now.getTime() + IAP_BILLING_POLICY.intentLifetimeMs),
    });
    return {
      intentId: intent.id,
      productId: intent.product.providerProductId,
      ...(input.store === 'APP_STORE'
        ? { appAccountToken: intent.accountToken }
        : { obfuscatedAccountId: intent.accountToken }),
    };
  }

  async verify(
    actor: AuthPrincipal,
    familyId: string,
    input: VerifyIapPurchaseDto,
  ) {
    await this.access.requireParent(actor, familyId, 'metadata');
    const intent = await this.repository.findIntent(familyId, input.intentId);
    if (!intent) throw new NotFoundError('Purchase intent was not found.');
    if (intent.userId !== actor.userId || intent.product.store !== input.store)
      throw new DomainError(
        'Purchase intent does not match the caller/store.',
        'IAP_INTENT_MISMATCH',
        409,
      );
    if (
      input.store === 'APP_STORE'
        ? !input.signedTransaction || input.purchaseToken !== undefined
        : input.store !== 'PLAY' ||
          !input.purchaseToken ||
          input.signedTransaction !== undefined
    )
      throw new ValidationError(
        'Provide exactly the credential for the selected store.',
      );
    const now = new Date();
    if (intent.status !== 'VERIFIED' && intent.expiresAt <= now)
      throw new DomainError(
        'Purchase intent has expired.',
        'IAP_INTENT_EXPIRED',
        410,
      );
    const purchase = await this.verifier.verifyPurchase({
      store: input.store,
      signedTransaction: input.signedTransaction,
      purchaseToken: input.purchaseToken,
      productId: intent.product.providerProductId,
      accountToken: intent.accountToken,
    });
    if (
      purchase.store !== input.store ||
      purchase.productId !== intent.product.providerProductId ||
      purchase.accountToken !== intent.accountToken ||
      purchase.environment !== intent.product.environment ||
      purchase.appNamespace !== intent.product.appNamespace
    )
      throw new DomainError(
        'Store purchase binding does not match the intent.',
        'IAP_PURCHASE_MISMATCH',
        409,
      );
    if (
      !Number.isFinite(purchase.startsAt.getTime()) ||
      !Number.isFinite(purchase.expiresAt.getTime()) ||
      purchase.expiresAt <= purchase.startsAt ||
      purchase.startsAt > now ||
      purchase.revokedAt
    )
      throw new DomainError(
        'Store purchase is not eligible.',
        'IAP_PURCHASE_INACTIVE',
        422,
      );
    await this.repository.applyPurchase(
      intent.id,
      purchase,
      now,
      input.purchaseToken
        ? this.encrypt(input.purchaseToken, `iap-token:${intent.accountToken}`)
        : undefined,
    );
    return this.billing.get(actor, familyId);
  }

  async upgradeOptions(actor: AuthPrincipal, familyId: string) {
    await this.access.requireParent(actor, familyId, 'metadata');
    const products = await this.repository.listUpgradeProducts(
      familyId,
      new Date(),
    );
    const current = await this.repository.findCurrentSubscription(
      familyId,
      new Date(),
    );
    return {
      currentSubscription: current
        ? {
            store: current.store,
            purchaserUserId: current.purchaserUserId,
            autoRenew: current.autoRenew,
            currentPeriodEnd: current.currentPeriodEnd,
          }
        : null,
      requiresPayerAction:
        !!current && current.purchaserUserId !== actor.userId,
      options: products
        .filter(
          (product) =>
            product.environment === this.config.environment &&
            product.appNamespace === this.namespace(product.store),
        )
        .map((product) => ({
          planCode: product.planCode,
          planVersionId: product.planVersionId,
          store: product.store,
          productId: product.providerProductId,
        })),
    };
  }

  async receiveAppStore(signedPayload: string) {
    const event = await this.verifier.verifyAppStoreNotification(signedPayload);
    return this.receive(event, { signedPayload });
  }
  async receivePlay(authorization: string | undefined, body: unknown) {
    const event = await this.verifier.verifyPlayNotification({
      authorization,
      body,
    });
    return this.receive(event, body);
  }
  private async receive(event: VerifiedStoreNotification, raw: unknown) {
    const envelope = JSON.stringify({ version: 1, event, raw });
    const payloadEnc = this.encrypt(envelope, 'iap-notification:v1');
    // Hash normalized provider identity, not Pub/Sub delivery metadata (which changes on retry).
    const hash = createHash('sha256')
      .update(JSON.stringify(event.raw))
      .digest();
    const stored = await this.repository.storeNotification(
      event,
      payloadEnc,
      hash,
      new Date(),
    );
    return { received: true as const, notificationId: stored.id };
  }

  async processNotification(id: string, context: JobContext) {
    context.signal.throwIfAborted();
    const row = await this.repository.findNotification(id);
    if (!row || row.status === 'PROCESSED') return { processed: 0 };
    if (!row.payloadEnc)
      throw new PermanentJobError(
        'IAP_EVENT_PAYLOAD_MISSING',
        'Store event payload is missing.',
      );
    let event: VerifiedStoreNotification;
    try {
      const decoded: unknown = JSON.parse(
        this.decrypt(row.payloadEnc, 'iap-notification:v1'),
      );
      event = storedIapNotificationSchema.parse(decoded).event;
    } catch (error) {
      if (error instanceof DomainError) throw error;
      throw new PermanentJobError(
        'IAP_EVENT_PAYLOAD_INVALID',
        'Store event payload is invalid.',
      );
    }
    try {
      await this.repository.applyNotification(
        id,
        event,
        context,
        new Date(),
        event.purchase?.purchaseToken
          ? this.encrypt(
              event.purchase.purchaseToken,
              `iap-token:${event.purchase.accountToken}`,
            )
          : undefined,
      );
    } catch (error) {
      if (
        error instanceof DomainError &&
        [400, 403, 409, 422].includes(error.statusCode) &&
        error.code !== 'JOB_LEASE_LOST'
      )
        throw new PermanentJobError(
          error.code,
          'Store event was rejected by billing policy.',
        );
      throw error;
    }
    return { processed: 1 };
  }
  async reconcileNotifications(
    now: Date,
    context: JobContext,
    familyId?: string,
  ) {
    const ids = await this.repository.pendingNotifications(now, familyId);
    let processed = 0;
    let failed = 0;
    if (!this.runner)
      throw new DomainError(
        'Store reconciliation runner is unavailable.',
        'IAP_RUNNER_UNAVAILABLE',
        503,
      );
    for (const id of ids) {
      context.signal.throwIfAborted();
      try {
        const outcome = await this.runner.execute(
          JOBS.processStoreNotification,
          {
            scopeKey: id,
            scheduledFor: new Date(0),
            idempotencyKey: `iap-event:${id}`,
            ...(familyId ? { familyId } : {}),
            inputReference: { notificationId: id },
          },
          (eventContext) => this.processNotification(id, eventContext),
        );
        if (outcome === 'SUCCEEDED') processed++;
      } catch {
        context.signal.throwIfAborted();
        failed++;
        this.logger.warn(
          'Store event reconciliation failed; inspect durable per-event job history.',
        );
      }
    }
    return { processed, failed };
  }

  private namespace(store: IapStore): string {
    const value =
      store === 'APP_STORE'
        ? this.config.appStoreBundleId
        : this.config.playPackageName;
    if (!value)
      throw new DomainError(
        'Store configuration is unavailable.',
        'IAP_STORE_UNAVAILABLE',
        503,
      );
    return value;
  }
  private key() {
    const key = Buffer.from(this.config.payloadEncryptionKey ?? '', 'base64');
    if (key.length !== 32)
      throw new DomainError(
        'Store encryption is unavailable.',
        'IAP_ENCRYPTION_UNAVAILABLE',
        503,
      );
    return key;
  }
  private encrypt(value: string, aad: string) {
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', this.key(), iv);
    cipher.setAAD(Buffer.from(aad));
    const ciphertext = Buffer.concat([
      cipher.update(value, 'utf8'),
      cipher.final(),
    ]);
    return Buffer.concat([
      Buffer.from([1]),
      iv,
      cipher.getAuthTag(),
      ciphertext,
    ]);
  }
  private decrypt(value: Uint8Array, aad: string) {
    const data = Buffer.from(value);
    if (data.length < 30 || data[0] !== 1)
      throw new Error('Unsupported encrypted envelope.');
    const decipher = createDecipheriv(
      'aes-256-gcm',
      this.key(),
      data.subarray(1, 13),
    );
    decipher.setAAD(Buffer.from(aad));
    decipher.setAuthTag(data.subarray(13, 29));
    return Buffer.concat([
      decipher.update(data.subarray(29)),
      decipher.final(),
    ]).toString('utf8');
  }
}
