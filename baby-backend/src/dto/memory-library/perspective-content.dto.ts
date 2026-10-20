import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsString,
  IsUUID,
  MaxLength,
  ValidateIf,
} from 'class-validator';

const nullable = (_: object, value: unknown) =>
  value !== undefined && value !== null;
export class PutPerspectiveContentDto {
  @ApiPropertyOptional({ nullable: true, maxLength: 1000 })
  @ValidateIf(nullable)
  @IsString()
  @MaxLength(1000)
  body?: string | null;

  @ApiPropertyOptional({ nullable: true, format: 'uuid' })
  @ValidateIf(nullable)
  @IsUUID()
  audioAssetId?: string | null;

  @ApiPropertyOptional()
  @ValidateIf((_: object, value: unknown) => value !== undefined)
  @IsBoolean()
  hiddenFromCircle?: boolean;
}

export class PerspectiveContentResponseDto {
  @ApiProperty() id!: string;
  @ApiProperty() memoryId!: string;
  @ApiProperty() authorUserId!: string;
  @ApiProperty({ nullable: true, type: String }) body!: string | null;
  @ApiProperty({ nullable: true, type: String }) audioAssetId!: string | null;
  @ApiProperty() hiddenFromCircle!: boolean;
  @ApiProperty() version!: number;
  @ApiProperty() createdAt!: string;
  @ApiProperty() updatedAt!: string;
}
