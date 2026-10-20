import type { AuthPrincipal } from '../../common/auth/auth-principal';
import type {
  WeeklyRecapQueryDto,
  WeeklyRecapResponse,
  WeekStats,
} from '../../dto/recap/weekly-recap.dto';
import type { JobContext } from './job-runner-service.interface';
export const WEEKLY_RECAP_SERVICE = Symbol('WEEKLY_RECAP_SERVICE');
export interface IWeeklyRecapService {
  build(now: Date, context: JobContext): Promise<Record<string, number>>;
  list(
    actor: AuthPrincipal,
    familyId: string,
    query: WeeklyRecapQueryDto,
  ): Promise<{ items: WeeklyRecapResponse[]; nextCursor: string | null }>;
  latest(actor: AuthPrincipal, familyId: string): Promise<WeeklyRecapResponse>;
  stats(actor: AuthPrincipal, familyId: string): Promise<WeekStats>;
}
