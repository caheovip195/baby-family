import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayUnique,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  Matches,
  Max,
  Min,
  ValidateIf,
} from 'class-validator';
import { MissionCategory } from '../../common/database.enums';

const optional = (_object: object, value: unknown) => value !== undefined;
const nullable = (_object: object, value: unknown) =>
  value !== undefined && value !== null;

/** CARE-12 family part (Parent): how full the daily board is. */
export class UpdateMissionFamilySettingsDto {
  @ApiPropertyOptional({ enum: ['LIGHT', 'MEDIUM', 'HEAVY'] })
  @ValidateIf(optional)
  @IsIn(['LIGHT', 'MEDIUM', 'HEAVY'])
  boardLevel?: 'LIGHT' | 'MEDIUM' | 'HEAVY';
}

/** CARE-12 personal part: only the caller's own preferences. */
export class UpdateMissionPreferencesDto {
  @ApiPropertyOptional({ enum: Object.values(MissionCategory), isArray: true })
  @ValidateIf(optional)
  @IsArray()
  @ArrayUnique()
  @IsIn(Object.values(MissionCategory), { each: true })
  disabledCategories?: (keyof typeof MissionCategory)[];

  /** Local `HH:mm` of the morning board notification. */
  @ApiPropertyOptional({ example: '07:00' })
  @ValidateIf(optional)
  @Matches(/^(?:[01]\d|2[0-3]):[0-5]\d$/)
  boardPushTime?: string;

  /** “Hỏi lúc tối”: offer to carry unfinished missions over. */
  @ApiPropertyOptional()
  @ValidateIf(optional)
  @IsBoolean()
  eveningCarryOver?: boolean;

  @ApiPropertyOptional({ nullable: true, minimum: 0, maximum: 1440 })
  @ValidateIf(nullable)
  @IsInt()
  @Min(0)
  @Max(1440)
  defaultReminderMin?: number | null;
}

export interface MissionSettingsResponseDto {
  boardLevel: 'LIGHT' | 'MEDIUM' | 'HEAVY';
  preferences: {
    disabledCategories: string[];
    boardPushTime: string;
    eveningCarryOver: boolean;
    defaultReminderMin: number | null;
  };
}
