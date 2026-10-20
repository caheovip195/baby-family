import type { Pregnancy } from '../../models/pregnancy.model';
import type { PrepItem } from '../../models/prep-item.model';
import type {
  CreatePregnancyPrepDto,
  UpdatePregnancyPrepDto,
} from '../../dto/pregnancy/prep.dto';

export const PREGNANCY_PREP_REPOSITORY = Symbol('PREGNANCY_PREP_REPOSITORY');
export interface IPregnancyPrepRepository {
  findPregnancy(id: string): Promise<Pregnancy | null>;
  findItem(id: string): Promise<PrepItem | null>;
  listAndSeed(
    pregnancy: Pregnancy,
    actorUserId: string,
  ): Promise<PrepItem[] | null>;
  create(
    pregnancy: Pregnancy,
    actorUserId: string,
    input: CreatePregnancyPrepDto,
  ): Promise<PrepItem | null>;
  update(
    item: PrepItem,
    actorUserId: string,
    input: UpdatePregnancyPrepDto,
  ): Promise<PrepItem | null>;
  remove(item: PrepItem, actorUserId: string): Promise<boolean>;
}
