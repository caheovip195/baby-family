export interface FamilyTreeTodayDto {
  leaves: number;
  total: number;
  bloomed: boolean;
}

export interface FamilyTreeResponseDto {
  level: number;
  levelName: string;
  progressPercent: number;
  fruits: number;
  flowers: number;
  bloomedDaysThisWeek: number;
  today: FamilyTreeTodayDto;
}
