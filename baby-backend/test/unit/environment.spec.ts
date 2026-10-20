import { validateEnvironment } from '../../src/config/environment';

const valid = { DATABASE_URL: 'postgresql://user:secret@localhost:5432/test' };

describe('environment validation', () => {
  it('parses typed config and defaults Swagger off in production', () => {
    const env = validateEnvironment({
      ...valid,
      NODE_ENV: 'production',
      PORT: '3001',
      CORS_ORIGINS: 'https://example.com, http://localhost:5173',
    });
    expect(env.PORT).toBe(3001);
    expect(env.SWAGGER_ENABLED).toBe(false);
    expect(env.CORS_ORIGINS).toEqual([
      'https://example.com',
      'http://localhost:5173',
    ]);
  });
  it('fails fast on invalid settings without exposing values', () => {
    expect(() => validateEnvironment({ ...valid, PORT: '-1' })).toThrow('PORT');
    expect(() =>
      validateEnvironment({
        DATABASE_URL: 'mysql://user:super-secret@localhost/db',
      }),
    ).toThrow('Expected a PostgreSQL URL');
    try {
      validateEnvironment({ DATABASE_URL: 'super-secret' });
    } catch (error) {
      expect(String(error)).not.toContain('super-secret');
    }
  });
  it('requires a pepper with a signing key and keeps the OTP mail sink out of production', () => {
    expect(() =>
      validateEnvironment({ ...valid, AUTH_JWT_PRIVATE_KEY: 'pem' }),
    ).toThrow('AUTH_SECRET_PEPPER');
    expect(() =>
      validateEnvironment({ ...valid, AUTH_SECRET_PEPPER: 'too-short' }),
    ).toThrow('AUTH_SECRET_PEPPER');
    expect(() =>
      validateEnvironment({
        ...valid,
        NODE_ENV: 'production',
        AUTH_OTP_DELIVERY: 'mail',
      }),
    ).toThrow('AUTH_OTP_DELIVERY');
    const local = validateEnvironment({
      ...valid,
      NODE_ENV: 'production',
      AUTH_OTP_DELIVERY: 'mail',
      AUTH_OTP_ALLOW_MAIL_IN_PRODUCTION: 'true',
    });
    expect(local.AUTH_OTP_DELIVERY).toBe('mail');
    expect(validateEnvironment(valid).AUTH_OTP_DELIVERY).toBe('disabled');
    expect(validateEnvironment(valid).AUTH_OTP_ALLOWED_COUNTRY_CODES).toEqual([
      '84',
    ]);
  });
});
