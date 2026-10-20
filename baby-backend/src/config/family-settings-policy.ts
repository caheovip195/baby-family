import { Visibility } from '../common/database.enums';

/** v1 whitelist. Family has no settings version: writes use last-write-wins per key.
 * Circle receives showLunar only, needed for shared calendar/date presentation.
 * Privacy defaults, review policy, suggestions and tree policy remain Parent-only.
 * Settings are privacy metadata: current Parents can manage them while waiting
 * for a partner or after a partner leaves, independently of billing entitlement
 * (same access principle as ApplicationAccessService metadata).
 */
export const FAMILY_SETTINGS_POLICY = {
  schemaVersion: 1,
  circleReadableKeys: ['showLunar'],
  fields: {
    showLunar: { type: 'boolean', default: true },
    circleCanSeeTree: { type: 'boolean', default: false },
    defaultVisibility: {
      type: 'visibility',
      default: null,
      values: [Visibility.PRIVATE, Visibility.PARENTS, Visibility.FAMILY],
    },
    requireCircleReview: { type: 'boolean', default: true },
    traditionalUseLunar: { type: 'boolean', default: false },
    milestoneSuggestions: { type: 'boolean', default: true },
  },
} as const;
