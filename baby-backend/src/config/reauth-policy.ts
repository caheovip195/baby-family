/** Versioned reauthentication policy; send limits match the phone sign-in pipeline. */
export const REAUTH_POLICY = {
  version: 1,
  ttlSeconds: 300,
  resendSeconds: 60,
  sendsPerHour: 5,
  sendsPerIpHour: 20,
  maxAttempts: 5,
  lockSeconds: 900,
} as const;
