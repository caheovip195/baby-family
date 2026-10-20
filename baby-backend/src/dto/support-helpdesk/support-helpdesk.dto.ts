import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';
import { SUPPORT_HELPDESK_POLICY as P } from '../../config/support-helpdesk-policy';
const trim = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim() : value;
export class CreateSupportHelpdeskDto {
  @IsString() @MinLength(1) @MaxLength(40) category!: string;
  @Transform(trim)
  @IsString()
  @MinLength(1)
  @MaxLength(P.subjectMax)
  subject!: string;
  @Transform(trim)
  @IsString()
  @MinLength(1)
  @MaxLength(P.bodyMax)
  body!: string;
  @IsOptional() @IsUUID() familyId?: string;
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(P.attachmentsMax)
  @ArrayUnique()
  @IsUUID('all', { each: true })
  attachmentAssetIds?: string[];
}
export class SupportHelpdeskMessageDto {
  @Transform(trim)
  @IsString()
  @MinLength(1)
  @MaxLength(P.bodyMax)
  body!: string;
}
export class SupportHelpdeskQueryDto {
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) offset?: number;
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(P.pageSize)
  limit?: number;
}
export interface SupportHelpdeskReceipt {
  id: string;
  code: string;
  status: string;
  createdAt: string;
}
export interface SupportHelpdeskDetail extends SupportHelpdeskReceipt {
  category: string;
  categoryVersion: number;
  subject: string;
  body: string;
  familyId: string | null;
  attachmentAssetIds: string[];
  messages: {
    id: string;
    sender: 'USER' | 'SUPPORT';
    body: string;
    createdAt: string;
  }[];
}
