import type { JobLease } from '../../models/job-lease.model';
import type { PushSendResult } from '../services/push-sender.interface';
export const PUSH_DELIVERY_REPOSITORY = Symbol('PUSH_DELIVERY_REPOSITORY');
export class PushCandidate {
  constructor(
    readonly id: string,
    readonly attempt: number,
    readonly token: string,
    readonly locale: string,
    readonly timezone: string,
    readonly notificationId: string,
    readonly category: string,
    readonly priority: string,
    readonly sensitive: boolean,
    readonly deepLink: string,
    readonly params: Record<string, unknown>,
    readonly title: string,
    readonly body: string,
    readonly hiddenTitle: string | null,
    readonly hiddenBody: string | null,
    readonly quietStart: string,
    readonly quietEnd: string,
    readonly quietUntil: Date | null,
    readonly bypass: boolean,
    readonly sentToday: number,
  ) {}
}
export type PushDecision =
  | { action: 'send' }
  | { action: 'delay'; at: Date }
  | { action: 'skip'; code: string };
export interface IPushDeliveryRepository {
  claim(
    now: Date,
    lease: JobLease,
    decide: (candidate: PushCandidate) => PushDecision,
  ): Promise<PushCandidate | null>;
  finish(
    candidate: PushCandidate,
    result: PushSendResult,
    now: Date,
    lease: JobLease,
  ): Promise<void>;
}
