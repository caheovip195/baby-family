import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayNotEmpty,
  ArrayUnique,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsUUID,
  Max,
  Min,
} from 'class-validator';
import type { DatabaseJsonValue } from '../../common/database.types';

export class NotificationListQueryDto {
  @IsOptional()
  @IsIn(['FAMILY', 'US'])
  tab?: 'FAMILY' | 'US';

  @IsOptional()
  @IsUUID()
  cursor?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}

export class NotificationReadDto {
  @IsOptional()
  @IsArray()
  @ArrayNotEmpty()
  @ArrayMaxSize(100)
  @ArrayUnique()
  @IsUUID('all', { each: true })
  ids?: string[];

  @IsOptional()
  @IsBoolean()
  all?: boolean;
}

export interface NotificationInboxViewDto {
  id: string;
  tab: 'FAMILY' | 'US';
  category: string;
  templateCode: string;
  /** Localized server template text; absent when optional renderer is not registered. */
  title?: string | null;
  body?: string | null;
  locale?: 'vi' | 'en';
  params: DatabaseJsonValue;
  createdAt: string;
  readAt: string | null;
  deepLink: string;
}

export interface NotificationListResponseDto {
  items: NotificationInboxViewDto[];
  nextCursor: string | null;
}
