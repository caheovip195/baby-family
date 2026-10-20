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
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { validateEnvironment } from '../../src/config/environment';
import {
  CalendarController,
  EventController,
} from '../../src/controllers/calendar.controller';
import { PrismaService } from '../../src/database/prisma.service';
import type { CalendarResponseDto } from '../../src/dto/calendar/calendar-response.dto';
import type { EventResponseDto } from '../../src/dto/calendar/event-response.dto';
import { AUTH_ACCESS_REPOSITORY } from '../../src/interfaces/repositories/auth-access-repository.interface';
import { CALENDAR_REPOSITORY } from '../../src/interfaces/repositories/calendar-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { CALENDAR_SERVICE } from '../../src/interfaces/services/calendar-service.interface';
import { AuthAccessRepository } from '../../src/repositories/auth-access.repository';
import { CalendarRepository } from '../../src/repositories/calendar.repository';
import { ApplicationAccessService } from '../../src/services/application-access.service';
import { AuthenticationService } from '../../src/services/authentication.service';
import { CalendarService } from '../../src/services/calendar.service';

const data = <T>(response: { body: unknown }): T =>
  (response.body as { data: T }).data;
const errCode = (response: { body: unknown }): string =>
  (response.body as { error: { code: string } }).error.code;

describe('Calendar & Events API (Focused module, PostgreSQL + ES256)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;

  const parentA = randomUUID();
  const parentB = randomUUID();
  const circleUser = randomUUID();
  const outsiderUser = randomUUID();

  const users = [parentA, parentB, circleUser, outsiderUser];
  const sessions = new Map(users.map((id) => [id, randomUUID()]));
  const tokens = new Map<string, string>();

  const familyId = randomUUID();
  const coupleSpaceId = randomUUID();
  const planId = randomUUID();
  const planVersionId = randomUUID();
  const licenseId = randomUUID();
  const childHanaId = randomUUID();
  const circleMemberId = randomUUID();

  const future = () => new Date(Date.now() + 86_400_000);
  const past = () => new Date(Date.now() - 60_000);

  beforeAll(async () => {
    if (!new URL(process.env.DATABASE_URL ?? '').pathname.endsWith('_test')) {
      throw new Error('Calendar integration test requires a *_test database.');
    }

    const keys = await generateKeyPair('ES256');
    const config = new ConfigService({
      ...validateEnvironment(process.env),
      AUTH_JWT_PUBLIC_KEY: await exportSPKI(keys.publicKey),
    });

    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [CalendarController, EventController],
      providers: [
        { provide: ConfigService, useValue: config },
        PrismaService,
        AccessTokenGuard,
        { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
        { provide: AUTHENTICATION_SERVICE, useClass: AuthenticationService },
        {
          provide: APPLICATION_ACCESS_SERVICE,
          useClass: ApplicationAccessService,
        },
        { provide: CALENDAR_REPOSITORY, useClass: CalendarRepository },
        { provide: CALENDAR_SERVICE, useClass: CalendarService },
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

    // Seed users
    await prisma.user.createMany({
      data: users.map((id) => ({
        id,
        displayName: `Calendar test ${id.slice(0, 8)}`,
        status: 'ACTIVE',
        tokenVersion: 1,
      })),
    });

    // Seed sessions
    await prisma.userSession.createMany({
      data: [...sessions].map(([userId, id]) => ({
        id,
        userId,
        refreshTokenHash: randomBytes(32),
        expiresAt: future(),
        absoluteExpiresAt: future(),
      })),
    });

    // Seed JWTs
    for (const userId of users) {
      const issued = Math.floor(Date.now() / 1000);
      const token = await new SignJWT({
        sub: userId,
        sid: sessions.get(userId),
        ver: 1,
        iat: issued,
        exp: issued + 900,
        iss: 'baby-family',
        aud: 'baby-family-app',
      })
        .setProtectedHeader({ alg: 'ES256', typ: 'at+jwt' })
        .sign(keys.privateKey);

      tokens.set(userId, `Bearer ${token}`);
    }

    // Seed family
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Gia đình Cà Chua Test',
        createdBy: parentA,
        status: 'ACTIVE',
        activatedAt: past(),
        timezone: 'Asia/Ho_Chi_Minh',
      },
    });

    // Seed parents
    const parentRowA = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentA,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });

    const parentRowB = await prisma.familyParent.create({
      data: {
        familyId,
        userId: parentB,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
      },
    });

    // Seed couple space
    await prisma.coupleSpace.create({
      data: {
        id: coupleSpaceId,
        familyId,
        parentAUserId: parentA,
        parentBUserId: parentB,
        parentAMembershipId: parentRowA.id,
        parentBMembershipId: parentRowB.id,
      },
    });

    // Seed plan and entitlement
    await prisma.plan.create({
      data: {
        id: planId,
        code: `CALENDAR_${randomUUID().slice(0, 16)}`,
        displayNameI18n: { vi: 'Calendar Test Plan' },
        purchaseEnabled: false,
      },
    });

    await prisma.planVersion.create({
      data: {
        id: planVersionId,
        planId,
        version: 1,
        quotas: {},
        features: {},
        availableFrom: past(),
      },
    });

    await prisma.familyLicense.create({
      data: { id: licenseId, familyId },
    });

    await prisma.familyEntitlement.create({
      data: {
        familyId,
        licenseId,
        accessPhase: 'PAID',
        effectivePlanVersionId: planVersionId,
        validUntil: future(),
      },
    });

    // Seed child Hana (born 2025-10-25)
    await prisma.child.create({
      data: {
        id: childHanaId,
        familyId,
        name: 'Hana Nguyen',
        nickname: 'Hana',
        birthDate: new Date('2025-10-25T00:00:00.000Z'),
        gender: 'FEMALE',
        colorIndex: 1,
        createdBy: parentA,
        status: 'ACTIVE',
        monthlyPhotoMode: 'AUTO',
        monthlyPhotoLunar: false,
      },
    });

    // Seed Circle Member with grant for Hana
    await prisma.circleMember.create({
      data: {
        id: circleMemberId,
        familyId,
        userId: circleUser,
        relation: 'CAREGIVER',
        displayName: 'Bà ngoại',
        status: 'ACTIVE',
        invitedBy: parentA,
      },
    });

    await prisma.circleGrant.create({
      data: {
        familyId,
        circleMemberId,
        childId: childHanaId,
        permission: 'VIEW',
        createdBy: parentA,
      },
    });
  });

  async function clearCalendarData() {
    await prisma.eventReminder.deleteMany({ where: { familyId } });
    await prisma.eventReminderRule.deleteMany({ where: { familyId } });
    await prisma.eventParticipant.deleteMany({ where: { familyId } });
    await prisma.eventChild.deleteMany({ where: { familyId } });
    await prisma.event.deleteMany({ where: { familyId } });
    // The mission scope trigger is deferred: drop children and missions together.
    await prisma.$transaction(async (tx) => {
      await tx.missionChild.deleteMany({ where: { familyId } });
      await tx.mission.deleteMany({ where: { familyId } });
    });
    await prisma.outboxEvent.deleteMany({ where: { familyId } });
  }

  beforeEach(clearCalendarData);

  afterAll(async () => {
    try {
      await clearCalendarData();
      await prisma.circleGrant.deleteMany({ where: { familyId } });
      await prisma.circleMember.deleteMany({ where: { familyId } });
      await prisma.child.deleteMany({ where: { familyId } });
      await prisma.familyEntitlement.deleteMany({ where: { familyId } });
      await prisma.familyLicense.deleteMany({ where: { familyId } });
      await prisma.planVersion.deleteMany({ where: { id: planVersionId } });
      await prisma.plan.deleteMany({ where: { id: planId } });
      await prisma.coupleSpace.deleteMany({ where: { familyId } });
      await prisma.familyParent.deleteMany({ where: { familyId } });
      await prisma.family.deleteMany({ where: { id: familyId } });
      await prisma.userSession.deleteMany({ where: { userId: { in: users } } });
      await prisma.user.deleteMany({ where: { id: { in: users } } });
      await app.close();
    } catch {
      // Best-effort cleanup
    }
  });

  describe('POST /events — Event creation', () => {
    it('creates an event with children, participants, reminder rules and outbox event', async () => {
      const payload = {
        familyId,
        type: 'CHILD',
        title: 'Tiêm phòng 1 tuổi cho Hana',
        notes: 'Mang theo sổ tiêm chủng',
        allDay: false,
        startAt: '2026-10-25T09:00:00.000Z',
        endAt: '2026-10-25T10:00:00.000Z',
        localStartDate: '2026-10-25',
        localEndDate: '2026-10-25',
        childIds: [childHanaId],
        participants: [{ userId: parentB, response: 'INVITED' }],
        reminderRules: [
          { recipientUserId: parentA, offsetMinutes: 60, enabled: true },
        ],
        inviteCircle: true,
      };

      const res = await request(app.getHttpServer())
        .post('/api/v1/events')
        .set('Authorization', tokens.get(parentA)!)
        .send(payload)
        .expect(201);

      const eventData = data<EventResponseDto>(res);
      expect(eventData.id).toBeDefined();
      expect(eventData.title).toBe(payload.title);
      expect(eventData.type).toBe('CHILD');
      expect(eventData.childIds).toEqual([childHanaId]);
      expect(eventData.participants).toHaveLength(1);
      expect(eventData.reminderRules).toHaveLength(1);
      expect(eventData.version).toBe(1);

      // Verify DB records
      const dbEvent = await prisma.event.findUnique({
        where: { id: eventData.id },
      });
      expect(dbEvent).toBeDefined();
      expect(dbEvent?.title).toBe(payload.title);
      expect(dbEvent?.deletedAt).toBeNull();

      const dbChildren = await prisma.eventChild.findMany({
        where: { eventId: eventData.id, deletedAt: null },
      });
      expect(dbChildren).toHaveLength(1);
      expect(dbChildren[0]!.childId).toBe(childHanaId);

      const dbParticipants = await prisma.eventParticipant.findMany({
        where: { eventId: eventData.id, deletedAt: null },
      });
      expect(dbParticipants).toHaveLength(1);
      expect(dbParticipants[0]!.userId).toBe(parentB);

      const dbRules = await prisma.eventReminderRule.findMany({
        where: { eventId: eventData.id, deletedAt: null },
      });
      expect(dbRules).toHaveLength(1);
      expect(dbRules[0]!.offsetMinutes).toBe(60);

      // Verify Outbox event: event.changed (ids only)
      const outbox = await prisma.outboxEvent.findFirst({
        where: {
          familyId,
          aggregateId: eventData.id,
          eventType: 'event.changed',
        },
      });
      expect(outbox).toBeDefined();
      expect(outbox?.payload).toEqual({
        eventId: eventData.id,
        familyId,
      });
    });

    it('rejects COUPLE event with inviteCircle=true (422)', async () => {
      const payload = {
        familyId,
        type: 'COUPLE',
        title: 'Hẹn hò bí mật',
        startAt: '2026-10-25T19:00:00.000Z',
        inviteCircle: true,
      };

      const res = await request(app.getHttpServer())
        .post('/api/v1/events')
        .set('Authorization', tokens.get(parentA)!)
        .send(payload)
        .expect(422);

      expect(errCode(res)).toBe('EVENT_INVITE_CIRCLE_INVALID');
    });

    it('rejects isLunar=true without lunar month/day (422)', async () => {
      const payload = {
        familyId,
        type: 'FAMILY',
        title: 'Cúng rằm',
        startAt: '2026-10-25T10:00:00.000Z',
        isLunar: true,
      };

      const res = await request(app.getHttpServer())
        .post('/api/v1/events')
        .set('Authorization', tokens.get(parentA)!)
        .send(payload)
        .expect(422);

      expect(errCode(res)).toBe('EVENT_LUNAR_DATE_INVALID');
    });

    it('rejects outsider from creating event (403)', async () => {
      const payload = {
        familyId,
        type: 'FAMILY',
        title: 'Sự kiện người ngoài',
        startAt: '2026-10-25T10:00:00.000Z',
      };

      await request(app.getHttpServer())
        .post('/api/v1/events')
        .set('Authorization', tokens.get(outsiderUser)!)
        .send(payload)
        .expect(404);
    });
  });

  describe('PATCH & DELETE /events/:id', () => {
    it('updates event and increments version', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/v1/events')
        .set('Authorization', tokens.get(parentA)!)
        .send({
          familyId,
          type: 'FAMILY',
          title: 'Đi công viên cuối tuần',
          startAt: '2026-10-25T08:00:00.000Z',
        })
        .expect(201);

      const eventId = data<EventResponseDto>(createRes).id;

      const patchRes = await request(app.getHttpServer())
        .patch(`/api/v1/events/${eventId}`)
        .set('Authorization', tokens.get(parentB)!)
        .send({
          title: 'Đi Thảo Cầm Viên cuối tuần',
          notes: 'Mang theo mũ và nước',
          version: 1,
        })
        .expect(200);

      const updated = data<EventResponseDto>(patchRes);
      expect(updated.title).toBe('Đi Thảo Cầm Viên cuối tuần');
      expect(updated.notes).toBe('Mang theo mũ và nước');
      expect(updated.version).toBe(2);

      // Verify outbox
      const outbox = await prisma.outboxEvent.findMany({
        where: { aggregateId: eventId, eventType: 'event.changed' },
      });
      expect(outbox.length).toBeGreaterThanOrEqual(2);
    });

    it('rejects update with stale version (409)', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/v1/events')
        .set('Authorization', tokens.get(parentA)!)
        .send({
          familyId,
          type: 'FAMILY',
          title: 'Sự kiện phiên bản',
          startAt: '2026-10-25T08:00:00.000Z',
        })
        .expect(201);

      const eventId = data<EventResponseDto>(createRes).id;

      const res = await request(app.getHttpServer())
        .patch(`/api/v1/events/${eventId}`)
        .set('Authorization', tokens.get(parentA)!)
        .send({
          title: 'Đổi tên',
          version: 99, // Mismatch
        })
        .expect(409);

      expect(errCode(res)).toBe('EVENT_VERSION_CONFLICT');
    });

    it('soft deletes event and cascades to relations', async () => {
      const createRes = await request(app.getHttpServer())
        .post('/api/v1/events')
        .set('Authorization', tokens.get(parentA)!)
        .send({
          familyId,
          type: 'CHILD',
          title: 'Sự kiện sẽ xoá',
          startAt: '2026-10-25T08:00:00.000Z',
          childIds: [childHanaId],
          participants: [{ userId: parentB }],
          reminderRules: [{ recipientUserId: parentA, offsetMinutes: 15 }],
        })
        .expect(201);

      const eventId = data<EventResponseDto>(createRes).id;

      await request(app.getHttpServer())
        .delete(`/api/v1/events/${eventId}`)
        .set('Authorization', tokens.get(parentA)!)
        .expect(200);

      // Verify database soft delete
      const dbEvent = await prisma.event.findUnique({ where: { id: eventId } });
      expect(dbEvent?.deletedAt).not.toBeNull();

      const dbChildren = await prisma.eventChild.findMany({
        where: { eventId },
      });
      expect(dbChildren.every((c) => c.deletedAt !== null)).toBe(true);

      const dbParticipants = await prisma.eventParticipant.findMany({
        where: { eventId },
      });
      expect(dbParticipants.every((p) => p.deletedAt !== null)).toBe(true);

      const dbRules = await prisma.eventReminderRule.findMany({
        where: { eventId },
      });
      expect(dbRules.every((r) => r.deletedAt !== null)).toBe(true);

      // Subsequent GET returns 404
      await request(app.getHttpServer())
        .get(`/api/v1/events/${eventId}`)
        .set('Authorization', tokens.get(parentA)!)
        .expect(404);
    });
  });

  describe('GET /families/:familyId/calendar — Calendar view (CARE-07)', () => {
    it('returns events, missions (without partner hearts), and computed special days within range', async () => {
      // 1. Create a Child event
      await prisma.event.create({
        data: {
          familyId,
          type: 'CHILD',
          title: 'Sinh nhật 1 tuổi Hana',
          startAt: new Date('2026-10-25T10:00:00.000Z'),
          localStartDate: new Date('2026-10-25T00:00:00.000Z'),
          createdBy: parentA,
          inviteCircle: true,
          eventChildren: {
            create: { childId: childHanaId },
          },
        },
      });

      // 2. Create a Couple event ("Hai ta")
      await prisma.event.create({
        data: {
          familyId,
          type: 'COUPLE',
          title: 'Kỷ niệm ngày cưới',
          startAt: new Date('2026-10-26T18:00:00.000Z'),
          localStartDate: new Date('2026-10-26T00:00:00.000Z'),
          createdBy: parentA,
          inviteCircle: false,
        },
      });

      // 3. Create My mission and Partner mission (scope trigger is deferred → one transaction)
      const partnerMissionId = randomUUID();
      await prisma.$transaction(async (tx) => {
        const myMissionId = randomUUID();
        await tx.mission.create({
          data: {
            id: myMissionId,
            familyId,
            boardDate: new Date('2026-10-25T00:00:00.000Z'),
            ownerKind: 'PARENT',
            ownerUserId: parentA,
            source: 'SYSTEM',
            title: 'Nhiệm vụ của Ba',
            category: 'CARE',
            targetScope: 'CHILD',
            hearts: 5,
            status: 'DONE',
            completedAt: new Date('2026-10-25T10:00:00.000Z'),
            completedBy: parentA,
          },
        });

        await tx.mission.create({
          data: {
            id: partnerMissionId,
            familyId,
            boardDate: new Date('2026-10-25T00:00:00.000Z'),
            ownerKind: 'PARENT',
            ownerUserId: parentB,
            source: 'SYSTEM',
            title: 'Nhiệm vụ của Mẹ',
            category: 'PLAY',
            targetScope: 'CHILD',
            hearts: 4,
            status: 'DONE',
            completedAt: new Date('2026-10-25T11:00:00.000Z'),
            completedBy: parentB,
          },
        });
        await tx.missionChild.createMany({
          data: [myMissionId, partnerMissionId].map((missionId) => ({
            missionId,
            childId: childHanaId,
            familyId,
          })),
        });
      });

      // Call calendar as Parent A
      const res = await request(app.getHttpServer())
        .get(
          `/api/v1/families/${familyId}/calendar?from=2026-10-20&to=2026-10-31`,
        )
        .set('Authorization', tokens.get(parentA)!)
        .expect(200);

      const calendar = data<CalendarResponseDto>(res);
      expect(calendar.from).toBe('2026-10-20');
      expect(calendar.to).toBe('2026-10-31');

      // Check events: Parent A sees both Child event and Couple event
      expect(calendar.events.length).toBeGreaterThanOrEqual(2);
      expect(calendar.events.some((e) => e.type === 'COUPLE')).toBe(true);

      // Check missions: Partner mission has no hearts
      expect(calendar.missions).toHaveLength(2);
      const partnerM = calendar.missions.find((m) => m.id === partnerMissionId);
      expect(partnerM).toBeDefined();
      expect(partnerM).not.toHaveProperty('hearts');
      expect(partnerM?.title).toBe('Nhiệm vụ của Mẹ');

      // Check Special Days: Hana 1 year birthday appears on 2026-10-25
      const birthday = calendar.specialDays.find(
        (s) => s.type === 'BIRTHDAY' && s.childId === childHanaId,
      );
      expect(birthday).toBeDefined();
      expect(birthday?.date).toBe('2026-10-25');
      expect(birthday?.ageYears).toBe(1);
    });

    it('rejects range exceeding 62 days with 400 CALENDAR_DATE_RANGE_INVALID', async () => {
      const res = await request(app.getHttpServer())
        .get(
          `/api/v1/families/${familyId}/calendar?from=2026-01-01&to=2026-03-15`,
        )
        .set('Authorization', tokens.get(parentA)!)
        .expect(400);

      expect(errCode(res)).toBe('CALENDAR_DATE_RANGE_INVALID');
    });

    it('circle member sees empty missions and never sees COUPLE events', async () => {
      // Create a Couple event
      await prisma.event.create({
        data: {
          familyId,
          type: 'COUPLE',
          title: 'Hẹn hò bí mật 2',
          startAt: new Date('2026-10-26T18:00:00.000Z'),
          localStartDate: new Date('2026-10-26T00:00:00.000Z'),
          createdBy: parentA,
          inviteCircle: false,
        },
      });

      // Create a Family event with inviteCircle=true
      await prisma.event.create({
        data: {
          familyId,
          type: 'FAMILY',
          title: 'Bữa cơm sum vầy',
          startAt: new Date('2026-10-25T18:00:00.000Z'),
          localStartDate: new Date('2026-10-25T00:00:00.000Z'),
          createdBy: parentA,
          inviteCircle: true,
        },
      });

      const res = await request(app.getHttpServer())
        .get(
          `/api/v1/families/${familyId}/calendar?from=2026-10-20&to=2026-10-31`,
        )
        .set('Authorization', tokens.get(circleUser)!)
        .expect(200);

      const calendar = data<CalendarResponseDto>(res);
      // Circle never sees missions
      expect(calendar.missions).toEqual([]);

      // Circle sees the inviteCircle=true event
      expect(calendar.events.some((e) => e.title === 'Bữa cơm sum vầy')).toBe(
        true,
      );

      // Circle NEVER sees COUPLE event
      expect(calendar.events.some((e) => e.type === 'COUPLE')).toBe(false);
    });
  });
});
