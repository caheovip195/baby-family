import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import type {
  Need,
  RequestDueKind,
  RequestKind,
  RequestStatus,
  RequestUrgency,
} from '../../common/database.enums';
import { COUPLE_REQUEST_POLICY } from '../../config/couple-request-policy';
export class CreateRequestDto {
  @IsIn(['TASK', 'NEED']) kind!: RequestKind;
  @IsOptional() @IsUUID() templateId?: string | null;
  @IsOptional()
  @IsString()
  @MaxLength(COUPLE_REQUEST_POLICY.titleMaxLength)
  title?: string | null;
  @IsOptional()
  @IsIn(['BREAK', 'HELP_CHILD', 'QUIET', 'HUG', 'TALK', 'REASSURANCE'])
  needCode?: Need | null;
  @IsOptional() @IsIn([15, 30, 60]) durationMin?: number | null;
  @IsOptional()
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(50)
  @IsUUID('all', { each: true })
  childIds?: string[];
  @IsOptional()
  @IsIn(['NOW', 'TODAY_AT', 'TONIGHT', 'TOMORROW'])
  dueKind?: RequestDueKind | null;
  // Business validation returns REQUEST_DUE_INVALID, including malformed dates.
  @IsOptional() @IsString() dueAt?: string | null;
  @IsOptional() @IsIn(['NORMAL', 'SOON']) urgency?: RequestUrgency;
  @IsOptional()
  @IsString()
  @MaxLength(COUPLE_REQUEST_POLICY.messageMaxLength)
  message?: string | null;
}
export class RequestListQueryDto {
  @IsOptional() @IsIn(['OPEN', 'SENT', 'RECEIVED', 'HISTORY']) box?:
    'OPEN' | 'SENT' | 'RECEIVED' | 'HISTORY';
  @IsOptional() @IsUUID() cursor?: string;
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(COUPLE_REQUEST_POLICY.maxLimit)
  limit?: number;
}
export class RequestDeclineDto {
  @IsOptional() @IsString() @MaxLength(30) reasonCode?: string;
}
export class RequestAcknowledgeDto {
  @IsIn(['SEEN', 'HUG', 'TALK_TIME', 'ENCOURAGED']) type!:
    'SEEN' | 'HUG' | 'TALK_TIME' | 'ENCOURAGED';
  @IsOptional() @IsString() talkAt?: string;
}
export class RequestReminderDto {
  @IsString() at!: string;
}
export interface RequestViewDto {
  id: string;
  senderUserId: string;
  receiverUserId: string;
  kind: RequestKind;
  needCode: Need | null;
  templateId: string | null;
  title: string | null;
  durationMin: number | null;
  childIds: string[];
  message: string | null;
  dueKind: RequestDueKind | null;
  dueAt: string | null;
  urgency: RequestUrgency;
  status: RequestStatus;
  volunteered: boolean;
  declineReason: string | null;
  ackType: string | null;
  talkAt: string | null;
  reminderAt: string | null;
  heartsAwarded?: number;
  selfMissionId: string | null;
  seenAt: string | null;
  respondedAt: string | null;
  doneAt: string | null;
  cancelledAt: string | null;
  expiresAt: string;
  createdAt: string;
  updatedAt: string;
  version: number;
}
export interface CreateRequestResponseDto {
  request: RequestViewDto;
  openCount: number;
  openLimit: number;
}
export interface RequestListResponseDto {
  items: RequestViewDto[];
  nextCursor: string | null;
}
