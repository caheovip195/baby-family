import type { MyMissionDto, PartnerMissionDto } from '../mission/mission.dto';
import type {
  CalendarSpecialDayDto,
  EventResponseDto,
} from './event-response.dto';

export interface CalendarResponseDto {
  from: string;
  to: string;
  events: EventResponseDto[];
  missions: (MyMissionDto | PartnerMissionDto)[];
  specialDays: CalendarSpecialDayDto[];
}
