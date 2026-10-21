import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { exportSPKI, generateKeyPair, SignJWT } from 'jose';
import request from 'supertest';
import { LoggerModule } from 'nestjs-pino';
import { JobLease } from '../../src/models/job-lease.model';
import { JOBS } from '../../src/config/jobs';
import { JOB_EXECUTION_REPOSITORY } from '../../src/interfaces/repositories/job-execution-repository.interface';
import { JobExecutionRepository } from '../../src/repositories/job-execution.repository';
import { JobRunnerService } from '../../src/services/job-runner.service';
import { NotificationDispatchService } from '../../src/services/notification-dispatch.service';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import { NotificationInboxController } from '../../src/controllers/notification-inbox.controller';
import { PrismaService } from '../../src/database/prisma.service';
import type { NotificationListResponseDto } from '../../src/dto/notification/notification-inbox.dto';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { NOTIFICATION_INBOX_REPOSITORY } from '../../src/interfaces/repositories/notification-inbox-repository.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { NOTIFICATION_INBOX_SERVICE } from '../../src/interfaces/services/notification-inbox-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { NotificationInboxRepository } from '../../src/repositories/notification-inbox.repository';
import { AuthenticationService } from '../../src/services/authentication.service';
import { NotificationInboxService } from '../../src/services/notification-inbox.service';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const daysAgo = (days: number) => new Date(Date.now() - days * 86400000);

