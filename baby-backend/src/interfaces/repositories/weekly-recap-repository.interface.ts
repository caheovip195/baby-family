import type { Recap } from '../../models/recap.model';
import type { WeeklyRecapData } from '../../models/weekly-recap-data.model';
import type { JobContext } from '../services/job-runner-service.interface';
export const WEEKLY_RECAP_REPOSITORY = Symbol('WEEKLY_RECAP_REPOSITORY');
export interface IWeeklyRecapRepository {
  families(
    after?: string,
  ): Promise<{ id: string; timezone: string; createdAt: Date }[]>;
  aggregate(
    familyId: string,
    start: string,
    end: string,
    timezone: string,
    viewer?: { userId: string; isParent: boolean; includePrivate?: boolean },
  ): Promise<WeeklyRecapData>;
  save(
    familyId: string,
    start: string,
    end: string,
    data: WeeklyRecapData,
    context: JobContext,
  ): Promise<void>;
  list(
    familyId: string,
    circle: boolean,
    cursor: string | undefined,
    limit: number,
  ): Promise<Recap[]>;
  /** Recap tuần của gia đình theo id (null = không có / đã xoá). */
  find(familyId: string, recapId: string): Promise<Recap | null>;
  /** Cờ chia sẻ với người thân của gói hiện tại (null = chưa khai báo) + Circle. */
  sharePlan(
    familyId: string,
  ): Promise<{ share: boolean | null; circle: boolean }>;
  /**
   * Đổi chia sẻ với người thân (visibility FAMILY/PARENTS); lần đầu chuyển
   * sang chia sẻ phát `recap.weekly.shared`.
   */
  share(
    familyId: string,
    recapId: string,
    shared: boolean,
    actorUserId: string,
  ): Promise<void>;
  /**
   * Lưu vào timeline: tạo một ký ức (một lần mỗi recap, gắn `memory_id`) với
   * ảnh đầu của các ký ức nổi bật; trả id ký ức.
   */
  saveToTimeline(
    familyId: string,
    recapId: string,
    input: {
      authorUserId: string;
      titles: Record<string, string>;
      occurredAt: Date;
      localDate: Date;
      maxPhotos: number;
    },
  ): Promise<string>;
}
