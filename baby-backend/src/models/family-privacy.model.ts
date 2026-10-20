import type { DatabaseJsonValue } from '../common/database.types';
import type { FamilyErasure } from './family-erasure.model';

export interface FamilyPrivacyGrant {
  childId?: string;
  pregnancyId?: string;
  permission: string;
  allowDownload: boolean;
}
export interface FamilyPrivacyMember {
  memberId: string;
  displayName: string;
  relation: string;
  status: string;
  grants: FamilyPrivacyGrant[];
}
export interface FamilyPrivacyExport {
  id: string;
  scope: string;
  status: string;
  createdAt: Date;
  completedAt: Date | null;
  expiresAt: Date | null;
  errorCode: string | null;
}
/** Metadata snapshot only: no private-content rows, asset keys or signed URLs. */
export class FamilyPrivacySnapshot {
  constructor(
    readonly role: 'PARENT' | 'CIRCLE' | 'INACTIVE',
    readonly settings: DatabaseJsonValue,
    readonly circle: FamilyPrivacyMember[],
    readonly pendingInvites: number,
    readonly blockedCount: number,
    readonly dataExport: FamilyPrivacyExport | null,
    readonly deletion: FamilyErasure | null,
  ) {}
}
