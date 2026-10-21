import type { VerifiedStorePurchase } from './store-verifier.interface';
export const STORE_PUBLISHER = Symbol('STORE_PUBLISHER');
/** Authoritative Android Publisher subscriptionsv2 lookup, including acknowledgement. */
export interface IStorePublisher {
  getSubscription(
    packageName: string,
    purchaseToken: string,
  ): Promise<VerifiedStorePurchase>;
}
