export interface HeartLedgerHistoryItem {
  id: bigint;
  createdAt: Date;
  amount: number;
  reason: string;
  sourceType: string;
  sourceId: string;
  title: string | null;
}

export interface CareHeartsSnapshot {
  today: number;
  week: number;
  total: number;
  dailyCap: number;
  history: HeartLedgerHistoryItem[];
  nextCursor: string | null;
}

export interface CareFamilyTreeSnapshot {
  level: number;
  levelName: string;
  progressPercent: number;
  fruits: number;
  flowers: number;
  bloomedDaysThisWeek: number;
  today: {
    leaves: number;
    total: number;
    bloomed: boolean;
  };
}

export interface CareBadgeEvaluation {
  code: string;
  titleI18n: Record<string, string>;
  descI18n: Record<string, string>;
  icon: string;
  scope: string;
  achieved: boolean;
  achievedAt: Date | null;
  current: number;
  target: number;
  percent: number;
}
