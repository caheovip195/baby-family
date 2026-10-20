import {
  IsArray,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { Type } from 'class-transformer';
import { Mood } from '../../common/database.enums';
import { COUPLE_JOURNAL_POLICY } from '../../config/couple-journal-policy';

export class CreateJournalEntryDto {
  @IsOptional()
  @IsString()
  @MaxLength(COUPLE_JOURNAL_POLICY.maxTitleLength)
  title?: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(COUPLE_JOURNAL_POLICY.maxBodyLength)
  body!: string;

  @IsOptional()
  @IsEnum(Mood)
  mood?: Mood;

  @IsOptional()
  @IsArray()
  @IsUUID('all', { each: true })
  assetIds?: string[];
}

export class UpdateJournalEntryDto {
  @IsOptional()
  @IsString()
  @MaxLength(COUPLE_JOURNAL_POLICY.maxTitleLength)
  title?: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  @MaxLength(COUPLE_JOURNAL_POLICY.maxBodyLength)
  body?: string;

  @IsOptional()
  @IsEnum(Mood)
  mood?: Mood;

  @IsOptional()
  @IsArray()
  @IsUUID('all', { each: true })
  assetIds?: string[];
}

export class JournalListQueryDto {
  @IsOptional()
  @IsUUID()
  cursor?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(COUPLE_JOURNAL_POLICY.maxLimit)
  @Type(() => Number)
  limit?: number;
}

export class ShareJournalExcerptDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(COUPLE_JOURNAL_POLICY.maxExcerptLength)
  excerpt!: string;
}

export interface JournalEntryViewDto {
  id: string;
  userId: string;
  title: string | null;
  body: string;
  mood: Mood | null;
  assetIds: string[];
  createdAt: string;
  updatedAt: string;
}

export interface JournalListDto {
  items: JournalEntryViewDto[];
  nextCursor: string | null;
}

export interface JournalShareResponseDto {
  id: string;
  entryId: string;
  excerpt: string;
  explicitlySharedAt: string;
}
