import { ApiProperty } from '@nestjs/swagger';
import type { AccessPhase } from '../../common/database.enums';
import { BillingPlanResponseDto } from './billing-catalog-response.dto';

export class FamilyBillingUsageResponseDto {
  @ApiProperty({ type: String }) storageBytes!: string;
  @ApiProperty({ type: String }) reservedStorageBytes!: string;
  @ApiProperty() memoryCount!: number;
  @ApiProperty() albumCount!: number;
  @ApiProperty() activeSeries!: number;
  @ApiProperty() letterCount!: number;
}

export class FamilyBillingResponseDto {
  @ApiProperty({ format: 'uuid' }) familyId!: string;
  @ApiProperty({ enum: ['INCOMPLETE', 'TRIAL', 'PAID', 'EXPIRED', 'BLOCKED'] })
  accessPhase!: AccessPhase;
  @ApiProperty() licenseBlocked!: boolean;
  @ApiProperty({ type: BillingPlanResponseDto, nullable: true })
  plan!: BillingPlanResponseDto | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  trialEndsAt!: Date | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  validUntil!: Date | null;
  @ApiProperty() inGrace!: boolean;
  @ApiProperty({ type: String, nullable: true }) entitlementVersion!:
    string | null;
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  computedAt!: Date | null;
  @ApiProperty({ type: FamilyBillingUsageResponseDto, nullable: true })
  usage!: FamilyBillingUsageResponseDto | null;
}
