import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsBoolean,
  IsDefined,
  IsIn,
  IsInt,
  IsObject,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { COUPLE_POLICY } from '../../config/couple-policy';
import type {
  CoupleMood,
  CoupleNeed,
  CoupleResponseType,
  CoupleSharedField,
} from '../../config/couple-policy';
const optional = (_object: object, value: unknown) => value !== undefined;
export class CheckinShareDto {
  @IsBoolean()
  enabled!: boolean;
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(COUPLE_POLICY.sharedFields.length)
  @IsIn(COUPLE_POLICY.sharedFields, { each: true })
  fields!: CoupleSharedField[];
}
export class CreateCheckinDto {
  @IsIn(COUPLE_POLICY.moods)
  mood!: CoupleMood;
  @ValidateIf(optional)
  @IsInt()
  @Min(1)
  @Max(5)
  energy?: number;
  @ValidateIf(optional)
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(COUPLE_POLICY.needs.length)
  @IsIn(COUPLE_POLICY.needs, { each: true })
  needs?: CoupleNeed[];
  @ValidateIf(optional)
  @IsString()
  @MaxLength(COUPLE_POLICY.noteMaxLength)
  note?: string;
  @IsDefined()
  @IsObject()
  @ValidateNested()
  @Type(() => CheckinShareDto)
  share!: CheckinShareDto;
}
export class CheckinHistoryQueryDto {
  @ValidateIf(optional)
  @IsUUID()
  cursor?: string;
  @ValidateIf(optional)
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(COUPLE_POLICY.historyMaxLimit)
  limit?: number;
}
export class CreateCheckinResponseDto {
  @IsIn(COUPLE_POLICY.responseTypes)
  type!: CoupleResponseType;
}
export interface CheckinViewDto {
  id: string;
  createdAt: string;
  expiresAt: string;
  mood?: CoupleMood;
  energy?: number | null;
  needs?: CoupleNeed[];
  note?: string | null;
  shared?: boolean;
  sharedFields?: string[];
}
export interface CheckinHistoryDto {
  items: CheckinViewDto[];
  nextCursor: string | null;
}
export interface CheckinTodayDto {
  mine: CheckinViewDto | null;
  partner: CheckinViewDto | null;
}
export interface CheckinResponseDto {
  id: string;
  checkinId: string;
  type: string;
  createdAt: string;
}
