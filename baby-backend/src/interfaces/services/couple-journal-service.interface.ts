import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  CreateJournalEntryDto,
  UpdateJournalEntryDto,
  JournalListQueryDto,
  ShareJournalExcerptDto,
  JournalEntryViewDto,
  JournalListDto,
  JournalShareResponseDto,
} from '../../dto/us/journal.dto';

export const COUPLE_JOURNAL_SERVICE = Symbol('COUPLE_JOURNAL_SERVICE');

export interface ICoupleJournalService {
  create(
    actor: AuthPrincipal,
    familyId: string,
    input: CreateJournalEntryDto,
  ): Promise<JournalEntryViewDto>;
  list(
    actor: AuthPrincipal,
    familyId: string,
    query: JournalListQueryDto,
  ): Promise<JournalListDto>;
  findById(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
  ): Promise<JournalEntryViewDto>;
  update(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: UpdateJournalEntryDto,
  ): Promise<JournalEntryViewDto>;
  delete(actor: AuthPrincipal, familyId: string, id: string): Promise<void>;
  share(
    actor: AuthPrincipal,
    familyId: string,
    id: string,
    input: ShareJournalExcerptDto,
  ): Promise<JournalShareResponseDto>;
}
