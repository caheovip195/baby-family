import { randomInt, randomUUID } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import type { Server } from 'node:http';
import path from 'node:path';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Test } from '@nestjs/testing';
import { parse } from 'dotenv';
import { exportPKCS8, generateKeyPair } from 'jose';
import request from 'supertest';
import { configureApp } from '../../src/bootstrap';
import { validateEnvironment } from '../../src/config/environment';
import { PrismaService } from '../../src/database/prisma.service';
import { ValkeyConnection } from '../../src/database/valkey.connection';

// Phone OTP needs Valkey (codes, rate limits) and Mailpit (dev OTP sink) from
// ../baby-storage. Skipped when they are not configured (CI).
const envFile = path.resolve(__dirname, '../../.env');
const fileValues = existsSync(envFile)
  ? parse(readFileSync(envFile, 'utf8'))
  : {};
const redisUrl = process.env.TEST_REDIS_URL ?? fileValues.REDIS_URL ?? '';
const smtpHost = process.env.TEST_SMTP_HOST ?? fileValues.SMTP_HOST ?? '';
const smtpPort = process.env.TEST_SMTP_PORT ?? fileValues.SMTP_PORT ?? '1025';
const mailpitApi = process.env.TEST_MAILPIT_API_URL ?? 'http://localhost:8025';
const available = Boolean(redisUrl) && Boolean(smtpHost);
const describeStack = available ? describe : describe.skip;
if (!available)
  console.warn(
    'Skipping auth/onboarding integration tests: no REDIS_URL/SMTP_HOST in TEST_* or .env.',
  );

/** Loose view of the success payloads this suite reads (`{ data }` envelope, spec §11.1). */
interface Payload {
  family: { id: string; status: string };
  me: { callName: string };
  parents: unknown[];
  code: string;
  url: string;
  inviteId: string;
  state: string;
  status: string;
  trialEndsAt: string;
}

const data = <T = Payload>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const errorCode = (response: { body: unknown }): string =>
  (response.body as { error: { code: string } }).error.code;

interface Tokens {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  isNewUser: boolean;
  user: { id: string };
}

