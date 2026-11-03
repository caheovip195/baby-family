import type { CoupleCheckinScope } from '../../models/couple-checkin-view.model';
import type { ConnectionAnswer } from '../../models/connection-answer.model';
import type { CoupleWeekCounts } from '../../models/couple-week.model';

export const COUPLE_QUESTION_REPOSITORY = Symbol('COUPLE_QUESTION_REPOSITORY');

export interface ICoupleQuestionRepository {
  /** Câu trả lời của cả hai cho một ngày (theo múi giờ gia đình). */
  answers(
    scope: CoupleCheckinScope,
    localDate: Date,
  ): Promise<ConnectionAnswer[]>;

  /** Tạo hoặc sửa câu trả lời của tôi trong ngày. */
  saveAnswer(
    scope: CoupleCheckinScope,
    localDate: Date,
    questionCode: string,
    answerEnc: Uint8Array,
  ): Promise<ConnectionAnswer>;

  /** US-14: đếm trong [from, to) của couple space. */
  week(
    scope: CoupleCheckinScope,
    from: Date,
    to: Date,
    togetherLimit: number,
  ): Promise<CoupleWeekCounts>;
}
