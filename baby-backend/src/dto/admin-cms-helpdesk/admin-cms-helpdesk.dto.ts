import { Transform, Type } from 'class-transformer';
import { SUPPORT_HELPDESK_POLICY } from '../../config/support-helpdesk-policy';
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
export const ADMIN_TICKET_STATUSES = [
  'OPEN',
  'IN_PROGRESS',
  'WAITING_USER',
  'RESOLVED',
  'CLOSED',
] as const;
export class AdminCmsHelpdeskQueryDto {
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) offset?: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(50) limit?: number;
  @IsOptional() @IsIn(ADMIN_TICKET_STATUSES) status?: string;
}
export class AdminCmsHelpdeskReasonDto {
  @IsString() @Matches(/^[A-Z][A-Z0-9_]{2,79}$/) reasonCode!: string;
}
export class AdminCmsHelpdeskReplyDto extends AdminCmsHelpdeskReasonDto {
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() : value,
  )
  @IsString()
  @MinLength(1)
  @MaxLength(SUPPORT_HELPDESK_POLICY.bodyMax)
  body!: string;
}
export class AdminCmsHelpdeskStatusDto extends AdminCmsHelpdeskReasonDto {
  @IsIn(ADMIN_TICKET_STATUSES) status!: string;
}
