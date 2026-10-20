import { ConfigService } from '@nestjs/config';
import { generateKeyPairSync, verify } from 'node:crypto';
import type { Environment } from '../../src/config/environment';
import type { PushMessage } from '../../src/interfaces/services/push-sender.interface';
import { FcmPushSender } from '../../src/services/push-senders/fcm-push-sender';
import { LogPushSender } from '../../src/services/push-senders/log-push-sender';
import { PUSH_SENDER_PROVIDER } from '../../src/services/push-senders/push-sender.provider';

const { privateKey, publicKey } = generateKeyPairSync('rsa', {
  modulusLength: 2048,
});
const credentials = JSON.stringify({
  client_email: 'push@test-project.iam.gserviceaccount.com',
  private_key: privateKey.export({ format: 'pem', type: 'pkcs8' }),
});
const message: PushMessage = {
  token: 'private-device-token',
  title: 'Generic title',
  body: 'Generic body',
  data: { notificationId: 'notification-1', deepLink: 'babyfamily://inbox' },
};
const response = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status });

describe('Push sender adapters', () => {
  let fetchMock: jest.SpiedFunction<typeof fetch>;
  beforeEach(() => {
    fetchMock = jest.spyOn(globalThis, 'fetch');
  });
  afterEach(() => jest.restoreAllMocks());

  function authenticatedSender() {
    fetchMock.mockResolvedValueOnce(
      response({ access_token: 'oauth-access-token', expires_in: 3600 }),
    );
    return new FcmPushSender('test-project', credentials);
  }

  it('disabled adapter never sends and never reports sent', async () => {
    await expect(
      new LogPushSender().send(message, new AbortController().signal),
    ).resolves.toEqual({ status: 'disabled', code: 'PUSH_DISABLED' });
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('provider forces disabled in tests even with configured credentials', async () => {
    const config = new ConfigService<Environment, true>({
      NODE_ENV: 'test',
      FCM_PROJECT_ID: 'test-project',
      FCM_SERVICE_ACCOUNT_JSON: credentials,
    });
    expect(await PUSH_SENDER_PROVIDER.useFactory(config)).toBeInstanceOf(
      LogPushSender,
    );
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it('provider selects disabled when absent and FCM when configured', async () => {
    const absent = new ConfigService<Environment, true>({
      NODE_ENV: 'development',
    });
    expect(await PUSH_SENDER_PROVIDER.useFactory(absent)).toBeInstanceOf(
      LogPushSender,
    );
    const configured = new ConfigService<Environment, true>({
      NODE_ENV: 'development',
      FCM_PROJECT_ID: 'test-project',
      FCM_SERVICE_ACCOUNT_JSON: credentials,
    });
    expect(await PUSH_SENDER_PROVIDER.useFactory(configured)).toBeInstanceOf(
      FcmPushSender,
    );
  });

  it('rejects partial/ambiguous/invalid configuration without leaking secrets', async () => {
    const partial = new ConfigService<Environment, true>({
      NODE_ENV: 'production',
      FCM_PROJECT_ID: 'test-project',
    });
    await expect(PUSH_SENDER_PROVIDER.useFactory(partial)).rejects.toThrow(
      'FCM requires project ID and exactly one credential source',
    );
    expect(
      () => new FcmPushSender('test-project', 'secret-invalid-json'),
    ).toThrow('Invalid FCM service-account configuration');
  });

  it('signs an OAuth JWT, sends HTTP v1 with only allowed data and caches auth', async () => {
    const sender = authenticatedSender();
    fetchMock.mockResolvedValue(
      response({ name: 'projects/test-project/messages/one' }),
    );
    const signal = new AbortController().signal;
    await expect(sender.send(message, signal)).resolves.toEqual({
      status: 'sent',
      messageId: 'projects/test-project/messages/one',
    });
    await sender.send(message, signal);
    expect(fetchMock).toHaveBeenCalledTimes(3);
    const oauth = fetchMock.mock.calls[0]!;
    expect(oauth[0]).toBe('https://oauth2.googleapis.com/token');
    const assertion = new URLSearchParams(oauth[1]?.body as string).get(
      'assertion',
    )!;
    const [header, payload, signature] = assertion.split('.');
    expect(
      verify(
        'RSA-SHA256',
        Buffer.from(`${header}.${payload}`),
        publicKey,
        Buffer.from(signature!, 'base64url'),
      ),
    ).toBe(true);
    expect(JSON.parse(Buffer.from(payload!, 'base64url').toString())).toEqual(
      expect.objectContaining({
        scope: 'https://www.googleapis.com/auth/firebase.messaging',
        aud: 'https://oauth2.googleapis.com/token',
      }),
    );
    const send = fetchMock.mock.calls[1]!;
    expect(send[0]).toBe(
      'https://fcm.googleapis.com/v1/projects/test-project/messages:send',
    );
    expect(JSON.parse(send[1]?.body as string)).toEqual({
      message: {
        token: message.token,
        notification: { title: message.title, body: message.body },
        data: message.data,
      },
    });
    expect(send[1]?.headers).toEqual({
      Authorization: 'Bearer oauth-access-token',
      'Content-Type': 'application/json',
    });
  });

  it.each(['UNREGISTERED', 'INVALID_ARGUMENT'])(
    'identifies invalid registration from FCM detail %s',
    async (errorCode) => {
      const sender = authenticatedSender();
      fetchMock.mockResolvedValueOnce(
        response(
          {
            error: {
              status: 'INVALID_ARGUMENT',
              details: [
                {
                  '@type':
                    'type.googleapis.com/google.firebase.fcm.v1.FcmError',
                  errorCode,
                },
              ],
            },
          },
          400,
        ),
      );
      await expect(
        sender.send(message, new AbortController().signal),
      ).resolves.toEqual({ status: 'invalid-token', code: `FCM_${errorCode}` });
    },
  );

  it('does not treat a malformed payload as an invalid registration', async () => {
    const sender = authenticatedSender();
    fetchMock.mockResolvedValueOnce(
      response({ error: { status: 'INVALID_ARGUMENT' } }, 400),
    );
    await expect(
      sender.send(message, new AbortController().signal),
    ).resolves.toEqual({ status: 'permanent', code: 'FCM_HTTP_400' });
  });

  it.each([408, 429, 500, 503])('retries HTTP %d', async (status) => {
    const sender = authenticatedSender();
    fetchMock.mockResolvedValueOnce(response({}, status));
    await expect(
      sender.send(message, new AbortController().signal),
    ).resolves.toEqual({ status: 'transient', code: `FCM_HTTP_${status}` });
  });

  it('returns sanitized network failures and stops before network when aborted', async () => {
    const sender = new FcmPushSender('test-project', credentials);
    const abort = new AbortController();
    abort.abort();
    await expect(sender.send(message, abort.signal)).resolves.toEqual({
      status: 'transient',
      code: 'FCM_ABORTED',
    });
    expect(fetchMock).not.toHaveBeenCalled();
    fetchMock.mockRejectedValueOnce(new Error('private token and content'));
    await expect(
      sender.send(message, new AbortController().signal),
    ).resolves.toEqual({ status: 'transient', code: 'FCM_NETWORK_ERROR' });
  });

  it('handles OAuth failures without sending FCM', async () => {
    fetchMock.mockResolvedValueOnce(response({}, 503));
    const sender = new FcmPushSender('test-project', credentials);
    await expect(
      sender.send(message, new AbortController().signal),
    ).resolves.toEqual({ status: 'transient', code: 'FCM_OAUTH_HTTP_503' });
    expect(fetchMock).toHaveBeenCalledTimes(1);
  });

  it('refreshes rejected cached OAuth credentials on the next retry', async () => {
    const sender = authenticatedSender();
    fetchMock
      .mockResolvedValueOnce(response({}, 401))
      .mockResolvedValueOnce(
        response({ access_token: 'refreshed-token', expires_in: 3600 }),
      )
      .mockResolvedValueOnce(response({ name: 'message-two' }));
    await expect(
      sender.send(message, new AbortController().signal),
    ).resolves.toEqual({ status: 'transient', code: 'FCM_HTTP_401' });
    await expect(
      sender.send(message, new AbortController().signal),
    ).resolves.toEqual({ status: 'sent', messageId: 'message-two' });
    expect(fetchMock).toHaveBeenCalledTimes(4);
  });
});
