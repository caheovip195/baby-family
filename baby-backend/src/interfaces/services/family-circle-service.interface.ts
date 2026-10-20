import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateCircleInviteDto,
  UpdateCircleMemberDto,
} from '../../dto/circle/circle-commands.dto';
import type { FamilyCircleInvite } from '../../models/family-circle-state.model';
import type {
  CircleMemberProfileResponse,
  CircleBootstrapProfileResponse,
  CircleOverviewProfileResponse,
} from '../../dto/circle/circle-profile-response.dto';
export const FAMILY_CIRCLE_SERVICE = Symbol('FAMILY_CIRCLE_SERVICE');
export interface CircleCreatedInvite {
  inviteId: string;
  code: string;
  url: string;
  qrPayload: string;
  expiresAt: string;
}
export interface IFamilyCircleService {
  createInvite(
    actor: AuthPrincipal,
    fid: string,
    input: CreateCircleInviteDto,
  ): Promise<CircleCreatedInvite>;
  listInvites(actor: AuthPrincipal, fid: string): Promise<FamilyCircleInvite[]>;
  changeInvite(
    actor: AuthPrincipal,
    id: string,
    renew: boolean,
  ): Promise<CircleCreatedInvite | { status: string }>;
  listMembers(
    actor: AuthPrincipal,
    fid: string,
  ): Promise<CircleMemberProfileResponse[]>;
  updateMember(
    actor: AuthPrincipal,
    id: string,
    input: UpdateCircleMemberDto | 'PAUSED' | 'ACTIVE' | 'REMOVED',
  ): Promise<void>;
  leave(actor: AuthPrincipal, fid: string): Promise<void>;
  overview(
    actor: AuthPrincipal,
    fid: string,
  ): Promise<CircleOverviewProfileResponse>;
  myCircles(actor: AuthPrincipal): Promise<CircleBootstrapProfileResponse[]>;
}
