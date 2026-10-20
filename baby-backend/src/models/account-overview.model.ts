import type {
  FamilyStatus,
  ParentKind,
  ParentSlot,
} from '../common/database.enums';
import type { User } from './user.model';

export interface ParentMembershipAttributes {
  familyId: string;
  familyName: string;
  familyStatus: FamilyStatus;
  slot: ParentSlot;
  kind: ParentKind;
  callName: string;
}

export interface AwaitingApprovalAttributes {
  inviteId: string;
  familyName: string;
  kind: ParentKind | null;
}

export interface AccountOverviewAttributes {
  user: User;
  parentMemberships: ParentMembershipAttributes[];
  /** Consent documents currently granted (latest decision per document). */
  grantedDocuments: string[];
  /** Partner invites this user accepted that wait for the inviter's final approval. */
  awaitingApproval: AwaitingApprovalAttributes[];
}

/** Read model for `GET /me` (spec §11.3): profile, families and onboarding progress. */
export class AccountOverview implements AccountOverviewAttributes {
  readonly user: User;
  readonly parentMemberships: ParentMembershipAttributes[];
  readonly grantedDocuments: string[];
  readonly awaitingApproval: AwaitingApprovalAttributes[];

  constructor(attributes: AccountOverviewAttributes) {
    this.user = attributes.user;
    this.parentMemberships = attributes.parentMemberships;
    this.grantedDocuments = attributes.grantedDocuments;
    this.awaitingApproval = attributes.awaitingApproval;
  }

  hasGranted(document: string): boolean {
    return this.grantedDocuments.includes(document);
  }
}
