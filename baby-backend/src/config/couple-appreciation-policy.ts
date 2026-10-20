export const COUPLE_APPRECIATION_POLICY = {
  maxBodyLength: 500,
  defaultLimit: 20,
  maxLimit: 50,
  defaultQuickSentence: 'Cảm ơn bạn đời nhiều lắm! 💛',
  allowedLinkedTypes: ['MISSION', 'REQUEST', 'MEMORY'] as const,
} as const;

export type AppreciationLinkedType =
  (typeof COUPLE_APPRECIATION_POLICY.allowedLinkedTypes)[number];
