/** SET-11 catalog; publish a new version when changing category codes. */
export const SUPPORT_HELPDESK_POLICY = {
  version: 1,
  categories: ['ACCOUNT', 'INVITATION', 'MEDIA', 'BILLING', 'PRIVACY', 'OTHER'],
  subjectMax: 200,
  bodyMax: 10000,
  attachmentsMax: 5,
  pageSize: 50,
} as const;
