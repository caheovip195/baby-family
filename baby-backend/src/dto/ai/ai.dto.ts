import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsIn,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  MaxLength,
  MinLength,
} from 'class-validator';
import { AI_FEATURES, AI_POLICY } from '../../config/ai-policy';

export class AiConsentDto {
  @ApiProperty({ enum: AI_FEATURES })
  @IsIn(AI_FEATURES)
  feature!: string;
}

export class AiCaptionDto {
  @ApiPropertyOptional({ description: 'Loại ký ức (photo, diary, …).' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  kind?: string;

  @ApiPropertyOptional({ description: 'Vài từ người dùng gõ.' })
  @IsOptional()
  @IsString()
  @MaxLength(AI_POLICY.captionHintMaxLength)
  hint?: string;
}

export class AiDayStoryDto {
  @ApiProperty({ format: 'uuid' }) @IsUUID() childId!: string;

  @ApiProperty({ example: '2026-10-28' })
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  date!: string;

  @ApiProperty({ type: [String], description: 'Ký ức người dùng tick chọn.' })
  @IsArray()
  @ArrayMaxSize(AI_POLICY.dayStoryMaxMemories)
  @IsUUID('all', { each: true })
  memoryIds!: string[];
}

export class AiMissionSuggestDto {
  @ApiPropertyOptional({
    format: 'uuid',
    description: 'Bé (lọc mẫu hợp tuổi).',
  })
  @IsOptional()
  @IsUUID()
  childId?: string;

  @ApiPropertyOptional({
    type: [String],
    description: 'Nhóm việc người dùng tắt (CARE, PLAY, …).',
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @IsString({ each: true })
  @MaxLength(20, { each: true })
  excludeCategories?: string[];
}

export class AiMissionPickDto {
  @ApiProperty({ format: 'uuid' }) templateId!: string;
  @ApiProperty() title!: string;
  @ApiProperty() category!: string;
  @ApiProperty() hearts!: number;
  @ApiProperty() durationMin!: number;
  @ApiProperty() reason!: string;
}

export class AiMissionResultDto {
  @ApiProperty({ format: 'uuid' }) invocationId!: string;
  @ApiProperty({ type: [AiMissionPickDto] }) missions!: AiMissionPickDto[];
}

export class AiRewriteDto {
  @ApiProperty()
  @IsString()
  @MinLength(1)
  @MaxLength(AI_POLICY.rewriteMaxLength)
  text!: string;
}

export class AiBridgeSummaryDto {
  @ApiProperty({ format: 'uuid' }) @IsUUID() sessionId!: string;
}

export class AiStatusDto {
  @ApiProperty() available!: boolean;
  @ApiProperty() used!: number;
  @ApiProperty() total!: number;
  @ApiProperty({ type: [String], description: 'Tính năng đã đồng ý.' })
  consented!: string[];
}

export class AiCaptionResultDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Lượt gọi (để báo cáo nội dung AI).',
  })
  invocationId!: string;
  @ApiProperty({ type: [String] }) suggestions!: string[];
}

export class AiStoryResultDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Lượt gọi (để báo cáo nội dung AI).',
  })
  invocationId!: string;
  @ApiProperty() story!: string;
}

export class AiRewriteResultDto {
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Lượt gọi (null khi nhánh an toàn, không gọi AI).',
  })
  invocationId!: string | null;
  @ApiProperty({
    description: 'Có dấu hiệu không an toàn: không gửi AI, mở màn hỗ trợ.',
  })
  safety!: boolean;
  @ApiProperty({ type: String, nullable: true }) neutral!: string | null;
  @ApiProperty({ type: String, nullable: true }) warm!: string | null;
  @ApiProperty({ type: String, nullable: true }) short!: string | null;
}

export class AiSummaryResultDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Lượt gọi (để báo cáo nội dung AI).',
  })
  invocationId!: string;
  @ApiProperty() summary!: string;
}
