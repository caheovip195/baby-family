import type { JobContext } from './job-runner-service.interface';
export const MEMORY_HEART_AWARD_SERVICE = Symbol('MEMORY_HEART_AWARD_SERVICE');
export interface IMemoryHeartAwardService {
  award(eventId: string, context: JobContext): Promise<number>;
}
