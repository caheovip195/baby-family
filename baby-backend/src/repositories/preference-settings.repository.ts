import { Injectable } from '@nestjs/common';
import { cloneDatabaseJson, DatabaseDecimal } from '../common/database.types';
import { PrismaService } from '../database/prisma.service';
import type { UserSetting as UserSettingRow } from '../generated/prisma/client';
import type {
  IPreferenceSettingsRepository,
  PreferenceSettingsPatch,
} from '../interfaces/repositories/preference-settings-repository.interface';
import { UserSetting } from '../models/user-setting.model';

function mapSettings(row: UserSettingRow): UserSetting {
  return new UserSetting({
    ...row,
    notificationPrefs: cloneDatabaseJson(row.notificationPrefs),
    aiFeatures: cloneDatabaseJson(row.aiFeatures),
    textScale: new DatabaseDecimal(row.textScale.toString()),
  });
}

/** `HH:mm` → Postgres `time` (Prisma maps it on 1970-01-01 UTC). */
function time(value: string): Date {
  return new Date(`1970-01-01T${value}:00.000Z`);
}

@Injectable()
export class PreferenceSettingsRepository implements IPreferenceSettingsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findOrCreate(userId: string): Promise<UserSetting | null> {
    const user = await this.prisma.user.findFirst({
      where: { id: userId, status: 'ACTIVE', deletedAt: null },
      select: { id: true },
    });
    if (!user) return null;
    // Rows normally exist from sign-up; upsert keeps older accounts working.
    const row = await this.prisma.userSetting.upsert({
      where: { userId },
      create: { userId },
      update: {},
    });
    return row.deletedAt ? null : mapSettings(row);
  }

  async update(
    userId: string,
    patch: PreferenceSettingsPatch,
  ): Promise<UserSetting | null> {
    const data = {
      ...(patch.quietStart === undefined
        ? {}
        : { quietStart: time(patch.quietStart) }),
      ...(patch.quietEnd === undefined
        ? {}
        : { quietEnd: time(patch.quietEnd) }),
      ...(patch.hideSensitivePreview === undefined
        ? {}
        : { hideSensitivePreview: patch.hideSensitivePreview }),
      ...(patch.circleDigestMode === undefined
        ? {}
        : { circleDigestMode: patch.circleDigestMode }),
      ...(patch.circleDigestTime === undefined
        ? {}
        : { circleDigestTime: time(patch.circleDigestTime) }),
      ...(patch.aiEnabled === undefined ? {} : { aiEnabled: patch.aiEnabled }),
      ...(patch.aiFeatures === undefined
        ? {}
        : { aiFeatures: patch.aiFeatures as object }),
      updatedAt: new Date(),
    };
    return this.prisma.$transaction(async (tx) => {
      const result = await tx.userSetting.updateMany({
        where: { userId, deletedAt: null },
        data,
      });
      if (!result.count) return null;
      if (patch.notificationPrefs !== undefined) {
        // Preserve FAM-08 context even if notification settings were read
        // before a concurrent default-family selection committed.
        await tx.$executeRaw`
          UPDATE app.user_settings
          SET notification_prefs = (${JSON.stringify(patch.notificationPrefs)}::jsonb - 'familyContext')
            || CASE WHEN notification_prefs ? 'familyContext'
              THEN jsonb_build_object('familyContext', notification_prefs->'familyContext')
              ELSE '{}'::jsonb END,
            updated_at = now()
          WHERE user_id = ${userId}::uuid AND deleted_at IS NULL
        `;
      }
      const row = await tx.userSetting.findFirst({
        where: { userId, deletedAt: null },
      });
      return row ? mapSettings(row) : null;
    });
  }
}
