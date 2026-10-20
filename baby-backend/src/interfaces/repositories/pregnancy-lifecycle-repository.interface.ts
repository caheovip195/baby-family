import type {
  Paginated,
  PaginationInput,
} from '../../common/pagination/pagination.types';
import type { PregnancyStatus } from '../../common/database.enums';
import type { Pregnancy } from '../../models/pregnancy.model';

export const PREGNANCY_LIFECYCLE_REPOSITORY = Symbol(
  'PREGNANCY_LIFECYCLE_REPOSITORY',
);

export interface IPregnancyLifecycleRepository {
  findById(id: string): Promise<Pregnancy | null>;
  listArchived(
    familyId: string,
    input: PaginationInput,
  ): Promise<Paginated<Pregnancy>>;
  changeStatus(current: Pregnancy, status: PregnancyStatus): Promise<Pregnancy>;
}
