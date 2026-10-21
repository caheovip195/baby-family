import { z } from 'zod';

// Empty strings come from Compose `${VAR:-}` defaults; treat them as "not configured".
const optional = <T extends z.ZodType>(schema: T) =>
  z.preprocess(
    (value) => (value === '' ? undefined : value),
    schema.optional(),
  );
const booleanFlag = (fallback: boolean) =>
  z
    .enum(['true', 'false'])
    .optional()
    .transform((value) => (value === undefined ? fallback : value === 'true'));
const bucketName = (fallback: string) =>
  z
    .string()
    .regex(/^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$/, 'Expected an S3 bucket name')
    .default(fallback);

const environmentSchema = z.object({
  NODE_ENV: z
    .enum(['development', 'test', 'production'])
    .default('development'),
  HOST: z.string().min(1).default('0.0.0.0'),
  PORT: z.coerce.number().int().min(1).max(65535).default(3000),
  DATABASE_URL: z
    .url()
    .refine(
      (url) => /^postgres(ql)?:\/\//.test(url),
      'Expected a PostgreSQL URL',
    ),
  DATABASE_POOL_SIZE: z.coerce.number().int().min(1).max(100).default(10),
  AUTH_JWT_PUBLIC_KEY: z.preprocess(
    (value) => (value === '' ? undefined : value),
    z.string().min(1).optional(),
  ),
  AUTH_JWT_ISSUER: z.string().min(1).default('baby-family'),
  AUTH_JWT_AUDIENCE: z.string().min(1).default('baby-family-app'),
  // Token issuance (spec §5.1): ES256 PKCS#8 private key. Absent → sign-in endpoints fail closed (503).
  AUTH_JWT_PRIVATE_KEY: optional(z.string().min(1)),
  // HMAC pepper for phone/OTP/invite-code/identity hashes (spec §5.3, §6.5). Required to issue tokens.
  AUTH_SECRET_PEPPER: optional(z.string().min(32)),
  // Social identity verification is opt-in; missing provider settings fail closed.
  AUTH_APPLE_JWKS_URL: optional(z.url()),
  AUTH_APPLE_ISSUER: optional(z.string().min(1)),
  AUTH_APPLE_CLIENT_ID: optional(z.string().min(1)),
  AUTH_GOOGLE_JWKS_URL: optional(z.url()),
  AUTH_GOOGLE_ISSUER: optional(z.string().min(1)),
  AUTH_GOOGLE_CLIENT_ID: optional(z.string().min(1)),
  // AES-256-GCM root key (base64, 32 bytes) for Papa & Mama check-in notes (spec §7.16.1).
  // Absent → creating/reading a note fails closed (503 CHECKIN_ENCRYPTION_UNAVAILABLE).
  COUPLE_CHECKIN_ENCRYPTION_KEY: optional(
    z.string().refine((value) => Buffer.from(value, 'base64').length === 32, {
      message: 'must be 32 bytes encoded as base64',
    }),
  ),
  // AES-256-GCM key (base64, 32 bytes) for support ticket content. Absent → support
  // endpoints that store/read content fail closed (503 SUPPORT_ENCRYPTION_UNAVAILABLE).
  // Admin CMS (separate from app auth): base64 32-byte keys for TOTP secrets at
  // rest and for signing admin session tokens. Absent → admin login fails closed.
  ADMIN_CMS_TOTP_ENCRYPTION_KEY: optional(
    z.string().refine((value) => Buffer.from(value, 'base64').length === 32, {
      message: 'must be 32 bytes encoded as base64',
    }),
  ),
  ADMIN_CMS_TOKEN_SECRET: optional(
    z.string().refine((value) => Buffer.from(value, 'base64').length === 32, {
      message: 'must be 32 bytes encoded as base64',
    }),
  ),
  // SET-11/12: public support contact and legal links (unset → hidden in the app).
  SUPPORT_CONTACT_EMAIL: optional(z.string().email()),
  SUPPORT_CONTACT_HOTLINE: optional(z.string().min(3).max(32)),
  LEGAL_TERMS_URL: optional(z.string().url()),
  LEGAL_PRIVACY_URL: optional(z.string().url()),
  LEGAL_LICENSES_URL: optional(z.string().url()),
  SUPPORT_ENCRYPTION_KEY: optional(
    z.string().refine((value) => Buffer.from(value, 'base64').length === 32, {
      message: 'must be 32 bytes encoded as base64',
    }),
  ),
  // OTP delivery: `mail` writes the code to a local mailbox (Mailpit) and is rejected in production.
  AUTH_OTP_DELIVERY: z.enum(['disabled', 'mail']).default('disabled'),
  AUTH_OTP_MAIL_TO: z.string().min(3).default('otp-inbox@babyfamily.local'),
  // Explicit opt-out for the local Compose stack, which runs a production build.
  AUTH_OTP_ALLOW_MAIL_IN_PRODUCTION: booleanFlag(false),
  // Country calling codes accepted for OTP (anti SMS-pumping, spec §5.3), comma separated.
  AUTH_OTP_ALLOWED_COUNTRY_CODES: z
    .string()
    .default('84')
    .transform((value) =>
      value
        .split(',')
        .map((code) => code.trim())
        .filter(Boolean),
    )
    .pipe(z.array(z.string().regex(/^[1-9][0-9]{0,2}$/)).min(1)),
  INVITE_LINK_BASE_URL: z.url().default('https://babyfamily.vn/i/'),
  CORS_ORIGINS: z
    .string()
    .default('http://localhost:3000')
    .transform((value) =>
      value
        .split(',')
        .map((origin) => origin.trim())
        .filter(Boolean),
    )
    .pipe(z.array(z.url())),
  LOG_FORMAT: z.enum(['json', 'pretty']).default('json'),
  METRICS_TOKEN: optional(z.string().min(32).max(512)),
  ERROR_REPORTING_DSN: optional(
    z.url().refine((value) => {
      const url = new URL(value);
      return (
        url.protocol === 'https:' &&
        Boolean(url.username) &&
        !url.password &&
        /^\/(?:[^/]+\/)*[0-9]+$/.test(url.pathname) &&
        !url.search &&
        !url.hash
      );
    }, 'Expected an HTTPS Sentry DSN with public key and numeric project ID'),
  ),
  LOG_LEVEL: z
    .enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent'])
    .default('info'),
  SWAGGER_ENABLED: z
    .enum(['true', 'false'])
    .optional()
    .transform((value) => (value === undefined ? undefined : value === 'true')),
  THROTTLE_TTL_MS: z.coerce.number().int().min(1).default(60000),
  THROTTLE_LIMIT: z.coerce.number().int().min(1).default(100),
  // Valkey/Redis (spec §9). Optional: cache/rate-limit storage fail closed or fall back when absent.
  REDIS_URL: optional(
    z
      .url()
      .refine(
        (url) => /^rediss?:\/\//.test(url),
        'Expected a redis:// or rediss:// URL',
      ),
  ),
  // S3-compatible object storage (spec §10). All-or-none; never use the storage root key.
  S3_ENDPOINT: optional(z.url()),
  S3_PUBLIC_ENDPOINT: optional(z.url()),
  S3_REGION: z.string().min(1).default('us-east-1'),
  S3_ACCESS_KEY_ID: optional(z.string().min(3)),
  S3_SECRET_ACCESS_KEY: optional(z.string().min(8)),
  S3_FORCE_PATH_STYLE: booleanFlag(true),
  S3_BUCKET_MEDIA: bucketName('bf-media'),
  S3_BUCKET_USER_MEDIA: bucketName('bf-user-media'),
  S3_BUCKET_EXPORTS: bucketName('bf-exports'),
  S3_BUCKET_PUBLIC: bucketName('bf-public'),
  MAIL_HOST: optional(z.string().min(1)),
  // SMTP (Mailpit locally). Optional: mail sending fails closed when absent.
  SMTP_HOST: optional(z.string().min(1)),
  SMTP_PORT: z.coerce.number().int().min(1).max(65535).default(587),
  SMTP_SECURE: booleanFlag(false),
  SMTP_REQUIRE_TLS: booleanFlag(false),
  // Explicit opt-out for a plaintext local sink (Mailpit) when running a production build.
  SMTP_ALLOW_INSECURE: booleanFlag(false),
  SMTP_USER: optional(z.string().min(1)),
  SMTP_PASSWORD: optional(z.string().min(1)),
  // Optional HTTP v1 push credentials. Absence selects a disabled provider.
  FCM_PROJECT_ID: optional(z.string().regex(/^[a-z][a-z0-9-]{4,62}$/)),
  FCM_SERVICE_ACCOUNT_JSON: optional(z.string().min(1)),
  FCM_SERVICE_ACCOUNT_FILE: optional(z.string().min(1)),
  // Background worker (src/workers). Media tools must be on PATH or configured here.
  WORKER_ID: optional(z.string().min(1).max(100)),
  MEDIA_SERVER_PROCESSING: z.enum(['disabled', 'legacy']).default('disabled'),
  MEDIA_WORKER_CONCURRENCY: z.coerce.number().int().min(1).max(16).default(2),
  FFMPEG_PATH: z.string().min(1).default('ffmpeg'),
  FFPROBE_PATH: z.string().min(1).default('ffprobe'),
  /** Opt-in: purge UPLOADED assets never attached after this many hours (spec §10.2). */
  MEDIA_PURGE_UNATTACHED_AFTER_HOURS: optional(
    z.coerce
      .number()
      .int()
      .min(24)
      .max(24 * 365),
  ),
  SMTP_FROM: z
    .string()
    .min(3)
    .default('Baby Family <no-reply@babyfamily.local>'),
});