describe('Notification inbox API (focused module, PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  const userA = randomUUID();
  const userB = randomUUID();
  const circle = randomUUID();
  const familyId = randomUUID();
  const coupleSpaceId = randomUUID();
  const planId = randomUUID();
  const planVersionId = randomUUID();
  const users = [userA, userB, circle];
  const sessions = new Map(users.map((id) => [id, randomUUID()]));
  const tokens = new Map<string, string>();
  const prefix = '/api/v1/notifications';

  function get(userId: string, suffix = '') {
    return request(app.getHttpServer())
      .get(`${prefix}${suffix}`)
      .set('Authorization', tokens.get(userId)!);
  }
  function read(userId: string, body: Record<string, unknown>) {
    return request(app.getHttpServer())
      .post(`${prefix}/read`)
      .set('Authorization', tokens.get(userId)!)
      .send(body);
  }
  async function notification(
    userId: string,
    options: {
      tab?: 'FAMILY' | 'US';
      age?: number;
      read?: boolean;
      deleted?: boolean;
      dismissed?: boolean;
      expired?: boolean;
    } = {},
  ) {
    const us = options.tab === 'US';
    return prisma.notification.create({
      data: {
        familyId,
        recipientUserId: userId,
        eventId: randomUUID(),
        templateCode: us ? 'MOOD_SHARED' : 'MEMORY_NEW',
        category: us ? 'US' : 'MEMORIES',
        sensitive: us,
        subjectType: us ? 'us' : 'memory',
        subjectId: familyId,
        payloadReference: {
          tab: us ? 'US' : 'FAMILY',
          params: { actorName: 'Test parent' },
          deepLink: us ? 'babyfamily://us' : 'babyfamily://memories',
        },
        createdAt: daysAgo(options.age ?? 0),
        readAt: options.read ? new Date() : null,
        deletedAt: options.deleted ? new Date() : null,
        dismissedAt: options.dismissed ? new Date() : null,
        expiresAt: options.expired ? daysAgo(1) : null,
      },
    });
  }

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test'))
      throw new Error('Notification integration requires a *_test database.');
    const keys = await generateKeyPair('ES256');
    const config = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [NotificationInboxController],
      providers: [
        { provide: ConfigService, useValue: config },
        PrismaService,
        AccessTokenGuard,
        JobRunnerService,
        NotificationDispatchService,
        { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        {
          provide: NOTIFICATION_INBOX_REPOSITORY,
          useClass: NotificationInboxRepository,
        },
        {
          provide: NOTIFICATION_INBOX_SERVICE,
          useClass: NotificationInboxService,
        },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
        forbidUnknownValues: true,
      }),
    );
    await app.init();
    prisma = app.get(PrismaService);
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: 'Inbox test user',
        status: 'ACTIVE',
        tokenVersion: 1,
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Notification test family',
        createdBy: userA,
        status: 'ACTIVE',
        activatedAt: daysAgo(1),
      },
    });
    await prisma.plan.create({
      data: {
        id: planId,
        code: `INBOX_${planId.slice(0, 16)}`,
        displayNameI18n: { vi: 'Synthetic inbox' },
      },
    });
    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: {},
        features: { 'circle.enabled': true },
      },
    });
    const license = await prisma.familyLicense.create({ data: { familyId } });
    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId: license.id,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: new Date(Date.now() + 86400000),
      },
    });
    const membershipA = await prisma.familyParent.create({
      data: {
        familyId,
        userId: userA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    const membershipB = await prisma.familyParent.create({
      data: {
        familyId,
        userId: userB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
      },
    });
    await prisma.coupleSpace.create({
      data: {
        id: coupleSpaceId,
        familyId,
        parentAUserId: userA,
        parentBUserId: userB,
        parentAMembershipId: membershipA.id,
        parentBMembershipId: membershipB.id,
      },
    });
    await prisma.circleMember.create({
      data: {
        familyId,
        userId: circle,
        relation: 'CAREGIVER',
        displayName: 'Circle',
        invitedBy: userA,
      },
    });
    await prisma.userSession.createMany({
      data: [...sessions].map(([userId, id]) => ({
        id,
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: new Date(Date.now() + 86400000),
        absoluteExpiresAt: new Date(Date.now() + 86400000),
      })),
    });
    for (const [userId, sid] of sessions) {
      const now = Math.floor(Date.now() / 1000);
      tokens.set(
        userId,
        `Bearer ${await new SignJWT({ sub: userId, sid, ver: 1, iat: now, exp: now + 900, iss: 'baby-family', aud: 'baby-family-app' }).setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' }).sign(keys.privateKey)}`,
      );
    }
  });
  async function cleanupEvents() {
    await prisma.notificationDelivery.deleteMany({
      where: { notification: { familyId } },
    });
    await prisma.notification.deleteMany({ where: { familyId } });
    await prisma.jobAttempt.deleteMany({ where: { jobRun: { familyId } } });
    await prisma.jobRun.deleteMany({ where: { familyId } });
    await prisma.request.deleteMany({ where: { familyId } });
    await prisma.appreciation.deleteMany({ where: { familyId } });
    await prisma.comment.deleteMany({ where: { familyId } });
    await prisma.memoryChild.deleteMany({ where: { familyId } });
    await prisma.memory.deleteMany({ where: { familyId } });
    await prisma.circleGrant.deleteMany({ where: { familyId } });
    await prisma.child.deleteMany({ where: { familyId } });
    await prisma.moodCheckin.deleteMany({ where: { familyId } });
    await prisma.outboxEvent.deleteMany({ where: { familyId } });
  }
  beforeEach(async () => {
    await cleanupEvents();
    await prisma.notification.deleteMany({
      where: { recipientUserId: { in: users } },
    });
  });
  afterAll(async () => {
    try {
      if (prisma) {
        await cleanupEvents();
        await prisma.coupleSpace.deleteMany({ where: { familyId } });
        await prisma.circleMember.deleteMany({ where: { familyId } });
        await prisma.familyParent.deleteMany({ where: { familyId } });
        await prisma.familyEntitlement.deleteMany({ where: { familyId } });
        // License identities have mandatory retention; retire only this fixture.
        await prisma.family.update({
          where: { id: familyId },
          data: { status: 'DELETED', deletedAt: new Date() },
        });
        await prisma.planVersion.deleteMany({ where: { id: planVersionId } });
        await prisma.plan.deleteMany({ where: { id: planId } });
        await prisma.notification.deleteMany({
          where: { recipientUserId: { in: users } },
        });
        await prisma.userSession.deleteMany({
          where: { userId: { in: users } },
        });
        await prisma.user.updateMany({
          where: { id: { in: users } },
          data: { status: 'DELETED', deletedAt: new Date() },
        });
      }
    } finally {
      if (app) await app.close();
    }
  });

  it('requires a verified bearer token backed by a live session', async () => {
    await request(app.getHttpServer()).get(prefix).expect(401);
    await request(app.getHttpServer())
      .get(`${prefix}/unread-count`)
      .set('Authorization', 'Bearer forged.token.value')
      .expect(401);
    await get(userA).expect(200);
  });

  it('lists only own rows and returns localized rendering inputs, without persistence internals', async () => {
    const own = await notification(userA);
    await notification(userB);
    const result = data<NotificationListResponseDto>(
      await get(userA).expect(200),
    );
    expect(result.items).toHaveLength(1);
    expect(result.items[0]).toMatchObject({
      id: own.id,
      templateCode: 'MEMORY_NEW',
      params: { actorName: 'Test parent' },
      createdAt: own.createdAt.toISOString(),
      readAt: null,
      deepLink: `babyfamily://memories/${familyId}`,
    });
    expect(result.items[0]).not.toHaveProperty('recipientUserId');
    expect(result.items[0]).not.toHaveProperty('payloadReference');
    expect(
      data<{ count: number }>(await get(userA, '/unread-count').expect(200)),
    ).toEqual({ count: 1 });
  });

  it('filters tabs and paginates with an own-row cursor; foreign cursors reveal no rows', async () => {
    await notification(userA, { age: 2 });
    await notification(userA, { age: 1 });
    await notification(userA, { tab: 'US' });
    const foreign = await notification(userB);
    const page = data<NotificationListResponseDto>(
      await get(userA, '?tab=FAMILY&limit=1').expect(200),
    );
    expect(page.items).toHaveLength(1);
    expect(page.items[0]!.tab).toBe('FAMILY');
    expect(page.nextCursor).toBe(page.items[0]!.id);
    const next = data<NotificationListResponseDto>(
      await get(userA, `?tab=FAMILY&limit=1&cursor=${page.nextCursor}`).expect(
        200,
      ),
    );
    expect(next.items).toHaveLength(1);
    expect(next.items[0]!.id).not.toBe(page.items[0]!.id);
    expect(next.nextCursor).toBeNull();
    const us = data<NotificationListResponseDto>(
      await get(userA, '?tab=US').expect(200),
    );
    expect(us.items.map((row) => row.tab)).toEqual(['US']);
    const foreignCursor = data<NotificationListResponseDto>(
      await get(userA, `?cursor=${foreign.id}`).expect(200),
    );
    expect(foreignCursor.items).toEqual([]);
  });

  it('marks selected own ids only, silently ignores others and remains idempotent', async () => {
    const own = await notification(userA);
    const other = await notification(userB);
    expect(
      data(
        await read(userA, { ids: [own.id, other.id, randomUUID()] }).expect(
          200,
        ),
      ),
    ).toEqual({ updatedCount: 1 });
    expect(data(await read(userA, { ids: [own.id] }).expect(200))).toEqual({
      updatedCount: 0,
    });
    expect(
      (await prisma.notification.findUniqueOrThrow({ where: { id: own.id } }))
        .readAt,
    ).not.toBeNull();
    expect(
      (await prisma.notification.findUniqueOrThrow({ where: { id: other.id } }))
        .readAt,
    ).toBeNull();
    expect(data(await get(userA, '/unread-count').expect(200))).toEqual({
      count: 0,
    });
    expect(data(await get(userB, '/unread-count').expect(200))).toEqual({
      count: 1,
    });
  });

  it('marks all active own rows read, across tabs, without touching another user', async () => {
    await notification(userA);
    await notification(userA, { tab: 'US' });
    const foreign = await notification(userB);
    expect(data(await read(userA, { all: true }).expect(200))).toEqual({
      updatedCount: 2,
    });
    expect(data(await get(userA, '/unread-count').expect(200))).toEqual({
      count: 0,
    });
    expect(
      (
        await prisma.notification.findUniqueOrThrow({
          where: { id: foreign.id },
        })
      ).readAt,
    ).toBeNull();
  });

  it('hides rows older than 90 days, deleted, grouped-away and expired rows from list/count/read', async () => {
    const old = await notification(userA, { age: 91 });
    await notification(userA, { deleted: true });
    await notification(userA, { dismissed: true });
    await notification(userA, { expired: true });
    const recent = await notification(userA, { age: 89 });
    const result = data<NotificationListResponseDto>(
      await get(userA).expect(200),
    );
    expect(result.items.map((row) => row.id)).toEqual([recent.id]);
    expect(data(await get(userA, '/unread-count').expect(200))).toEqual({
      count: 1,
    });
    expect(data(await read(userA, { all: true }).expect(200))).toEqual({
      updatedCount: 1,
    });
    expect(
      (await prisma.notification.findUniqueOrThrow({ where: { id: old.id } }))
        .readAt,
    ).toBeNull();
  });

  it('validates queries and requires exactly ids or all:true without accepting an actor override', async () => {
    await get(userA, '?tab=INVALID').expect(400);
    await get(userA, '?limit=101').expect(400);
    await get(userA, '?cursor=invalid').expect(400);
    await get(userA, `?userId=${userB}`).expect(400);
    await read(userA, {}).expect(422);
    await read(userA, { all: false }).expect(422);
    await read(userA, { all: true, ids: [randomUUID()] }).expect(422);
    await read(userA, { ids: [] }).expect(400);
    await read(userA, { ids: ['invalid'] }).expect(400);
    await read(userA, { all: true, userId: userB }).expect(400);
  });
  async function memory(
    visibility: 'PRIVATE' | 'PARENTS' | 'FAMILY' = 'PARENTS',
  ) {
    return prisma.memory.create({
      data: {
        familyId,
        authorUserId: userA,
        authorRole: 'PARENT',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        visibility,
        status: 'PUBLISHED',
        familyMoment: true,
      },
    });
  }
  async function event(
    eventType: string,
    aggregateId: string,
    payload: Record<string, string | null>,
  ) {
    return prisma.outboxEvent.create({
      data: { familyId, eventType, aggregateId, payload },
    });
  }
  async function consume(
    outbox: { eventId: string; createdAt: Date },
    suffix = '',
  ) {
    return app.get(JobRunnerService).execute(
      JOBS.dispatchNotification,
      {
        familyId,
        scopeKey: `${outbox.eventId}${suffix}`,
        scheduledFor: outbox.createdAt,
        idempotencyKey: `notification-test:${outbox.eventId}${suffix}`,
      },
      (context) =>
        app.get(NotificationDispatchService).dispatch(outbox.eventId, context),
    );
  }
  it('routes Circle submissions to both Parents and review outcomes only to the Circle author without preview content', async () => {
    const post = await prisma.memory.create({
      data: {
        familyId,
        authorUserId: circle,
        authorRole: 'CIRCLE',
        status: 'PENDING_REVIEW',
        visibility: 'FAMILY',
        occurredAt: new Date(),
        occurredLocalDate: new Date(),
        body: 'Private photo caption',
      },
    });
    const submission = await event('memory.review_requested', post.id, {
      authorUserId: circle,
      caption: 'Private photo caption',
    });
    await consume(submission);
    await consume(submission, '-replay');
    const pending = await prisma.notification.findMany({
      where: { eventId: submission.eventId },
    });
    expect(pending.map((row) => row.recipientUserId).sort()).toEqual(
      [userA, userB].sort(),
    );
    expect(
      pending.every(
        (row) => row.templateCode === 'NOTI_MEMORY_REVIEW_REQUESTED',
      ),
    ).toBe(true);
    // Approval must notify while the asset is still processing, before publication.
    for (const [status, eventType, templateCode] of [
      ['PROCESSING', 'memory.approved', 'NOTI_MEMORY_APPROVED'],
      ['REJECTED', 'memory.rejected', 'NOTI_MEMORY_REJECTED'],
    ] as const) {
      await prisma.memory.update({
        where: { id: post.id },
        data: { status, reviewedBy: userA, reviewedAt: new Date() },
      });
      const reviewed = await event(eventType, post.id, {
        authorUserId: circle,
        reviewedBy: userA,
        reason: 'Private review reason',
      });
      await consume(reviewed);
      await consume(reviewed, '-replay');
      const rows = await prisma.notification.findMany({
        where: { eventId: reviewed.eventId },
      });
      expect(rows).toHaveLength(1);
      expect(rows[0]).toMatchObject({
        recipientUserId: circle,
        templateCode,
        category: 'MEMORIES',
        sensitive: false,
      });
      expect(JSON.stringify(rows[0]!.payloadReference)).not.toMatch(
        /Private|caption|reason|childNames/,
      );
    }
    const inbox = data<NotificationListResponseDto>(
      await get(circle).expect(200),
    );
    expect(inbox.items).toHaveLength(2);
    expect(JSON.stringify(inbox)).not.toMatch(/Private|caption|reason/);
    // A stale pending event must not request review after a decision.
    const stale = await event('memory.review_requested', post.id, {
      authorUserId: circle,
    });
    await consume(stale);
    expect(
      await prisma.notification.count({ where: { eventId: stale.eventId } }),
    ).toBe(0);
  });

  it('consumes memory publication once per event with durable job attempts and excludes PRIVATE partners', async () => {
    const visible = await memory();
    const published = await event('memory.published', visible.id, {
      authorUserId: userA,
    });
    await consume(published);
    expect(await consume(published)).toBe('ALREADY_FINISHED');
    // A different durable run still cannot repeat this event's inbox side effect.
    await consume(published, '-replay');
    const rows = await prisma.notification.findMany({
      where: { eventId: published.eventId },
    });
    expect(rows.map((row) => row.recipientUserId)).toEqual([userB]);
    expect(
      await prisma.jobAttempt.count({ where: { jobRun: { familyId } } }),
    ).toBe(2);
    const hidden = await memory('PRIVATE');
    const privateEvent = await event('memory.published', hidden.id, {
      authorUserId: userA,
    });
    await consume(privateEvent);
    expect(
      await prisma.notification.count({
        where: { eventId: privateEvent.eventId },
      }),
    ).toBe(0);
  });

  it('notifies memory author and visible thread participants, excludes commenter, and groups within 30 minutes', async () => {
    const post = await memory('FAMILY');
    await prisma.comment.create({
      data: {
        familyId,
        memoryId: post.id,
        authorUserId: circle,
        body: 'Earlier comment',
      },
    });
    const comment = await prisma.comment.create({
      data: {
        familyId,
        memoryId: post.id,
        authorUserId: userB,
        body: 'Private message text must never be copied',
      },
    });
    const created = await event('comment.created', comment.id, {
      memoryId: post.id,
      authorUserId: userB,
    });
    await consume(created);
    const first = await prisma.notification.findMany({
      where: { eventId: created.eventId },
    });
    expect(first.map((row) => row.recipientUserId).sort()).toEqual(
      [userA, circle].sort(),
    );
    const another = await prisma.comment.create({
      data: {
        familyId,
        memoryId: post.id,
        authorUserId: userB,
        body: 'Another',
      },
    });
    const again = await event('comment.created', another.id, {
      memoryId: post.id,
      authorUserId: userB,
    });
    await consume(again);
    expect(
      data<NotificationListResponseDto>(await get(userA).expect(200)).items,
    ).toHaveLength(1);
    const grouped = data<NotificationListResponseDto>(
      await get(userA).expect(200),
    ).items[0]!;
    expect(grouped.params).toMatchObject({ count: 2 });
    expect(
      await prisma.notification.count({
        where: { familyId, recipientUserId: userA },
      }),
    ).toBe(2);
    expect(
      await prisma.notification.count({
        where: { familyId, recipientUserId: userB },
      }),
    ).toBe(0);
    expect(JSON.stringify(first)).not.toContain('Private message');
  });

  it('ignores reaction removals and groups additions for the memory author', async () => {
    const post = await memory();
    const added = await event('reaction.changed', post.id, {
      memoryId: post.id,
      userId: userB,
      type: 'LOVE',
    });
    await consume(added);
    const second = await event('reaction.changed', post.id, {
      memoryId: post.id,
      userId: userB,
      type: 'LOVE',
    });
    await consume(second);
    const removed = await event('reaction.changed', post.id, {
      memoryId: post.id,
      userId: userB,
      type: null,
    });
    await consume(removed);
    expect(await prisma.notification.count({ where: { familyId } })).toBe(2);
    const inbox = data<NotificationListResponseDto>(
      await get(userA).expect(200),
    );
    expect(inbox.items).toHaveLength(1);
    expect(inbox.items[0]!.params).toMatchObject({ count: 2 });
  });

  it('stores only identifiers for sensitive updates and never delivers or exposes Papa & Mama to Circle', async () => {
    const checkin = await prisma.moodCheckin.create({
      data: {
        familyId,
        coupleSpaceId,
        userId: userA,
        mood: 'GOOD',
        shared: true,
        sharedFields: ['mood'],
        noteEnc: Buffer.from('private note'),
        expiresAt: new Date(Date.now() + 86400000),
      },
    });
    const shared = await event('us.checkin.shared', checkin.id, {
      userId: userA,
      body: 'Secret shared content',
      hearts: '123',
    });
    await consume(shared);
    const rows = await prisma.notification.findMany({
      where: { eventId: shared.eventId },
    });
    expect(rows.map((row) => row.recipientUserId)).toEqual([userB]);
    expect(rows[0]!.sensitive).toBe(true);
    const reference = rows[0]!.payloadReference as {
      params: Record<string, unknown>;
    };
    expect(
      Object.keys(reference.params).every(
        (key) => key.endsWith('Id') || key.endsWith('Ids'),
      ),
    ).toBe(true);
    expect(JSON.stringify(reference)).not.toMatch(
      /Secret|private note|hearts|GOOD/,
    );
    // Defense against a historical or malformed row addressed to a Circle member.
    const badRow = await notification(circle, { tab: 'US' });
    expect(
      data<NotificationListResponseDto>(await get(circle).expect(200)).items,
    ).toEqual([]);
    expect(data(await get(circle, '/unread-count').expect(200))).toEqual({
      count: 0,
    });
    expect(data(await read(circle, { ids: [badRow.id] }).expect(200))).toEqual({
      updatedCount: 0,
    });
  });
  it('starts a new notification group after the 30-minute window', async () => {
    const post = await memory();
    await prisma.notification.create({
      data: {
        familyId,
        recipientUserId: userA,
        eventId: randomUUID(),
        templateCode: 'NOTI_REACTION_CHANGED',
        category: 'MEMORIES',
        subjectType: 'memory',
        subjectId: post.id,
        createdAt: new Date(Date.now() - 31 * 60000),
        payloadReference: {
          groupKey: `NOTI_REACTION_CHANGED:${post.id}`,
          count: 1,
          params: { actorUserId: userB },
        },
      },
    });
    const second = await event('reaction.changed', post.id, {
      memoryId: post.id,
      userId: userB,
      type: 'LOVE',
    });
    await consume(second);
    expect(
      data<NotificationListResponseDto>(await get(userA).expect(200)).items,
    ).toHaveLength(2);
  });

  it.each(['memory.published', 'memory.review_requested'] as const)(
    'reserves at most three %s pushes on the post-quiet local delivery day while retaining all inbox rows',
    async (eventType) => {
      // Select a real IANA fixed-offset timezone where it is currently 23:xx.
      // Quiet hours must move every reservation to the following local morning.
      let offset = 23 - new Date().getUTCHours();
      if (offset > 14) offset -= 24;
      const timezone =
        offset === 0
          ? 'Etc/GMT'
          : `Etc/GMT${offset > 0 ? '-' : '+'}${Math.abs(offset)}`;
      await prisma.user.update({ where: { id: userB }, data: { timezone } });
      try {
        for (let index = 0; index < 5; index++) {
          const post = await memory();
          if (eventType === 'memory.review_requested') {
            await prisma.memory.update({
              where: { id: post.id },
              data: {
                authorUserId: circle,
                authorRole: 'CIRCLE',
                status: 'PENDING_REVIEW',
              },
            });
          }
          await consume(
            await event(eventType, post.id, {
              authorUserId:
                eventType === 'memory.review_requested' ? circle : userA,
            }),
          );
        }
        const rows = await prisma.notification.findMany({
          where: { familyId, recipientUserId: userB },
          include: { notificationDeliveries: true },
        });
        expect(rows).toHaveLength(5);
        const deliveries = rows.flatMap((row) => row.notificationDeliveries);
        expect(deliveries).toHaveLength(3);
        const local = new Intl.DateTimeFormat('en-GB', {
          timeZone: timezone,
          dateStyle: 'short',
          timeStyle: 'short',
          hourCycle: 'h23',
        });
        for (const delivery of deliveries) {
          expect(delivery.status).toBe('PENDING');
          expect(delivery.nextAttemptAt!.getTime()).toBeGreaterThan(Date.now());
          expect(local.format(delivery.nextAttemptAt!)).toContain('06:30');
        }
      } finally {
        await prisma.user.update({
          where: { id: userB },
          data: { timezone: 'Asia/Ho_Chi_Minh' },
        });
      }
    },
  );

  it('deduplicates multi-child events and removes inaccessible child names and ids for Circle', async () => {
    const childA = await prisma.child.create({
      data: {
        familyId,
        nickname: 'Visible child',
        birthDate: daysAgo(100),
        colorIndex: 1,
        createdBy: userA,
      },
    });
    const childB = await prisma.child.create({
      data: {
        familyId,
        nickname: 'Hidden child',
        birthDate: daysAgo(100),
        colorIndex: 1,
        createdBy: userA,
      },
    });
    const member = await prisma.circleMember.findFirstOrThrow({
      where: { familyId, userId: circle },
    });
    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId: member.id,
        childId: childA.id,
        permission: 'COMMENT',
        createdBy: userA,
      },
    });
    const post = await memory('FAMILY');
    await prisma.memoryChild.createMany({
      data: [childA, childB].map((child) => ({
        familyId,
        memoryId: post.id,
        childId: child.id,
        ageMonth: 3,
      })),
    });
    const publication = await event('memory.published', post.id, {
      authorUserId: userA,
    });
    await consume(publication);
    expect(
      await prisma.notification.count({
        where: { eventId: publication.eventId, recipientUserId: userB },
      }),
    ).toBe(1);
    await prisma.comment.create({
      data: {
        familyId,
        memoryId: post.id,
        authorUserId: circle,
        body: 'Visible thread participant',
      },
    });
    const comment = await prisma.comment.create({
      data: {
        familyId,
        memoryId: post.id,
        authorUserId: userB,
        body: 'New comment',
      },
    });
    await consume(
      await event('comment.created', comment.id, {
        memoryId: post.id,
        authorUserId: userB,
      }),
    );
    const inbox = data<NotificationListResponseDto>(
      await get(circle).expect(200),
    );
    expect(inbox.items).toHaveLength(1);
    expect(inbox.items[0]!.params).toMatchObject({
      childIds: [childA.id],
      childNames: ['Visible child'],
    });
    expect(JSON.stringify(inbox)).not.toContain(childB.id);
    expect(JSON.stringify(inbox)).not.toContain('Hidden child');
  });

  it('rejects a missing or expired durable job lease without creating inbox rows', async () => {
    const post = await memory();
    const publication = await event('memory.published', post.id, {
      authorUserId: userA,
    });
    await expect(
      app.get(NotificationDispatchService).dispatch(publication.eventId, {
        signal: new AbortController().signal,
        lease: new JobLease(randomUUID(), 1, 1n, 3, 'missing-worker'),
      }),
    ).rejects.toThrow('lease');
    expect(await prisma.notification.count({ where: { familyId } })).toBe(0);
  });
  it('routes emitted request creation to receiver and accepted/done/declined responses to sender', async () => {
    const cases = [
      ['us.request.sent', 'SENT', userB, 'HIGH'],
      ['us.request.accept', 'ACCEPTED', userA, 'NORMAL'],
      ['us.request.done', 'DONE', userA, 'NORMAL'],
      ['us.request.decline', 'DECLINED', userA, 'NORMAL'],
    ] as const;
    for (const [eventType, status, recipient, priority] of cases) {
      const requestRow = await prisma.request.create({
        data: {
          familyId,
          coupleSpaceId,
          senderUserId: userA,
          receiverUserId: userB,
          kind: 'TASK',
          titleEnc: Buffer.from('secret task'),
          messageEnc: Buffer.from('secret request message'),
          contentKey: randomBytes(32),
          urgency: 'SOON',
          status,
          expiresAt: new Date(Date.now() + 86400000),
        },
      });
      const emitted = await event(eventType, requestRow.id, {
        senderUserId: userA,
        receiverUserId: userB,
        hearts: '999',
      });
      await consume(emitted);
      const notifications = await prisma.notification.findMany({
        where: { eventId: emitted.eventId },
      });
      expect(notifications).toHaveLength(1);
      expect(notifications[0]).toMatchObject({
        recipientUserId: recipient,
        sensitive: true,
        priority,
      });
      expect(JSON.stringify(notifications[0]!.payloadReference)).not.toMatch(
        /secret|hearts|\b999\b/,
      );
    }
    expect(
      data<NotificationListResponseDto>(
        await get(circle, '?tab=US').expect(200),
      ).items,
    ).toEqual([]);
  });

  it('routes appreciation creation only to its recipient and strips encrypted text from params', async () => {
    const appreciation = await prisma.appreciation.create({
      data: {
        familyId,
        coupleSpaceId,
        fromUserId: userA,
        toUserId: userB,
        bodyEnc: Buffer.from('secret thanks'),
      },
    });
    const emitted = await event('us.appreciation.created', appreciation.id, {
      fromUserId: userA,
      toUserId: userB,
      body: 'secret thanks',
    });
    await consume(emitted);
    const notifications = await prisma.notification.findMany({
      where: { eventId: emitted.eventId },
    });
    expect(notifications).toHaveLength(1);
    expect(notifications[0]).toMatchObject({
      recipientUserId: userB,
      sensitive: true,
      category: 'APPRECIATION',
    });
    expect(JSON.stringify(notifications[0]!.payloadReference)).not.toContain(
      'secret thanks',
    );
  });
});
