import { CARE_PROGRESS_POLICY } from '../../src/config/care-progress-policy';
import { CareProgressService } from '../../src/services/care-progress.service';
import type { IApplicationAccessService } from '../../src/interfaces/services/application-access-service.interface';
import type { ICareProgressRepository } from '../../src/interfaces/repositories/care-progress-repository.interface';
import type { AuthPrincipal } from '../../src/common/auth/auth-principal';
import { Mission } from '../../src/models/mission.model';
import { Family } from '../../src/models/family.model';
import type { HeartsMeQueryDto } from '../../src/dto/care/hearts-me.dto';
import type { MyMissionDto } from '../../src/dto/mission/mission.dto';

describe('CareProgressPolicy', () => {
  it('defines correct tree level names and thresholds', () => {
    expect(CARE_PROGRESS_POLICY.treeLevelNames[1]).toBe('Hạt mầm');
    expect(CARE_PROGRESS_POLICY.treeLevelNames[7]).toBe('Cây cổ thụ');
    expect(CARE_PROGRESS_POLICY.treeLevelThresholds).toEqual([
      0, 100, 300, 700, 1500, 3000, 6000,
    ]);
    expect(CARE_PROGRESS_POLICY.maxMissionHistoryDays).toBe(92);
    expect(CARE_PROGRESS_POLICY.dailyHeartCap).toBe(75);
  });
});

