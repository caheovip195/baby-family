import { Type } from 'class-transformer';
import { IsInt, IsOptional, Matches, Max, Min } from 'class-validator';
export class WeeklyRecapQueryDto {
  @IsOptional() @Matches(/^\d{4}-\d{2}-\d{2}$/) cursor?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(50) limit = 20;
}
import type { WeeklyContent } from '../../models/weekly-recap-data.model';
export type {
  WeekStats,
  WeeklyContent,
} from '../../models/weekly-recap-data.model';
export interface WeeklyRecapResponse {
  id: string;
  periodStart: string;
  periodEnd: string;
  visibility: string;
  content: WeeklyContent;
  contentParentsOnly?: { version: number; appreciationCount: number };
  coverAssetId: string | null;
}
