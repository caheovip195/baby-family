import {
  IsIn,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
  MinLength,
} from 'class-validator';
import type { IapStore } from '../../models/iap-billing.model';

export class CreateIapIntentDto {
  @IsString() @MinLength(1) @MaxLength(40) planCode!: string;
  @IsIn(['APP_STORE', 'PLAY']) store!: IapStore;
}
export class VerifyIapPurchaseDto {
  @IsIn(['APP_STORE', 'PLAY']) store!: IapStore;
  @IsUUID() intentId!: string;
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(100000)
  signedTransaction?: string;
  @IsOptional()
  @IsString()
  @MinLength(1)
  @MaxLength(10000)
  purchaseToken?: string;
}
export class AppStoreNotificationDto {
  @IsString() @MinLength(1) @MaxLength(200000) signedPayload!: string;
}
export interface IapIntentResponse {
  intentId: string;
  productId: string;
  appAccountToken?: string;
  obfuscatedAccountId?: string;
}
export interface IapUpgradeOptionsResponse {
  currentSubscription: {
    store: IapStore;
    purchaserUserId: string | null;
    autoRenew: boolean;
    currentPeriodEnd: Date | null;
  } | null;
  requiresPayerAction: boolean;
  options: {
    planCode: string;
    planVersionId: string;
    store: IapStore;
    productId: string;
  }[];
}
