import { createPrivateKey, sign } from 'node:crypto';
import { z } from 'zod';
import type {
  IPushSender,
  PushMessage,
  PushSendResult,
} from '../../interfaces/services/push-sender.interface';

const TOKEN_URL = 'https://oauth2.googleapis.com/token';
const serviceAccountSchema = z.object({
  client_email: z.email(),
  private_key: z.string().min(1),
});
const tokenSchema = z.object({
  access_token: z.string().min(1),
  expires_in: z.number().int().positive(),
});
const errorSchema = z.object({
  error: z.object({
    status: z.string().optional(),
    details: z
      .array(
        z.object({
          '@type': z.string().optional(),
          errorCode: z.string().optional(),
        }),
      )
      .optional(),
  }),
});

/** HTTP v1, OAuth service-account JWT. No SDK dependency or provider retry here. */
export class FcmPushSender implements IPushSender {
  private readonly account: z.infer<typeof serviceAccountSchema>;
  private readonly privateKey: ReturnType<typeof createPrivateKey>;
  private cachedToken?: { value: string; expiresAt: number };

  constructor(
    private readonly projectId: string,
    serviceAccountJson: string,
  ) {
    try {
      if (!/^[a-z][a-z0-9-]{4,62}$/.test(projectId)) throw new Error();
      this.account = serviceAccountSchema.parse(
        JSON.parse(serviceAccountJson) as unknown,
      );
      this.privateKey = createPrivateKey(this.account.private_key);
      if (this.privateKey.asymmetricKeyType !== 'rsa') throw new Error();
    } catch {
      throw new Error('Invalid FCM service-account configuration');
    }
  }

  async send(
    message: PushMessage,
    signal: AbortSignal,
  ): Promise<PushSendResult> {
    const requestSignal = AbortSignal.any([
      signal,
      AbortSignal.timeout(15_000),
    ]);
    if (requestSignal.aborted)
      return { status: 'transient', code: 'FCM_ABORTED' };
    try {
      const accessToken = await this.accessToken(requestSignal);
      if (typeof accessToken !== 'string') return accessToken;
      // Select each field explicitly: callers cannot add private data to the payload.
      const response = await fetch(
        `https://fcm.googleapis.com/v1/projects/${this.projectId}/messages:send`,
        {
          method: 'POST',
          signal: requestSignal,
          headers: {
            Authorization: `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            message: {
              token: message.token,
              notification: { title: message.title, body: message.body },
              data: {
                notificationId: message.data.notificationId,
                deepLink: message.data.deepLink,
              },
            },
          }),
        },
      );
      const body: unknown = await response.json().catch(() => null);
      if (response.ok) {
        const parsed = z.object({ name: z.string().min(1) }).safeParse(body);
        return parsed.success
          ? { status: 'sent', messageId: parsed.data.name }
          : { status: 'transient', code: 'FCM_INVALID_RESPONSE' };
      }
      if (response.status === 401) this.cachedToken = undefined;
      const error = errorSchema.safeParse(body);
      const fcmCode = error.success
        ? error.data.error.details?.find(
            (detail) =>
              detail['@type'] ===
              'type.googleapis.com/google.firebase.fcm.v1.FcmError',
          )?.errorCode
        : undefined;
      // Generic INVALID_ARGUMENT can mean a malformed payload; only the
      // FcmError detail identifies an invalid registration token.
      if (fcmCode === 'UNREGISTERED' || fcmCode === 'INVALID_ARGUMENT')
        return { status: 'invalid-token', code: `FCM_${fcmCode}` };
      return this.httpFailure(response.status, 'FCM');
    } catch {
      return {
        status: 'transient',
        code: requestSignal.aborted ? 'FCM_ABORTED' : 'FCM_NETWORK_ERROR',
      };
    }
  }

  private async accessToken(
    signal: AbortSignal,
  ): Promise<string | PushSendResult> {
    if (this.cachedToken && this.cachedToken.expiresAt > Date.now())
      return this.cachedToken.value;
    const now = Math.floor(Date.now() / 1000);
    const encode = (value: object) =>
      Buffer.from(JSON.stringify(value)).toString('base64url');
    const unsigned = `${encode({ alg: 'RS256', typ: 'JWT' })}.${encode({
      iss: this.account.client_email,
      scope: 'https://www.googleapis.com/auth/firebase.messaging',
      aud: TOKEN_URL,
      iat: now,
      exp: now + 3600,
    })}`;
    const assertion = `${unsigned}.${sign(
      'RSA-SHA256',
      Buffer.from(unsigned),
      this.privateKey,
    ).toString('base64url')}`;
    const response = await fetch(TOKEN_URL, {
      method: 'POST',
      signal,
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion,
      }).toString(),
    });
    if (!response.ok) return this.httpFailure(response.status, 'FCM_OAUTH');
    const parsed = tokenSchema.safeParse(await response.json());
    if (!parsed.success)
      return { status: 'transient', code: 'FCM_OAUTH_INVALID_RESPONSE' };
    this.cachedToken = {
      value: parsed.data.access_token,
      expiresAt: Date.now() + Math.max(0, parsed.data.expires_in - 60) * 1000,
    };
    return this.cachedToken.value;
  }

  private httpFailure(status: number, prefix: string): PushSendResult {
    return {
      status:
        status === 408 || status === 429 || status >= 500 || status === 401
          ? 'transient'
          : 'permanent',
      code: `${prefix}_HTTP_${status}`,
    };
  }
}
