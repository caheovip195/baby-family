import { createHash } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { SUBSCRIPTION_REMINDER_POLICY as POLICY } from '../config/subscription-reminder-policy';
import { SUBSCRIPTION_REMINDER_REPOSITORY } from '../interfaces/repositories/subscription-reminder-repository.interface';
import type { ISubscriptionReminderRepository } from '../interfaces/repositories/subscription-reminder-repository.interface';
import type { ISubscriptionReminderService } from '../interfaces/services/subscription-reminder-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import type {
  SubscriptionReminderState,
  SubscriptionReminderDecision,
  SubscriptionStatusBanner,
} from '../models/subscription-reminder-state.model';

@Injectable()
export class SubscriptionReminderService implements ISubscriptionReminderService {
  constructor(
    @Inject(SUBSCRIPTION_REMINDER_REPOSITORY)
    private readonly repository: ISubscriptionReminderRepository,
  ) {}

  private offsets(state: SubscriptionReminderState): number[] {
    if (!state.trial) return [...POLICY.paidReminderOffsetsSeconds];
    const policy = state.trialPolicy;
    if (!policy || policy.durationSeconds <= 0n) return [];
    return [...new Set(policy.reminderOffsetsSeconds)]
      .filter(
        (offset) =>
          Number.isSafeInteger(offset) &&
          offset > 0 &&
          BigInt(offset) < policy.durationSeconds,
      )
      .sort((a, b) => b - a);
  }

  async status(
    familyId: string,
    now: Date,
  ): Promise<SubscriptionStatusBanner | null> {
    const state = await this.repository.findState(familyId, now);
    if (!state || state.phase === 'INCOMPLETE') return null;
    const expiresAt = state.expiresAt;
    const remainingSeconds = expiresAt
      ? Math.max(0, Math.ceil((expiresAt.getTime() - now.getTime()) / 1000))
      : 0;
    const kind =
      state.blocked || state.phase === 'BLOCKED'
        ? 'BLOCKED'
        : state.phase === 'EXPIRED' || remainingSeconds === 0
          ? 'EXPIRED'
          : state.inGrace
            ? 'GRACE'
            : state.phase === 'TRIAL'
              ? 'TRIAL'
              : null;
    if (!kind) return null;
    const offsets = this.offsets(state);
    const next = expiresAt
      ? offsets
          .map((offset) => new Date(expiresAt.getTime() - offset * 1000))
          .filter((at) => at > now)
          .sort((a, b) => a.getTime() - b.getTime())[0]
      : undefined;
    return {
      kind,
      serverTime: now,
      expiresAt,
      remainingSeconds,
      reminderOffsetsSeconds: offsets,
      policyCode:
        state.phase === 'PAID' ? null : (state.trialPolicy?.code ?? null),
      policyVersion: !state.trial
        ? POLICY.version
        : (state.trialPolicy?.version ?? null),
      nextReminderAt: next ?? null,
      dismissible: kind === 'TRIAL' || kind === 'GRACE',
    };
  }

  async dispatch(
    now: Date,
    context: JobContext,
    familyId?: string,
  ): Promise<Record<string, number>> {
    context.signal.throwIfAborted();
    const created = await this.repository.dispatch(
      now,
      context,
      (state) => this.decide(state, now),
      familyId,
    );
    return { created };
  }

  private decide(
    state: SubscriptionReminderState,
    now: Date,
  ): SubscriptionReminderDecision | null {
    if (
      state.blocked ||
      ['INCOMPLETE', 'BLOCKED'].includes(state.phase) ||
      !state.expiresAt
    )
      return null;
    let hour: number;
    try {
      hour = Number(
        new Intl.DateTimeFormat('en-GB', {
          timeZone: state.timezone,
          hour: '2-digit',
          hourCycle: 'h23',
        }).format(now),
      );
    } catch {
      return null;
    }
    if (hour < POLICY.localHour) return null;
    const remaining = (state.expiresAt.getTime() - now.getTime()) / 1000;
    const expired = remaining <= 0;
    if (expired && -remaining > POLICY.expiryCatchUpSeconds) return null;
    if (state.phase === 'EXPIRED' && !expired) return null;
    const due = this.offsets(state).filter((offset) => remaining <= offset);
    if (!expired && !state.inGrace && !due.length) return null;
    const offset = expired ? 0 : state.inGrace ? -1 : Math.min(...due);
    const trial = state.trial;
    const templateCode = expired
      ? trial
        ? 'NOTI_TRIAL_EXPIRED'
        : 'NOTI_SUBSCRIPTION_EXPIRED'
      : state.inGrace
        ? 'NOTI_SUBSCRIPTION_GRACE'
        : trial
          ? 'NOTI_TRIAL_ENDING'
          : 'NOTI_SUBSCRIPTION_ENDING';
    const hash = createHash('sha256')
      .update(
        `${state.familyId}:${state.expiresAt.toISOString()}:${state.trialPolicy?.id ?? POLICY.version}:${offset}`,
      )
      .digest('hex');
    const eventId = `${hash.slice(0, 8)}-${hash.slice(8, 12)}-5${hash.slice(13, 16)}-a${hash.slice(17, 20)}-${hash.slice(20, 32)}`;
    return { eventId, templateCode, offsetSeconds: offset };
  }
}
