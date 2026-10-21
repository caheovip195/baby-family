import { createHash } from 'node:crypto';
import { ConfigService } from '@nestjs/config';
import { createLocalJWKSet, exportJWK, generateKeyPair, SignJWT } from 'jose';
import type { JWTPayload } from 'jose';
import type { ExternalProvider } from '../../src/interfaces/services/external-identity-verifier.interface';
import { ExternalIdentityVerifierService } from '../../src/services/external-identity-verifier.service';

describe('ExternalIdentityVerifierService', () => {
  let service: ExternalIdentityVerifierService;
  let privateKey: CryptoKey;
  let otherPrivateKey: CryptoKey;
  const issuer = 'https://identity.example.test';
  const audience = 'baby-family-client';
  const values: Record<string, string> = {};
  beforeAll(async () => {
    const pair = await generateKeyPair('RS256');
    privateKey = pair.privateKey;
    otherPrivateKey = (await generateKeyPair('RS256')).privateKey;
    const jwk = await exportJWK(pair.publicKey);
    const keySet = createLocalJWKSet({ keys: [{ ...jwk, kid: 'local' }] });
    for (const provider of ['APPLE', 'GOOGLE']) {
      values[`AUTH_${provider}_ISSUER`] = issuer;
      values[`AUTH_${provider}_CLIENT_ID`] = audience;
      values[`AUTH_${provider}_JWKS_URL`] = `${issuer}/keys`;
    }
    service = new ExternalIdentityVerifierService(new ConfigService(values), {
      getKeySet: () => keySet,
    });
  });
  function sign(claims: JWTPayload = {}, key = privateKey) {
    const now = Math.floor(Date.now() / 1000);
    return new SignJWT({
      sub: 'subject',
      iss: issuer,
      aud: audience,
      iat: now - 10,
      exp: now + 60,
      ...claims,
    })
      .setProtectedHeader({ alg: 'RS256', kid: 'local' })
      .sign(key);
  }
  it.each<ExternalProvider>(['APPLE', 'GOOGLE'])(
    'verifies %s through a local JWKS without network',
    async (provider) => {
      await expect(
        service.verify(
          provider,
          await sign({
            email: 'parent@example.test',
            email_verified: true,
          }),
        ),
      ).resolves.toEqual({
        provider,
        subject: 'subject',
        email: 'parent@example.test',
      });
    },
  );
  it('only returns verified email; handles Apple string true', async () => {
    for (const email_verified of [false, 'true', undefined]) {
      await expect(
        service.verify(
          'GOOGLE',
          await sign({
            email: 'parent@example.test',
            email_verified,
          }),
        ),
      ).resolves.toMatchObject({ email: null });
    }
    await expect(
      service.verify(
        'APPLE',
        await sign({
          email: 'relay@example.test',
          email_verified: 'true',
        }),
      ),
    ).resolves.toMatchObject({ email: 'relay@example.test' });
  });
  it.each([
    ['audience', { aud: 'other' }],
    ['issuer', { iss: 'https://other.test' }],
    ['expiry', { exp: 1 }],
    ['missing expiry', { exp: undefined }],
    ['missing issued at', { iat: undefined }],
    ['future issued at', { iat: 9999999999 }],
    ['empty subject', { sub: '' }],
    ['oversized subject', { sub: 'a'.repeat(256) }],
    ['non-string subject', { sub: 123 }],
  ])('rejects invalid %s', async (_label, claims) => {
    await expect(
      service.verify('GOOGLE', await sign(claims as JWTPayload)),
    ).rejects.toMatchObject({ code: 'AUTH_IDENTITY_INVALID', statusCode: 401 });
  });
  it('rejects invalid signature and malformed token', async () => {
    for (const token of [await sign({}, otherPrivateKey), 'not-a-jwt']) {
      await expect(service.verify('GOOGLE', token)).rejects.toMatchObject({
        code: 'AUTH_IDENTITY_INVALID',
        statusCode: 401,
      });
    }
  });

  it.each(['not-an-email', 'a@b', 'a'.repeat(250) + '@example.test'])(
    'does not return malformed or oversized verified email',
    async (email) => {
      await expect(
        service.verify(
          'GOOGLE',
          await sign({
            email,
            email_verified: true,
          }),
        ),
      ).resolves.toMatchObject({ email: null });
    },
  );
  it('compares Apple nonce against SHA256 only', async () => {
    const nonce = 'client-random-nonce';
    await expect(
      service.verify(
        'APPLE',
        await sign({
          nonce: createHash('sha256').update(nonce).digest('hex'),
        }),
        nonce,
      ),
    ).resolves.toMatchObject({ subject: 'subject' });
    for (const claims of [{ nonce }, {}, { nonce: 'wrong' }]) {
      await expect(
        service.verify('APPLE', await sign(claims), nonce),
      ).rejects.toMatchObject({
        code: 'AUTH_IDENTITY_INVALID',
        statusCode: 401,
      });
    }
  });
  it.each(['JWKS_URL', 'ISSUER', 'CLIENT_ID'])(
    'fails closed without %s',
    async (suffix) => {
      const config = { ...values };
      delete config[`AUTH_GOOGLE_${suffix}`];
      const unconfigured = new ExternalIdentityVerifierService(
        new ConfigService(config),
      );
      await expect(
        unconfigured.verify('GOOGLE', await sign()),
      ).rejects.toMatchObject({
        code: 'AUTH_PROVIDER_UNAVAILABLE',
        statusCode: 503,
      });
    },
  );
  it('classifies resolver outage as unavailable', async () => {
    const offline = new ExternalIdentityVerifierService(
      new ConfigService(values),
      {
        getKeySet: () => () => Promise.reject(new TypeError('fetch failed')),
      },
    );
    await expect(offline.verify('APPLE', await sign())).rejects.toMatchObject({
      code: 'AUTH_PROVIDER_UNAVAILABLE',
      statusCode: 503,
    });
  });
  it('rejects unknown key id', async () => {
    const token = await new SignJWT({ sub: 'subject' })
      .setProtectedHeader({ alg: 'RS256', kid: 'unknown' })
      .sign(privateKey);
    await expect(service.verify('GOOGLE', token)).rejects.toMatchObject({
      code: 'AUTH_IDENTITY_INVALID',
      statusCode: 401,
    });
  });

  it('rejects algorithms outside RS256', async () => {
    const token = await new SignJWT({ sub: 'subject' })
      .setProtectedHeader({ alg: 'HS256' })
      .sign(new Uint8Array(32));
    await expect(service.verify('GOOGLE', token)).rejects.toMatchObject({
      code: 'AUTH_IDENTITY_INVALID',
      statusCode: 401,
    });
  });

  it.each(['not-a-url', 'http://identity.example.test/keys'])(
    'fails closed with invalid JWKS endpoint %s',
    async (url) => {
      const unconfigured = new ExternalIdentityVerifierService(
        new ConfigService({ ...values, AUTH_GOOGLE_JWKS_URL: url }),
      );
      await expect(
        unconfigured.verify('GOOGLE', await sign()),
      ).rejects.toMatchObject({
        code: 'AUTH_PROVIDER_UNAVAILABLE',
        statusCode: 503,
      });
    },
  );
});
