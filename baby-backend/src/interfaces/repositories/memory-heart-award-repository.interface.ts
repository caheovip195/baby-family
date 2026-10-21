import type { JobContext } from '../services/job-runner-service.interface';
export const MEMORY_HEART_AWARD_REPOSITORY = Symbol(
  'MEMORY_HEART_AWARD_REPOSITORY',
);
export interface IMemoryHeartAwardRepository {
  award(
    eventId: string,
    context: JobContext,
    policy: { award: number; awardsPerDay: number; dailyCap: number },
  ): Promise<number>;
}
