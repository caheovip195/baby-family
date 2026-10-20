import type { FamilyCirclePreview } from '../../models/family-circle-state.model';
import type { ParentKind } from '../../common/database.enums';
import type { Family } from '../../models/family.model';
import type { FamilyInvite } from '../../models/family-invite.model';
import type {
  FamilyBootstrapState,
  InvitePreview,
} from '../../models/onboarding-state.model';

export const ONBOARDING_REPOSITORY = Symbol('ONBOARDING_REPOSITORY');

/** Locates an invite by its link token or 8-character code (both stored hashed). */
export type InviteLookup = { tokenHash: Buffer } | { codeHash: Buffer };

export interface CreateFamilyInput {
  userId: string;
  name: string;
  kind: ParentKind;
  callName: string;
  timezone: string;
  now: Date;
}

export type CreateFamilyResult =
  | { kind: 'CREATED'; family: Family }
  | { kind: 'ROLE_REQUIRED' }
  | { kind: 'ALREADY_PARENT' };

export type CancelFamilyResult =
  { kind: 'CANCELLED' } | { kind: 'NOT_FOUND' } | { kind: 'NOT_WAITING' };

export interface CreatePartnerInviteInput {
  userId: string;
  familyId: string;
  /** Role offered to the partner; defaults to the opposite of the inviter's kind. */
  kind: ParentKind | null;
  message: string | null;
  requireFinalApproval: boolean;
  tokenHash: Buffer;
  codeHash: Buffer;
  expiresAt: Date;
  dailyLimit: number;
  now: Date;
}

export type CreatePartnerInviteResult =
  | { kind: 'CREATED'; invite: FamilyInvite }
  | { kind: 'NOT_FOUND' }
  | { kind: 'FAMILY_COMPLETE' }
  | { kind: 'LIMIT_REACHED' };

export interface AcceptInviteInput {
  userId: string;
  lookup: InviteLookup;
  callName: string | null;
  now: Date;
  /** HMAC of `provider:uid` for trial abuse checks (spec §6.5). */
  identityHash: (provider: string, providerUid: string) => Buffer;
}

export type InviteDecisionResult =
  | { kind: 'JOINED'; familyId: string; trialEndsAt: Date | null }
  | { kind: 'AWAITING_APPROVAL'; familyId: string }
  | { kind: 'DECLINED'; familyId: string }
  | { kind: 'NOT_FOUND' }
  | { kind: 'EXPIRED' }
  | { kind: 'ALREADY_USED' }
  | { kind: 'SELF_INVITE' }
  | { kind: 'NOT_SUPPORTED' }
  | { kind: 'SLOTS_FULL' }
  | { kind: 'ALREADY_PARENT' };

export interface DecideInviteInput {
  userId: string;
  inviteId: string;
  approve: boolean;
  now: Date;
  identityHash: (provider: string, providerUid: string) => Buffer;
}

/** Family creation, partner invites and activation with trial (spec §6.5, §7.3, BR-050…056). */
export interface IOnboardingRepository {
  createFamily(input: CreateFamilyInput): Promise<CreateFamilyResult>;
  cancelFamily(
    userId: string,
    familyId: string,
    now: Date,
  ): Promise<CancelFamilyResult>;
  createPartnerInvite(
    input: CreatePartnerInviteInput,
  ): Promise<CreatePartnerInviteResult>;
  /** Latest partner invite of a family the user is an active Parent of. */
  findLatestPartnerInvite(
    userId: string,
    familyId: string,
  ): Promise<FamilyInvite | null | 'NOT_FOUND'>;
  /** Active children of a family (names for a PARTNER_LEFT partner invite). */
  activeChildren(familyId: string): Promise<{ id: string; name: string }[]>;
  resolveInvite(
    lookup: InviteLookup,
  ): Promise<InvitePreview | FamilyCirclePreview | null>;
  acceptInvite(input: AcceptInviteInput): Promise<InviteDecisionResult>;
  declineInvite(
    userId: string,
    lookup: InviteLookup,
    now: Date,
  ): Promise<InviteDecisionResult>;
  /** Final approval/rejection by an active Parent of the inviting family. */
  decideInvite(input: DecideInviteInput): Promise<InviteDecisionResult>;
  findBootstrap(
    userId: string,
    familyId: string,
  ): Promise<FamilyBootstrapState | null>;
}
