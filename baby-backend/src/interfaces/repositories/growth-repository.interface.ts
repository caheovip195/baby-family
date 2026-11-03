import type { GrowthChild, GrowthEntry } from '../../models/growth.model';

export const GROWTH_REPOSITORY = Symbol('GROWTH_REPOSITORY');

export interface GrowthValues {
  weightGrams: number | null;
  heightMm: number | null;
  note: string | null;
}

export interface IGrowthRepository {
  /** Bé còn hoạt động / lưu trữ (không gồm bé đã xoá). */
  child(childId: string): Promise<GrowthChild | null>;

  /** Các lần đo còn hiệu lực, cũ → mới. */
  list(childId: string, limit: number): Promise<GrowthEntry[]>;

  /** Một lần đo mỗi ngày: có rồi thì ghi đè. */
  upsert(
    child: GrowthChild,
    measuredOn: string,
    values: GrowthValues,
    userId: string,
  ): Promise<GrowthEntry>;

  /** Xoá mềm; false khi ngày đó chưa có lần đo. */
  remove(childId: string, measuredOn: string): Promise<boolean>;
}
