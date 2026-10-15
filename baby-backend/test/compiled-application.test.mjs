import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { createRequire } from 'node:module';
import test from 'node:test';
import { generateKeyPair, exportSPKI, SignJWT } from 'jose';
import request from 'supertest';

// Load actual native-built JS; no ts-jest or ts-node transforms in this test.
const require = createRequire(import.meta.url);
require('reflect-metadata');

test('native-built Nest application retains DI, JWT guards, DTO metadata and services', async () => {
  const userId = randomUUID();
  const sessionId = randomUUID();
  const familyId = randomUUID();
  const { publicKey, privateKey } = await generateKeyPair('ES256');
  const now = new Date();
  Object.assign(process.env, {
    NODE_ENV: 'test',
    LOG_LEVEL: 'silent',
    SWAGGER_ENABLED: 'true',
    DATABASE_URL: 'postgresql://compiled:temporary@127.0.0.1:1/compiled_test',
    AUTH_JWT_PUBLIC_KEY: await exportSPKI(publicKey),
    AUTH_JWT_ISSUER: 'baby-family',
    AUTH_JWT_AUDIENCE: 'baby-family-app',
    // Keep supporting services from a developer's .env out of this hermetic test.
    REDIS_URL: '',
    S3_ENDPOINT: '',
    S3_ACCESS_KEY_ID: '',
    S3_SECRET_ACCESS_KEY: '',
    SMTP_HOST: '',
  });
  const { Test } = require('@nestjs/testing');
  const { AppModule } = require('../dist/app.module.js');
  const { configureApp } = require('../dist/bootstrap.js');
  const { PrismaService } = require('../dist/database/prisma.service.js');
  const { User } = require('../dist/models/user.model.js');
  const {
    AuthSessionState,
  } = require('../dist/models/auth-session-state.model.js');
  const {
    AUTH_ACCESS_REPOSITORY,
  } = require('../dist/interfaces/repositories/auth-access-repository.interface.js');
  const {
    USER_REPOSITORY,
  } = require('../dist/interfaces/repositories/user-repository.interface.js');
  const {
    CHILD_REPOSITORY,
  } = require('../dist/interfaces/repositories/child-repository.interface.js');
  const {
    APPLICATION_ACCESS_SERVICE,
  } = require('../dist/interfaces/services/application-access-service.interface.js');
  const user = new User({
    id: userId,
    displayName: 'Compiled',
    avatarAssetId: null,
    locale: 'vi',
    timezone: 'Asia/Ho_Chi_Minh',
    status: 'ACTIVE',
    onboardingRole: null,
    tokenVersion: 0,
    lastActiveAt: null,
    createdAt: now,
    updatedAt: now,
    deletedAt: null,
  });
  let userScope;
  let childScope;
  const module = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(PrismaService)
    .useValue({ $queryRaw: async () => [{ '?column?': 1 }] })
    .overrideProvider(AUTH_ACCESS_REPOSITORY)
    .useValue({
      findUserSessionState: async (sid, sub) =>
        sid === sessionId && sub === userId
          ? new AuthSessionState({ userId, sessionId, tokenVersion: 0 })
          : null,
    })
    .overrideProvider(USER_REPOSITORY)
    .useValue({
      findByKey: async (scope, key) => {
        userScope = { scope, key };
        return user;
      },
      update: async (_scope, _key, input) => new User({ ...user, ...input }),
    })
    .overrideProvider(APPLICATION_ACCESS_SERVICE)
    .useValue({ requireParent: async () => undefined })
    .overrideProvider(CHILD_REPOSITORY)
    .useValue({
      list: async (scope) => {
        childScope = scope;
        return {
          data: [],
          meta: { page: 1, limit: 20, total: 0, totalPages: 0 },
        };
      },
    })
    .compile();
  const app = module.createNestApplication({ bufferLogs: true });
  try {
    configureApp(app);
    await app.init();
    const seconds = Math.floor(Date.now() / 1000);
    const token = await new SignJWT({ sub: userId, sid: sessionId, ver: 0 })
      .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
      .setIssuer('baby-family')
      .setAudience('baby-family-app')
      .setIssuedAt(seconds)
      .setExpirationTime(seconds + 900)
      .sign(privateKey);
    const server = app.getHttpServer();
    await request(server).get('/health/ready').expect(200);
    const api = await request(server).get('/docs-json').expect(200);
    assert.ok(api.body.paths['/api/v1/me'].patch.requestBody);
    await request(server).get('/api/v1/me').expect(401);
    const me = await request(server)
      .get('/api/v1/me')
      .auth(token, { type: 'bearer' })
      .expect(200);
    assert.equal(me.body.id, userId);
    assert.equal(me.body.tokenVersion, undefined);
    assert.deepEqual(userScope, {
      scope: { privileged: true },
      key: { id: userId },
    });
    const patched = await request(server)
      .patch('/api/v1/me')
      .auth(token, { type: 'bearer' })
      .send({ displayName: '  Native  ' })
      .expect(200);
    assert.equal(patched.body.displayName, 'Native');
    await request(server)
      .patch('/api/v1/me')
      .auth(token, { type: 'bearer' })
      .send({ displayName: 'Name', status: 'SUSPENDED' })
      .expect(400);
    await request(server)
      .patch('/api/v1/me')
      .auth(token, { type: 'bearer' })
      .send({ displayName: null })
      .expect(400);
    await request(server)
      .get(`/api/v1/families/${familyId}/children`)
      .auth(token, { type: 'bearer' })
      .expect(200);
    assert.deepEqual(childScope, { familyId });
  } finally {
    await app.close();
  }
});
