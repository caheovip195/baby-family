import { Transform, Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  MinLength,
  Matches,
} from 'class-validator';
const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;
export class AdminCmsOperationsReasonDto {
  @Transform(trim) @IsString() @MinLength(1) @MaxLength(1000) reason!: string;
}
export class AdminCmsOperationsListDto {
  @IsOptional()
  @IsIn(['OPEN', 'IN_REVIEW', 'RESOLVED', 'ESCALATED'])
  status?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) offset?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(100) limit?: number;
}
export class AdminCmsOperationsStatusDto extends AdminCmsOperationsReasonDto {
  @IsIn(['IN_REVIEW', 'RESOLVED', 'ESCALATED']) status!: string;
}
export class AdminCmsOperationsActionDto extends AdminCmsOperationsReasonDto {
  @IsIn(['HIDE']) action!: 'HIDE';
}
export class AdminCmsOperationsBlockDto extends AdminCmsOperationsReasonDto {
  @IsString() @Matches(/^[A-Z][A-Z0-9_]{0,79}$/) reasonCode!: string;
}
