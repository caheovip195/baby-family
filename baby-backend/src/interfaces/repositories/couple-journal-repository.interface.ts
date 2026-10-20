import type {
  CoupleJournalScope,
  CoupleJournalEntryView,
} from '../../models/couple-journal-view.model';
import type { Mood } from '../../common/database.enums';

export const COUPLE_JOURNAL_REPOSITORY = Symbol('COUPLE_JOURNAL_REPOSITORY');

export interface CreateJournalEntryCommand {
  titleEnc: Uint8Array | null;
  bodyEnc: Uint8Array;
  mood: Mood | null;
  assetIds: string[];
  createdAt: Date;
}

export interface UpdateJournalEntryCommand {
  titleEnc?: Uint8Array | null;
  bodyEnc?: Uint8Array;
  mood?: Mood | null;
  assetIds?: string[];
}

export interface CreateJournalShareCommand {
  entryId: string;
  snippetEnc: Uint8Array;
  explicitlySharedAt: Date;
}

export interface ICoupleJournalRepository {
  resolveScope(
    familyId: string,
    userId: string,
  ): Promise<CoupleJournalScope | null>;
  verifyAssets(scope: CoupleJournalScope, assetIds: string[]): Promise<boolean>;
  create(
    scope: CoupleJournalScope,
    command: CreateJournalEntryCommand,
  ): Promise<CoupleJournalEntryView>;
  findById(
    scope: CoupleJournalScope,
    id: string,
  ): Promise<CoupleJournalEntryView | null>;
  list(
    scope: CoupleJournalScope,
    cursor: string | undefined,
    limit: number,
  ): Promise<CoupleJournalEntryView[]>;
  update(
    scope: CoupleJournalScope,
    id: string,
    command: UpdateJournalEntryCommand,
  ): Promise<CoupleJournalEntryView>;
  delete(scope: CoupleJournalScope, id: string): Promise<void>;
  createShare(
    scope: CoupleJournalScope,
    command: CreateJournalShareCommand,
  ): Promise<{ id: string; entryId: string; explicitlySharedAt: Date }>;
}
