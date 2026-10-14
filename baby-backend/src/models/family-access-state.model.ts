import type { Family } from './family.model';
import type { FamilyEntitlement } from './family-entitlement.model';

export interface FamilyAccessStateAttributes {
  family: Family;
  activeParentCount: number;
  licenseBlocked: boolean;
  entitlement: FamilyEntitlement | null;
}

export class FamilyAccessState implements FamilyAccessStateAttributes {
  readonly family: Family;
  readonly activeParentCount: number;
  readonly licenseBlocked: boolean;
  readonly entitlement: FamilyEntitlement | null;

  constructor(attributes: FamilyAccessStateAttributes) {
    this.family = attributes.family;
    this.activeParentCount = attributes.activeParentCount;
    this.licenseBlocked = attributes.licenseBlocked;
    this.entitlement = attributes.entitlement;
  }
}
