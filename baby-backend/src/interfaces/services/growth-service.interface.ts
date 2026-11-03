import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  GrowthEntryDto,
  GrowthListDto,
  UpsertGrowthDto,
} from '../../dto/growth/growth.dto';

export const GROWTH_SERVICE = Symbol('GROWTH_SERVICE');

export interface IGrowthService {
  list(actor: AuthPrincipal, childId: string): Promise<GrowthListDto>;
  upsert(
    actor: AuthPrincipal,
    childId: string,
    measuredOn: string,
    input: UpsertGrowthDto,
  ): Promise<GrowthEntryDto>;
  remove(
    actor: AuthPrincipal,
    childId: string,
    measuredOn: string,
  ): Promise<void>;
}
