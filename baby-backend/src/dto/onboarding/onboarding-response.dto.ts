import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { FamilyBillingResponseDto } from '../billing/family-billing-response.dto';
import type { FamilyInvite } from '../../models/family-invite.model';
import type {
  FamilyBootstrapState,
  InvitePreview,
} from '../../models/onboarding-state.model';

const iso = (value: Date | null) => (value ? value.toISOString() : null);
const day = (value: Date | null) =>
  value ? value.toISOString().slice(0, 10) : null;

/** Returned once at creation: the plain token/code are never stored or shown again. */
export class CreatedPartnerInviteResponseDto {
  @ApiProperty({ format: 'uuid' }) inviteId!: string;
  @ApiProperty() url!: string;
  @ApiProperty({ example: 'K7Q29MXA' }) code!: string;
  @ApiProperty() qrPayload!: string;
  @ApiProperty({ format: 'date-time' }) expiresAt!: string;
}

export class PartnerInviteStatusResponseDto {
  @ApiProperty({ format: 'uuid' }) inviteId!: string;
  @ApiProperty({
    enum: [
      'PENDING',
      'AWAITING_APPROVAL',
      'ACCEPTED',
      'DECLINED',
      'REVOKED',
      'EXPIRED',
    ],
  })
  status!: string;
  @ApiProperty({ enum: ['FATHER', 'MOTHER'], nullable: true })
  kind!: string | null;
  @ApiProperty() requireFinalApproval!: boolean;
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ format: 'date-time' }) expiresAt!: string;
  @ApiProperty({
    nullable: true,
    description: 'Call name chosen by the joiner.',
  })
  acceptedCallName!: string | null;

  static fromModel(
    invite: FamilyInvite,
    now: Date,
  ): PartnerInviteStatusResponseDto {
    const payload =
      invite.payload && typeof invite.payload === 'object'
        ? (invite.payload as Record<string, unknown>)
        : {};
    const expired =
      invite.status === 'PENDING' &&
      invite.expiresAt.getTime() <= now.getTime();
    return Object.assign(new PartnerInviteStatusResponseDto(), {
      inviteId: invite.id,
      status: expired ? 'EXPIRED' : invite.status,
      kind:
        payload.kind === 'FATHER' || payload.kind === 'MOTHER'
          ? payload.kind
          : null,
      requireFinalApproval: invite.requireFinalApproval,
      createdAt: invite.createdAt.toISOString(),
      expiresAt: invite.expiresAt.toISOString(),
      acceptedCallName:
        typeof payload.acceptedCallName === 'string'
          ? payload.acceptedCallName
          : null,
    });
  }
}

export class InvitePreviewResponseDto {
  @ApiProperty({ format: 'uuid' }) inviteId!: string;
  @ApiProperty({ enum: ['PARTNER', 'CIRCLE'] }) type!: string;
  @ApiProperty({ enum: ['VALID', 'EXPIRED', 'USED'] }) state!: string;
  @ApiProperty() familyName!: string;
  @ApiProperty({ nullable: true }) inviterCallName!: string | null;
  @ApiProperty({ enum: ['FATHER', 'MOTHER'], nullable: true })
  inviterKind!: string | null;
  @ApiProperty({ enum: ['FATHER', 'MOTHER'], nullable: true })
  proposedKind!: string | null;
  @ApiProperty({ nullable: true }) message!: string | null;
  @ApiProperty({ format: 'date-time' }) expiresAt!: string;
  /**
   * §7.3 bước 4: lời mời bạn đời mới của gia đình `PARTNER_LEFT` hiện tên các
   * bé (gia đình đang chờ bạn đời lần đầu chưa có bé → không có trường này).
   */
  @ApiPropertyOptional({ type: Object, isArray: true })
  children?: { id: string; name: string }[];

  static fromModel(model: InvitePreview, now: Date): InvitePreviewResponseDto {
    const state = model.isExpiredAt(now)
      ? 'EXPIRED'
      : model.status === 'PENDING'
        ? 'VALID'
        : 'USED';
    return Object.assign(new InvitePreviewResponseDto(), {
      inviteId: model.inviteId,
      type: model.type,
      state,
      familyName: model.familyName,
      inviterCallName: model.inviterCallName,
      inviterKind: model.inviterKind,
      proposedKind: model.proposedKind,
      message: model.message,
      expiresAt: model.expiresAt.toISOString(),
    });
  }
}

