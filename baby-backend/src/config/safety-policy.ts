/**
 * RPT-01/02 (BF-20261019-006). Versioned: changing reasons, severities or SLA
 * targets is a policy change. Reason codes are the `report_reason` enum.
 */
export const SAFETY_POLICY = {
  version: 1,
  reportTargets: ['MEMORY', 'COMMENT', 'USER'] as const,
  reasons: [
    'INAPPROPRIATE',
    'HARASSMENT',
    'PRIVACY',
    'CHILD_SAFETY',
    'SPAM',
    'AI_CONTENT',
    'OTHER',
  ] as const,
  /** 1 = most urgent; anything about a child's safety is triaged first. */
  severity: { CHILD_SAFETY: 1, default: 2 } as const,
  slaMs: {
    1: 24 * 60 * 60 * 1000,
    2: 72 * 60 * 60 * 1000,
  } as const,
  noteMaxLength: 1000,
} as const;

export type ReportTargetType = (typeof SAFETY_POLICY.reportTargets)[number];
export type ReportReasonCode = (typeof SAFETY_POLICY.reasons)[number];
