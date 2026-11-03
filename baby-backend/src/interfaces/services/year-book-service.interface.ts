import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  SaveYearBookDto,
  YearBookDto,
  YearBookListDto,
} from '../../dto/year-book/year-book.dto';

export const YEAR_BOOK_SERVICE = Symbol('YEAR_BOOK_SERVICE');

export interface IYearBookService {
  get(
    actor: AuthPrincipal,
    childId: string,
    year: number,
  ): Promise<YearBookDto>;
  save(
    actor: AuthPrincipal,
    childId: string,
    year: number,
    input: SaveYearBookDto,
  ): Promise<YearBookDto>;
  /** Sách cả nhà (BF-20261030-001). */
  getFamily(
    actor: AuthPrincipal,
    familyId: string,
    year: number,
  ): Promise<YearBookDto>;
  saveFamily(
    actor: AuthPrincipal,
    familyId: string,
    year: number,
    input: SaveYearBookDto,
  ): Promise<YearBookDto>;
  /** Sách đã lưu (người thân: bản chia sẻ, BF-20261030-002). */
  list(actor: AuthPrincipal, familyId: string): Promise<YearBookListDto>;
}
