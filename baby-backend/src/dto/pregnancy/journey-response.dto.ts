import type { MemoryResponseDto } from '../memory/memory-response.dto';
export interface JourneyWeekContent {
  emoji: string;
  lengthCm: number;
  weightG?: number;
  label: string;
  tip: string;
}
export interface JourneyResponseDto {
  pregnancyId: string;
  dueDate: string | null;
  currentWeek: number | null;
  currentDay: number | null;
  daysLeft: number | null;
  trimester: number | null;
  week: {
    number: number | null;
    size: Omit<JourneyWeekContent, 'tip'> | null;
    tip: string | null;
  };
}
export interface JourneyMemoriesResponseDto {
  data: (MemoryResponseDto & { week: number | null })[];
  nextCursor: string | null;
}
