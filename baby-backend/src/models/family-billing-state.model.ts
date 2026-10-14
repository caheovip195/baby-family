import type { FamilyEntitlement } from './family-entitlement.model';
import type { FamilyUsage } from './family-usage.model';
import type { BillingPlan } from './billing-catalog.model';

export class FamilyBillingState {
  constructor(
    readonly familyId: string,
    readonly licenseBlocked: boolean,
    readonly entitlement: FamilyEntitlement | null,
    readonly usage: FamilyUsage | null,
    readonly effectivePlan: BillingPlan | null,
  ) {}
}
