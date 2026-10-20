import type { JobContext } from './job-runner-service.interface';
export const PUSH_DELIVERY_SERVICE = Symbol('PUSH_DELIVERY_SERVICE');
export interface IPushDeliveryService {
  deliver(now: Date, context: JobContext): Promise<Record<string, number>>;
}
