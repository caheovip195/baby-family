import { Type } from 'class-transformer';
import {
  IsInt,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
import { MILESTONE_POLICY } from '../../config/milestone-policy';
const optional = (_object: object, value: unknown) => value !== undefined;
export class MilestoneCatalogQueryDto {
  @ValidateIf(optional) @IsUUID() childId?: string;
  @ValidateIf(optional) @IsUUID() pregnancyId?: string;
}
export class MilestoneListQueryDto {
  @ValidateIf(optional) @IsString() @MaxLength(500) cursor?: string;
  @ValidateIf(optional)
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(MILESTONE_POLICY.maxLimit)
  limit?: number;
}
