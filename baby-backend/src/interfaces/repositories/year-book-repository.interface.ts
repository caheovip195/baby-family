import type {
  SavedYearBook,
  SavedYearBookSummary,
  YearBookMemory,
  YearBookPlan,
  YearBookSubject,
} from '../../models/year-book.model';

export const YEAR_BOOK_REPOSITORY = Symbol('YEAR_BOOK_REPOSITORY');

export interface IYearBookRepository {
  child(childId: string): Promise<YearBookSubject | null>;

  /** Cả nhà: tên gia đình, năm sớm nhất = năm sinh bé lớn nhất / năm tạo. */
  family(familyId: string): Promise<YearBookSubject | null>;

  /**
   * Ký ức của đối tượng (bé / cả nhà) trong [from, to) theo quyền xem của
   * [userId], cũ → mới.
   */
  memories(
    subject: YearBookSubject,
    userId: string,
    from: Date,
    to: Date,
    limit: number,
  ): Promise<YearBookMemory[]>;

  saved(
    subject: YearBookSubject,
    yearStart: Date,
  ): Promise<SavedYearBook | null>;

  /**
   * Lưu bản chỉnh sửa (một bản mỗi đối tượng + năm); [shared] = người thân
   * được xem (visibility FAMILY).
   */
  save(
    subject: YearBookSubject,
    yearStart: Date,
    yearEnd: Date,
    content: unknown,
    coverAssetId: string | null,
    shared: boolean,
    /** Parent lưu (người gửi thông báo `yearbook.shared`). */
    actorUserId: string,
  ): Promise<void>;

  /** Sách năm đã lưu của gia đình, mới nhất trước. */
  savedList(familyId: string): Promise<SavedYearBookSummary[]>;

  /** Bé người thân [userId] được xem (Parent: [isParent] true). */
  viewer(
    familyId: string,
    userId: string,
  ): Promise<{ isParent: boolean; childIds: string[] }>;

  /** Cờ xuất / chia sẻ của gói hiện tại + giai đoạn quyền truy cập. */
  plan(familyId: string): Promise<YearBookPlan>;
}
