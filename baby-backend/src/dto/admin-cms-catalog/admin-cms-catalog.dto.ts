import { Type } from 'class-transformer';
import { IsInt, IsOptional, Max, Min } from 'class-validator';
export const ADMIN_CMS_CATALOG_KINDS = [
  'missions',
  'milestones',
  'notification-templates',
  'plan-versions',
  'trial-policies',
] as const;
export type AdminCmsCatalogKind = (typeof ADMIN_CMS_CATALOG_KINDS)[number];
export class AdminCmsCatalogQueryDto {
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) offset?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(100) limit?: number;
}
