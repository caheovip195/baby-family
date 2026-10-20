import type {
  Need,
  RequestDueKind,
  RequestKind,
  RequestStatus,
  RequestUrgency,
} from '../../common/database.enums';
import type { RequestListQueryDto } from '../../dto/us/request.dto';
import type { CoupleCheckinScope } from '../../models/couple-checkin-view.model';
import type { CoupleRequestView } from '../../models/couple-request-view.model';

export const COUPLE_REQUEST_REPOSITORY = Symbol('COUPLE_REQUEST_REPOSITORY');

export interface CreateCoupleRequestCommand {
  id: string;
  kind: RequestKind;
  needCode: Need | null;
  templateId: string | null;
  titleEnc: Uint8Array | null;
  durationMin: number | null;
  contentKey: Uint8Array;
  messageEnc: Uint8Array | null;
  dueKind: RequestDueKind | null;
  dueAt: Date | null;
  urgency: RequestUrgency;
  talkAt: Date | null;
  expiresAt: Date;
  now: Date;
  childIds: string[];
  idempotencyKey: string;
  requestHash: Uint8Array;
  idempotencyExpiresAt: Date;
}

/** Business decision produced by the service while the repository holds its lock. */
export interface RequestMutation {
  eventType: string;
  status?: RequestStatus;
  seenAt?: Date;
  respondedAt?: Date;
  declineReason?: string | null;
  ackType?: string;
  talkAt?: Date | null;
  reminderAt?: Date;
  doneAt?: Date;
  cancelledAt?: Date;
}

export interface ICoupleRequestRepository {
  resolveScope(
    familyId: string,
    userId: string,
  ): Promise<CoupleCheckinScope | null>;
  findReplay(
    scope: CoupleCheckinScope,
    idempotencyKey: string,
    requestHash: Uint8Array,
  ): Promise<{ view: CoupleRequestView; openCount: number } | null>;
  create(
    scope: CoupleCheckinScope,
    command: CreateCoupleRequestCommand,
  ): Promise<{ view: CoupleRequestView; openCount: number }>;
  list(
    scope: CoupleCheckinScope,
    query: RequestListQueryDto,
  ): Promise<CoupleRequestView[]>;
  find(
    scope: CoupleCheckinScope,
    id: string,
  ): Promise<CoupleRequestView | null>;
  transition(
    scope: CoupleCheckinScope,
    id: string,
    decide: (view: CoupleRequestView) => RequestMutation,
  ): Promise<CoupleRequestView>;
}
