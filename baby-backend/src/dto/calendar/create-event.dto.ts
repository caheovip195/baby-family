import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';
import { CALENDAR_POLICY, type EventType } from '../../config/calendar-policy';

export class CreateEventReminderRuleDto {
  @IsUUID()
  recipientUserId!: string;

  @IsInt()
  @Min(0)
  @Max(10080)
  offsetMinutes!: number;

  @IsOptional()
  @IsBoolean()
  enabled?: boolean;
}

export class CreateEventParticipantDto {
  @IsUUID()
  userId!: string;

  @IsOptional()
  @IsIn(['INVITED', 'ACCEPTED', 'DECLINED'])
  response?: string;
}

export class CreateEventDto {
  @IsUUID()
  familyId!: string;

  @IsIn(CALENDAR_POLICY.allowedTypes)
  type!: EventType;

  @IsString()
  @MaxLength(CALENDAR_POLICY.maxTitleLength)
  title!: string;

  @IsOptional()
  @IsString()
  @MaxLength(CALENDAR_POLICY.maxNotesLength)
  notes?: string | null;

  @IsOptional()
  @IsBoolean()
  allDay?: boolean;

  @IsString()
  startAt!: string;

  @IsOptional()
  @IsString()
  endAt?: string | null;

  @IsOptional()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, {
    message: 'localStartDate must be in YYYY-MM-DD format',
  })
  localStartDate?: string;

  @IsOptional()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, {
    message: 'localEndDate must be in YYYY-MM-DD format',
  })
  localEndDate?: string | null;

  @IsOptional()
  @IsString()
  timezone?: string;

  @IsOptional()
  @IsBoolean()
  isLunar?: boolean;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(12)
  lunarMonth?: number | null;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(30)
  lunarDay?: number | null;

  @IsOptional()
  @IsBoolean()
  lunarLeap?: boolean | null;

  @IsOptional()
  @IsBoolean()
  repeatYearly?: boolean;

  @IsOptional()
  @IsBoolean()
  inviteCircle?: boolean;

  @IsOptional()
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(50)
  @IsUUID('all', { each: true })
  childIds?: string[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(20)
  @ValidateNested({ each: true })
  @Type(() => CreateEventParticipantDto)
  participants?: CreateEventParticipantDto[];

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(10)
  @ValidateNested({ each: true })
  @Type(() => CreateEventReminderRuleDto)
  reminderRules?: CreateEventReminderRuleDto[];
}
