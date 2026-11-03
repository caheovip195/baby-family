import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  MonthRecapDto,
  MonthRecapQueryDto,
} from '../../dto/memory/month-recap.dto';

export const MONTH_RECAP_SERVICE = Symbol('MONTH_RECAP_SERVICE');

export interface IMonthRecapService {
  get(
    actor: AuthPrincipal,
    childId: string,
    query: MonthRecapQueryDto,
  ): Promise<MonthRecapDto>;
}
