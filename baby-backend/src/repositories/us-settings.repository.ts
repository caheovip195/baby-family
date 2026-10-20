import { Injectable } from '@nestjs/common';
import { cloneDatabaseJson, DatabaseDecimal } from '../common/database.types';
import { PrismaService } from '../database/prisma.service';
import type { UpdateUsSettingsDto } from '../dto/us-settings/us-settings.dto';
import type { UserSetting as UserSettingRow } from '../generated/prisma/client';
import type { IUsSettingsRepository } from '../interfaces/repositories/us-settings-repository.interface';
import { FamilyParent } from '../models/family-parent.model';
import { UserSetting } from '../models/user-setting.model';

function mapSettings(row: UserSettingRow): UserSetting {
  return new UserSetting({
    ...row,
    notificationPrefs: cloneDatabaseJson(row.notificationPrefs),
    aiFeatures: cloneDatabaseJson(row.aiFeatures),
    textScale: new DatabaseDecimal(row.textScale.toString()),
  });
}

@Injectable()
export class UsSettingsRepository implements IUsSettingsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findActiveParent(userId: string): Promise<FamilyParent | null> {
    const row = await this.prisma.familyParent.findFirst({
      where: {
        userId,
        status: 'ACTIVE',
        deletedAt: null,
        leftAt: null,
        joinedAt: { lte: new Date() },
        family: { status: 'ACTIVE', deletedAt: null },
        user: { status: 'ACTIVE', deletedAt: null },
      },
    });
    return row ? new FamilyParent(row) : null;
  }

  async findSettings(userId: string): Promise<UserSetting | null> {
    const row = await this.prisma.userSetting.findFirst({
      where: { userId, deletedAt: null },
    });
    return row ? mapSettings(row) : null;
  }

  async updateSettings(
    userId: string,
    input: UpdateUsSettingsDto,
  ): Promise<UserSetting | null> {
    return this.prisma.$transaction(async (tx) => {
      const result = await tx.userSetting.updateMany({
        where: { userId, deletedAt: null },
        data: {
          ...(input.usLockEnabled === undefined
            ? {}
            : { usLockEnabled: input.usLockEnabled }),
          ...(input.moodShareDefault === undefined
            ? {}
            : { moodShareDefault: input.moodShareDefault }),
          ...(input.requestSoonBypassQuiet === undefined
            ? {}
            : { requestSoonBypassQuiet: input.requestSoonBypassQuiet }),
          ...(input.hideSensitivePreview === undefined
            ? {}
            : { hideSensitivePreview: input.hideSensitivePreview }),
        },
      });
      if (!result.count) return null;
      const row = await tx.userSetting.findFirst({
        where: { userId, deletedAt: null },
      });
      return row ? mapSettings(row) : null;
    });
  }
}
