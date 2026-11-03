import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsDateString,
  IsIn,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { BRIDGE_POLICY } from '../../config/bridge-policy';

/** Ý chọn chia sẻ — nháp riêng không bao giờ gửi lên server. */
export class BridgeShareInputDto {
  @ApiProperty({ type: [String], enum: BRIDGE_POLICY.feelings })
  @IsArray()
  @ArrayMaxSize(6)
  @IsIn(BRIDGE_POLICY.feelings, { each: true })
  feelings!: string[];

  @ApiProperty({ type: [String], enum: BRIDGE_POLICY.needs })
  @IsArray()
  @ArrayMaxSize(6)
  @IsIn(BRIDGE_POLICY.needs, { each: true })
  needs!: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(BRIDGE_POLICY.topicMaxLength)
  topic?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(BRIDGE_POLICY.messageMaxLength)
  message?: string;
}

/** `POST /families/:familyId/us/bridges` (Idempotency-Key). */
export class CreateBridgeDto extends BridgeShareInputDto {
  @ApiPropertyOptional({ enum: BRIDGE_POLICY.retentionDays })
  @IsOptional()
  @IsIn(BRIDGE_POLICY.retentionDays)
  retentionDays?: number;
}

export class ClarifyBridgeDto {
  @ApiProperty()
  @IsString()
  @MaxLength(BRIDGE_POLICY.messageMaxLength)
  message!: string;
}

export class BridgeNextStepInputDto {
  @ApiProperty({ enum: BRIDGE_POLICY.nextSteps })
  @IsIn(BRIDGE_POLICY.nextSteps)
  code!: string;

  @ApiPropertyOptional({ description: 'Tự nhập / mốc thời gian dạng chữ.' })
  @IsOptional()
  @IsString()
  @MaxLength(BRIDGE_POLICY.nextStepTextMaxLength)
  text?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  at?: string;
}

export class BridgeShareDto {
  @ApiProperty({ format: 'uuid' }) userId!: string;
  @ApiProperty({ type: [String] }) feelings!: string[];
  @ApiProperty({ type: [String] }) needs!: string[];
  @ApiProperty({ type: String, nullable: true }) topic!: string | null;
  @ApiProperty({ type: String, nullable: true }) message!: string | null;
  @ApiProperty() understood!: boolean;
}

export class BridgeNextStepDto {
  @ApiProperty() code!: string;
  @ApiProperty({ type: String, nullable: true }) text!: string | null;
  @ApiProperty({ type: String, nullable: true }) at!: string | null;
  @ApiProperty({ type: [String] }) agreedUserIds!: string[];
}

export class BridgeSessionDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({
    enum: ['INVITED', 'ACTIVE', 'PAUSED', 'NEXT_STEP', 'CLOSED', 'EXPIRED'],
  })
  status!: string;
  @ApiProperty({ format: 'uuid' }) initiatorUserId!: string;
  @ApiProperty({ type: String, nullable: true }) startedAt!: string | null;
  @ApiProperty({ type: String, nullable: true }) closedAt!: string | null;
  @ApiProperty() retentionDays!: number;
  @ApiProperty({ description: 'Nội dung đã tự xoá theo thời hạn lưu.' })
  contentPurged!: boolean;
  @ApiProperty({ type: [BridgeShareDto] }) shares!: BridgeShareDto[];
  @ApiProperty({ type: BridgeNextStepDto, nullable: true })
  nextStep!: BridgeNextStepDto | null;
  @ApiProperty({ type: [String] }) closeAgreedUserIds!: string[];
  @ApiProperty() createdAt!: string;
}
