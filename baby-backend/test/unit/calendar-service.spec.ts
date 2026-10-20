import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import type { CalendarQueryDto } from '../../src/dto/calendar/calendar-query.dto';
import type { CreateEventDto } from '../../src/dto/calendar/create-event.dto';
import type {
  CalendarMissionRow,
  FamilyCalendarContext,
  ICalendarRepository,
} from '../../src/interfaces/repositories/calendar-repository.interface';
import type { IApplicationAccessService } from '../../src/interfaces/services/application-access-service.interface';
import { Child } from '../../src/models/child.model';
import { Family } from '../../src/models/family.model';
import { Mission } from '../../src/models/mission.model';
import { CalendarService } from '../../src/services/calendar.service';

describe('CalendarService', () => {
  let service: CalendarService;
  let repository: jest.Mocked<ICalendarRepository>;
  let access: jest.Mocked<IApplicationAccessService>;

  const parentActor: AuthPrincipal = {
    userId: 'user-parent-1',
    sessionId: 'session-1',
    tokenVersion: 1,
  };

  const circleActor: AuthPrincipal = {
    userId: 'user-circle-1',
    sessionId: 'session-2',
    tokenVersion: 1,
  };

  const familyId = 'family-uuid-1';

  const mockFamily = new Family({
    id: familyId,
    name: 'Gia đình Cà Chua',
    coverAssetId: null,
    status: 'ACTIVE',
    activatedAt: new Date('2026-01-01T00:00:00.000Z'),
    timezone: 'Asia/Ho_Chi_Minh',
    contentLocale: 'vi',
    settings: {},
    accessVersion: 1,
    createdBy: parentActor.userId,
    createdAt: new Date('2026-01-01T00:00:00.000Z'),
    updatedAt: new Date('2026-01-01T00:00:00.000Z'),
    deletionScheduledAt: null,
    deletedAt: null,
  });

  beforeEach(() => {
    repository = {
      findFamilyContext: jest.fn(),
      findEventsForCalendar: jest.fn(),
      findEventById: jest.fn(),
      findFamilyChildren: jest.fn(),
      findCalendarMissions: jest.fn(),
      createEvent: jest.fn(),
      updateEvent: jest.fn(),
      softDeleteEvent: jest.fn(),
    };

    access = {
      requireParent: jest.fn().mockResolvedValue(mockFamily),
    };

    service = new CalendarService(repository, access);
  });

  describe('Range validation', () => {
    it('rejects range exceeding 62 days with CALENDAR_DATE_RANGE_INVALID 400', async () => {
      const query: CalendarQueryDto = {
        from: '2026-01-01',
        to: '2026-03-10', // 69 days
      };

      await expect(
        service.getCalendar(parentActor, familyId, query),
      ).rejects.toMatchObject({
        code: 'CALENDAR_DATE_RANGE_INVALID',
        statusCode: 400,
      });
    });

    it('rejects invalid date format', async () => {
      const query: CalendarQueryDto = {
        from: 'invalid-date',
        to: '2026-01-10',
      };

      await expect(
        service.getCalendar(parentActor, familyId, query),
      ).rejects.toMatchObject({
        code: 'CALENDAR_DATE_RANGE_INVALID',
        statusCode: 400,
      });
    });

    it('rejects from date after to date', async () => {
      const query: CalendarQueryDto = {
        from: '2026-02-10',
        to: '2026-02-01',
      };

      await expect(
        service.getCalendar(parentActor, familyId, query),
      ).rejects.toMatchObject({
        code: 'CALENDAR_DATE_RANGE_INVALID',
        statusCode: 400,
      });
    });
  });

  describe('Event validation', () => {
    it('rejects COUPLE event with inviteCircle=true', async () => {
      const dto: CreateEventDto = {
        familyId,
        type: 'COUPLE',
        title: 'Hẹn hò hai ta',
        startAt: '2026-10-25T12:00:00.000Z',
        inviteCircle: true,
      };

      await expect(service.createEvent(parentActor, dto)).rejects.toMatchObject(
        {
          code: 'EVENT_INVITE_CIRCLE_INVALID',
          statusCode: 422,
        },
      );
    });

    it('rejects lunar event without lunarMonth or lunarDay', async () => {
      const dto: CreateEventDto = {
        familyId,
        type: 'FAMILY',
        title: 'Giỗ ông',
        startAt: '2026-10-25T12:00:00.000Z',
        isLunar: true,
      };

      await expect(service.createEvent(parentActor, dto)).rejects.toMatchObject(
        {
          code: 'EVENT_LUNAR_DATE_INVALID',
          statusCode: 422,
        },
      );
    });

    it('rejects endAt earlier than startAt', async () => {
      const dto: CreateEventDto = {
        familyId,
        type: 'CHILD',
        title: 'Sinh nhật',
        startAt: '2026-10-25T12:00:00.000Z',
        endAt: '2026-10-24T12:00:00.000Z',
      };

      await expect(service.createEvent(parentActor, dto)).rejects.toMatchObject(
        {
          code: 'EVENT_DATE_INVALID',
          statusCode: 422,
        },
      );
    });
  });

  describe('Mission projection & privacy', () => {
    it('projects partner mission as PartnerMissionDto without hearts', async () => {
      const parentCtx: FamilyCalendarContext = {
        family: mockFamily,
        isParent: true,
        isCircle: false,
        grantedChildIds: [],
      };
      repository.findFamilyContext.mockResolvedValue(parentCtx);
      repository.findEventsForCalendar.mockResolvedValue([]);
      repository.findFamilyChildren.mockResolvedValue([]);

      const partnerMission = new Mission({
        id: 'mission-partner-1',
        familyId,
        boardDate: new Date('2026-10-20T00:00:00.000Z'),
        ownerKind: 'PARENT',
        ownerUserId: 'user-parent-2',
        source: 'SYSTEM',
        templateId: null,
        seriesId: null,
        swappedFromId: null,
        swapCount: 0,
        refType: null,
        refId: null,
        title: 'Tắm cho bé',
        note: null,
        category: 'CARE',
        targetScope: 'CHILD',
        hearts: 5,
        status: 'DONE',
        scheduledTime: null,
        dueAt: null,
        reminderAt: null,
        memoryPrompt: true,
        completedBy: 'user-parent-2',
        completedAt: new Date('2026-10-20T11:00:00.000Z'),
        late: false,
        removedReason: null,
        removedAt: null,
        createdBy: null,
        createdAt: new Date('2026-10-20T00:00:00.000Z'),
        updatedAt: new Date('2026-10-20T11:00:00.000Z'),
        deletedAt: null,
        version: 1,
      });

      const myMission = new Mission({
        id: 'mission-me-1',
        familyId,
        boardDate: new Date('2026-10-20T00:00:00.000Z'),
        ownerKind: 'PARENT',
        ownerUserId: parentActor.userId,
        source: 'SYSTEM',
        templateId: null,
        seriesId: null,
        swappedFromId: null,
        swapCount: 0,
        refType: null,
        refId: null,
        title: 'Đọc sách cùng con',
        note: null,
        category: 'PLAY',
        targetScope: 'CHILD',
        hearts: 3,
        status: 'TODO',
        scheduledTime: null,
        dueAt: null,
        reminderAt: null,
        memoryPrompt: true,
        completedBy: null,
        completedAt: null,
        late: false,
        removedReason: null,
        removedAt: null,
        createdBy: null,
        createdAt: new Date('2026-10-20T00:00:00.000Z'),
        updatedAt: new Date('2026-10-20T00:00:00.000Z'),
        deletedAt: null,
        version: 1,
      });

      const missionRows: CalendarMissionRow[] = [
        { mission: partnerMission, childIds: ['child-1'], events: [] },
        { mission: myMission, childIds: ['child-1'], events: [] },
      ];

      repository.findCalendarMissions.mockResolvedValue(missionRows);

      const res = await service.getCalendar(parentActor, familyId, {
        from: '2026-10-20',
        to: '2026-10-21',
      });

      expect(res.missions).toHaveLength(2);

      const projectedPartner = res.missions.find(
        (m) => m.id === partnerMission.id,
      );
      expect(projectedPartner).toBeDefined();
      expect(projectedPartner).not.toHaveProperty('hearts');
      expect(projectedPartner).toEqual({
        id: partnerMission.id,
        title: 'Tắm cho bé',
        category: 'CARE',
        childIds: ['child-1'],
        status: 'DONE',
        completedAt: '2026-10-20T11:00:00.000Z',
        late: false,
        thanked: false,
      });

      const projectedMine = res.missions.find((m) => m.id === myMission.id);
      expect(projectedMine).toBeDefined();
      expect(projectedMine).toHaveProperty('hearts', 3);
    });

    it('omits partner EXPIRED or past TODO missions', async () => {
      const parentCtx: FamilyCalendarContext = {
        family: mockFamily,
        isParent: true,
        isCircle: false,
        grantedChildIds: [],
      };
      repository.findFamilyContext.mockResolvedValue(parentCtx);
      repository.findEventsForCalendar.mockResolvedValue([]);
      repository.findFamilyChildren.mockResolvedValue([]);

      const expiredPartnerMission = new Mission({
        id: 'mission-partner-expired',
        familyId,
        boardDate: new Date('2026-10-10T00:00:00.000Z'),
        ownerKind: 'PARENT',
        ownerUserId: 'user-parent-2',
        source: 'SYSTEM',
        templateId: null,
        seriesId: null,
        swappedFromId: null,
        swapCount: 0,
        refType: null,
        refId: null,
        title: 'Hết hạn',
        note: null,
        category: 'CARE',
        targetScope: 'CHILD',
        hearts: 5,
        status: 'EXPIRED',
        scheduledTime: null,
        dueAt: null,
        reminderAt: null,
        memoryPrompt: true,
        completedBy: null,
        completedAt: null,
        late: false,
        removedReason: null,
        removedAt: null,
        createdBy: null,
        createdAt: new Date('2026-10-10T00:00:00.000Z'),
        updatedAt: new Date('2026-10-10T00:00:00.000Z'),
        deletedAt: null,
        version: 1,
      });

      repository.findCalendarMissions.mockResolvedValue([
        { mission: expiredPartnerMission, childIds: [], events: [] },
      ]);

      const res = await service.getCalendar(parentActor, familyId, {
        from: '2026-10-09',
        to: '2026-10-15',
      });

      expect(res.missions).toHaveLength(0);
    });

    it('circle member sees empty missions list', async () => {
      const circleCtx: FamilyCalendarContext = {
        family: mockFamily,
        isParent: false,
        isCircle: true,
        grantedChildIds: ['child-1'],
      };
      repository.findFamilyContext.mockResolvedValue(circleCtx);
      repository.findEventsForCalendar.mockResolvedValue([]);
      repository.findFamilyChildren.mockResolvedValue([]);

      const res = await service.getCalendar(circleActor, familyId, {
        from: '2026-10-01',
        to: '2026-10-10',
      });

      expect(res.missions).toEqual([]);
      expect(repository.findCalendarMissions).not.toHaveBeenCalled();
    });
  });

  describe('Special days (Birthdays & Monthiversaries)', () => {
    it('computes birthday and monthiversaries from children', async () => {
      const parentCtx: FamilyCalendarContext = {
        family: mockFamily,
        isParent: true,
        isCircle: false,
        grantedChildIds: [],
      };
      repository.findFamilyContext.mockResolvedValue(parentCtx);
      repository.findEventsForCalendar.mockResolvedValue([]);
      repository.findCalendarMissions.mockResolvedValue([]);

      const child = new Child({
        id: 'child-hana',
        familyId,
        pregnancyId: null,
        birthOrder: 1,
        name: 'Hana Nguyen',
        nickname: 'Hana',
        birthDate: new Date('2025-10-25T00:00:00.000Z'),
        birthTime: null,
        gender: 'FEMALE',
        colorIndex: 0,
        avatarAssetId: null,
        coverAssetId: null,
        profile: {},
        birthStats: null,
        status: 'ACTIVE',
        sortOrder: 0,
        monthlyPhotoMode: 'AUTO',
        monthlyPhotoLunar: false,
        createdBy: parentActor.userId,
        createdAt: new Date('2025-10-25T00:00:00.000Z'),
        updatedAt: new Date('2025-10-25T00:00:00.000Z'),
        archivedAt: null,
        version: 1,
        deletedAt: null,
        deletionRequestedAt: null,
        purgeAfter: null,
      });

      repository.findFamilyChildren.mockResolvedValue([child]);

      const res = await service.getCalendar(parentActor, familyId, {
        from: '2026-10-20',
        to: '2026-10-31',
      });

      // 1 year birthday on 2026-10-25, and month 12 is birthday
      const birthday = res.specialDays.find((s) => s.type === 'BIRTHDAY');
      expect(birthday).toBeDefined();
      expect(birthday?.date).toBe('2026-10-25');
      expect(birthday?.ageYears).toBe(1);
      expect(birthday?.title).toContain('Sinh nhật Hana (1 tuổi)');
    });
  });
});
