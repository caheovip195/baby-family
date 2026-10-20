import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { Family } from '../../models/family.model';

export const APPLICATION_ACCESS_SERVICE = Symbol('APPLICATION_ACCESS_SERVICE');
/**
 * `download`: read-only access that keeps working after the subscription
 * lapsed (`accessPhase` EXPIRED or an unrenewed TRIAL/PAID), so Parents can
 * still open and download their data (spec §6.5 EXPIRED allowlist:
 * `GET /memories/{id}`, download URLs, media grid). Membership, family
 * lifecycle are still enforced. BLOCKED preserves this data right too;
 * ordinary reads/writes remain blocked.
 */
export type FamilyAccessMode =
  'read' | 'download' | 'write' | 'metadata' | 'family-profile-update';
export interface IApplicationAccessService {
  requireContentAccess?(
    actor: AuthPrincipal,
    familyId: string,
    mode: FamilyAccessMode,
  ): Promise<{ family: Family; isParent: boolean }>;
  requireParent(
    actor: AuthPrincipal,
    familyId: string,
    mode: FamilyAccessMode,
  ): Promise<Family>;
}
