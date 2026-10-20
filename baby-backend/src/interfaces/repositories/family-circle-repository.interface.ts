import type { CircleInvitePayload } from '../../config/circle-policy';
import type { UpdateCircleMemberDto } from '../../dto/circle/circle-commands.dto';
import type {
  FamilyCircleMember,
  FamilyCircleInvite,
  FamilyCirclePreview,
  FamilyCircleOverview,
  FamilyCircleBootstrap,
} from '../../models/family-circle-state.model';
import type {
  AcceptInviteInput,
  DecideInviteInput,
  InviteDecisionResult,
  InviteLookup,
} from './onboarding-repository.interface';
export const FAMILY_CIRCLE_REPOSITORY = Symbol('FAMILY_CIRCLE_REPOSITORY');
export interface CircleInviteSecrets {
  tokenHash: Buffer;
  codeHash: Buffer;
  expiresAt: Date;
}
export interface IFamilyCircleRepository {
  createInvite(
    userId: string,
    familyId: string,
    payload: CircleInvitePayload,
    approval: boolean,
    secrets: CircleInviteSecrets,
  ): Promise<FamilyCircleInvite>;
  listInvites(familyId: string): Promise<FamilyCircleInvite[]>;
  findInvite(id: string): Promise<FamilyCircleInvite | null>;
  changeInvite(
    userId: string,
    id: string,
    secrets: CircleInviteSecrets | null,
  ): Promise<FamilyCircleInvite>;
  listMembers(familyId: string): Promise<FamilyCircleMember[]>;
  findMember(id: string): Promise<FamilyCircleMember | null>;
  updateMember(
    userId: string,
    id: string,
    input: UpdateCircleMemberDto | 'PAUSED' | 'ACTIVE' | 'REMOVED',
  ): Promise<void>;
  leave(userId: string, familyId: string): Promise<void>;
  overview(familyId: string): Promise<FamilyCircleOverview>;
  myCircles(userId: string): Promise<FamilyCircleBootstrap[]>;
  resolveCircle(lookup: InviteLookup): Promise<FamilyCirclePreview | null>;
  acceptCircle(input: AcceptInviteInput): Promise<InviteDecisionResult>;
  decideCircle(input: DecideInviteInput): Promise<InviteDecisionResult>;
}
