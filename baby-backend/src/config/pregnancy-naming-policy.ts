/** PREG-07 technical limits; billing rights still come from the family catalog. */
export const PREGNANCY_NAMING_POLICY = {
  version: 1,
  maxNames: 100,
  maxNameLength: 60,
  maxMeaningLength: 200,
  milestoneTemplateCode: 'name_chosen',
  milestoneTitle: 'Chọn được tên',
  memoryIdempotencyRetentionMs: 24 * 60 * 60 * 1000,
} as const;

export function cleanPregnancyName(value: string): string {
  return value.normalize('NFC').trim().replace(/\s+/gu, ' ');
}

export function normalizePregnancyName(value: string): string {
  return cleanPregnancyName(value).toLocaleLowerCase('vi');
}