type ParsedEnvironment = z.infer<typeof environmentSchema>;

function crossFieldIssues(env: ParsedEnvironment): string[] {
  const issues: string[] = [];
  const s3 = [env.S3_ENDPOINT, env.S3_ACCESS_KEY_ID, env.S3_SECRET_ACCESS_KEY];
  if (s3.some(Boolean) && !s3.every(Boolean)) {
    issues.push(
      'S3_ENDPOINT/S3_ACCESS_KEY_ID/S3_SECRET_ACCESS_KEY: set all or none',
    );
  }
  if (Boolean(env.SMTP_USER) !== Boolean(env.SMTP_PASSWORD)) {
    issues.push('SMTP_USER/SMTP_PASSWORD: set both or neither');
  }
  if (
    env.NODE_ENV === 'production' &&
    env.SMTP_HOST &&
    !env.SMTP_SECURE &&
    !env.SMTP_REQUIRE_TLS &&
    !env.SMTP_ALLOW_INSECURE
  ) {
    issues.push(
      'SMTP_SECURE/SMTP_REQUIRE_TLS: production SMTP must use TLS (or SMTP_ALLOW_INSECURE=true for a local sink)',
    );
  }
  if (env.AUTH_JWT_PRIVATE_KEY && !env.AUTH_SECRET_PEPPER) {
    issues.push(
      'AUTH_SECRET_PEPPER: required when AUTH_JWT_PRIVATE_KEY is set',
    );
  }
  if (
    env.NODE_ENV === 'production' &&
    env.AUTH_OTP_DELIVERY === 'mail' &&
    !env.AUTH_OTP_ALLOW_MAIL_IN_PRODUCTION
  ) {
    issues.push(
      'AUTH_OTP_DELIVERY: the local mail sink must not deliver OTP in production (AUTH_OTP_ALLOW_MAIL_IN_PRODUCTION=true only for the local stack)',
    );
  }
  return issues;
}

