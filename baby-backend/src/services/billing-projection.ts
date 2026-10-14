import { ServiceUnavailableException } from '@nestjs/common';
import { z } from 'zod';
import type {
  BillingPlan,
  BillingTrialPolicy,
} from '../models/billing-catalog.model';
import type { FamilyBillingState } from '../models/family-billing-state.model';
import type {
  BillingPlanResponseDto,
  BillingTrialPolicyResponseDto,
} from '../dto/billing/billing-catalog-response.dto';
import type { FamilyBillingResponseDto } from '../dto/billing/family-billing-response.dto';

const displayNameSchema = z.record(z.string().min(1), z.string().min(1));
const quotaSchema = z.record(z.string().min(1), z.number().int().nonnegative());
const featureSchema = z.record(z.string().min(1), z.boolean());

/** Positive response allowlists; persistence models never become HTTP payloads. */
export class BillingProjection {
  static plan(plan: BillingPlan): BillingPlanResponseDto {
    const displayName = displayNameSchema.safeParse(plan.displayName);
    const quotas = quotaSchema.safeParse(plan.quotas);
    const features = featureSchema.safeParse(plan.features);
    if (
      !displayName.success ||
      !Object.keys(displayName.data).length ||
      !quotas.success ||
      !features.success
    )
      throw new ServiceUnavailableException(
        'Billing catalog configuration is unavailable.',
      );
    return {
      code: plan.code,
      displayName: displayName.data,
      displayOrder: plan.displayOrder,
      versionId: plan.versionId,
      version: plan.version,
      quotas: quotas.data,
      features: features.data,
    };
  }

  static trial(policy: BillingTrialPolicy): BillingTrialPolicyResponseDto {
    if (
      policy.durationSeconds <= 0n ||
      policy.reminderOffsetsSeconds.some(
        (offset) =>
          !Number.isSafeInteger(offset) ||
          offset <= 0 ||
          BigInt(offset) >= policy.durationSeconds,
      )
    )
      throw new ServiceUnavailableException(
        'Trial policy configuration is unavailable.',
      );
    return {
      code: policy.code,
      version: policy.version,
      durationSeconds: policy.durationSeconds.toString(),
      reminderOffsetsSeconds: [...policy.reminderOffsetsSeconds],
      plan: this.plan(policy.plan),
    };
  }

  static family(
    state: FamilyBillingState,
    now: Date,
  ): FamilyBillingResponseDto {
    const entitlement = state.entitlement;
    let accessPhase = entitlement?.accessPhase ?? 'INCOMPLETE';
    if (state.licenseBlocked) accessPhase = 'BLOCKED';
    else if (
      (accessPhase === 'TRIAL' || accessPhase === 'PAID') &&
      (!entitlement?.validUntil ||
        entitlement.validUntil.getTime() <= now.getTime() ||
        (accessPhase === 'TRIAL' &&
          (!entitlement.trialEndsAt ||
            entitlement.trialEndsAt.getTime() <= now.getTime())) ||
        !state.effectivePlan)
    )
      accessPhase = 'EXPIRED';
    const usage = state.usage;
    return {
      familyId: state.familyId,
      accessPhase,
      licenseBlocked: state.licenseBlocked,
      plan: state.effectivePlan ? this.plan(state.effectivePlan) : null,
      trialEndsAt: entitlement?.trialEndsAt ?? null,
      validUntil: entitlement?.validUntil ?? null,
      inGrace:
        (accessPhase === 'PAID' || accessPhase === 'TRIAL') &&
        (entitlement?.inGrace ?? false),
      entitlementVersion: entitlement?.version.toString() ?? null,
      computedAt: entitlement?.computedAt ?? null,
      usage: usage
        ? {
            storageBytes: usage.storageBytes.toString(),
            reservedStorageBytes: usage.reservedStorageBytes.toString(),
            memoryCount: usage.memoryCount,
            albumCount: usage.albumCount,
            activeSeries: usage.activeSeries,
            letterCount: usage.letterCount,
          }
        : null,
    };
  }
}
