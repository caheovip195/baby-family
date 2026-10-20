import type {
  MonthlyPhotoCandidate,
  MonthlyPhotoChild,
  MonthlyPhotoSelection,
} from '../../models/monthly-photo-selection.model';
export const MONTHLY_PHOTO_SELECTION_REPOSITORY = Symbol(
  'MONTHLY_PHOTO_SELECTION_REPOSITORY',
);
export interface IMonthlyPhotoSelectionRepository {
  child(id: string, userId: string): Promise<MonthlyPhotoChild | null>;
  candidate(
    familyId: string,
    memoryId: string,
    assetId: string,
  ): Promise<MonthlyPhotoCandidate | null>;
  list(
    familyId: string,
    childId: string,
    userId: string,
  ): Promise<MonthlyPhotoSelection[]>;
  set(
    familyId: string,
    childId: string,
    userId: string,
    monthIndex: number,
    memoryId: string,
    assetId: string,
    version: number,
  ): Promise<MonthlyPhotoSelection>;
}
