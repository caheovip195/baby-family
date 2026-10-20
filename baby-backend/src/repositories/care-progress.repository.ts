import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { Prisma } from '../generated/prisma/client';
import { Mission } from '../models/mission.model';
import { CARE_PROGRESS_POLICY } from '../config/care-progress-policy';
import type {
  CareBadgeEvaluation,
  CareFamilyTreeSnapshot,
  CareHeartsSnapshot,
  HeartLedgerHistoryItem,
} from '../models/care-progress.model';
import type { CareMissionHistoryQueryDto } from '../dto/care/care-mission-history.dto';
import type {
  CareMissionHistoryRow,
  ICareProgressRepository,
} from '../interfaces/repositories/care-progress-repository.interface';

const DEFAULT_BADGES = [
  {
    code: 'WARM_BEDTIME',
    titleI18n: { vi: 'Giờ ngủ ấm áp', en: 'Warm Bedtime' },
    descI18n: { vi: '7 hoạt động giờ đi ngủ', en: '7 bedtime activities' },
    icon: 'moon',
    rule: { metric: 'BEDTIME_MISSIONS', target: 7 },
    scope: 'FAMILY',
  },
  {
    code: 'BOOKWORM',
    titleI18n: { vi: 'Nhà mọt sách', en: 'Bookworm Family' },
    descI18n: { vi: '10 lần đọc sách', en: '10 reading sessions' },
    icon: 'book-open',
    rule: { metric: 'READING_MISSIONS', target: 10 },
    scope: 'FAMILY',
  },
  {
    code: 'OUTDOOR_FAMILY',
    titleI18n: { vi: 'Gia đình ngoài trời', en: 'Outdoor Family' },
    descI18n: {
      vi: '5 lần ra ngoài cùng nhau',
      en: '5 outdoor outings together',
    },
    icon: 'trees',
    rule: { metric: 'OUTDOOR_MISSIONS', target: 5 },
    scope: 'FAMILY',
  },
  {
    code: 'TEAM_WEEK',
    titleI18n: { vi: 'Tuần đồng đội', en: 'Teamwork Week' },
    descI18n: { vi: '5 nhiệm vụ cùng nhau', en: '5 missions together' },
    icon: 'users',
    rule: { metric: 'TOGETHER_MISSIONS', target: 5 },
    scope: 'FAMILY',
  },
  {
    code: 'MEMORY_KEEPER',
    titleI18n: { vi: 'Người giữ ký ức', en: 'Memory Keeper' },
    descI18n: { vi: '30 ký ức', en: '30 memories' },
    icon: 'camera',
    rule: { metric: 'MEMORIES_COUNT', target: 30 },
    scope: 'FAMILY',
  },
  {
    code: 'GRATITUDE_WEEK',
    titleI18n: { vi: 'Tuần cảm ơn', en: 'Gratitude Week' },
    descI18n: { vi: '7 lời cảm ơn trong tuần', en: '7 appreciations' },
    icon: 'heart',
    rule: { metric: 'APPRECIATIONS_COUNT', target: 7 },
    scope: 'FAMILY',
  },
  {
    code: 'ALWAYS_TOGETHER',
    titleI18n: { vi: 'Luôn bên nhau', en: 'Always Together' },
    descI18n: { vi: '10 lời nhờ được hỗ trợ', en: '10 requests supported' },
    icon: 'heart-handshake',
    rule: { metric: 'REQUESTS_DONE', target: 10 },
    scope: 'FAMILY',
  },
  {
    code: 'FIRST_MOMENTS',
    titleI18n: { vi: 'Những lần đầu', en: 'First Moments' },
    descI18n: { vi: '10 cột mốc của một bé', en: '10 milestones recorded' },
    icon: 'star',
    rule: { metric: 'MILESTONES_COUNT', target: 10 },
    scope: 'FAMILY',
  },
];

