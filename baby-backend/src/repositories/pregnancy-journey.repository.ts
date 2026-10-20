import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { IPregnancyJourneyRepository } from '../interfaces/repositories/pregnancy-journey-repository.interface';
import type { JourneyCursor } from '../config/pregnancy-journey-policy';
import { Pregnancy } from '../models/pregnancy.model';
import { ContentItem } from '../models/content-item.model';
import type { DatabaseJsonValue } from '../common/database.types';
import { Memory } from '../models/memory.model';
@Injectable()
export class PregnancyJourneyRepository implements IPregnancyJourneyRepository {
  constructor(private readonly prisma: PrismaService) {}
  async findPregnancy(id: string) {
    const row = await this.prisma.pregnancy.findFirst({
      where: { id, deletedAt: null },
    });
    return row ? new Pregnancy(row) : null;
  }
  async userLocale(userId: string) {
    return (
      (
        await this.prisma.user.findFirst({
          where: { id: userId, deletedAt: null },
          select: { locale: true },
        })
      )?.locale ?? 'vi'
    );
  }
  async weekContent(week: number, locale: string) {
    const rows = await this.prisma.contentItem.findMany({
      where: {
        type: 'PREGNANCY_WEEK',
        code: `W${String(week).padStart(2, '0')}`,
        locale: { in: [locale, 'vi'] },
        status: 'ACTIVE',
        deletedAt: null,
      },
    });
    const row =
      rows.find((r) => r.locale === locale) ??
      rows.find((r) => r.locale === 'vi');
    return row
      ? new ContentItem({ ...row, data: row.data as DatabaseJsonValue })
      : null;
  }
  /** Same parent visibility/status and createdAt ordering as MemoryContentRepository.listFeedForParent.
   * Its public interface has no kind filter; IDs here are projected by IMemoryContentService.getById.
   */
  async memories(
    familyId: string,
    pregnancyId: string,
    userId: string,
    kind: 'BUMP' | 'ULTRASOUND',
    after: JourneyCursor | null,
    limit: number,
  ) {
    const rows = await this.prisma.memory.findMany({
      where: {
        familyId,
        pregnancyId,
        kind,
        deletedAt: null,
        AND: [
          {
            OR: [
              {
                status: 'PUBLISHED',
                visibility: { in: ['PARENTS', 'FAMILY'] },
              },
              { status: 'PENDING_REVIEW' },
              {
                authorUserId: userId,
                status: { in: ['PUBLISHED', 'PROCESSING'] },
              },
            ],
          },
          ...(after
            ? [
                {
                  OR: [
                    { createdAt: { lt: after.createdAt } },
                    { createdAt: after.createdAt, id: { lt: after.id } },
                  ],
                },
              ]
            : []),
        ],
      },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit + 1,
    });
    return rows.map((row) => new Memory(row));
  }
}
