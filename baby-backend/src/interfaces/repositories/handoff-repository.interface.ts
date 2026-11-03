import type { CoupleCheckinScope } from '../../models/couple-checkin-view.model';
import type { HandoffRow } from '../../models/handoff-view.model';

export const HANDOFF_REPOSITORY = Symbol('HANDOFF_REPOSITORY');

export interface NewHandoff {
  idempotencyKey: string;
  childIds: string[];
  fedAt: Date | null;
  sleptAt: Date | null;
  wokeAt: Date | null;
  noteEnc: Uint8Array | null;
  requestId: string | null;
}

export interface IHandoffRepository {
  /** Bé đang hoạt động của gia đình trong [childIds]. */
  activeChildIds(familyId: string, childIds: string[]): Promise<string[]>;

  /** Lời nhờ của chính tôi gửi bạn đời trong couple space. */
  ownRequestExists(
    scope: CoupleCheckinScope,
    requestId: string,
  ): Promise<boolean>;

  findByKey(
    scope: CoupleCheckinScope,
    idempotencyKey: string,
  ): Promise<HandoffRow | null>;

  /** Tạo + phát `us.handoff.created` trong cùng giao dịch. */
  create(scope: CoupleCheckinScope, input: NewHandoff): Promise<HandoffRow>;

  list(scope: CoupleCheckinScope, limit: number): Promise<HandoffRow[]>;

  /** Người nhận bấm “Đã nhận”; null khi không phải bàn giao gửi tới tôi. */
  acknowledge(
    scope: CoupleCheckinScope,
    handoffId: string,
    at: Date,
  ): Promise<HandoffRow | null>;
}
