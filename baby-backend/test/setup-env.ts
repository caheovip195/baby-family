process.env.NODE_ENV = 'test';
process.env.LOG_LEVEL = 'silent';
process.env.SWAGGER_ENABLED = 'true';
process.env.DATABASE_URL =
  process.env.TEST_DATABASE_URL ??
  process.env.DATABASE_URL ??
  'postgresql://baby:baby_local_only@localhost:5433/baby_family_test?schema=public';
// Supporting services stay disabled unless explicitly provided (ConfigModule would
// otherwise read them from a developer's .env). Storage integration tests opt in.
for (const name of [
  'FCM_PROJECT_ID',
  'FCM_SERVICE_ACCOUNT_JSON',
  'FCM_SERVICE_ACCOUNT_FILE',
  'REDIS_URL',
  'S3_ENDPOINT',
  'S3_PUBLIC_ENDPOINT',
  'S3_ACCESS_KEY_ID',
  'S3_SECRET_ACCESS_KEY',
  'SMTP_HOST',
  'SMTP_USER',
  'SMTP_PASSWORD',
  'AUTH_JWT_PRIVATE_KEY',
  'AUTH_SECRET_PEPPER',
  'COUPLE_CHECKIN_ENCRYPTION_KEY',
]) {
  process.env[name] = '';
}
// Token issuance and OTP delivery stay off unless a suite configures them explicitly.
process.env.AUTH_OTP_DELIVERY = 'disabled';
