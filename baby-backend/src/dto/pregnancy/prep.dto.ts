import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsInt,
  IsString,
  Length,
  Max,
  Min,
  ValidateIf,
} from 'class-validator';
import type { PrepItem } from '../../models/prep-item.model';

export class CreatePregnancyPrepDto {
  @ApiProperty({ maxLength: 20 })
  @IsString()
  @Length(1, 20)
  groupCode!: string;

  @ApiProperty({ maxLength: 120 })
  @IsString()
  @Length(1, 120)
  title!: string;
}

export class UpdatePregnancyPrepDto {
  @ApiPropertyOptional({ maxLength: 120 })
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsString()
  @Length(1, 120)
  title?: string;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsBoolean()
  done?: boolean;

  @ApiPropertyOptional()
  @ValidateIf((_object, value: unknown) => value !== undefined)
  @IsInt()
  @Min(0)
  @Max(2147483647)
  sortOrder?: number;
}

export class PregnancyPrepItemDto {
  id!: string;
  pregnancyId!: string;
  groupCode!: string;
  title!: string;
  sortOrder!: number;
  done!: boolean;
  doneAt!: string | null;
  doneBy!: string | null;
  missionId!: string | null;

  static fromModel(item: PrepItem): PregnancyPrepItemDto {
    return {
      id: item.id,
      pregnancyId: item.pregnancyId,
      groupCode: item.groupCode,
      title: item.title,
      sortOrder: item.sortOrder,
      done: item.doneAt !== null,
      doneAt: item.doneAt?.toISOString() ?? null,
      doneBy: item.doneBy,
      missionId: item.missionId,
    };
  }
}

export interface PregnancyPrepGroupDto {
  groupCode: string;
  items: PregnancyPrepItemDto[];
}
