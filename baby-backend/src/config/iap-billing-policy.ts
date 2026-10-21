import { z } from 'zod';

export const IAP_BILLING_CONFIG = Symbol('IAP_BILLING_CONFIG');
export interface IapBillingConfig {
  environment: string;
  appStoreBundleId?: string;
  playPackageName?: string;
  /** Base64 encoded 32-byte AES key. Required before accepting a webhook. */
  payloadEncryptionKey?: string;
}
export function createIapBillingConfig(): IapBillingConfig {
  return {
    environment: process.env.IAP_ENVIRONMENT ?? 'PRODUCTION',
    appStoreBundleId: process.env.APP_STORE_BUNDLE_ID,
    playPackageName: process.env.PLAY_PACKAGE_NAME,
    payloadEncryptionKey: process.env.IAP_PAYLOAD_ENCRYPTION_KEY,
  };
}
export const IAP_BILLING_POLICY = {
  version: 1,
  intentLifetimeMs: 30 * 60 * 1000,
  reconciliationEveryMs: 60 * 1000,
} as const;

// Decode only server-encrypted, previously verified envelopes. No date revival of raw data.
const purchaseSchema = z.object({
  store: z.enum(['APP_STORE', 'PLAY']),
  transactionId: z.string().min(1),
  originalTransactionId: z.string().min(1),
  productId: z.string().min(1),
  accountToken: z.string().min(1),
  appNamespace: z.string().min(1),
  environment: z.string().min(1),
  startsAt: z.coerce.date(),
  expiresAt: z.coerce.date(),
  autoRenew: z.boolean(),
  graceUntil: z.coerce.date().optional(),
  revokedAt: z.coerce.date().optional(),
  purchaseToken: z.string().optional(),
  raw: z.record(z.string(), z.unknown()),
});
export const storedIapNotificationSchema = z.object({
  version: z.literal(1),
  event: z.object({
    store: z.enum(['APP_STORE', 'PLAY']),
    eventId: z.string().min(1),
    type: z.enum([
      'RENEWED',
      'EXPIRED',
      'GRACE',
      'REVOKED',
      'AUTO_RENEW_CHANGED',
      'IGNORED',
    ]),
    occurredAt: z.coerce.date(),
    purchase: purchaseSchema.nullable(),
    autoRenew: z.boolean().optional(),
    raw: z.record(z.string(), z.unknown()),
  }),
});
