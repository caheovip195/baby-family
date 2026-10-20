import { NOTIFICATION_POLICY } from './notification-policy';
import type { NotificationCategory } from './notification-policy';

/**
 * Versioned catalog of what a user may change in SET notification / AI
 * settings (BF-20261019-006). Categories come from the notification policy so
 * dispatch and settings never drift; adding a key here is a policy change.
 */
export const PREFERENCE_SETTINGS_POLICY = {
  version: 1,
  /** Categories a user may switch off; account/security notices are not listed. */
  notificationCategories: Object.keys(
    NOTIFICATION_POLICY.categoryDefaults,
  ) as NotificationCategory[],
  circleDigestModes: ['INSTANT', 'DIGEST', 'OFF'] as const,
  /** AI features (§23, release 1.2) the user can opt out of individually. */
  aiFeatures: [
    'caption',
    'dailyStory',
    'missionSuggest',
    'gentleRewrite',
    'bridgeSummary',
  ] as const,
  aiFeatureDefault: true,
} as const;

export type CircleDigestMode =
  (typeof PREFERENCE_SETTINGS_POLICY.circleDigestModes)[number];
export type AiFeatureKey =
  (typeof PREFERENCE_SETTINGS_POLICY.aiFeatures)[number];
