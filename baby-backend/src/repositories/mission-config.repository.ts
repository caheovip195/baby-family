import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type {
  IMissionConfigRepository,
  MissionPreferencePatch,
} from '../interfaces/repositories/mission-config-repository.interface';
import { MissionPreferenceModel } from '../models/mission-recurrence.model';

@Injectable()
export class MissionConfigRepository implements IMissionConfigRepository {
  constructor(private readonly prisma: PrismaService) {}

  async boardLevel(familyId: string) {
    const row = await this.prisma.missionFamilySetting.findFirst({
      where: { familyId, deletedAt: null },
      select: { boardLevel: true },
    });
    return row?.boardLevel ?? null;
  }

  async saveBoardLevel(
    familyId: string,
    userId: string,
    level: 'LIGHT' | 'MEDIUM' | 'HEAVY',
  ) {
    await this.prisma.missionFamilySetting.upsert({
      where: { familyId },
      create: { familyId, boardLevel: level, updatedBy: userId },
      update: {
        boardLevel: level,
        updatedBy: userId,
        deletedAt: null,
        version: { increment: 1 },
      },
    });
  }

  async preference(familyId: string, userId: string) {
    const row = await this.prisma.missionPreference.findFirst({
      where: { familyId, userId, deletedAt: null },
    });
    return row
      ? new MissionPreferenceModel(
          row.disabledCategories,
          row.boardPushTime,
          row.eveningCarryOver,
          row.defaultReminderMin,
        )
      : null;
  }

  async savePreference(
    familyId: string,
    userId: string,
    patch: MissionPreferencePatch,
  ) {
    const data = {
      ...(patch.disabledCategories && {
        disabledCategories: patch.disabledCategories as never,
      }),
      ...(patch.boardPushTime && { boardPushTime: patch.boardPushTime }),
      ...(patch.eveningCarryOver !== undefined && {
        eveningCarryOver: patch.eveningCarryOver,
      }),
      ...(patch.defaultReminderMin !== undefined && {
        defaultReminderMin: patch.defaultReminderMin,
      }),
    };
    await this.prisma.missionPreference.upsert({
      where: { familyId_userId: { familyId, userId } },
      create: { familyId, userId, ...data },
      update: { ...data, deletedAt: null },
    });
  }
}