describe('CareProgressService (Unit)', () => {
  let service: CareProgressService;
  let mockAccess: jest.Mocked<IApplicationAccessService>;
  let mockRepo: jest.Mocked<ICareProgressRepository>;

  const actor: AuthPrincipal = {
    userId: '11111111-1111-1111-1111-111111111111',
    sessionId: 'session-1',
    tokenVersion: 1,
  };
  const partnerId = '22222222-2222-2222-2222-222222222222';
  const familyId = '33333333-3333-3333-3333-333333333333';
  const activeFamily = new Family({
    id: familyId,
    name: 'Test Family',
    coverAssetId: null,
    status: 'ACTIVE',
    activatedAt: new Date(),
    timezone: 'Asia/Ho_Chi_Minh',
    contentLocale: 'vi',
    settings: {},
    accessVersion: 1,
    createdBy: actor.userId,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletionScheduledAt: null,
    deletedAt: null,
  });

  beforeEach(() => {
    mockAccess = {
      requireParent: jest.fn().mockResolvedValue(activeFamily),
    };
    mockRepo = {
      getHeartsMe: jest.fn(),
      getFamilyTree: jest.fn(),
      getBadges: jest.fn(),
      getMissionHistory: jest.fn(),
    };
    service = new CareProgressService(mockAccess, mockRepo);
  });

  describe('getHeartsMe', () => {
    it('rejects userId in query parameters with 400', async () => {
      await expect(
        service.getHeartsMe(actor, familyId, {
          userId: partnerId,
        } as unknown as HeartsMeQueryDto),
      ).rejects.toMatchObject({
        code: 'USER_ID_NOT_ALLOWED',
        statusCode: 400,
      });
      expect(mockRepo.getHeartsMe).not.toHaveBeenCalled();
    });

    it('returns caller Hearts ledger without leaking partner ledger', async () => {
      mockRepo.getHeartsMe.mockResolvedValueOnce({
        today: 10,
        week: 35,
        total: 120,
        dailyCap: 75,
        history: [
          {
            id: 1n,
            createdAt: new Date('2026-10-18T10:00:00Z'),
            amount: 5,
            reason: 'MISSION_COMPLETED',
            sourceType: 'MISSION',
            sourceId: 'comp-1',
            title: 'Tắm cho bé',
          },
        ],
        nextCursor: null,
      });

      const result = await service.getHeartsMe(actor, familyId, {});
      expect(result.today).toBe(10);
      expect(result.week).toBe(35);
      expect(result.total).toBe(120);
      expect(result.dailyCap).toBe(75);
      expect(result.history).toHaveLength(1);
      expect(result.history[0]).toEqual({
        at: '2026-10-18T10:00:00.000Z',
        amount: 5,
        reason: 'MISSION_COMPLETED',
        title: 'Tắm cho bé',
      });
    });
  });

  describe('getFamilyTree', () => {
    it('returns tree status without any Hearts numbers in the response', async () => {
      mockRepo.getFamilyTree.mockResolvedValueOnce({
        level: 3,
        levelName: 'Cây non',
        progressPercent: 45,
        fruits: 0,
        flowers: 2,
        bloomedDaysThisWeek: 2,
        today: {
          leaves: 3,
          total: 5,
          bloomed: false,
        },
      });

      const result = await service.getFamilyTree(actor, familyId);
      expect(result).toEqual({
        level: 3,
        levelName: 'Cây non',
        progressPercent: 45,
        fruits: 0,
        flowers: 2,
        bloomedDaysThisWeek: 2,
        today: {
          leaves: 3,
          total: 5,
          bloomed: false,
        },
      });
      expect(result).not.toHaveProperty('totalHearts');
      expect(result).not.toHaveProperty('hearts');
      expect(result).not.toHaveProperty('myHeartsToday');
    });
  });

  describe('getBadges', () => {
    it('returns earned badges first, then upcoming badges with progress', async () => {
      mockRepo.getBadges.mockResolvedValueOnce([
        {
          code: 'OUTDOOR_FAMILY',
          titleI18n: { vi: 'Gia đình ngoài trời', en: 'Outdoor Family' },
          descI18n: {
            vi: '5 lần ra ngoài cùng nhau',
            en: '5 outdoor outings together',
          },
          icon: 'trees',
          scope: 'FAMILY',
          achieved: true,
          achievedAt: new Date('2026-10-15T08:00:00Z'),
          current: 5,
          target: 5,
          percent: 100,
        },
        {
          code: 'BOOKWORM',
          titleI18n: { vi: 'Nhà mọt sách', en: 'Bookworm Family' },
          descI18n: { vi: '10 lần đọc sách', en: '10 reading sessions' },
          icon: 'book-open',
          scope: 'FAMILY',
          achieved: false,
          achievedAt: null,
          current: 6,
          target: 10,
          percent: 60,
        },
      ]);

      const result = await service.getBadges(actor, familyId);
      expect(result.items).toHaveLength(2);
      expect(result.items[0]!.code).toBe('OUTDOOR_FAMILY');
      expect(result.items[0]!.achieved).toBe(true);
      expect(result.items[0]!.progress.percent).toBe(100);
      expect(result.items[1]!.code).toBe('BOOKWORM');
      expect(result.items[1]!.achieved).toBe(false);
      expect(result.items[1]!.progress.percent).toBe(60);
    });
  });

  describe('getMissionHistory', () => {
    it('rejects range > 92 days with 400', async () => {
      await expect(
        service.getMissionHistory(actor, familyId, {
          from: '2026-01-01',
          to: '2026-05-01',
        }),
      ).rejects.toMatchObject({
        code: 'MISSION_DATE_RANGE_INVALID',
        statusCode: 400,
      });
    });

    it('rejects from > to with 400', async () => {
      await expect(
        service.getMissionHistory(actor, familyId, {
          from: '2026-10-18',
          to: '2026-10-10',
        }),
      ).rejects.toMatchObject({
        code: 'MISSION_DATE_RANGE_INVALID',
        statusCode: 400,
      });
    });

    it('projects partner items as PartnerMissionDto without hearts', async () => {
      const partnerMission = new Mission({
        id: 'mission-partner-1',
        familyId,
        boardDate: new Date('2026-10-17T00:00:00Z'),
        ownerKind: 'PARENT',
        ownerUserId: partnerId,
        source: 'SYSTEM',
        templateId: null,
        seriesId: null,
        swappedFromId: null,
        swapCount: 0,
        refType: null,
        refId: null,
        title: 'Partner Mission',
        note: 'Secret partner note',
        category: 'CARE',
        targetScope: 'CHILD',
        hearts: 5,
        status: 'DONE',
        scheduledTime: null,
        dueAt: null,
        reminderAt: null,
        memoryPrompt: false,
        completedBy: partnerId,
        completedAt: new Date('2026-10-17T09:00:00Z'),
        late: false,
        removedReason: null,
        removedAt: null,
        createdBy: partnerId,
        createdAt: new Date('2026-10-17T00:00:00Z'),
        updatedAt: new Date('2026-10-17T09:00:00Z'),
        version: 1,
        deletedAt: null,
      });

      mockRepo.getMissionHistory.mockResolvedValueOnce({
        items: [
          {
            mission: partnerMission,
            childIds: ['child-1'],
            events: [],
          },
        ],
        nextCursor: null,
      });

      const result = await service.getMissionHistory(actor, familyId, {
        owner: 'PARTNER',
      });
      expect(result.items).toHaveLength(1);
      const item = result.items[0]!;
      expect(item).not.toHaveProperty('hearts');
      expect(item).not.toHaveProperty('note');
      expect(item).not.toHaveProperty('source');
      expect(item.id).toBe('mission-partner-1');
      expect(item.title).toBe('Partner Mission');
      expect(item.status).toBe('DONE');
    });

    it('projects own/together items as MyMissionDto with hearts and details', async () => {
      const ownMission = new Mission({
        id: 'mission-own-1',
        familyId,
        boardDate: new Date('2026-10-18T00:00:00Z'),
        ownerKind: 'PARENT',
        ownerUserId: actor.userId,
        source: 'SYSTEM',
        templateId: null,
        seriesId: null,
        swappedFromId: null,
        swapCount: 0,
        refType: null,
        refId: null,
        title: 'My Mission',
        note: 'My private note',
        category: 'CARE',
        targetScope: 'CHILD',
        hearts: 4,
        status: 'DONE',
        scheduledTime: null,
        dueAt: null,
        reminderAt: null,
        memoryPrompt: true,
        completedBy: actor.userId,
        completedAt: new Date('2026-10-18T08:00:00Z'),
        late: false,
        removedReason: null,
        removedAt: null,
        createdBy: actor.userId,
        createdAt: new Date('2026-10-18T00:00:00Z'),
        updatedAt: new Date('2026-10-18T08:00:00Z'),
        version: 1,
        deletedAt: null,
      });

      mockRepo.getMissionHistory.mockResolvedValueOnce({
        items: [
          {
            mission: ownMission,
            childIds: ['child-1'],
            events: [
              { type: 'CREATED', createdAt: new Date('2026-10-18T00:00:00Z') },
            ],
          },
        ],
        nextCursor: null,
      });

      const result = await service.getMissionHistory(actor, familyId, {
        owner: 'ME',
      });
      expect(result.items).toHaveLength(1);
      const item = result.items[0] as MyMissionDto;
      expect(item.hearts).toBe(4);
      expect(item.mine).toBe(true);
      expect(item.note).toBe('My private note');
      expect(item.events).toHaveLength(1);
    });
  });
});