describeStack('Phone sign-in, onboarding and partner activation', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let valkey: NonNullable<ValkeyConnection['client']>;
  const otpInbox = `otp-${randomUUID()}@test.local`;
  // Unique Vietnamese mobile numbers per run (+849x…).
  const phone = () => `+849${randomInt(10_000_000, 99_999_999)}`;
  const phoneA = phone();
  const phoneB = phone();
  const userIds: string[] = [];
  const familyIds: string[] = [];

  const http = () => request(app.getHttpServer());
  const auth = (token: string) => ({ Authorization: `Bearer ${token}` });

  async function latestOtp(phoneE164: string): Promise<string> {
    for (let attempt = 0; attempt < 20; attempt += 1) {
      const search = await fetch(
        `${mailpitApi}/api/v1/search?query=${encodeURIComponent(`to:${otpInbox}`)}`,
      );
      const found = (await search.json()) as {
        messages: { ID: string; Snippet: string }[];
      };
      const message = found.messages.find((item) =>
        item.Snippet.includes(phoneE164),
      );
      if (message) {
        const code = /: ([0-9]{6})/.exec(message.Snippet)?.[1];
        if (code) return code;
      }
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    throw new Error(`No OTP mail for ${phoneE164}`);
  }

  async function signIn(phoneE164: string): Promise<Tokens> {
    const sent = await http()
      .post('/api/v1/auth/phone/otp')
      .send({ phone: phoneE164, channel: 'SMS' });
    if (sent.status !== 202)
      throw new Error(
        `OTP request ${sent.status}: ${JSON.stringify(sent.body)}`,
      );
    const code = await latestOtp(phoneE164);
    const response = await http()
      .post('/api/v1/auth/phone/verify')
      .send({ phone: phoneE164, code, device: { platform: 'IOS' } })
      .expect(200);
    const tokens = data<Tokens>(response);
    userIds.push(tokens.user.id);
    return tokens;
  }

  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (!database.endsWith('_test'))
      throw new Error('Integration tests require a *_test database.');
    const keys = await generateKeyPair('ES256', { extractable: true });
    const redis = new URL(redisUrl);
    redis.pathname = '/15';
    const configuration = new ConfigService({
      ...validateEnvironment({
        ...process.env,
        REDIS_URL: redis.toString(),
        SMTP_HOST: smtpHost,
        SMTP_PORT: smtpPort,
        AUTH_JWT_PRIVATE_KEY: await exportPKCS8(keys.privateKey),
        AUTH_SECRET_PEPPER: `test-pepper-${randomUUID()}`,
        AUTH_OTP_DELIVERY: 'mail',
        AUTH_OTP_MAIL_TO: otpInbox,
        THROTTLE_LIMIT: '1000',
      }),
    });
    const { AppModule } = await import('../../src/app.module.js');
    const module = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(ConfigService)
      .useValue(configuration)
      .compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
    prisma = app.get(PrismaService);
    // Logical DB 15 is reserved for tests: drop rate-limit/OTP counters of earlier runs.
    valkey = app.get(ValkeyConnection).client!;
    for (const pattern of ['rl:*', 'otp:*']) {
      const keys = await valkey.keys(pattern);
      if (keys.length) await valkey.del(...keys);
    }
  });

  afterAll(async () => {
    try {
      if (prisma && userIds.length) {
        const now = new Date();
        // Soft-delete owned fixtures; protected trial/grant history stays in the *_test DB.
        await prisma.familyInvite.updateMany({
          where: { familyId: { in: familyIds } },
          data: { deletedAt: now },
        });
        await prisma.family.updateMany({
          where: { id: { in: familyIds } },
          data: { deletedAt: now, status: 'DELETED' },
        });
        await prisma.userSession.updateMany({
          where: { userId: { in: userIds } },
          data: { revokedAt: now, deletedAt: now },
        });
        await prisma.authIdentity.updateMany({
          where: { userId: { in: userIds } },
          data: { deletedAt: now },
        });
        await prisma.user.updateMany({
          where: { id: { in: userIds } },
          data: { deletedAt: now, status: 'DELETED' },
        });
      }
      await fetch(`${mailpitApi}/api/v1/search?query=to:${otpInbox}`, {
        method: 'DELETE',
      }).catch(() => undefined);
    } finally {
      if (app) await app.close();
    }
  });

  it('rejects unsupported numbers and wrong codes, then locks after 5 tries', async () => {
    await http()
      .post('/api/v1/auth/phone/otp')
      .send({ phone: '+12025550123' })
      .expect(400)
      .expect((response) =>
        expect(errorCode(response)).toBe('PHONE_NOT_SUPPORTED'),
      );
    const target = phone();
    await http()
      .post('/api/v1/auth/phone/otp')
      .send({ phone: target })
      .expect(202)
      .expect((response) =>
        expect(data(response)).toMatchObject({
          expiresIn: 300,
          resendIn: 60,
          channelUsed: 'MAIL',
        }),
      );
    // Resend inside 60 s is refused.
    await http()
      .post('/api/v1/auth/phone/otp')
      .send({ phone: target })
      .expect(429);
    const real = await latestOtp(target);
    const wrong = real === '000000' ? '111111' : '000000';
    for (let attempt = 1; attempt < 5; attempt += 1)
      await http()
        .post('/api/v1/auth/phone/verify')
        .send({ phone: target, code: wrong })
        .expect(400)
        .expect((response) => expect(errorCode(response)).toBe('OTP_INVALID'));
    await http()
      .post('/api/v1/auth/phone/verify')
      .send({ phone: target, code: wrong })
      .expect(429);
    // Locked: even the right code is refused now.
    await http()
      .post('/api/v1/auth/phone/verify')
      .send({ phone: target, code: real })
      .expect(429);
  });

  it('signs in, activates a family with a 7-day trial and rotates refresh tokens', async () => {
    const a = await signIn(phoneA);
    expect(a.isNewUser).toBe(true);
    expect(a.expiresIn).toBe(900);

    // A replayed OTP cannot sign in twice.
    const me = await http()
      .get('/api/v1/me')
      .set(auth(a.accessToken))
      .expect(200);
    expect(data(me)).toMatchObject({
      id: a.user.id,
      onboardingRole: null,
      profileCompleted: false,
      families: [],
    });

    // AUTH-04 → ONB-03.
    await http()
      .patch('/api/v1/me')
      .set(auth(a.accessToken))
      .send({ displayName: 'Linh' })
      .expect(200);
    await http()
      .post('/api/v1/me/consents')
      .set(auth(a.accessToken))
      .send({
        consents: [
          { document: 'TERMS', version: '2026-10', granted: true },
          { document: 'PRIVACY', version: '2026-10', granted: true },
        ],
      })
      .expect(204);
    await http()
      .post('/api/v1/families')
      .set(auth(a.accessToken))
      .send({ name: 'Nhà thử' })
      .expect(403)
      .expect((response) =>
        expect(errorCode(response)).toBe('ROLE_NOT_SELECTED'),
      );
    const role = await http()
      .put('/api/v1/me/onboarding-role')
      .set(auth(a.accessToken))
      .send({ role: 'PARENT_MOTHER' })
      .expect(200);
    expect(data(role)).toMatchObject({
      onboardingRole: 'PARENT_MOTHER',
      profileCompleted: true,
    });
    await http()
      .post('/api/v1/me/devices')
      .set(auth(a.accessToken))
      .send({ platform: 'IOS', appVersion: '1.0.0+1', pushEnabled: false })
      .expect(204);

    // ONB-06: WAITING_PARTNER, nothing usable yet (BR-052).
    const created = await http()
      .post('/api/v1/families')
      .set(auth(a.accessToken))
      .send({ name: 'Nhà thử' })
      .expect(201);
    const family = data(created);
    familyIds.push(family.family.id);
    expect(family).toMatchObject({
      family: { name: 'Nhà thử', status: 'WAITING_PARTNER' },
      me: { slot: 'A', kind: 'MOTHER', callName: 'Mama' },
      coupleLinked: false,
      entitlement: { accessPhase: 'INCOMPLETE' },
    });
    await http()
      .post('/api/v1/families')
      .set(auth(a.accessToken))
      .send({ name: 'Nhà thứ hai' })
      .expect(409);
    await http()
      .put('/api/v1/me/onboarding-role')
      .set(auth(a.accessToken))
      .send({ role: 'CIRCLE' })
      .expect(409);

    // ONB-07: the code is shown once; a new invite revokes the previous one.
    const first = await http()
      .post(`/api/v1/families/${family.family.id}/invites/partner`)
      .set(auth(a.accessToken))
      .send({})
      .expect(201);
    const invite = await http()
      .post(`/api/v1/families/${family.family.id}/invites/partner`)
      .set(auth(a.accessToken))
      .send({ message: 'Vào nhà mình nhé' })
      .expect(201);
    expect(data(invite).code).toMatch(/^[A-Z2-9]{8}$/);
    expect(data(invite).url).toContain('/i/');

    const b = await signIn(phoneB);
    await http()
      .post('/api/v1/invites/resolve')
      .send({ code: data(first).code })
      .expect(200)
      .expect((response) => expect(data(response).state).toBe('USED'));
    const preview = await http()
      .post('/api/v1/invites/resolve')
      .send({ code: data(invite).code.toLowerCase() })
      .expect(200);
    expect(data(preview)).toMatchObject({
      type: 'PARTNER',
      state: 'VALID',
      familyName: 'Nhà thử',
      inviterCallName: 'Mama',
      proposedKind: 'FATHER',
      message: 'Vào nhà mình nhé',
    });
    expect(JSON.stringify(preview.body)).not.toContain(a.user.id);

    // The inviter cannot accept her own invite; B waits for final approval.
    await http()
      .post('/api/v1/invites/accept')
      .set(auth(a.accessToken))
      .send({ code: data(invite).code })
      .expect(422);
    const accepted = await http()
      .post('/api/v1/invites/accept')
      .set(auth(b.accessToken))
      .send({ code: data(invite).code, callName: 'Bố' })
      .expect(200);
    expect(data(accepted)).toMatchObject({
      status: 'AWAITING_APPROVAL',
      familyId: family.family.id,
    });
    const meB = await http()
      .get('/api/v1/me')
      .set(auth(b.accessToken))
      .expect(200);
    expect(data(meB)).toMatchObject({
      onboardingRole: 'PARENT_FATHER',
      awaitingApproval: [{ familyName: 'Nhà thử', kind: 'FATHER' }],
    });
    const status = await http()
      .get(`/api/v1/families/${family.family.id}/invites/partner`)
      .set(auth(a.accessToken))
      .expect(200);
    expect(data(status)).toMatchObject({
      status: 'AWAITING_APPROVAL',
      acceptedCallName: 'Bố',
    });

    // Final approval activates the family and starts the trial exactly once.
    const approved = await http()
      .post(`/api/v1/invites/${data(invite).inviteId}/approve`)
      .set(auth(a.accessToken))
      .expect(200);
    expect(data(approved).status).toBe('JOINED');
    const trialEnds = new Date(data(approved).trialEndsAt).getTime();
    expect(trialEnds - Date.now()).toBeGreaterThan(
      7 * 24 * 3600 * 1000 - 60_000,
    );
    expect(trialEnds - Date.now()).toBeLessThanOrEqual(7 * 24 * 3600 * 1000);
    await http()
      .post(`/api/v1/invites/${data(invite).inviteId}/approve`)
      .set(auth(a.accessToken))
      .expect(409);

    const bootstrap = await http()
      .get(`/api/v1/families/${family.family.id}/bootstrap`)
      .set(auth(b.accessToken))
      .expect(200);
    expect(data(bootstrap)).toMatchObject({
      family: { status: 'ACTIVE' },
      me: { slot: 'B', kind: 'FATHER', callName: 'Bố' },
      coupleLinked: true,
      entitlement: { accessPhase: 'TRIAL' },
    });
    expect(data(bootstrap).parents).toHaveLength(2);
    // Content endpoints open once the family is ACTIVE with a trial.
    await http()
      .get(`/api/v1/families/${family.family.id}/children`)
      .set(auth(b.accessToken))
      .expect(200)
      .expect((response) =>
        expect(response.body).toMatchObject({ data: [], meta: { total: 0 } }),
      );

    // Refresh rotation; presenting a replaced token revokes the whole chain.
    const rotated = await http()
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: a.refreshToken })
      .expect(200);
    const next = data<Tokens>(rotated);
    expect(next.refreshToken).not.toBe(a.refreshToken);
    await http().get('/api/v1/me').set(auth(next.accessToken)).expect(200);
    await http()
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: a.refreshToken })
      .expect(401)
      .expect((response) =>
        expect(errorCode(response)).toBe('AUTH_SESSION_REVOKED'),
      );
    await http()
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: next.refreshToken })
      .expect(401);
    await http().get('/api/v1/me').set(auth(next.accessToken)).expect(401);

    // Logout revokes the current session immediately.
    await http()
      .post('/api/v1/auth/logout')
      .set(auth(b.accessToken))
      .expect(204);
    await http().get('/api/v1/me').set(auth(b.accessToken)).expect(401);

    // Signing in again finds the same account (not a new user). Simulate the
    // 60-second resend cooldown having elapsed.
    const cooldowns = await valkey.keys('otp:cool:*');
    if (cooldowns.length) await valkey.del(...cooldowns);
    const again = await signIn(phoneB);
    expect(again.isNewUser).toBe(false);
    expect(again.user.id).toBe(b.user.id);
  });

  it('lets a waiting Parent cancel the empty family and choose a role again', async () => {
    const c = await signIn(phone());
    await http()
      .put('/api/v1/me/onboarding-role')
      .set(auth(c.accessToken))
      .send({ role: 'PARENT_FATHER' })
      .expect(200);
    const created = await http()
      .post('/api/v1/families')
      .set(auth(c.accessToken))
      .send({ name: 'Nhà chờ', parent: { callName: 'Ba' } })
      .expect(201);
    const familyId = data(created).family.id;
    familyIds.push(familyId);
    expect(data(created).me.callName).toBe('Ba');
    await http()
      .post(`/api/v1/families/${familyId}/cancel`)
      .set(auth(c.accessToken))
      .expect(204);
    const me = await http()
      .get('/api/v1/me')
      .set(auth(c.accessToken))
      .expect(200);
    expect(data(me)).toMatchObject({ onboardingRole: null, families: [] });
    await http()
      .get(`/api/v1/families/${familyId}/bootstrap`)
      .set(auth(c.accessToken))
      .expect(404);
  });
});
