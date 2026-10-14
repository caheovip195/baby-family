import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type { Family } from '../../models/family.model';

export const APPLICATION_ACCESS_SERVICE = Symbol('APPLICATION_ACCESS_SERVICE');
export type FamilyAccessMode =
  'read' | 'write' | 'metadata' | 'family-profile-update';
export interface IApplicationAccessService {
  requireParent(
    actor: AuthPrincipal,
    familyId: string,
    mode: FamilyAccessMode,
  ): Promise<Family>;
}
