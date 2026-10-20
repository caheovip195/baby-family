import { ApiProperty } from '@nestjs/swagger';
import type { AccountOverview } from '../../models/account-overview.model';

export class MeFamilyDto {
  @ApiProperty({ format: 'uuid' }) familyId!: string;
  @ApiProperty() name!: string;
  @ApiProperty({
    enum: ['WAITING_PARTNER', 'ACTIVE', 'PARTNER_LEFT', 'DELETION_SCHEDULED'],
  })
  status!: string;
  @ApiProperty({ enum: ['PARENT'] }) role!: 'PARENT';
  @ApiProperty({ enum: ['A', 'B'] }) slot!: string;
  @ApiProperty({ enum: ['FATHER', 'MOTHER'] }) kind!: string;
  @ApiProperty() callName!: string;
}

export class MeAwaitingApprovalDto {
  @ApiProperty({ format: 'uuid' }) inviteId!: string;
  @ApiProperty() familyName!: string;
  @ApiProperty({ enum: ['FATHER', 'MOTHER'], nullable: true })
  kind!: string | null;
}

/** `GET /me` (spec §11.3): profile + families + onboarding progress for SPL-01 routing. */
export class MeResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ type: String, nullable: true, format: 'uuid' })
  avatarAssetId!: string | null;
  @ApiProperty({ type: String, nullable: true }) avatarUrl!: string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  avatarUrlExpiresAt!: Date | null;
  @ApiProperty() displayName!: string;
  @ApiProperty() locale!: string;
  @ApiProperty() timezone!: string;
  @ApiProperty({
    enum: ['PARENT_FATHER', 'PARENT_MOTHER', 'CIRCLE'],
    nullable: true,
    description: 'null ⇒ the client must show ONB-03.',
  })
  onboardingRole!: string | null;
  @ApiProperty({ description: 'AUTH-04 done: the Terms consent is granted.' })
  profileCompleted!: boolean;
  @ApiProperty({ type: [MeFamilyDto] }) families!: MeFamilyDto[];
  @ApiProperty({ type: [MeAwaitingApprovalDto] })
  awaitingApproval!: MeAwaitingApprovalDto[];
  @ApiProperty({ format: 'date-time' }) createdAt!: string;
  @ApiProperty({ format: 'date-time' }) updatedAt!: string;

  static fromModel(model: AccountOverview): MeResponseDto {
    const user = model.user;
    return Object.assign(new MeResponseDto(), {
      id: user.id,
      avatarAssetId: user.avatarAssetId,
      avatarUrl: null,
      avatarUrlExpiresAt: null,
      displayName: user.displayName,
      locale: user.locale,
      timezone: user.timezone,
      onboardingRole: user.onboardingRole,
      profileCompleted: model.hasGranted('TERMS'),
      families: model.parentMemberships.map((membership) =>
        Object.assign(new MeFamilyDto(), {
          familyId: membership.familyId,
          name: membership.familyName,
          status: membership.familyStatus,
          role: 'PARENT' as const,
          slot: membership.slot,
          kind: membership.kind,
          callName: membership.callName,
        }),
      ),
      awaitingApproval: model.awaitingApproval.map((item) =>
        Object.assign(new MeAwaitingApprovalDto(), item),
      ),
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
    });
  }
}
