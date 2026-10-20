import {
  IsBoolean,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';
import { COUPLE_APPRECIATION_POLICY } from '../../config/couple-appreciation-policy';

export class CreateAppreciationDto {
  @IsOptional()
  @IsString()
  @MaxLength(COUPLE_APPRECIATION_POLICY.maxBodyLength)
  body?: string;

  @IsOptional()
  @IsString()
  @MaxLength(40)
  sticker?: string;

  @IsOptional()
  @IsIn(COUPLE_APPRECIATION_POLICY.allowedLinkedTypes)
  linkedType?: 'MISSION' | 'REQUEST' | 'MEMORY';

  @IsOptional()
  @IsUUID()
  linkedId?: string;

  @IsOptional()
  @IsBoolean()
  quick?: boolean;
}

export class AppreciationListQueryDto {
  @IsOptional()
  @IsUUID()
  cursor?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(COUPLE_APPRECIATION_POLICY.maxLimit)
  @Type(() => Number)
  limit?: number;

  @IsOptional()
  @IsString()
  @Matches(/^\d{4}-(0[1-9]|1[0-2])$/, {
    message: 'month must be formatted as YYYY-MM',
  })
  month?: string;
}

export class ReactAppreciationDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  reaction!: string;
}

export class ShareRespondAppreciationDto {
  @IsBoolean()
  approve!: boolean;
}

export interface AppreciationViewDto {
  id: string;
  fromUserId: string;
  toUserId: string;
  body: string;
  sticker: string | null;
  linkedType: string | null;
  linkedId: string | null;
  familyShareStatus: string;
  familyMemoryId: string | null;
  seenAt: string | null;
  reaction: string | null;
  createdAt: string;
  isMine: boolean;
}

export interface AppreciationWallDto {
  items: AppreciationViewDto[];
  nextCursor: string | null;
}
