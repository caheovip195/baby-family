import { ApiProperty } from '@nestjs/swagger';
import {
  ArrayUnique,
  IsArray,
  IsString,
  IsUUID,
  MaxLength,
  ValidateIf,
} from 'class-validator';
import { ChildResponseDto } from './child-response.dto';
import type { Child } from '../../models/child.model';
export class ChildProfileOrderDto {
  @ApiProperty({ type: [String] })
  @IsArray()
  @ArrayUnique()
  @IsUUID('all', { each: true })
  childIds!: string[];
}
export class ChildProfileDeleteDto {
  @ApiProperty() @IsString() @MaxLength(60) confirmName!: string;
}
export class ChildProfileAssetDto {
  @ApiProperty({ type: String, nullable: true })
  @ValidateIf((_object, value: unknown) => value !== null)
  @IsUUID()
  assetId!: string | null;
}
export class ChildProfileStatsDto {
  @ApiProperty() memoryCount!: number;
  @ApiProperty() milestoneCount!: number;
  @ApiProperty({ type: String, nullable: true }) firstMemoryAt!: string | null;
  @ApiProperty() photoCount!: number;
}
export class ChildProfileResponseDto extends ChildResponseDto {
  @ApiProperty({ type: String, nullable: true }) avatarAssetId!: string | null;
  @ApiProperty({ type: String, nullable: true }) coverAssetId!: string | null;
  @ApiProperty() sortOrder!: number;
  static override fromModel(child: Child): ChildProfileResponseDto {
    return Object.assign(
      new ChildProfileResponseDto(),
      ChildResponseDto.fromModel(child),
      {
        avatarAssetId: child.avatarAssetId,
        coverAssetId: child.coverAssetId,
        sortOrder: child.sortOrder,
      },
    );
  }
}
