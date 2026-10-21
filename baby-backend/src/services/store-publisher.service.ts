import { Injectable } from '@nestjs/common';
import { DomainError } from '../common/errors/domain.error';
import type { IStorePublisher } from '../interfaces/services/store-publisher.interface';
import type { VerifiedStorePurchase } from '../interfaces/services/store-verifier.interface';
/** Replace with authenticated Android Publisher lookup before enabling Play. */
@Injectable()
export class StorePublisherService implements IStorePublisher {
  getSubscription(
    _packageName: string,
    _purchaseToken: string,
  ): Promise<VerifiedStorePurchase> {
    return Promise.reject(
      new DomainError(
        'Android Publisher integration is not configured.',
        'STORE_PUBLISHER_UNAVAILABLE',
        503,
      ),
    );
  }
}
