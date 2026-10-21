import { execFileSync } from 'node:child_process';
import { createPrivateKey, X509Certificate } from 'node:crypto';
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { ConfigService } from '@nestjs/config';
import { CompactSign } from 'jose';
import type { IStorePublisher } from '../../src/interfaces/services/store-publisher.interface';
import type { VerifiedStorePurchase } from '../../src/interfaces/services/store-verifier.interface';
import { StoreVerifierService } from '../../src/services/store-verifier.service';
import { StorePublisherService } from '../../src/services/store-publisher.service';

describe('StoreVerifierService', () => {
  let folder: string;
  let root: string;
  let x5c: string[];
  let settings: Record<string, string>;
  let publisher: jest.Mocked<IStorePublisher>;
  let service: StoreVerifierService;
  const transaction = () => ({
    transactionId: 'transaction',
    originalTransactionId: 'original',
    productId: 'product',
    appAccountToken: 'account',
    bundleId: 'vn.babyfamily.app',
    environment: 'Sandbox',
    signedDate: Date.now(),
    purchaseDate: Date.now() - 1000,
    expiresDate: Date.now() + 3600000,
  });
  const sign = async (payload: Record<string, unknown>, certs = x5c) =>
    new CompactSign(Buffer.from(JSON.stringify(payload)))
      .setProtectedHeader({ alg: 'ES256', x5c: certs })
      .sign(createPrivateKey(readFileSync(join(folder, 'leaf.key'))));
  const play = (): VerifiedStorePurchase => ({
    store: 'PLAY',
    transactionId: 'order',
    originalTransactionId: 'stable',
    productId: 'product',
    accountToken: 'account',
    appNamespace: 'vn.babyfamily.app',
    startsAt: new Date(),
    expiresAt: new Date(Date.now() + 3600000),
    autoRenew: true,
    environment: 'Sandbox',
    raw: {},
  });
  beforeAll(() => {
    folder = mkdtempSync(join(tmpdir(), 'bf-store-verifier-'));
    const openssl = (...args: string[]) =>
      execFileSync('openssl', args, { cwd: folder, stdio: 'pipe' });
    openssl(
      'req',
      '-x509',
      '-newkey',
      'ec',
      '-pkeyopt',
      'ec_paramgen_curve:P-256',
      '-nodes',
      '-keyout',
      'root.key',
      '-out',
      'root.pem',
      '-days',
      '1',
      '-subj',
      '/CN=Test Root',
      '-addext',
      'basicConstraints=critical,CA:TRUE',
      '-addext',
      '1.2.840.113635.100.6.2.1=ASN1:NULL',
    );
    openssl(
      'req',
      '-newkey',
      'ec',
      '-pkeyopt',
      'ec_paramgen_curve:P-256',
      '-nodes',
      '-keyout',
      'leaf.key',
      '-out',
      'leaf.csr',
      '-subj',
      '/CN=Test Store Signing',
    );
    writeFileSync(
      join(folder, 'leaf.ext'),
      'basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature\n1.2.840.113635.100.6.11.1=ASN1:NULL\n',
    );
    openssl(
      'x509',
      '-req',
      '-in',
      'leaf.csr',
      '-CA',
      'root.pem',
      '-CAkey',
      'root.key',
      '-CAcreateserial',
      '-out',
      'leaf.pem',
      '-days',
      '1',
      '-extfile',
      'leaf.ext',
    );
    writeFileSync(
      join(folder, 'no-purpose.ext'),
      'basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature\n',
    );
    openssl(
      'x509',
      '-req',
      '-in',
      'leaf.csr',
      '-CA',
      'root.pem',
      '-CAkey',
      'root.key',
      '-CAcreateserial',
      '-out',
      'no-purpose.pem',
      '-days',
      '1',
      '-extfile',
      'no-purpose.ext',
    );
    root = readFileSync(join(folder, 'root.pem'), 'utf8');
    x5c = ['leaf.pem', 'root.pem'].map((name) =>
      new X509Certificate(readFileSync(join(folder, name))).raw.toString(
        'base64',
      ),
    );
  });
  afterAll(() => rmSync(folder, { recursive: true, force: true }));
  beforeEach(() => {
    settings = {
      APP_STORE_ROOT_CERTIFICATES_JSON: JSON.stringify([root]),
      APP_STORE_BUNDLE_ID: 'vn.babyfamily.app',
      APP_STORE_ENVIRONMENT: 'Sandbox',
      PLAY_PACKAGE_NAME: 'vn.babyfamily.app',
      PLAY_WEBHOOK_TOKEN: 'secret',
    };
    publisher = { getSubscription: jest.fn().mockResolvedValue(play()) };
    service = new StoreVerifierService(new ConfigService(settings), publisher);
  });
  it('verifies a trusted x5c JWS and expected product/account', async () => {
    expect(
      await service.verifyPurchase({
        store: 'APP_STORE',
        signedTransaction: await sign(transaction()),
        productId: 'product',
        accountToken: 'account',
      }),
    ).toMatchObject({
      transactionId: 'transaction',
      originalTransactionId: 'original',
      appNamespace: 'vn.babyfamily.app',
    });
  });
  it.each(['bundleId', 'environment', 'appAccountToken', 'productId'])(
    'rejects mismatched %s',
    async (field) => {
      await expect(
        service.verifyPurchase({
          store: 'APP_STORE',
          signedTransaction: await sign({ ...transaction(), [field]: 'wrong' }),
          productId: 'product',
          accountToken: 'account',
        }),
      ).rejects.toMatchObject({ code: 'STORE_VERIFICATION_FAILED' });
    },
  );
  it('rejects payload tampering and untrusted certificate chains', async () => {
    const jws = await sign(transaction());
    const parts = jws.split('.');
    parts[1] = Buffer.from(
      JSON.stringify({ ...transaction(), productId: 'forged' }),
    ).toString('base64url');
    await expect(
      service.verifyPurchase({
        store: 'APP_STORE',
        signedTransaction: parts.join('.'),
      }),
    ).rejects.toMatchObject({ code: 'STORE_VERIFICATION_FAILED' });
    settings.APP_STORE_ROOT_CERTIFICATES_JSON = JSON.stringify([]);
    await expect(
      service.verifyPurchase({ store: 'APP_STORE', signedTransaction: jws }),
    ).rejects.toMatchObject({ code: 'STORE_VERIFICATION_FAILED' });
  });
  it('rejects missing config, missing x5c, future dates and invalid certificate dates', async () => {
    for (const signedDate of [Date.now() + 600000, 1000])
      await expect(
        service.verifyPurchase({
          store: 'APP_STORE',
          signedTransaction: await sign({ ...transaction(), signedDate }),
        }),
      ).rejects.toMatchObject({ code: 'STORE_VERIFICATION_FAILED' });
    await expect(
      service.verifyPurchase({
        store: 'APP_STORE',
        signedTransaction: await sign(transaction(), []),
      }),
    ).rejects.toMatchObject({ code: 'STORE_VERIFICATION_FAILED' });
    delete settings.APP_STORE_ROOT_CERTIFICATES_JSON;
    await expect(
      service.verifyPurchase({ store: 'APP_STORE', signedTransaction: 'x' }),
    ).rejects.toMatchObject({
      code: 'STORE_VERIFIER_UNAVAILABLE',
      statusCode: 503,
    });
  });
  it.each([
    ['DID_RENEW', undefined, 'RENEWED'],
    ['EXPIRED', undefined, 'EXPIRED'],
    ['REFUND', undefined, 'REVOKED'],
    ['REVOKE', undefined, 'REVOKED'],
    ['DID_FAIL_TO_RENEW', 'GRACE_PERIOD', 'GRACE'],
    ['DID_CHANGE_RENEWAL_STATUS', undefined, 'AUTO_RENEW_CHANGED'],
  ])(
    'verifies nested Apple notification %s',
    async (notificationType, subtype, type) => {
      const signedPayload = await sign({
        signedDate: Date.now(),
        notificationType,
        subtype,
        notificationUUID: 'event',
        data: {
          bundleId: 'vn.babyfamily.app',
          environment: 'Sandbox',
          signedTransactionInfo: await sign(transaction()),
          signedRenewalInfo: await sign({
            signedDate: Date.now(),
            originalTransactionId: 'original',
            environment: 'Sandbox',
            autoRenewStatus: 0,
            gracePeriodExpiresDate: Date.now() + 7200000,
          }),
        },
      });
      expect(
        await service.verifyAppStoreNotification(signedPayload),
      ).toMatchObject({
        type,
        eventId: 'event',
        autoRenew: false,
        purchase: { autoRenew: false, graceUntil: expect.any(Date) },
      });
    },
  );
  it('rejects trusted certificates missing the App Store signing extension', async () => {
    const noPurpose = new X509Certificate(
      readFileSync(join(folder, 'no-purpose.pem')),
    ).raw.toString('base64');
    await expect(
      service.verifyPurchase({
        store: 'APP_STORE',
        signedTransaction: await sign(transaction(), [noPurpose, x5c[1]!]),
      }),
    ).rejects.toMatchObject({ code: 'STORE_VERIFICATION_FAILED' });
  });
  it('rejects renewal information bound to another subscription', async () => {
    const signedPayload = await sign({
      signedDate: Date.now(),
      notificationType: 'DID_RENEW',
      notificationUUID: 'event',
      data: {
        bundleId: 'vn.babyfamily.app',
        environment: 'Sandbox',
        signedTransactionInfo: await sign(transaction()),
        signedRenewalInfo: await sign({
          signedDate: Date.now(),
          originalTransactionId: 'different',
          environment: 'Sandbox',
          autoRenewStatus: 1,
        }),
      },
    });
    await expect(
      service.verifyAppStoreNotification(signedPayload),
    ).rejects.toMatchObject({ code: 'STORE_VERIFICATION_FAILED' });
  });
  it('authenticates Play RTDN before authoritative publisher lookup', async () => {
    const body = {
      message: {
        messageId: 'event',
        data: Buffer.from(
          JSON.stringify({
            packageName: 'vn.babyfamily.app',
            eventTimeMillis: String(Date.now()),
            subscriptionNotification: {
              notificationType: 12,
              purchaseToken: 'token',
            },
          }),
        ).toString('base64'),
      },
    };
    await expect(
      service.verifyPlayNotification({ authorization: 'Bearer wrong', body }),
    ).rejects.toMatchObject({
      code: 'STORE_WEBHOOK_UNAUTHORIZED',
      statusCode: 401,
    });
    expect(publisher.getSubscription).not.toHaveBeenCalled();
    expect(
      await service.verifyPlayNotification({
        authorization: 'Bearer secret',
        body,
      }),
    ).toMatchObject({
      type: 'REVOKED',
      purchase: { transactionId: 'order', purchaseToken: 'token' },
    });
    expect(publisher.getSubscription).toHaveBeenCalledWith(
      'vn.babyfamily.app',
      'token',
    );
  });
  it('fails closed until production Play publisher is configured', async () => {
    await expect(
      new StorePublisherService().getSubscription('package', 'token'),
    ).rejects.toMatchObject({
      code: 'STORE_PUBLISHER_UNAVAILABLE',
      statusCode: 503,
    });
  });
});
