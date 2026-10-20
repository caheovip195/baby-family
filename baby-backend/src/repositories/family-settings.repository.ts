import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import type { UpdateFamilySettingsDto } from '../dto/family/family-settings.dto';
import type {
  FamilySettingsContext,
  IFamilySettingsRepository,
} from '../interfaces/repositories/family-settings-repository.interface';
import { Family } from '../models/family.model';

@Injectable()
export class FamilySettingsRepository implements IFamilySettingsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findContext(
    familyId: string,
    userId: string,
  ): Promise<FamilySettingsContext | null> {
    const now = new Date();
    const row = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null, status: { not: 'DELETED' } },
      include: {
        familyParents: { where: { userId } },
        circleMembers: { where: { userId } },
      },
    });
    if (!row || (!row.familyParents.length && !row.circleMembers.length))
      return null;
    const parent = row.familyParents.some(
      (member) =>
        member.status === 'ACTIVE' &&
        member.deletedAt === null &&
        member.leftAt === null &&
        member.joinedAt <= now,
    );
    const circle = row.circleMembers.some(
      (member) =>
        member.status === 'ACTIVE' &&
        member.deletedAt === null &&
        member.endedAt === null &&
        member.joinedAt <= now,
    );
    return {
      family: new Family({ ...row, settings: cloneDatabaseJson(row.settings) }),
      role: parent ? 'PARENT' : circle ? 'CIRCLE' : 'INACTIVE',
    };
  }

  merge(
    familyId: string,
    userId: string,
    input: UpdateFamilySettingsDto,
  ): Promise<Family | null> {
    return this.prisma.$transaction(async (tx) => {
      // JSONB concatenation runs under the row lock: concurrent changes to other keys survive.
      // accessVersion is authorization state, not a settings revision; do not use it as If-Match.
      const changed = await tx.$executeRaw(Prisma.sql`
        UPDATE app.families AS f
        SET settings = f.settings || ${JSON.stringify(input)}::jsonb,
            access_version = f.access_version + CASE
              WHEN ${Object.hasOwn(input, 'circleCanSeeTree')}
                AND f.settings->'circleCanSeeTree' IS DISTINCT FROM ${JSON.stringify(input.circleCanSeeTree ?? null)}::jsonb
              THEN 1 ELSE 0 END,
            updated_at = now()
        WHERE f.id = ${familyId}::uuid AND f.deleted_at IS NULL AND f.status NOT IN ('DELETED', 'DELETION_SCHEDULED')
          AND EXISTS (
            SELECT 1 FROM app.family_parents p
            JOIN app.users u ON u.id = p.user_id
            WHERE p.family_id = f.id AND p.user_id = ${userId}::uuid
              AND p.status = 'ACTIVE' AND p.deleted_at IS NULL AND p.left_at IS NULL
              AND p.joined_at <= now() AND u.status = 'ACTIVE' AND u.deleted_at IS NULL
          )
      `);
      if (!changed) return null;
      await tx.outboxEvent.create({
        data: {
          eventType: 'family.settings.changed',
          aggregateId: familyId,
          familyId,
          payload: { familyId, keys: Object.keys(input).sort() },
        },
      });
      const row = await tx.family.findUniqueOrThrow({
        where: { id: familyId },
      });
      return new Family({ ...row, settings: cloneDatabaseJson(row.settings) });
    });
  }
}
