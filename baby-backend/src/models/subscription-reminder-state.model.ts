import type { AccessPhase } from '../common/database.enums';

export interface SubscriptionReminderState {
  familyId: string;
  timezone: string;
  phase: AccessPhase;
  blocked: boolean;
  inGrace: boolean;
  expiresAt: Date | null;
  trialEndsAt: Date | null;
  trial: boolean;
  trialPolicy: {
    id: string;
    code: string;
    version: number;
    durationSeconds: bigint;
    reminderOffsetsSeconds: number[];
  } | null;
}

export interface SubscriptionReminderDecision {
  eventId: string;
  templateCode: string;
  offsetSeconds: number;
}

export interface SubscriptionStatusBanner {
  kind: 'TRIAL' | 'GRACE' | 'EXPIRED' | 'BLOCKED';
  serverTime: Date;
  expiresAt: Date | null;
  remainingSeconds: number;
  reminderOffsetsSeconds: number[];
  policyCode: string | null;
  policyVersion: number | null;
  nextReminderAt: Date | null;
  dismissible: boolean;
}