export function validateEnvironment(input: Record<string, unknown>) {
  // MAIL_* aliases share the existing adapter and production TLS validation.
  const normalized = { ...input };
  for (const key of [
    'HOST',
    'PORT',
    'USER',
    'PASSWORD',
    'FROM',
    'SECURE',
    'REQUIRE_TLS',
    'ALLOW_INSECURE',
  ]) {
    if (input[`MAIL_${key}`] !== undefined && input[`MAIL_${key}`] !== '')
      normalized[`SMTP_${key}`] = input[`MAIL_${key}`];
  }
  const result = environmentSchema.safeParse(normalized);
  if (!result.success) {
    // Never include environment values (which may contain secrets) in validation errors.
    const fields = result.error.issues.map(
      (issue) => `${issue.path.join('.')}: ${issue.message}`,
    );
    throw new Error(`Invalid environment configuration: ${fields.join('; ')}`);
  }
  const issues = crossFieldIssues(result.data);
  if (issues.length > 0) {
    throw new Error(`Invalid environment configuration: ${issues.join('; ')}`);
  }
  return {
    ...result.data,
    SWAGGER_ENABLED:
      result.data.SWAGGER_ENABLED ?? result.data.NODE_ENV !== 'production',
    S3_PUBLIC_ENDPOINT:
      result.data.S3_PUBLIC_ENDPOINT ?? result.data.S3_ENDPOINT,
  };
}

export type Environment = ReturnType<typeof validateEnvironment>;