@Injectable()
export class CareProgressRepository implements ICareProgressRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getHeartsMe(
    familyId: string,
    userId: string,
    todayDate: Date,
    cursor?: string,
    limit = CARE_PROGRESS_POLICY.defaultLimit,
  ): Promise<CareHeartsSnapshot> {
    const weekStartDate = new Date(todayDate.getTime() - 6 * 86_400_000);

    const [todayAgg, weekAgg, totalAgg, rows] = await Promise.all([
      this.prisma.heartLedger.aggregate({
        _sum: { amount: true },
        where: {
          familyId,
          userId,
          localDate: todayDate,
          deletedAt: null,
        },
      }),
      this.prisma.heartLedger.aggregate({
        _sum: { amount: true },
        where: {
          familyId,
          userId,
          localDate: { gte: weekStartDate, lte: todayDate },
          deletedAt: null,
        },
      }),
      this.prisma.heartLedger.aggregate({
        _sum: { amount: true },
        where: {
          familyId,
          userId,
          deletedAt: null,
        },
      }),
      this.prisma.heartLedger.findMany({
        where: {
          familyId,
          userId,
          reversalOf: null,
          deletedAt: null,
          ...(cursor ? { id: { lt: BigInt(cursor) } } : {}),
        },
        include: {
          otherHeartLedgerHeartLedgerReversalOfToheartLedger: {
            where: { deletedAt: null },
            select: { amount: true },
          },
        },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        take: limit + 1,
      }),
    ]);

    const hasMore = rows.length > limit;
    const candidates = rows.slice(0, limit);
    const nextCursor = hasMore
      ? candidates[candidates.length - 1]!.id.toString()
      : null;

    const missionCompletionIds = candidates
      .filter((r) => r.sourceType === 'MISSION')
      .map((r) => r.sourceId);

    const completions = missionCompletionIds.length
      ? await this.prisma.missionCompletion.findMany({
          where: { id: { in: missionCompletionIds } },
          select: {
            id: true,
            missionsMissionCompletionsMissionIdTomissions: {
              select: { title: true },
            },
          },
        })
      : [];

    const completionTitleMap = new Map<string, string>();
    for (const c of completions) {
      if (c.missionsMissionCompletionsMissionIdTomissions?.title) {
        completionTitleMap.set(
          c.id,
          c.missionsMissionCompletionsMissionIdTomissions.title,
        );
      }
    }

    const history: HeartLedgerHistoryItem[] = [];
    for (const row of candidates) {
      const reversalAmount =
        row.otherHeartLedgerHeartLedgerReversalOfToheartLedger.reduce(
          (acc, cur) => acc + cur.amount,
          0,
        );
      const netAmount = row.amount + reversalAmount;
      if (netAmount <= 0) continue;

      let title: string | null = null;
      if (row.sourceType === 'MISSION') {
        title = completionTitleMap.get(row.sourceId) ?? null;
      }
      if (!title) {
        if (row.reason === 'CUSTOM_COMPLETED') title = 'Nhiệm vụ tự gõ';
        else if (row.reason === 'REQUEST_DONE') title = 'Lời nhờ hoàn thành';
        else if (row.reason === 'MEMORY_CREATED') title = 'Tạo ký ức';
        else if (row.reason === 'PERSPECTIVE_ADDED') title = 'Góc nhìn thứ hai';
        else if (row.reason === 'MILESTONE_RECORDED') title = 'Ghi cột mốc';
        else if (row.reason === 'APPRECIATION_SENT') title = 'Gửi lời cảm ơn';
      }

      history.push({
        id: row.id,
        createdAt: row.createdAt,
        amount: netAmount,
        reason: row.reason,
        sourceType: row.sourceType,
        sourceId: row.sourceId,
        title,
      });
    }

    return {
      today: Math.max(0, todayAgg._sum.amount ?? 0),
      week: Math.max(0, weekAgg._sum.amount ?? 0),
      total: Math.max(0, totalAgg._sum.amount ?? 0),
      dailyCap: CARE_PROGRESS_POLICY.dailyHeartCap,
      history,
      nextCursor,
    };
  }

  async getFamilyTree(
    familyId: string,
    todayDate: Date,
    weekStartDate: Date,
    weekEndDate: Date,
  ): Promise<CareFamilyTreeSnapshot> {
    const [tree, bloomedCount, todayMissions, todayBoard] = await Promise.all([
      this.prisma.familyTree.findUnique({
        where: { familyId },
      }),
      this.prisma.dailyMissionBoard.count({
        where: {
          familyId,
          boardDate: { gte: weekStartDate, lte: weekEndDate },
          bloomedAt: { not: null },
          deletedAt: null,
        },
      }),
      this.prisma.mission.findMany({
        where: {
          familyId,
          boardDate: todayDate,
          deletedAt: null,
          status: { not: 'REMOVED' },
        },
        select: { status: true },
      }),
      this.prisma.dailyMissionBoard.findUnique({
        where: { familyId_boardDate: { familyId, boardDate: todayDate } },
      }),
    ]);

    const totalHearts = tree?.totalHearts ?? 0;
    const level = tree?.level ?? 1;
    const fruits = tree?.fruits ?? 0;
    const flowers = tree?.flowers ?? 0;
    const levelName = CARE_PROGRESS_POLICY.treeLevelNames[level] ?? 'Hạt mầm';

    let progressPercent: number;
    const thresholds = CARE_PROGRESS_POLICY.treeLevelThresholds;
    if (level >= 7) {
      const overflow = Math.max(0, totalHearts - thresholds[6]);
      progressPercent = Math.min(
        100,
        Math.floor(
          ((overflow % CARE_PROGRESS_POLICY.fruitEveryHearts) * 100) /
            CARE_PROGRESS_POLICY.fruitEveryHearts,
        ),
      );
    } else {
      const minThreshold = thresholds[level - 1] ?? 0;
      const nextThreshold = thresholds[level] ?? minThreshold + 100;
      const span = Math.max(1, nextThreshold - minThreshold);
      const earnedInLevel = Math.max(0, totalHearts - minThreshold);
      progressPercent = Math.min(100, Math.floor((earnedInLevel * 100) / span));
    }

    const todayLeaves = todayMissions.filter((m) => m.status === 'DONE').length;
    const todayTotal = todayMissions.length;
    const todayBloomed = todayBoard?.bloomedAt != null;

    return {
      level,
      levelName,
      progressPercent,
      fruits,
      flowers,
      bloomedDaysThisWeek: bloomedCount,
      today: {
        leaves: todayLeaves,
        total: todayTotal,
        bloomed: todayBloomed,
      },
    };
  }

  async getBadges(familyId: string): Promise<CareBadgeEvaluation[]> {
    let catalogBadges = await this.prisma.badge.findMany({
      where: { status: 'ACTIVE', scope: 'FAMILY', deletedAt: null },
      orderBy: { code: 'asc' },
    });

    if (!catalogBadges.length) {
      catalogBadges = DEFAULT_BADGES.map((b) => ({
        code: b.code,
        titleI18n: b.titleI18n,
        descI18n: b.descI18n,
        icon: b.icon,
        rule: b.rule,
        scope: b.scope,
        status: 'ACTIVE',
        createdAt: new Date(),
        updatedAt: new Date(),
        deletedAt: null,
      }));
    }

    const earnedRows = await this.prisma.familyBadge.findMany({
      where: { familyId, subjectUserId: null, deletedAt: null },
    });
    const earnedMap = new Map(earnedRows.map((eb) => [eb.badgeCode, eb]));

    const [
      togetherMissionsDone,
      outdoorMissionsDone,
      memoriesCount,
      requestsDone,
      appreciationsCount,
      milestonesCount,
    ] = await Promise.all([
      this.prisma.mission.count({
        where: {
          familyId,
          ownerKind: 'TOGETHER',
          status: 'DONE',
          deletedAt: null,
        },
      }),
      this.prisma.mission.count({
        where: {
          familyId,
          category: 'OUTDOOR',
          status: 'DONE',
          deletedAt: null,
        },
      }),
      this.prisma.memory.count({ where: { familyId, deletedAt: null } }),
      this.prisma.request.count({
        where: { familyId, status: 'DONE', deletedAt: null },
      }),
      this.prisma.appreciation.count({ where: { familyId, deletedAt: null } }),
      this.prisma.milestone.count({ where: { familyId, deletedAt: null } }),
    ]);

    const evaluations: CareBadgeEvaluation[] = [];

    for (const badge of catalogBadges) {
      const earnedRecord = earnedMap.get(badge.code);
      const rule = (badge.rule ?? {}) as { metric?: string; target?: number };
      const target = Number(rule.target ?? 10);
      const metric = String(rule.metric ?? '');

      let current: number;
      switch (metric) {
        case 'BEDTIME_MISSIONS':
        case 'READING_MISSIONS':
        case 'TOGETHER_MISSIONS':
          current = togetherMissionsDone;
          break;
        case 'OUTDOOR_MISSIONS':
          current = outdoorMissionsDone;
          break;
        case 'MEMORIES_COUNT':
          current = memoriesCount;
          break;
        case 'APPRECIATIONS_COUNT':
          current = appreciationsCount;
          break;
        case 'REQUESTS_DONE':
          current = requestsDone;
          break;
        case 'MILESTONES_COUNT':
          current = milestonesCount;
          break;
        default:
          current = 0;
          break;
      }

      const achieved = !!earnedRecord;
      const achievedAt = earnedRecord?.achievedAt ?? null;
      const progressCurrent = achieved ? target : current;
      const percent = achieved
        ? 100
        : Math.min(100, Math.floor((progressCurrent * 100) / target));

      const titleI18n = (badge.titleI18n as Record<string, string>) ?? {
        vi: badge.code,
        en: badge.code,
      };
      const descI18n = (badge.descI18n as Record<string, string>) ?? {
        vi: '',
        en: '',
      };

      evaluations.push({
        code: badge.code,
        titleI18n,
        descI18n,
        icon: badge.icon,
        scope: badge.scope,
        achieved,
        achievedAt,
        current: progressCurrent,
        target,
        percent,
      });
    }

    evaluations.sort((a, b) => {
      if (a.achieved !== b.achieved) {
        return Number(b.achieved) - Number(a.achieved);
      }
      if (a.achieved) {
        const timeA = a.achievedAt?.getTime() ?? 0;
        const timeB = b.achievedAt?.getTime() ?? 0;
        return timeB - timeA || a.code.localeCompare(b.code);
      }
      return b.percent - a.percent || a.code.localeCompare(b.code);
    });

    return evaluations;
  }

  async getMissionHistory(
    familyId: string,
    userId: string,
    query: CareMissionHistoryQueryDto,
  ): Promise<{ items: CareMissionHistoryRow[]; nextCursor: string | null }> {
    const limit = query.limit ?? CARE_PROGRESS_POLICY.defaultLimit;

    let cursorDate: Date | null = null;
    let cursorId: string | null = null;
    if (query.cursor) {
      try {
        const decoded = JSON.parse(
          Buffer.from(query.cursor, 'base64url').toString('utf8'),
        ) as { date?: string; id?: string };
        if (
          decoded &&
          typeof decoded.date === 'string' &&
          typeof decoded.id === 'string'
        ) {
          cursorDate = new Date(`${decoded.date}T00:00:00.000Z`);
          cursorId = decoded.id;
        }
      } catch {
        if (
          /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
            query.cursor,
          )
        ) {
          cursorId = query.cursor;
          const target = await this.prisma.mission.findUnique({
            where: { id: cursorId },
            select: { boardDate: true },
          });
          if (target) cursorDate = target.boardDate;
        }
      }
    }

    const where: Prisma.MissionWhereInput = {
      familyId,
      deletedAt: null,
    };

    if (query.from || query.to) {
      where.boardDate = {
        ...(query.from ? { gte: new Date(`${query.from}T00:00:00.000Z`) } : {}),
        ...(query.to ? { lte: new Date(`${query.to}T00:00:00.000Z`) } : {}),
      };
    }

    if (query.owner === 'ME') {
      where.ownerKind = 'PARENT';
      where.ownerUserId = userId;
      where.status = query.status ? query.status : { not: 'REMOVED' };
    } else if (query.owner === 'TOGETHER') {
      where.ownerKind = 'TOGETHER';
      where.status = query.status ? query.status : { not: 'REMOVED' };
    } else if (query.owner === 'PARTNER') {
      where.ownerKind = 'PARENT';
      where.ownerUserId = { not: userId };
      where.status = 'DONE';
    } else {
      where.OR = [
        {
          ownerUserId: userId,
          status: query.status ? query.status : { not: 'REMOVED' },
        },
        {
          ownerKind: 'TOGETHER',
          status: query.status ? query.status : { not: 'REMOVED' },
        },
        {
          ownerKind: 'PARENT',
          ownerUserId: { not: userId },
          status: 'DONE',
        },
      ];
    }

    if (query.childId) {
      where.missionChildren = {
        some: { childId: query.childId, deletedAt: null },
      };
    }

    if (query.category) {
      where.category = query.category;
    }

    if (cursorDate && cursorId) {
      where.AND = [
        {
          OR: [
            { boardDate: { lt: cursorDate } },
            { boardDate: cursorDate, id: { lt: cursorId } },
          ],
        },
      ];
    }

    const rows = await this.prisma.mission.findMany({
      where,
      include: {
        missionChildren: {
          where: { deletedAt: null },
          select: { childId: true },
        },
        missionEventsMissionEventsMissionIdTomissions: {
          where: { deletedAt: null },
          select: { type: true, createdAt: true },
          orderBy: { createdAt: 'asc' },
        },
      },
      orderBy: [{ boardDate: 'desc' }, { id: 'desc' }],
      take: limit + 1,
    });

    const hasMore = rows.length > limit;
    const candidates = rows.slice(0, limit);
    let nextCursor: string | null = null;
    if (hasMore && candidates.length > 0) {
      const last = candidates[candidates.length - 1]!;
      nextCursor = Buffer.from(
        JSON.stringify({
          date: last.boardDate.toISOString().slice(0, 10),
          id: last.id,
        }),
      ).toString('base64url');
    }

    const items: CareMissionHistoryRow[] = candidates.map((row) => ({
      mission: new Mission(row),
      childIds: row.missionChildren.map((c) => c.childId),
      events: row.missionEventsMissionEventsMissionIdTomissions,
    }));

    return { items, nextCursor };
  }
}
