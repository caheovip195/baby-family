import { cloneDatabaseJson } from '../common/database.types';
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { IMemoryPromptRepository } from '../interfaces/repositories/memory-prompt-repository.interface';
import type { MemoryPromptSubjectDto } from '../dto/memory-library/memory-prompt.dto';
import { Child } from '../models/child.model';
import { Pregnancy } from '../models/pregnancy.model';
import { MemoryPromptDelivery } from '../models/memory-prompt-delivery.model';
import { MemoryPromptTemplate } from '../models/memory-prompt-template.model';
@Injectable()
export class MemoryPromptRepository implements IMemoryPromptRepository {
  constructor(private readonly prisma: PrismaService) {}
  async findSubject(
    familyId: string | null,
    input: MemoryPromptSubjectDto,
  ): Promise<Child | Pregnancy | null> {
    if (!input.pregnancyId) {
      const child = await this.prisma.child.findFirst({
        where: {
          ...(familyId ? { familyId } : {}),
          ...(input.childId ? { id: input.childId } : {}),
          status: 'ACTIVE',
          deletedAt: null,
        },
        orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }],
      });
      if (child)
        return new Child({
          ...child,
          profile: cloneDatabaseJson(child.profile),
          birthStats:
            child.birthStats === null
              ? null
              : cloneDatabaseJson(child.birthStats),
        });
      if (input.childId) return null;
    }
    const pregnancy = await this.prisma.pregnancy.findFirst({
      where: {
        ...(familyId ? { familyId } : {}),
        ...(input.pregnancyId ? { id: input.pregnancyId } : {}),
        status: 'ACTIVE',
        deletedAt: null,
      },
      orderBy: { seqNo: 'asc' },
    });
    return pregnancy ? new Pregnancy(pregnancy) : null;
  }
  async isEnabled(userId: string): Promise<boolean> {
    const settings = await this.prisma.userSetting.findFirst({
      where: { userId, deletedAt: null },
    });
    return settings?.memoryPromptsEnabled ?? true;
  }
  async deliver(input: Parameters<IMemoryPromptRepository['deliver']>[0]) {
    return this.prisma.$transaction(async (tx) => {
      // Serialize all family/subject requests of the same user; uq_prompt_day is global per user.
      await tx.$queryRaw`SELECT 1 FROM pg_advisory_xact_lock(hashtextextended(${input.userId}, 42))`;
      const today = await tx.memoryPromptDelivery.findMany({
        where: {
          userId: input.userId,
          localDate: input.localDate,
          deletedAt: null,
        },
      });
      if (today.some((row) => row.status === 'DISMISSED')) return null;
      const existing = today.find((row) =>
        ['SHOWN', 'USED'].includes(row.status),
      );
      if (existing) {
        if (
          existing.familyId !== input.familyId ||
          existing.childId !== input.childId ||
          existing.pregnancyId !== input.pregnancyId
        )
          return null;
        const template = await tx.memoryPromptTemplate.findFirst({
          where: {
            code: existing.templateCode,
            deletedAt: null,
            status: 'ACTIVE',
          },
        });
        return template
          ? {
              template: new MemoryPromptTemplate({
                ...template,
                textI18n: cloneDatabaseJson(template.textI18n),
              }),
              delivery: new MemoryPromptDelivery(existing),
            }
          : null;
      }
      const recent = await tx.memoryPromptDelivery.findMany({
        where: {
          userId: input.userId,
          localDate: { gte: input.recentSince },
          deletedAt: null,
        },
        select: { templateCode: true },
      });
      const candidates = await tx.memoryPromptTemplate.findMany({
        where: {
          status: 'ACTIVE',
          deletedAt: null,
          stage: { in: [input.childId ? 'CHILD' : 'PREGNANCY', 'ANY'] },
          code: { notIn: recent.map((row) => row.templateCode) },
        },
        orderBy: [{ weight: 'desc' }, { code: 'asc' }],
      });
      const template = candidates.find((row) => {
        const within = (
          value: number | null,
          min: number | null,
          max: number | null,
        ) =>
          value === null
            ? min === null && max === null
            : (min === null || value >= min) && (max === null || value <= max);
        return (
          within(input.ageDays, row.minAgeDays, row.maxAgeDays) &&
          within(input.pregnancyWeek, row.minPregWeek, row.maxPregWeek)
        );
      });
      if (!template) return null;
      const delivery = await tx.memoryPromptDelivery.create({
        data: {
          familyId: input.familyId,
          userId: input.userId,
          childId: input.childId,
          pregnancyId: input.pregnancyId,
          localDate: input.localDate,
          templateCode: template.code,
        },
      });
      return {
        template: new MemoryPromptTemplate({
          ...template,
          textI18n: cloneDatabaseJson(template.textI18n),
        }),
        delivery: new MemoryPromptDelivery(delivery),
      };
    });
  }
  async dismiss(
    input: Parameters<IMemoryPromptRepository['dismiss']>[0],
  ): Promise<boolean> {
    const rows = await this.prisma.memoryPromptDelivery.updateMany({
      where: {
        familyId: input.familyId,
        userId: input.userId,
        templateCode: input.code,
        childId: input.childId,
        pregnancyId: input.pregnancyId,
        localDate: input.localDate,
        status: { in: ['SHOWN', 'DISMISSED'] },
        deletedAt: null,
      },
      data: { status: 'DISMISSED', actedAt: new Date() },
    });
    return rows.count > 0;
  }
}
