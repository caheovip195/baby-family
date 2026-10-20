import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  Max,
  Min,
} from 'class-validator';
import { MissionCategory, MissionStatus } from '../../common/database.enums';
import type { MyMissionDto, PartnerMissionDto } from '../mission/mission.dto';

export class CareMissionHistoryQueryDto {
  @IsOptional()
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, {
    message: 'from must be formatted as YYYY-MM-DD',
  })
  from?: string;

  @IsOptional()
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, {
    message: 'to must be formatted as YYYY-MM-DD',
  })
  to?: string;

  @IsOptional()
  @IsIn(['ME', 'PARTNER', 'TOGETHER'])
  owner?: 'ME' | 'PARTNER' | 'TOGETHER';

  @IsOptional()
  @IsIn(Object.values(MissionStatus))
  status?: MissionStatus;

  @IsOptional()
  @IsUUID()
  childId?: string;

  @IsOptional()
  @IsIn(Object.values(MissionCategory))
  category?: MissionCategory;

  @IsOptional()
  @IsString()
  cursor?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}

export interface CareMissionHistoryResponseDto {
  items: (MyMissionDto | PartnerMissionDto)[];
  nextCursor: string | null;
}
