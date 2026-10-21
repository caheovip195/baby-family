import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsUUID, MaxLength, ValidateIf } from 'class-validator';

export class MemoryPersonInputDto {
  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf((_object, value) => value !== undefined)
  @IsUUID()
  memberId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @ValidateIf((_object, value) => value !== undefined)
  @IsUUID()
  userId?: string;

  @ApiPropertyOptional({ maxLength: 40 })
  @ValidateIf((_object, value) => value !== undefined)
  @IsString()
  @MaxLength(40)
  displayName?: string;
}

export class MemoryPersonResponseDto {
  @ApiProperty({ type: String, nullable: true, format: 'uuid' })
  memberId!: string | null;
  @ApiProperty({ type: String, nullable: true, format: 'uuid' })
  userId!: string | null;
  @ApiProperty()
  displayName!: string;
}

export class PeopleSuggestionsResponseDto {
  @ApiProperty({ type: [MemoryPersonResponseDto] })
  items!: MemoryPersonResponseDto[];
}
