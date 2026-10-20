import type { JobContext } from './job-runner-service.interface';

export const NOTIFICATION_DISPATCH_SERVICE = Symbol(
  'NOTIFICATION_DISPATCH_SERVICE',
);

export interface INotificationDispatchService {
  dispatch(
    eventId: string,
    context: JobContext,
  ): Promise<Record<string, number>>;
}
