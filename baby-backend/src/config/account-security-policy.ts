import { REAUTH_POLICY } from './reauth-policy';
/** Separate purpose and policy version; shared login phone/IP throttles remain mandatory. */
export const ACCOUNT_SECURITY_POLICY = {
  ...REAUTH_POLICY,
  version: 1,
  purpose: 'PHONE_CHANGE',
  transactionAttempts: 3,
} as const;
