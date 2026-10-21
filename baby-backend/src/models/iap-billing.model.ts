export type IapStore = 'APP_STORE' | 'PLAY';

export class IapProductModel {
  constructor(
    public readonly id: string,
    public readonly providerProductId: string,
    public readonly store: IapStore,
    public readonly environment: string,
    public readonly appNamespace: string,
    public readonly planCode: string,
    public readonly planVersionId: string,
    public readonly entitlementRank: number,
  ) {}
}

export class IapIntentModel {
  constructor(
    public readonly id: string,
    public readonly familyId: string,
    public readonly licenseId: string,
    public readonly userId: string | null,
    public readonly product: IapProductModel,
    public readonly accountToken: string,
    public readonly expiresAt: Date,
    public readonly status: string,
  ) {}
}

export class IapNotificationModel {
  constructor(
    public readonly id: string,
    public readonly payloadEnc: Uint8Array | null,
    public readonly status: string,
  ) {}
}

export class IapCurrentSubscriptionModel {
  constructor(
    public readonly store: IapStore,
    public readonly purchaserUserId: string | null,
    public readonly autoRenew: boolean,
    public readonly currentPeriodEnd: Date | null,
  ) {}
}
