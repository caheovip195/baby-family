import type { RequestStatus } from '../common/database.enums';
import { HEARTS_POLICY } from './hearts-policy';
/** US-03/04 policy v1. Dates are evaluated in the family's IANA timezone. */
export const COUPLE_REQUEST_POLICY = {
  version: 1,
  openLimit: 5,
  resendBlockMs: 12 * 60 * 60 * 1000,
  openStatuses: ['SENT', 'SEEN', 'ACCEPTED'] as RequestStatus[],
  defaultLimit: 30,
  maxLimit: 100,
  taskExpiryMs: 2 * 60 * 60 * 1000,
  needExpiryMs: 12 * 60 * 60 * 1000,
  maxDueMs: 7 * 24 * 60 * 60 * 1000,
  tonightHour: 20,
  tomorrowHour: 9,
  heartAward: 5,
  dailyHeartCap: HEARTS_POLICY.dailyHeartCap,
  titleMaxLength: 120,
  messageMaxLength: 500,
} as const;
export type CoupleRequestAction =
  | 'seen'
  | 'accept'
  | 'decline'
  | 'acknowledge'
  | 'done'
  | 'remind-me'
  | 'cancel';
