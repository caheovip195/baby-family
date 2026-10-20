import { FamilyCirclePreview } from '../models/family-circle-state.model';
import { CirclePreviewResponseDto } from '../dto/invite/circle-preview.dto';
import { randomInt } from 'node:crypto';
import { Optional, Inject, Injectable } from '@nestjs/common';
import { NO_PROFILE_IMAGES } from './no-profile-images';
import { ConfigService } from '@nestjs/config';
import type { Environment } from '../config/environment';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import type { ParentKind } from '../common/database.enums';
import {
  DomainError,
  NotFoundError,
  ValidationError,
} from '../common/errors/domain.error';
import type {
  AcceptInviteDto,
  CreateFamilyDto,
  CreatePartnerInviteDto,
  InviteReferenceDto,
} from '../dto/onboarding/onboarding-commands.dto';
import {
  CreatedPartnerInviteResponseDto,
  FamilyBootstrapResponseDto,
  InviteDecisionResponseDto,
  InvitePreviewResponseDto,
  PartnerInviteStatusResponseDto,
} from '../dto/onboarding/onboarding-response.dto';
import { ONBOARDING_REPOSITORY } from '../interfaces/repositories/onboarding-repository.interface';
import type {
  InviteDecisionResult,
  InviteLookup,
  IOnboardingRepository,
} from '../interfaces/repositories/onboarding-repository.interface';
import { USER_REPOSITORY } from '../interfaces/repositories/user-repository.interface';
import type { IUserRepository } from '../interfaces/repositories/user-repository.interface';
import { AUTH_TOKEN_SERVICE } from '../interfaces/services/auth-token-service.interface';
import type { IAuthTokenService } from '../interfaces/services/auth-token-service.interface';
import { FAMILY_BILLING_SERVICE } from '../interfaces/services/family-billing-service.interface';
import type { IFamilyBillingService } from '../interfaces/services/family-billing-service.interface';
import type { IOnboardingService } from '../interfaces/services/onboarding-service.interface';
import { PROFILE_IMAGE_SERVICE } from '../interfaces/services/profile-image-service.interface';
import type { IProfileImageService } from '../interfaces/services/profile-image-service.interface';

/** §7.3: partner invites last 7 days, at most 5 per day. */
const PARTNER_INVITE_TTL_MS = 7 * 24 * 3600 * 1000;
const PARTNER_INVITES_PER_DAY = 5;
/** 8 characters without look-alikes (0/O, 1/I/L). */
const CODE_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
const CODE_LENGTH = 8;
const DEFAULT_CALL_NAME: Record<ParentKind, string> = {
  FATHER: 'Papa',
  MOTHER: 'Mama',
};

