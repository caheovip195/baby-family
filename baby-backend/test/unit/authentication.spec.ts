import { randomUUID } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { generateKeyPair, exportSPKI, SignJWT } from 'jose';
import type { JWTPayload } from 'jose';
import type { Environment } from '../../src/config/environment';
import { validateEnvironment } from '../../src/config/environment';
import { AuthenticationService } from '../../src/services/authentication.service';
import { AuthSessionState } from '../../src/models/auth-session-state.model';
import type { IAuthAccessRepository } from '../../src/interfaces/repositories/auth-access-repository.interface';

describe('ES256 access authentication and live session validation', () => {
  const userId = randomUUID();
  const sessionId = randomUUID();
  const repository: jest.Mocked<IAuthAccessRepository> = {
    findUserSessionState: jest.fn(),
    findFamilyAccessState: jest.fn(),
  };
  let keys: Awaited<ReturnType<typeof generateKeyPair>>;
  let pem: string;
  let service: AuthenticationService;
  const configuration = (publicKey?: string) =>
    new ConfigService<Environment, true>(
      validateEnvironment({
        DATABASE_URL: 'postgresql://test:temporary@localhost/auth_test',
        ...(publicKey ? { AUTH_JWT_PUBLIC_KEY: publicKey } : {}),
      }),
    );
  const token = (claims: JWTPayload = {}, typ = 'at+jwt') => {
    const now = Math.floor(Date.now() / 1000);
    return new SignJWT({
      sub: userId,
      sid: sessionId,
      ver: 3,
      iss: 'baby-family',
      aud: 'baby-family-app',
      iat: now,
      exp: now + 900,
      ...claims,
    })
      .setProtectedHeader({ alg: 'ES256', typ })
      .sign(keys.privateKey);
  };

  beforeAll(async () => {
    keys = await generateKeyPair('ES256');
    pem = await exportSPKI(keys.publicKey);
    service = new AuthenticationService(configuration(pem), repository);
    await service.onModuleInit();
  });
  beforeEach(() => {
    repository.findUserSessionState.mockResolvedValue(
      new AuthSessionState({
        userId,
        sessionId,
        tokenVersion: 3,
      }),
    );
  });

  it('uses the verified subject/session and ignores client role/family claims', async () => {
    const result = await service.verifyAccessToken(
      await token({ familyId: randomUUID(), role: 'ADMIN' }),
    );
    expect(result).toEqual({ userId, sessionId, tokenVersion: 3 });
    expect(repository.findUserSessionState).toHaveBeenCalledWith(
      sessionId,
      userId,
      expect.any(Date),
    );
    expect(result).not.toHaveProperty('role');
  });
  it.each([
    { iss: 'other-issuer' },
    { aud: 'baby-family-admin' },
    { exp: 1 },
    { exp: Math.floor(Date.now() / 1000) + 3600 },
    { iat: Math.floor(Date.now() / 1000) + 60 },
    { sub: 'not-a-uuid' },
    { sid: 'not-a-uuid' },
    { ver: -1 },
    { ver: '3' },
    { scope: 'reauth' },
  ])('rejects invalid claims before database access: %j', async (claims) => {
    await expect(
      service.verifyAccessToken(await token(claims)),
    ).rejects.toMatchObject({ status: 401 });
    expect(repository.findUserSessionState).not.toHaveBeenCalled();
  });
  it('rejects wrong JWT type, HS256, malformed and forged signatures', async () => {
    await expect(
      service.verifyAccessToken(await token({}, 'reauth+jwt')),
    ).rejects.toMatchObject({ status: 401 });
    const hs = await new SignJWT({ sub: userId })
      .setProtectedHeader({ alg: 'HS256', typ: 'at+jwt' })
      .sign(new Uint8Array(32));
    await expect(service.verifyAccessToken(hs)).rejects.toMatchObject({
      status: 401,
    });
    await expect(service.verifyAccessToken('malformed')).rejects.toMatchObject({
      status: 401,
    });
    const valid = await token();
    const parts = valid.split('.');
    parts[2] = 'X' + parts[2]!.slice(1);
    if (parts.join('.') === valid) parts[2] = 'Y' + parts[2].slice(1);
    await expect(
      service.verifyAccessToken(parts.join('.')),
    ).rejects.toMatchObject({ status: 401 });
    expect(repository.findUserSessionState).not.toHaveBeenCalled();
  });
  it('rejects a revoked/expired/replaced session and tokenVersion mismatch', async () => {
    repository.findUserSessionState.mockResolvedValueOnce(null);
    await expect(
      service.verifyAccessToken(await token()),
    ).rejects.toMatchObject({ status: 401 });
    repository.findUserSessionState.mockResolvedValueOnce(
      new AuthSessionState({ userId, sessionId, tokenVersion: 4 }),
    );
    await expect(
      service.verifyAccessToken(await token()),
    ).rejects.toMatchObject({ status: 401 });
  });
  it('distinguishes database outage and missing configuration from bad credentials', async () => {
    repository.findUserSessionState.mockRejectedValueOnce(
      new Error('database unavailable'),
    );
    await expect(
      service.verifyAccessToken(await token()),
    ).rejects.toMatchObject({ status: 503 });
    const unconfigured = new AuthenticationService(configuration(), repository);
    await expect(
      unconfigured.verifyAccessToken(await token()),
    ).rejects.toMatchObject({ status: 503 });
  });
  it('fails startup on a configured invalid public key without disclosing it', async () => {
    const invalid = new AuthenticationService(
      configuration('invalid-key-content'),
      repository,
    );
    await expect(invalid.onModuleInit()).rejects.toThrow(
      'Invalid AUTH_JWT_PUBLIC_KEY',
    );
    await expect(invalid.onModuleInit()).rejects.not.toThrow(
      'invalid-key-content',
    );
  });
});
