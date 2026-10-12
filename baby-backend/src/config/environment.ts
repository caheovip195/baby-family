import { z } from 'zod';

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
});

export function validateEnvironment(input: Record<string, unknown>) {
  const result = environmentSchema.safeParse(input);
  if (!result.success) {
    // Never include environment values (which may contain secrets) in validation errors.
    const fields = result.error.issues.map(
      (issue) => `${issue.path.join('.')}: ${issue.message}`,
    );
    throw new Error(`Invalid environment configuration: ${fields.join('; ')}`);
  }
  return {
    ...result.data,
    SWAGGER_ENABLED:
      result.data.SWAGGER_ENABLED ?? result.data.NODE_ENV !== 'production',
  };
}

export type Environment = ReturnType<typeof validateEnvironment>;
