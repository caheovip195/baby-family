import type { DatabaseJsonValue } from '../../common/database.types';
import type { Memory } from '../../models/memory.model';
import type { Milestone } from '../../models/milestone.model';
import type { MilestoneTemplate } from '../../models/milestone-template.model';
export const MILESTONE_CATALOG_REPOSITORY = Symbol(
  'MILESTONE_CATALOG_REPOSITORY',
);
export interface MilestoneSubjectContext {
  id: string;
  familyId: string;
  birthDate: Date | null;
  pregnancy: boolean;
  traditionalUseLunar: boolean;
  parent: boolean;
  circle: null | {
    active: boolean;
    granted: boolean;
    enabled: boolean;
    licensed: boolean;
    familyActive: boolean;
  };
}
export interface MilestoneRecord {
  milestone: Milestone;
  memory: Memory;
  coverAssetId: string | null;
}
export interface MilestoneCursor {
  occurredOn: Date;
  id: string;
}
export interface IMilestoneCatalogRepository {
  subject(
    id: string,
    pregnancy: boolean,
    userId: string,
  ): Promise<MilestoneSubjectContext | null>;
  templates(pregnancy?: boolean): Promise<MilestoneTemplate[]>;
  records(
    subject: MilestoneSubjectContext,
    userId: string,
    circle: boolean,
    after: MilestoneCursor | null,
    limit?: number,
  ): Promise<MilestoneRecord[]>;
}
export type MilestoneDateRule = DatabaseJsonValue;
