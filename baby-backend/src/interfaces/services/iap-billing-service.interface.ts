import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateIapIntentDto,
  VerifyIapPurchaseDto,
  IapIntentResponse,
  IapUpgradeOptionsResponse,
} from '../../dto/billing/iap-billing.dto';
import type { FamilyBillingResponseDto } from '../../dto/billing/family-billing-response.dto';
import type { JobContext } from './job-runner-service.interface';

export const IAP_BILLING_SERVICE = Symbol('IAP_BILLING_SERVICE');
export interface IIapBillingService {
  createIntent(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateIapIntentDto,
    key: string | undefined,
  ): Promise<IapIntentResponse>;
  verify(
    actor: AuthPrincipal,
    familyId: string,
    input: VerifyIapPurchaseDto,
  ): Promise<FamilyBillingResponseDto>;
  upgradeOptions(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<IapUpgradeOptionsResponse>;
  receiveAppStore(
    signedPayload: string,
  ): Promise<{ received: true; notificationId: string }>;
  receivePlay(
    authorization: string | undefined,
    body: unknown,
  ): Promise<{ received: true; notificationId: string }>;
  processNotification(
    id: string,
    context: JobContext,
  ): Promise<Record<string, number>>;
  reconcileNotifications(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>>;
}
