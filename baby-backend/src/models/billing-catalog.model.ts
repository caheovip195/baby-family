import type { DatabaseJsonValue } from '../common/database.types';

export interface BillingPlanAttributes {
  code: string;
  displayName: DatabaseJsonValue;
  displayOrder: number;
  versionId: string;
  version: number;
  quotas: DatabaseJsonValue;
  features: DatabaseJsonValue;
}

export class BillingPlan implements BillingPlanAttributes {
  readonly code: string;
  readonly displayName: DatabaseJsonValue;
  readonly displayOrder: number;
  readonly versionId: string;
  readonly version: number;
  readonly quotas: DatabaseJsonValue;
  readonly features: DatabaseJsonValue;
  constructor(attributes: BillingPlanAttributes) {
    this.code = attributes.code;
    this.displayName = attributes.displayName;
    this.displayOrder = attributes.displayOrder;
    this.versionId = attributes.versionId;
    this.version = attributes.version;
    this.quotas = attributes.quotas;
    this.features = attributes.features;
  }
}

export class BillingTrialPolicy {
  constructor(
    readonly code: string,
    readonly version: number,
    readonly durationSeconds: bigint,
    readonly reminderOffsetsSeconds: readonly number[],
    readonly plan: BillingPlan,
  ) {}
}

export class BillingCatalog {
  constructor(
    readonly plans: readonly BillingPlan[],
    readonly trialPolicies: readonly BillingTrialPolicy[],
  ) {}
}
