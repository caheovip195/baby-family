import type { AiAccess, AiReservation } from '../../models/ai-access.model';

export const AI_REPOSITORY = Symbol('AI_REPOSITORY');

export interface AiOutcome {
  status: 'SUCCEEDED' | 'FAILED' | 'REFUSED';
  model: string;
  inputTokens: number | null;
  outputTokens: number | null;
  durationMs: number;
  errorCode: string | null;
}

export interface IAiRepository {
  access(familyId: string, userId: string): Promise<AiAccess>;

  /** Id đồng ý mới nhất còn hiệu lực cho [document]/[version]; null = chưa. */
  consent(
    userId: string,
    document: string,
    version: string,
  ): Promise<string | null>;

  grantConsent(
    userId: string,
    document: string,
    version: string,
  ): Promise<string>;

  /** Gợi ý nhiệm vụ: số việc đã xong theo nhóm từ [since] (tổng hợp, không chi tiết người). */
  recentMissionCategories(
    familyId: string,
    since: Date,
  ): Promise<Record<string, number>>;

  /** Lượt đã dùng trong tháng (tính cả lượt đang giữ chỗ). */
  used(familyId: string, month: Date, now: Date): Promise<number>;

  /** Giữ chỗ một lượt nếu còn hạn mức; null khi hết. Ghi lượt gọi PENDING. */
  reserve(input: {
    familyId: string;
    userId: string;
    feature: string;
    promptVersion: string;
    model: string;
    consentId: string;
    month: Date;
    limit: number;
    expiresAt: Date;
  }): Promise<AiReservation | null>;

  /** Kết thúc lượt gọi: thành công → trừ hạn mức; còn lại → trả chỗ. */
  finish(reservation: AiReservation, outcome: AiOutcome): Promise<void>;
}
