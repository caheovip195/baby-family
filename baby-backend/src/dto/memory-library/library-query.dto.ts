import { Type } from 'class-transformer';
import {
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
export class LibraryQueryDto {
  @IsOptional() @IsString() @MaxLength(500) cursor?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(50) limit?: number;
}
export interface OriginalDownloadResponse {
  items: {
    assetId: string;
    kind: string;
    url: string;
    expiresAt: string;
    fileName: string;
  }[];
}
