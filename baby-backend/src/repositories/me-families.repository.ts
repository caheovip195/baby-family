import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { IMeFamiliesRepository } from '../interfaces/repositories/me-families-repository.interface';
import { MeFamily, MeFamiliesState } from '../models/me-family.model';

function defaultFamily(value: unknown): string | null {
  if (!value || typeof value !== 'object' || Array.isArray(value)) return null;
  const context = (value as Record<string, unknown>).familyContext;
  if (!context || typeof context !== 'object' || Array.isArray(context))
    return null;
  const settings = context as Record<string, unknown>;
  return settings.version === 1 && typeof settings.defaultFamilyId === 'string'
    ? settings.defaultFamilyId
    : null;
}

@Injectable()
export class MeFamiliesRepository implements IMeFamiliesRepository {
  constructor(private readonly prisma: PrismaService) {}

  find(userId: string): Promise<MeFamiliesState | null> {
    return this.prisma.$transaction(async (tx) => {
      const user = await tx.user.findFirst({
        where: { id: userId, status: 'ACTIVE', deletedAt: null },
        select: { id: true },
      });
      if (!user) return null;
      const family = { deletedAt: null, status: { not: 'DELETED' as const } };
      const now = new Date();
      const [parents, circles, settings] = await Promise.all([
        tx.familyParent.findMany({
          where: {
            userId,
            status: 'ACTIVE',
            deletedAt: null,
            leftAt: null,
            joinedAt: { lte: now },
            family,
          },
          select: {
            family: { select: { id: true, name: true, status: true } },
            status: true,
          },
          orderBy: [{ joinedAt: 'asc' }, { id: 'asc' }],
        }),
        tx.circleMember.findMany({
          where: {
            userId,
            status: { in: ['ACTIVE', 'PAUSED', 'SUSPENDED_PLAN'] },
            deletedAt: null,
            endedAt: null,
            joinedAt: { lte: now },
            family,
          },
          select: {
            family: { select: { id: true, name: true, status: true } },
            status: true,
          },
          orderBy: [{ joinedAt: 'asc' }, { id: 'asc' }],
        }),
        tx.userSetting.findFirst({
          where: { userId, deletedAt: null },
          select: { notificationPrefs: true },
        }),
      ]);
      const items = parents.map(
        (row) =>
          new MeFamily(
            row.family.id,
            row.family.name,
            'PARENT',
            row.family.status,
            row.status,
            true,
          ),
      );
      for (const row of circles) {
        if (items.some((item) => item.familyId === row.family.id)) continue;
        items.push(
          new MeFamily(
            row.family.id,
            row.family.name,
            'CIRCLE',
            row.family.status,
            row.status,
            // Family covers have no subject ACL; Circle must not receive
            // an image that may depict another, ungranted child.
            false,
          ),
        );
      }
      return new MeFamiliesState(
        items,
        defaultFamily(settings?.notificationPrefs),
      );
    });
  }

  async setDefault(userId: string, familyId: string): Promise<boolean> {
    // Existing JSON is an extension bag. The versioned context namespace is
    // ignored by notification dispatch; jsonb_set preserves all other keys.
    const rows = await this.prisma.$queryRaw<{ userId: string }[]>`
      INSERT INTO app.user_settings (user_id, notification_prefs)
      SELECT u.id, jsonb_build_object('familyContext', jsonb_build_object('version', 1, 'defaultFamilyId', ${familyId}::text))
      FROM app.users u
      WHERE u.id = ${userId}::uuid AND u.status = 'ACTIVE' AND u.deleted_at IS NULL
        AND EXISTS (
          SELECT 1 FROM app.families f
          WHERE f.id = ${familyId}::uuid AND f.deleted_at IS NULL AND f.status <> 'DELETED'
            AND (
              EXISTS (SELECT 1 FROM app.family_parents p WHERE p.family_id = f.id AND p.user_id = u.id AND p.status = 'ACTIVE' AND p.deleted_at IS NULL AND p.left_at IS NULL AND p.joined_at <= now())
              OR EXISTS (SELECT 1 FROM app.circle_members c WHERE c.family_id = f.id AND c.user_id = u.id AND c.status IN ('ACTIVE', 'PAUSED', 'SUSPENDED_PLAN') AND c.deleted_at IS NULL AND c.ended_at IS NULL AND c.joined_at <= now())
            )
        )
      ON CONFLICT (user_id) DO UPDATE
      SET notification_prefs = jsonb_set(app.user_settings.notification_prefs, '{familyContext}', EXCLUDED.notification_prefs->'familyContext', true), updated_at = now()
      WHERE app.user_settings.deleted_at IS NULL
      RETURNING user_id AS "userId"
    `;
    return rows.length > 0;
  }
}
