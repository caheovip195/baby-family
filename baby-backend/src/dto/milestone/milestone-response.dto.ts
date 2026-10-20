import type { DatabaseJsonValue } from '../../common/database.types';
export interface MilestoneSummaryDto {
  milestoneId: string;
  memoryId: string;
  occurredOn: string;
}
export interface MilestoneCatalogResponseDto {
  categories: {
    category: string;
    templates: {
      code: string;
      icon: string;
      titleI18n: DatabaseJsonValue;
      promptI18n: DatabaseJsonValue | null;
      isTraditional: boolean;
      dateRule: DatabaseJsonValue | null;
      suggestedDate: string | null;
      achieved: MilestoneSummaryDto | null;
    }[];
  }[];
}
export interface MilestoneListResponseDto {
  data: (MilestoneSummaryDto & {
    templateCode: string | null;
    customTitle: string | null;
    memory: {
      id: string;
      title: string | null;
      kind: string;
      occurredAt: string;
      coverAssetId: string | null;
    };
  })[];
  nextCursor: string | null;
}
