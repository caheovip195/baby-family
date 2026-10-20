import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export class HeartsMeQueryDto {
  @IsOptional()
  @IsString()
  cursor?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}

export interface HeartHistoryItemDto {
  at: string;
  amount: number;
  reason: string;
  title: string | null;
}

export interface HeartsMeResponseDto {
  today: number;
  week: number;
  total: number;
  dailyCap: number;
  history: HeartHistoryItemDto[];
  nextCursor: string | null;
}
