import type { CoupleCheckinScope } from '../../models/couple-checkin-view.model';
import type { BridgeSessionRow } from '../../models/bridge-view.model';

export const BRIDGE_REPOSITORY = Symbol('BRIDGE_REPOSITORY');

export interface BridgeShareValues {
  feelings: string[];
  needs: string[];
  /** JSON `{topic, message}` đã mã hoá. */
  sharedEnc: Uint8Array | null;
}

/** Thay đổi phiên theo từ vựng API (chỉ field có mặt được ghi). */
export interface BridgeSessionPatch {
  status?: 'ACTIVE' | 'PAUSED' | 'NEXT_STEP' | 'CLOSED';
  startedAt?: Date;
  closedAt?: Date;
  purgeAt?: Date;
  /** Chọn bước mới (phiên bản tăng, người chọn tự đồng ý). */
  nextStep?: { code: string; textEnc: string | null; at: Date | null };
  closeAgreed?: string[];
}

export interface IBridgeRepository {
  /** Phiên chưa đóng của cặp (tối đa một). */
  live(scope: CoupleCheckinScope): Promise<BridgeSessionRow | null>;

  find(scope: CoupleCheckinScope, id: string): Promise<BridgeSessionRow | null>;

  list(scope: CoupleCheckinScope, limit: number): Promise<BridgeSessionRow[]>;

  /** Tạo phiên INVITED + ý của người mời + phát `us.bridge.invited`. */
  create(
    scope: CoupleCheckinScope,
    retentionDays: number,
    share: BridgeShareValues,
  ): Promise<BridgeSessionRow>;

  /** Ghi ý của tôi (có rồi thì đè); người kia phải đọc lại. */
  saveShare(
    scope: CoupleCheckinScope,
    sessionId: string,
    share: BridgeShareValues,
    clarify?: boolean,
  ): Promise<void>;

  setUnderstood(scope: CoupleCheckinScope, sessionId: string): Promise<void>;

  /** Đồng ý bước tiếp theo đang chọn (`us.conflict_confirmations`). */
  confirmStep(
    scope: CoupleCheckinScope,
    sessionId: string,
    version: number,
  ): Promise<void>;

  update(
    scope: CoupleCheckinScope,
    sessionId: string,
    patch: BridgeSessionPatch,
  ): Promise<void>;

  /** Hết hạn phiên bỏ dở (14 ngày) và xoá nội dung quá thời hạn lưu; [scope]
   *  null = mọi gia đình (job định kỳ). Trả số phiên hết hạn / đã xoá. */
  housekeep(
    scope: CoupleCheckinScope | null,
    now: Date,
  ): Promise<{ expired: number; purged: number }>;
}
