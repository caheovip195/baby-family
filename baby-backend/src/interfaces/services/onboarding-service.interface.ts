import type { CirclePreviewResponseDto } from '../../dto/invite/circle-preview.dto';
import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  AcceptInviteDto,
  CreateFamilyDto,
  CreatePartnerInviteDto,
  InviteReferenceDto,
} from '../../dto/onboarding/onboarding-commands.dto';
import type {
  CreatedPartnerInviteResponseDto,
  FamilyBootstrapResponseDto,
  InviteDecisionResponseDto,
  InvitePreviewResponseDto,
  PartnerInviteStatusResponseDto,
} from '../../dto/onboarding/onboarding-response.dto';

export const ONBOARDING_SERVICE = Symbol('ONBOARDING_SERVICE');

/** ONB-03…ONB-ACT and INV-01…05 flows (spec §6.5, §7.2–7.3, §23.1). */
export interface IOnboardingService {
  createFamily(
    actor: AuthPrincipal,
    input: CreateFamilyDto,
  ): Promise<FamilyBootstrapResponseDto>;
  cancelFamily(actor: AuthPrincipal, familyId: string): Promise<void>;
  createPartnerInvite(
    actor: AuthPrincipal,
    familyId: string,
    input: CreatePartnerInviteDto,
  ): Promise<CreatedPartnerInviteResponseDto>;
  getPartnerInvite(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<PartnerInviteStatusResponseDto>;
  resolveInvite(
    input: InviteReferenceDto,
  ): Promise<InvitePreviewResponseDto | CirclePreviewResponseDto>;
  acceptInvite(
    actor: AuthPrincipal,
    input: AcceptInviteDto,
  ): Promise<InviteDecisionResponseDto>;
  declineInvite(
    actor: AuthPrincipal,
    input: InviteReferenceDto,
  ): Promise<InviteDecisionResponseDto>;
  decideInvite(
    actor: AuthPrincipal,
    inviteId: string,
    approve: boolean,
  ): Promise<InviteDecisionResponseDto>;
  bootstrap(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyBootstrapResponseDto>;
}
