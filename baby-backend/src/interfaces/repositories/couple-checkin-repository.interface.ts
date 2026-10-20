import type {
  CoupleCheckinScope,
  CoupleCheckinView,
} from '../../models/couple-checkin-view.model';
import type { MoodResponse } from '../../models/mood-response.model';
import type {
  CoupleMood,
  CoupleNeed,
  CoupleResponseType,
} from '../../config/couple-policy';
export const COUPLE_CHECKIN_REPOSITORY = Symbol('COUPLE_CHECKIN_REPOSITORY');
export interface CreateCoupleCheckinCommand {
  mood: CoupleMood;
  energy: number | null;
  needs: CoupleNeed[];
  noteEnc: Uint8Array | null;
  sharedNoteEnc: Uint8Array | null;
  shared: boolean;
  sharedFields: string[];
  createdAt: Date;
  expiresAt: Date;
}
export interface ICoupleCheckinRepository {
  resolveScope(
    familyId: string,
    userId: string,
  ): Promise<CoupleCheckinScope | null>;
  create(
    scope: CoupleCheckinScope,
    input: CreateCoupleCheckinCommand,
  ): Promise<CoupleCheckinView>;
  find(
    scope: CoupleCheckinScope,
    id: string,
  ): Promise<CoupleCheckinView | null>;
  latest(
    scope: CoupleCheckinScope,
    userId: string,
  ): Promise<CoupleCheckinView | null>;
  history(
    scope: CoupleCheckinScope,
    cursor: string | undefined,
    limit: number,
  ): Promise<CoupleCheckinView[]>;
  respond(
    scope: CoupleCheckinScope,
    id: string,
    type: CoupleResponseType,
  ): Promise<MoodResponse>;
  deleteHistory(scope: CoupleCheckinScope): Promise<void>;
}
