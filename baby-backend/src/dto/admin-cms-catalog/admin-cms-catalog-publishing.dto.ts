import { z } from 'zod';
const reason = z.string().trim().min(1).max(80);
const i18n = z
  .object({ vi: z.string().trim().min(1), en: z.string().trim().min(1) })
  .strict();
export const catalogMissionCreateSchema = z
  .object({
    reason,
    code: z.string().trim().min(1).max(20),
    stage: z.enum(['PREGNANCY', 'CHILD', 'ANY']),
    minAgeDays: z.number().int().nonnegative().max(2147483647).nullable(),
    maxAgeDays: z.number().int().nonnegative().max(2147483647).nullable(),
    minPregWeek: z.number().int().min(1).max(42).nullable(),
    maxPregWeek: z.number().int().min(1).max(42).nullable(),
    category: z.enum([
      'CARE',
      'BONDING',
      'PLAY',
      'OUTDOOR',
      'MEMORY',
      'TOGETHER',
      'SUPPORT',
      'SELF',
      'COUPLE',
      'PREP',
      'HOME',
    ]),
    suggestedScope: z.enum(['CHILD', 'MULTI_CHILD', 'FAMILY', 'COUPLE']),
    roleFit: z.enum([
      'ANY_PARENT',
      'PREGNANT_MOTHER',
      'PARTNER_OF_PREGNANT',
      'TOGETHER',
    ]),
    hearts: z.number().int().min(1).max(10),
    durationMin: z.number().int().positive().max(32767),
    multiChildOk: z.boolean(),
    requestable: z.boolean(),
    titleI18n: i18n,
    descI18n: i18n,
    memoryPromptI18n: i18n.optional(),
    tags: z.array(z.string().min(1)),
    weight: z.number().int().positive().max(32767),
    version: z.number().int().positive().max(2147483647),
  })
  .strict()
  .superRefine((item, ctx) => {
    if (item.suggestedScope === 'COUPLE' && item.roleFit !== 'TOGETHER')
      ctx.addIssue({
        code: 'custom',
        message: 'COUPLE requires TOGETHER roleFit',
      });
    if (
      (item.minAgeDays !== null &&
        item.maxAgeDays !== null &&
        item.minAgeDays > item.maxAgeDays) ||
      (item.minPregWeek !== null &&
        item.maxPregWeek !== null &&
        item.minPregWeek > item.maxPregWeek)
    )
      ctx.addIssue({
        code: 'custom',
        message: 'Mission age range is reversed',
      });
  });
export const catalogPlanCreateSchema = z
  .object({
    reason,
    planId: z.uuid(),
    version: z.number().int().positive().max(2147483647),
    quotas: z.record(
      z.string().min(1),
      z.number().int().nonnegative().max(Number.MAX_SAFE_INTEGER),
    ),
    features: z.record(z.string().min(1), z.boolean()),
    entitlementRank: z.number().int().nonnegative().max(2147483647),
  })
  .strict();
export const catalogTrialCreateSchema = z
  .object({
    reason,
    code: z.string().trim().min(1).max(60),
    version: z.number().int().positive().max(2147483647),
    planVersionId: z.uuid(),
    durationSeconds: z.number().int().positive().max(Number.MAX_SAFE_INTEGER),
    reminderOffsetsSeconds: z.array(
      z.number().int().positive().max(2147483647),
    ),
  })
  .strict()
  .refine(
    (item) =>
      item.reminderOffsetsSeconds.every(
        (offset) => offset < item.durationSeconds,
      ),
    'Trial reminder offset must be within duration',
  );
export const catalogPublishSchema = z
  .object({ reason, availableFrom: z.iso.datetime({ offset: true }) })
  .strict();
export const catalogMissionPublishSchema = z
  .object({ reason, rolloutPct: z.number().int().min(1).max(100).optional() })
  .strict();
export const catalogRetireSchema = z.object({ reason }).strict();
export type CatalogPublishingKind =
  'missions' | 'plan-versions' | 'trial-policies';
export type CatalogMissionInput = Omit<
  z.infer<typeof catalogMissionCreateSchema>,
  'reason'
>;
export type CatalogPlanInput = Omit<
  z.infer<typeof catalogPlanCreateSchema>,
  'reason'
>;
export type CatalogTrialInput = Omit<
  z.infer<typeof catalogTrialCreateSchema>,
  'reason'
>;
export type CatalogPublishingInput =
  CatalogMissionInput | CatalogPlanInput | CatalogTrialInput;
