import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  MilestoneCatalogQueryDto,
  MilestoneListQueryDto,
} from '../../dto/milestone/milestone-query.dto';
import type {
  MilestoneCatalogResponseDto,
  MilestoneListResponseDto,
} from '../../dto/milestone/milestone-response.dto';
export const MILESTONE_CATALOG_SERVICE = Symbol('MILESTONE_CATALOG_SERVICE');
export interface IMilestoneCatalogService {
  catalog(
    actor: AuthPrincipal,
    query: MilestoneCatalogQueryDto,
  ): Promise<MilestoneCatalogResponseDto>;
  list(
    actor: AuthPrincipal,
    id: string,
    pregnancy: boolean,
    query: MilestoneListQueryDto,
  ): Promise<MilestoneListResponseDto>;
}
