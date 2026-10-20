export interface CareBadgeProgressDto {
  current: number;
  target: number;
  percent: number;
}

export interface CareBadgeDto {
  code: string;
  title: string;
  titleI18n: Record<string, string>;
  description: string;
  descI18n: Record<string, string>;
  icon: string;
  scope: string;
  earned: boolean;
  achieved: boolean;
  achievedAt: string | null;
  progress: CareBadgeProgressDto;
}

export interface CareBadgesResponseDto {
  items: CareBadgeDto[];
}
