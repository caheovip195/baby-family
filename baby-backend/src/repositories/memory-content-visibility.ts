import { Prisma } from '../generated/prisma/client';
import type { PrismaService } from '../database/prisma.service';
import { parentVisibleMemorySql } from './parent-asset-visibility.sql';

/** Current membership and grants are read on every query, before pagination. */
export async function memoryContentScope(
  prisma: Pick<PrismaService, 'familyParent' | 'circleGrant'>,
  familyId: string,
  userId: string,
  ownPending = false,
): Promise<{
  where: Prisma.MemoryWhereInput;
  sql: Prisma.Sql;
  childIds: string[];
  pregnancyIds: string[];
  isParent: boolean;
  contributeChildIds: string[];
  contributePregnancyIds: string[];
}> {
  const parent = await prisma.familyParent.findFirst({
    where: {
      familyId,
      userId,
      status: 'ACTIVE',
      deletedAt: null,
      leftAt: null,
      joinedAt: { lte: new Date() },
    },
  });
  if (parent)
    return {
      where: {},
      sql: parentVisibleMemorySql(userId),
      childIds: [],
      pregnancyIds: [],
      isParent: true,
      contributeChildIds: [],
      contributePregnancyIds: [],
    };
  const grants = await prisma.circleGrant.findMany({
    where: {
      familyId,
      status: 'ACTIVE',
      deletedAt: null,
      circleMember: {
        userId,
        status: 'ACTIVE',
        deletedAt: null,
        endedAt: null,
        joinedAt: { lte: new Date() },
      },
      OR: [
        { child: { deletedAt: null, status: 'ACTIVE' } },
        {
          pregnancy: {
            deletedAt: null,
            status: { in: ['ACTIVE', 'COMPLETED'] },
          },
        },
      ],
    },
  });
  const childIds = grants.flatMap((g) => (g.childId ? [g.childId] : [])),
    pregnancyIds = grants.flatMap((g) =>
      g.pregnancyId ? [g.pregnancyId] : [],
    );
  const subjects: Prisma.MemoryWhereInput[] = [
    {
      memoryChildren: {
        none: { deletedAt: null, childId: { notIn: childIds } },
      },
    },
    {
      OR: [
        { pregnancyId: null },
        {
          pregnancy: {
            deletedAt: null,
            status: { in: ['ACTIVE', 'COMPLETED'] },
          },
        },
      ],
    },
    {
      OR: [
        {
          memoryChildren: {
            some: { deletedAt: null, childId: { in: childIds } },
          },
        },
        { pregnancyId: { in: pregnancyIds } },
        ...(grants.length ? [{ familyMoment: true }] : []),
      ],
    },
    { OR: [{ unlockAt: null }, { unlockAt: { lte: new Date() } }] },
  ];
  const states: Prisma.MemoryWhereInput[] = [{ status: 'PUBLISHED' }];
  if (ownPending)
    states.push({
      authorUserId: userId,
      status: { in: ['PENDING_REVIEW', 'REJECTED', 'PROCESSING'] },
    });
  return {
    isParent: false,
    childIds,
    pregnancyIds,
    contributeChildIds: grants.flatMap((g) =>
      g.permission === 'CONTRIBUTE' && g.childId ? [g.childId] : [],
    ),
    contributePregnancyIds: grants.flatMap((g) =>
      g.permission === 'CONTRIBUTE' && g.pregnancyId ? [g.pregnancyId] : [],
    ),
    where: {
      familyId,
      deletedAt: null,
      visibility: 'FAMILY',
      OR: states,
      AND: subjects,
    },
    sql: Prisma.sql`m.deleted_at IS NULL AND m.status = 'PUBLISHED' AND m.visibility = 'FAMILY'
    AND (m.unlock_at IS NULL OR m.unlock_at <= now())
    AND NOT EXISTS (SELECT 1 FROM app.memory_children mc WHERE mc.memory_id=m.id AND mc.family_id=m.family_id AND mc.deleted_at IS NULL AND NOT(mc.child_id = ANY(${childIds}::uuid[])))
    AND (m.pregnancy_id IS NULL OR (EXISTS(SELECT 1 FROM app.pregnancies p WHERE p.id=m.pregnancy_id AND p.deleted_at IS NULL AND p.status IN ('ACTIVE','COMPLETED'))))
    AND (EXISTS(SELECT 1 FROM app.memory_children mc WHERE mc.memory_id=m.id AND mc.family_id=m.family_id AND mc.deleted_at IS NULL AND mc.child_id = ANY(${childIds}::uuid[])) OR m.pregnancy_id = ANY(${pregnancyIds}::uuid[]) OR (m.family_moment AND ${grants.length > 0}))`,
  };
}
