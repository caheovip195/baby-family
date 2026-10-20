import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  ArrayUnique,
  IsArray,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
  ValidateIf,
} from 'class-validator';
import type { MemoryResponseDto } from '../memory/memory-response.dto';

export class CreateAlbumDto {
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() : value,
  )
  @IsString()
  @Length(1, 60)
  name!: string;
}
export class UpdateAlbumDto {
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim() : value,
  )
  @IsString()
  @Length(1, 60)
  name?: string;

  @ValidateIf(
    (_object, value: unknown) => value !== undefined && value !== null,
  )
  @IsUUID()
  coverMemoryId?: string | null;
}
export class AddAlbumMemoriesDto {
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(100)
  @ArrayUnique()
  @IsUUID(undefined, { each: true })
  memoryIds!: string[];
}
export class AlbumMemoriesQueryDto {
  @IsOptional()
  @IsUUID()
  cursor?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}
export interface AlbumCollectionResponseDto {
  id: string;
  familyId: string;
  ownerUserId: string;
  name: string;
  isSensitive: boolean;
  coverMemoryId: string | null;
  cover: MemoryResponseDto | null;
  memoryCount: number;
  createdAt: string;
}
