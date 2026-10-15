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
  // SMTP (Mailpit locally). Optional: mail sending fails closed when absent.
  SMTP_HOST: optional(z.string().min(1)),
  SMTP_PORT: z.coerce.number().int().min(1).max(65535).default(587),
  SMTP_SECURE: booleanFlag(false),
  SMTP_REQUIRE_TLS: booleanFlag(false),
  // Explicit opt-out for a plaintext local sink (Mailpit) when running a production build.
  SMTP_ALLOW_INSECURE: booleanFlag(false),
  SMTP_USER: optional(z.string().min(1)),
  SMTP_PASSWORD: optional(z.string().min(1)),
  // Background worker (src/workers). Media tools must be on PATH or configured here.
  WORKER_ID: optional(z.string().min(1).max(100)),
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
  return issues;
}

export function validateEnvironment(input: Record<string, unknown>) {
  const result = environmentSchema.safeParse(input);
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
