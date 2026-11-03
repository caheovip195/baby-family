import type {
  MonthRecapChild,
  MonthRecapData,
} from '../../models/month-recap.model';

export const MONTH_RECAP_REPOSITORY = Symbol('MONTH_RECAP_REPOSITORY');

export interface IMonthRecapRepository {
  /** Bé còn hoạt động / lưu trữ (không gồm bé đã xoá). */
  child(childId: string): Promise<MonthRecapChild | null>;

  /** Người thân chỉ xem bé được cấp quyền. */
  canSeeChild(
    familyId: string,
    userId: string,
    childId: string,
  ): Promise<boolean>;

  /** Ký ức có `age_month = ageMonth` + ảnh tháng [monthIndexes]. */
  recap(
    familyId: string,
    userId: string,
    childId: string,
    ageMonth: number,
    monthIndexes: readonly number[],
    highlightLimit: number,
  ): Promise<MonthRecapData>;
}
