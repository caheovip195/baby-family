import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsBoolean,
  IsIn,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { MissionCategory, MissionScope } from '../../common/database.enums';

export class MissionBoardQueryDto {
  @IsOptional() @IsString() date?: string;
  @IsOptional() @IsIn(['MINE', 'PARTNER', 'TOGETHER']) tab?:
    'MINE' | 'PARTNER' | 'TOGETHER';
  @IsOptional() @IsUUID() childId?: string;
}
export class MissionTemplateQueryDto {
  @IsOptional() @IsUUID() familyId?: string;
  @IsOptional()
  @IsIn(Object.values(MissionCategory))
  category?: MissionCategory;
  @IsOptional() @IsUUID() childId?: string;
}
export class CreateMissionDto {
  @IsUUID() familyId!: string;
  // Keep ownership business validation in the service to return MISSION_OWNER_INVALID.
  @IsString() owner!: string;
  @IsOptional() @IsUUID() ownerUserId?: string;
  @IsOptional() @IsUUID() templateId?: string;
  @IsOptional() @IsString() @MaxLength(120) title?: string;
  @IsOptional() @IsString() @MaxLength(500) note?: string;
  @IsOptional() @IsString() date?: string;
  @IsOptional() @IsString() boardDate?: string;
  @IsOptional() @IsString() scheduledTime?: string;
  @IsOptional() @IsString() dueAt?: string;
  @IsOptional() @IsBoolean() memoryPrompt?: boolean;
  @IsOptional()
  @IsIn(Object.values(MissionCategory))
  category?: MissionCategory;
  @IsOptional() @IsIn(Object.values(MissionScope)) targetScope?: MissionScope;
  @IsOptional()
  @IsArray()
  @ArrayUnique()
  @ArrayMaxSize(50)
  @IsUUID('all', { each: true })
  childIds?: string[];
}
export class SwapMissionDto {
  @IsUUID() templateId!: string;
  @IsString() @MaxLength(2048) optionsToken!: string;
}
export class CompleteMissionDto {
  @IsOptional() @IsString() @MaxLength(500) note?: string;
}
export interface CreateMissionResponseDto {
  mission: MyMissionDto;
  seriesId: null;
}
export interface CompleteMissionResponseDto {
  mission: MyMissionDto;
  myHeartsAwarded: number;
  memoryId: null;
  tree: { leaves: number; total: number; bloomed: boolean };
}
export interface SwapMissionResponseDto {
  removedId: string;
  mission: MyMissionDto;
}
export type MissionActionResponseDto =
  MyMissionDto | CompleteMissionResponseDto | SwapMissionResponseDto;
export interface PartnerMissionDto {
  id: string;
  title: string;
  category: MissionCategory;
  childIds: string[];
  status: 'TODO' | 'DONE';
  completedAt: string | null;
  late: boolean;
  thanked: boolean;
}
export interface MyMissionDto {
  id: string;
  familyId: string;
  boardDate: string;
  ownerKind: string;
  mine: boolean;
  source: string;
  templateId: string | null;
  title: string;
  note: string | null;
  category: MissionCategory;
  targetScope: MissionScope;
  childIds: string[];
  hearts: number;
  status: string;
  scheduledTime: string | null;
  dueAt: string | null;
  completedAt: string | null;
  late: boolean;
  canSwap: boolean;
  version: number;
  events: { type: string; createdAt: string }[];
}
export interface MissionBoardResponseDto {
  date: string;
  level: string | null;
  tree: { leaves: number; total: number; bloomed: boolean };
  tabs: Record<
    'mine' | 'partner' | 'together',
    { done: number; total: number }
  >;
  items: (MyMissionDto | PartnerMissionDto)[];
  myHeartsToday?: number;
  swapsLeft?: number;
  openRequestCount: number;
}
