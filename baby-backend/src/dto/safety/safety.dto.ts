import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsIn,
  IsString,
  IsUUID,
  MaxLength,
  ValidateIf,
} from 'class-validator';
import { SAFETY_POLICY } from '../../config/safety-policy';
import type {
  ReportReasonCode,
  ReportTargetType,
} from '../../config/safety-policy';

const optional = (_object: object, value: unknown) => value !== undefined;

export class CreateReportDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  familyId!: string;

  @ApiProperty({ enum: SAFETY_POLICY.reportTargets })
  @IsIn(SAFETY_POLICY.reportTargets)
  targetType!: ReportTargetType;

  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  targetId!: string;

  @ApiProperty({ enum: SAFETY_POLICY.reasons })
  @IsIn(SAFETY_POLICY.reasons)
  reason!: ReportReasonCode;

  @ApiPropertyOptional({ maxLength: SAFETY_POLICY.noteMaxLength })
  @ValidateIf(optional)
  @IsString()
  @MaxLength(SAFETY_POLICY.noteMaxLength)
  note?: string;

  @ApiPropertyOptional({ description: 'Hide the memory/comment for me now.' })
  @ValidateIf(optional)
  @IsBoolean()
  hideForMe?: boolean;
}

export class ReportResponseDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  /** Short reference shown to the reporter (RPT-01b). */
  @ApiProperty({ example: 'BC-261019-3F2A' }) code!: string;
  @ApiProperty() status!: string;
  @ApiProperty() createdAt!: string;
}

export class CreateBlockDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  familyId!: string;

  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  userId!: string;
}

export class FamilyScopeQueryDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  familyId!: string;
}

export class BlockedUserDto {
  @ApiProperty({ format: 'uuid' }) userId!: string;
  @ApiProperty() displayName!: string;
  @ApiProperty() blockedAt!: string;
}

export class BlockListResponseDto {
  @ApiProperty({ type: BlockedUserDto, isArray: true })
  items!: BlockedUserDto[];
}