export class InviteDecisionResponseDto {
  @ApiProperty({ enum: ['JOINED', 'AWAITING_APPROVAL', 'DECLINED'] })
  status!: string;
  @ApiProperty({ format: 'uuid' }) familyId!: string;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  trialEndsAt!: string | null;
}

export class BootstrapParentDto {
  @ApiProperty({ format: 'uuid' }) userId!: string;
  @ApiProperty({ enum: ['A', 'B'] }) slot!: string;
  @ApiProperty({ enum: ['FATHER', 'MOTHER'] }) kind!: string;
  @ApiProperty() callName!: string;
  @ApiProperty() displayName!: string;
  @ApiProperty({ type: String, nullable: true }) avatarUrl!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  avatarUrlExpiresAt!: string | null;
}

export class BootstrapSubjectDto {
  @ApiProperty({ type: String, nullable: true }) avatarUrl!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  avatarUrlExpiresAt!: string | null;
  @ApiProperty({ type: String, nullable: true }) coverUrl!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  coverUrlExpiresAt!: string | null;
  @ApiProperty({ enum: ['CHILD', 'PREGNANCY'] }) type!: string;
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() displayName!: string;
  @ApiProperty({ type: String, nullable: true }) name!: string | null;
  @ApiProperty({ type: String, nullable: true }) nickname!: string | null;
  @ApiProperty({ type: String, format: 'date', nullable: true })
  birthDate!: string | null;
  @ApiProperty({ type: String, format: 'date', nullable: true })
  dueDate!: string | null;
  @ApiProperty({ type: Number, nullable: true }) colorIndex!: number | null;
  @ApiProperty({ type: String, nullable: true }) gender!: string | null;
  @ApiProperty({ type: Number, nullable: true }) expectedCount!: number | null;
  @ApiProperty({ type: Number, nullable: true }) seqNo!: number | null;
  @ApiProperty() status!: string;
}

export class BootstrapFamilyDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() name!: string;
  @ApiProperty({
    enum: ['WAITING_PARTNER', 'ACTIVE', 'PARTNER_LEFT', 'DELETION_SCHEDULED'],
  })
  status!: string;
  @ApiProperty() timezone!: string;
  @ApiProperty({ type: Object }) settings!: unknown;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  activatedAt!: string | null;
}

/** `GET /families/{fid}/bootstrap` (spec §11.4) for a Parent; no Hearts, no unread yet. */
export class FamilyBootstrapResponseDto {
  @ApiProperty({ type: BootstrapFamilyDto }) family!: BootstrapFamilyDto;
  @ApiProperty({ type: BootstrapParentDto }) me!: BootstrapParentDto;
  @ApiProperty({ type: [BootstrapParentDto] }) parents!: BootstrapParentDto[];
  @ApiProperty() coupleLinked!: boolean;
  @ApiProperty({ type: [BootstrapSubjectDto] })
  subjects!: BootstrapSubjectDto[];
  @ApiProperty({ type: FamilyBillingResponseDto })
  entitlement!: FamilyBillingResponseDto;
  @ApiProperty() accessVersion!: number;

  static fromModel(
    model: FamilyBootstrapState,
    entitlement: FamilyBillingResponseDto,
  ): FamilyBootstrapResponseDto {
    const parent = (value: FamilyBootstrapState['me']) =>
      Object.assign(new BootstrapParentDto(), value);
    return Object.assign(new FamilyBootstrapResponseDto(), {
      family: Object.assign(new BootstrapFamilyDto(), {
        id: model.familyId,
        name: model.name,
        status: model.status,
        timezone: model.timezone,
        settings: model.settings,
        activatedAt: iso(model.activatedAt),
      }),
      me: parent(model.me),
      parents: model.parents.map(parent),
      coupleLinked: model.coupleLinked,
      subjects: model.subjects.map((subject) =>
        Object.assign(new BootstrapSubjectDto(), {
          ...subject,
          birthDate: day(subject.birthDate),
          dueDate: day(subject.dueDate),
        }),
      ),
      entitlement,
      accessVersion: model.accessVersion,
    });
  }
}
