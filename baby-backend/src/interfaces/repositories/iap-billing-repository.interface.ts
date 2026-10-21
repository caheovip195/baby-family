import type {
  IapCurrentSubscriptionModel,
  IapIntentModel,
  IapNotificationModel,
  IapProductModel,
  IapStore,
} from '../../models/iap-billing.model';
import type {
  VerifiedStoreNotification,
  VerifiedStorePurchase,
} from '../services/store-verifier.interface';
import type { JobContext } from '../services/job-runner-service.interface';
export const IAP_BILLING_REPOSITORY = Symbol('IAP_BILLING_REPOSITORY');
export interface IIapBillingRepository {
  findCurrentSubscription(
    familyId: string,
    now: Date,
  ): Promise<IapCurrentSubscriptionModel | null>;
  listProducts(
    now: Date,
    store?: IapStore,
    environment?: string,
    appNamespace?: string,
  ): Promise<IapProductModel[]>;
  listUpgradeProducts(familyId: string, now: Date): Promise<IapProductModel[]>;
  createIntent(input: {
    familyId: string;
    userId: string;
    product: IapProductModel;
    idempotencyKey: string;
    now: Date;
    expiresAt: Date;
  }): Promise<IapIntentModel>;
  findIntent(
    familyId: string,
    intentId: string,
  ): Promise<IapIntentModel | null>;
  applyPurchase(
    intentId: string,
    purchase: VerifiedStorePurchase,
    now: Date,
    purchaseTokenEnc?: Uint8Array,
  ): Promise<void>;
  storeNotification(
    event: VerifiedStoreNotification,
    payloadEnc: Uint8Array,
    payloadHash: Uint8Array,
    now: Date,
  ): Promise<{ id: string; created: boolean }>;
  findNotification(id: string): Promise<IapNotificationModel | null>;
  applyNotification(
    id: string,
    event: VerifiedStoreNotification,
    context: JobContext,
    now: Date,
    purchaseTokenEnc?: Uint8Array,
  ): Promise<void>;
  pendingNotifications(now: Date, familyId?: string): Promise<string[]>;
}
