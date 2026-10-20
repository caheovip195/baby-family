import type {
  CoupleAppreciationScope,
  CoupleAppreciationView,
} from '../../models/couple-appreciation-view.model';

export const COUPLE_APPRECIATION_REPOSITORY = Symbol(
  'COUPLE_APPRECIATION_REPOSITORY',
);

export interface CreateAppreciationCommand {
  bodyEnc: Uint8Array;
  sticker: string | null;
  linkedType: string | null;
  linkedId: string | null;
  createdAt: Date;
}

export interface ListAppreciationFilter {
  cursor?: string;
  limit: number;
  month?: string;
}

export interface ICoupleAppreciationRepository {
  resolveScope(
    familyId: string,
    userId: string,
  ): Promise<CoupleAppreciationScope | null>;
  verifyLinkedItem(
    scope: CoupleAppreciationScope,
    linkedType: string,
    linkedId: string,
  ): Promise<boolean>;
  create(
    scope: CoupleAppreciationScope,
    input: CreateAppreciationCommand,
  ): Promise<CoupleAppreciationView>;
  find(
    scope: CoupleAppreciationScope,
    id: string,
  ): Promise<CoupleAppreciationView | null>;
  listWall(
    scope: CoupleAppreciationScope,
    filter: ListAppreciationFilter,
  ): Promise<CoupleAppreciationView[]>;
  react(
    scope: CoupleAppreciationScope,
    id: string,
    reaction: string,
  ): Promise<CoupleAppreciationView>;
  requestShare(
    scope: CoupleAppreciationScope,
    id: string,
  ): Promise<CoupleAppreciationView>;
  respondShare(
    scope: CoupleAppreciationScope,
    id: string,
    approve: boolean,
    memoryBody: string | null,
  ): Promise<CoupleAppreciationView>;
  delete(scope: CoupleAppreciationScope, id: string): Promise<void>;
}
