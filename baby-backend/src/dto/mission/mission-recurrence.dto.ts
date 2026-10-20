import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsIn,
  IsString,
  IsUUID,
  Matches,
  MaxLength,
  MinLength,
  ValidateIf,
} from 'class-validator';
import { MissionCategory } from '../../common/database.enums';
import { WEEKDAYS } from '../../models/mission-recurrence.model';
import type { Weekday } from '../../models/mission-recurrence.model';

const optional = (_object: object, value: unknown) => value !== undefined;
const DATE = /^\d{4}-\d{2}-\d{2}$/;

/** `POST /families/:fid/mission-series` — a custom repeating mission. */
export class CreateMissionSeriesDto {
  @ApiProperty({ maxLength: 120 })
  @IsString()
  @MinLength(1)
  @MaxLength(120)
  title!: string;

  @ApiPropertyOptional({ maxLength: 500 })
  @ValidateIf(optional)
  @IsString()
  @MaxLength(500)
  note?: string;

  /** ME (only me) or TOGETHER; never the partner alone (BR-020). */
  @ApiProperty({ enum: ['ME', 'TOGETHER'] })
  @IsIn(['ME', 'TOGETHER'])
  owner!: 'ME' | 'TOGETHER';

  @ApiPropertyOptional({ enum: Object.values(MissionCategory) })
  @ValidateIf(optional)
  @IsIn(Object.values(MissionCategory))
  category?: MissionCategory;

  @ApiPropertyOptional({ type: [String] })
  @ValidateIf(optional)
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(10)
  @IsUUID('all', { each: true })
  childIds?: string[];

  /** Local time `HH:mm`. */
  @ApiPropertyOptional({ example: '19:30' })
  @ValidateIf(optional)
  @Matches(/^(?:[01]\d|2[0-3]):[0-5]\d$/)
  scheduledTime?: string;

  @ApiProperty({ example: '2026-10-20' })
  @Matches(DATE)
  startDate!: string;

  @ApiPropertyOptional({ example: '2026-12-31' })
  @ValidateIf(optional)
  @Matches(DATE)
  endDate?: string;

  /** Weekdays (`MO`…`SU`); empty = every day. */
  @ApiPropertyOptional({ enum: WEEKDAYS, isArray: true })
  @ValidateIf(optional)
  @IsArray()
  @ArrayUnique()
  @IsIn(WEEKDAYS, { each: true })
  days?: Weekday[];
}

/** `POST /mission-series/:id/pause` — skip these local dates (inclusive). */
export class PauseMissionSeriesDto {
  @ApiProperty({ example: '2026-10-25' })
  @Matches(DATE)
  from!: string;

  @ApiProperty({ example: '2026-10-27' })
  @Matches(DATE)
  to!: string;
}

export interface MissionSeriesResponseDto {
  id: string;
  title: string;
  note: string | null;
  ownerKind: 'PARENT' | 'TOGETHER';
  mine: boolean;
  category: string;
  childIds: string[];
  scheduledTime: string | null;
  startDate: string;
  endDate: string | null;
  days: Weekday[];
  pausedRanges: { from: string; to: string }[];
  status: string;
  version: number;
}