@Injectable()
export class OnboardingService implements IOnboardingService {
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(ONBOARDING_REPOSITORY)
    private readonly repository: IOnboardingRepository,
    @Inject(USER_REPOSITORY) private readonly users: IUserRepository,
    @Inject(AUTH_TOKEN_SERVICE) private readonly tokens: IAuthTokenService,
    @Inject(FAMILY_BILLING_SERVICE)
    private readonly billing: IFamilyBillingService,
    @Optional()
    @Inject(PROFILE_IMAGE_SERVICE)
    private readonly profileImages: IProfileImageService = NO_PROFILE_IMAGES,
  ) {}

  async createFamily(
    actor: AuthPrincipal,
    input: CreateFamilyDto,
  ): Promise<FamilyBootstrapResponseDto> {
    const name = input.name.trim();
    if (!name) throw new ValidationError('Family name is required.');
    const user = await this.users.findByKey(
      { privileged: true },
      { id: actor.userId },
    );
    if (!user) throw new NotFoundError('User was not found.');
    const roleKind: ParentKind | null =
      user.onboardingRole === 'PARENT_FATHER'
        ? 'FATHER'
        : user.onboardingRole === 'PARENT_MOTHER'
          ? 'MOTHER'
          : null;
    if (!roleKind)
      throw new DomainError(
        'Choose Papa or Mama before creating a family.',
        'ROLE_NOT_SELECTED',
        403,
      );
    const kind = input.parent?.kind ?? roleKind;
    const callName = input.parent?.callName?.trim() || DEFAULT_CALL_NAME[kind];
    const result = await this.repository.createFamily({
      userId: actor.userId,
      name,
      kind,
      callName,
      timezone: user.timezone,
      now: new Date(),
    });
    if (result.kind === 'ROLE_REQUIRED')
      throw new DomainError(
        'Choose Papa or Mama before creating a family.',
        'ROLE_NOT_SELECTED',
        403,
      );
    if (result.kind === 'ALREADY_PARENT')
      throw new DomainError(
        'You already belong to a family.',
        'ALREADY_PARENT_OF_ANOTHER_FAMILY',
        409,
      );
    return this.bootstrap(actor, result.family.id);
  }

  async cancelFamily(actor: AuthPrincipal, familyId: string): Promise<void> {
    const result = await this.repository.cancelFamily(
      actor.userId,
      familyId,
      new Date(),
    );
    if (result.kind === 'NOT_FOUND')
      throw new NotFoundError('Family was not found.');
    if (result.kind === 'NOT_WAITING')
      throw new DomainError(
        'Only a family still waiting for the partner can be cancelled.',
        'FAMILY_NOT_WAITING',
        409,
      );
  }

  async createPartnerInvite(
    actor: AuthPrincipal,
    familyId: string,
    input: CreatePartnerInviteDto,
  ): Promise<CreatedPartnerInviteResponseDto> {
    await this.requireInviteAccess(actor, familyId);
    const now = new Date();
    // A code collision is astronomically rare; the unique index makes it safe to retry.
    for (let attempt = 0; attempt < 3; attempt += 1) {
      const token = this.tokens.newInviteToken();
      const code = this.newCode();
      try {
        const result = await this.repository.createPartnerInvite({
          userId: actor.userId,
          familyId,
          kind: input.kind ?? null,
          message: input.message?.trim() || null,
          requireFinalApproval: input.requireFinalApproval ?? true,
          tokenHash: token.hash,
          codeHash: this.tokens.keyedHash('invite-code', code),
          expiresAt: new Date(now.getTime() + PARTNER_INVITE_TTL_MS),
          dailyLimit: PARTNER_INVITES_PER_DAY,
          now,
        });
        if (result.kind === 'NOT_FOUND')
          throw new NotFoundError('Family was not found.');
        if (result.kind === 'FAMILY_COMPLETE')
          throw new DomainError(
            'This family already has both Parents.',
            'PARENT_SLOTS_FULL',
            409,
          );
        if (result.kind === 'LIMIT_REACHED')
          throw new DomainError(
            'Too many invites today. Try again tomorrow.',
            'INVITE_DAILY_LIMIT',
            429,
          );
        const url = `${this.config.get('INVITE_LINK_BASE_URL', { infer: true })}${token.value}`;
        return Object.assign(new CreatedPartnerInviteResponseDto(), {
          inviteId: result.invite.id,
          url,
          code,
          qrPayload: url,
          expiresAt: result.invite.expiresAt.toISOString(),
        });
      } catch (error) {
        if (attempt < 2 && isUniqueViolation(error)) continue;
        throw error;
      }
    }
    throw new DomainError('Could not create the invite.', 'INTERNAL', 500);
  }

  async getPartnerInvite(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<PartnerInviteStatusResponseDto> {
    await this.requireInviteAccess(actor, familyId);
    const invite = await this.repository.findLatestPartnerInvite(
      actor.userId,
      familyId,
    );
    if (invite === 'NOT_FOUND')
      throw new NotFoundError('Family was not found.');
    if (!invite) throw new NotFoundError('No partner invite yet.');
    return PartnerInviteStatusResponseDto.fromModel(invite, new Date());
  }

  /** Partner invites remain available during onboarding/PARTNER_LEFT, not after expiry. */
  private async requireInviteAccess(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<void> {
    const billing = await this.billing.get(actor, familyId);
    if (billing.licenseBlocked || billing.accessPhase === 'BLOCKED')
      throw new DomainError(
        'The family license is blocked.',
        'LICENSE_BLOCKED',
        403,
      );
    if (billing.accessPhase !== 'EXPIRED') return;
    const family = await this.repository.findBootstrap(actor.userId, familyId);
    if (family && ['WAITING_PARTNER', 'PARTNER_LEFT'].includes(family.status))
      return;
    throw new DomainError(
      'An active family subscription is required.',
      'SUBSCRIPTION_REQUIRED',
      402,
    );
  }

  async resolveInvite(
    input: InviteReferenceDto,
  ): Promise<InvitePreviewResponseDto | CirclePreviewResponseDto> {
    const preview = await this.repository.resolveInvite(this.lookup(input));
    if (!preview) throw new NotFoundError('Invite was not found.');
    if (preview instanceof FamilyCirclePreview)
      return CirclePreviewResponseDto.fromModel(preview);
    const response = InvitePreviewResponseDto.fromModel(preview, new Date());
    // §7.3: inviting a new partner after PARTNER_LEFT shows the children.
    if (preview.familyStatus === 'PARTNER_LEFT' && response.state === 'VALID')
      response.children = await this.repository.activeChildren(
        preview.familyId,
      );
    return response;
  }

  async acceptInvite(
    actor: AuthPrincipal,
    input: AcceptInviteDto,
  ): Promise<InviteDecisionResponseDto> {
    return this.decision(
      await this.repository.acceptInvite({
        userId: actor.userId,
        lookup: this.lookup(input),
        callName: input.callName?.trim() || null,
        now: new Date(),
        identityHash: this.identityHash,
      }),
    );
  }

  async declineInvite(
    actor: AuthPrincipal,
    input: InviteReferenceDto,
  ): Promise<InviteDecisionResponseDto> {
    return this.decision(
      await this.repository.declineInvite(
        actor.userId,
        this.lookup(input),
        new Date(),
      ),
    );
  }

  async decideInvite(
    actor: AuthPrincipal,
    inviteId: string,
    approve: boolean,
  ): Promise<InviteDecisionResponseDto> {
    return this.decision(
      await this.repository.decideInvite({
        userId: actor.userId,
        inviteId,
        approve,
        now: new Date(),
        identityHash: this.identityHash,
      }),
    );
  }

  async bootstrap(
    actor: AuthPrincipal,
    familyId: string,
  ): Promise<FamilyBootstrapResponseDto> {
    const state = await this.repository.findBootstrap(actor.userId, familyId);
    if (!state) throw new NotFoundError('Family was not found.');
    const entitlement = await this.billing.get(actor, familyId);
    const response = FamilyBootstrapResponseDto.fromModel(state, entitlement);
    await Promise.all([
      ...response.parents.map(async (parent) => {
        const image = await this.profileImages.userAvatar(parent.userId);
        Object.assign(parent, {
          avatarUrl: image.avatarUrl,
          avatarUrlExpiresAt: image.avatarUrlExpiresAt?.toISOString() ?? null,
        });
      }),
      ...response.subjects.map(async (subject) => {
        const images =
          subject.type === 'CHILD'
            ? await this.profileImages.childImages(actor, familyId, subject.id)
            : null;
        Object.assign(subject, {
          avatarUrl: images?.avatarUrl ?? null,
          avatarUrlExpiresAt: images?.avatarUrlExpiresAt?.toISOString() ?? null,
          coverUrl: images?.coverUrl ?? null,
          coverUrlExpiresAt: images?.coverUrlExpiresAt?.toISOString() ?? null,
        });
      }),
    ]);
    // `me` is a separate DTO instance from the parents projection.
    const me = response.parents.find(
      (parent) => parent.userId === actor.userId,
    )!;
    response.me.avatarUrl = me.avatarUrl;
    response.me.avatarUrlExpiresAt = me.avatarUrlExpiresAt;
    return response;
  }

  private readonly identityHash = (provider: string, providerUid: string) =>
    this.tokens.keyedHash('identity', `${provider}:${providerUid}`);

  private lookup(input: InviteReferenceDto): InviteLookup {
    if (input.token)
      return { tokenHash: this.tokens.hashInviteToken(input.token) };
    const code = (input.code ?? '').toUpperCase().replace(/[\s-]/g, '');
    if (code.length !== CODE_LENGTH)
      throw new ValidationError('Invite code must have 8 characters.');
    return { codeHash: this.tokens.keyedHash('invite-code', code) };
  }

  private newCode(): string {
    let code = '';
    for (let index = 0; index < CODE_LENGTH; index += 1)
      code += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
    return code;
  }

  private decision(result: InviteDecisionResult): InviteDecisionResponseDto {
    switch (result.kind) {
      case 'JOINED':
        return Object.assign(new InviteDecisionResponseDto(), {
          status: 'JOINED',
          familyId: result.familyId,
          trialEndsAt: result.trialEndsAt?.toISOString() ?? null,
        });
      case 'AWAITING_APPROVAL':
      case 'DECLINED':
        return Object.assign(new InviteDecisionResponseDto(), {
          status: result.kind,
          familyId: result.familyId,
          trialEndsAt: null,
        });
      case 'NOT_FOUND':
        throw new NotFoundError('Invite was not found.');
      case 'EXPIRED':
        throw new DomainError('The invite has expired.', 'INVITE_EXPIRED', 410);
      case 'ALREADY_USED':
        throw new DomainError(
          'The invite was already used.',
          'INVITE_ALREADY_USED',
          409,
        );
      case 'SELF_INVITE':
        throw new DomainError(
          'You cannot accept your own invite.',
          'INVITE_SELF',
          422,
        );
      case 'NOT_SUPPORTED':
        throw new DomainError(
          'Relative invites are not available yet.',
          'INVITE_TYPE_NOT_SUPPORTED',
          422,
        );
      case 'SLOTS_FULL':
        throw new DomainError(
          'This family already has both Parents.',
          'PARENT_SLOTS_FULL',
          409,
        );
      case 'ALREADY_PARENT':
        throw new DomainError(
          'You already belong to another family.',
          'ALREADY_PARENT_OF_ANOTHER_FAMILY',
          409,
        );
    }
  }
}

function isUniqueViolation(error: unknown): boolean {
  return (
    typeof error === 'object' &&
    error !== null &&
    'code' in error &&
    error.code === 'P2002'
  );
}
