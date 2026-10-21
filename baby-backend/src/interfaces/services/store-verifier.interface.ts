export const STORE_VERIFIER = Symbol('STORE_VERIFIER');
export type PurchaseStore = 'APP_STORE' | 'PLAY';
export interface VerifiedStorePurchase {
  store: PurchaseStore;
  transactionId: string;
  originalTransactionId: string;
  productId: string;
  accountToken: string;
  appNamespace: string;
  startsAt: Date;
  expiresAt: Date;
  autoRenew: boolean;
  environment: string;
  graceUntil?: Date;
  revokedAt?: Date;
  purchaseToken?: string;
  raw: Record<string, unknown>;
}
export interface VerifiedStoreNotification {
  store: PurchaseStore;
  eventId: string;
  type:
    | 'RENEWED'
    | 'EXPIRED'
    | 'GRACE'
    | 'REVOKED'
    | 'AUTO_RENEW_CHANGED'
    | 'IGNORED';
  occurredAt: Date;
  environment?: string;
  appNamespace?: string;
  purchase: VerifiedStorePurchase | null;
  autoRenew?: boolean;
  raw: Record<string, unknown>;
}
export interface VerifyStorePurchaseInput {
  store: PurchaseStore;
  signedTransaction?: string;
  purchaseToken?: string;
  productId?: string;
  accountToken?: string;
}
export interface IStoreVerifier {
  verifyPurchase(
    input: VerifyStorePurchaseInput,
  ): Promise<VerifiedStorePurchase>;
  verifyAppStoreNotification(
    signedPayload: string,
  ): Promise<VerifiedStoreNotification>;
  verifyPlayNotification(input: {
    authorization: string | undefined;
    body: unknown;
  }): Promise<VerifiedStoreNotification>;
}
