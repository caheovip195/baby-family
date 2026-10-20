import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import type {
  CircleMember,
  CircleGrant,
  Child,
  Pregnancy,
  FamilyInvite,
} from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { DomainError, NotFoundError } from '../common/errors/domain.error';
import { parseCirclePayload } from '../config/circle-policy';
import type {
  CircleGrantInput,
  CircleInvitePayload,
} from '../config/circle-policy';
import type { UpdateCircleMemberDto } from '../dto/circle/circle-commands.dto';
import type {
  IFamilyCircleRepository,
  CircleInviteSecrets,
} from '../interfaces/repositories/family-circle-repository.interface';
import type {
  InviteLookup,
  AcceptInviteInput,
  DecideInviteInput,
  InviteDecisionResult,
} from '../interfaces/repositories/onboarding-repository.interface';
import {
  FamilyCircleInvite,
  FamilyCircleMember,
  FamilyCirclePreview,
  FamilyCircleOverview,
  FamilyCircleBootstrap,
} from '../models/family-circle-state.model';
import type { CircleSubject } from '../models/family-circle-state.model';
type Tx = Prisma.TransactionClient;
const live = {
  deletedAt: null,
  status: {
    in: ['ACTIVE', 'PAUSED', 'SUSPENDED_PLAN'] as (
      'ACTIVE' | 'PAUSED' | 'SUSPENDED_PLAN'
    )[],
  },
};
const activeParent = () => ({
  deletedAt: null,
  status: 'ACTIVE' as const,
  leftAt: null,
  joinedAt: { lte: new Date() },
  user: { status: 'ACTIVE' as const, deletedAt: null },
});
const options = { timeout: 15000 };
function lookupWhere(lookup: InviteLookup) {
  return 'tokenHash' in lookup
    ? { tokenHash: new Uint8Array(lookup.tokenHash) }
    : { codeHash: new Uint8Array(lookup.codeHash) };
}
function mapInvite(row: FamilyInvite) {
  return new FamilyCircleInvite(
    row.id,
    row.familyId,
    row.status === 'PENDING' && row.expiresAt <= new Date()
      ? 'EXPIRED'
      : row.status,
    parseCirclePayload(row.payload),
    row.requireFinalApproval,
    row.createdAt,
    row.expiresAt,
  );
}
function mapMember(row: CircleMember & { circleGrants: CircleGrant[] }) {
  return new FamilyCircleMember(
    row.id,
    row.familyId,
    row.userId,
    row.displayName,
    row.relation,
    row.status,
    row.allowDownload,
    row.circleGrants.map((g) => ({
      ...(g.childId ? { childId: g.childId } : { pregnancyId: g.pregnancyId! }),
      allowDownload: g.allowDownload,
      permission: g.permission,
    })),
    row.joinedAt,
  );
}
const grantsInclude = { where: { deletedAt: null, status: 'ACTIVE' as const } };
function subjects(
  children: Child[],
  pregnancies: Pregnancy[],
): CircleSubject[] {
  return [
    ...children.map((c) => ({
      id: c.id,
      name: c.nickname ?? c.name ?? '',
      kind: 'CHILD' as const,
    })),
    ...pregnancies.map((p) => ({
      id: p.id,
      name: p.nickname,
      kind: 'PREGNANCY' as const,
    })),
  ];
}
@Injectable()
export class FamilyCircleRepository implements IFamilyCircleRepository {
  constructor(private readonly prisma: PrismaService) {}
  async createInvite(
    userId: string,
    familyId: string,
    payload: CircleInvitePayload,
    approval: boolean,
    secrets: CircleInviteSecrets,
  ) {
    return this.prisma.$transaction(async (tx) => {
      await this.lockFamily(tx, familyId);
      await this.parent(tx, userId, familyId);
      await this.capacity(tx, familyId, 1);
      await this.validateTargets(tx, familyId, payload.grants);
      return mapInvite(
        await tx.familyInvite.create({
          data: {
            familyId,
            type: 'CIRCLE',
            inviterUserId: userId,
            payload: payload as unknown as Prisma.InputJsonValue,
            requireFinalApproval: approval,
            tokenHash: new Uint8Array(secrets.tokenHash),
            codeHash: new Uint8Array(secrets.codeHash),
            expiresAt: secrets.expiresAt,
          },
        }),
      );
    }, options);
  }
  async listInvites(familyId: string) {
    return (
      await this.prisma.familyInvite.findMany({
        where: {
          familyId,
          type: 'CIRCLE',
          deletedAt: null,
          status: { in: ['PENDING', 'AWAITING_APPROVAL', 'EXPIRED'] },
        },
        orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      })
    ).map(mapInvite);
  }
  async findInvite(id: string) {
    const row = await this.prisma.familyInvite.findFirst({
      where: { id, type: 'CIRCLE', deletedAt: null },
    });
    return row ? mapInvite(row) : null;
  }
  async changeInvite(
    userId: string,
    id: string,
    secrets: CircleInviteSecrets | null,
  ) {
    return this.prisma.$transaction(async (tx) => {
      const row = await this.lockInvite(tx, { id });
      if (!row) throw new NotFoundError('Invite was not found.');
      await this.parent(tx, userId, row.familyId);
      if (secrets) {
        if (!['PENDING', 'EXPIRED'].includes(row.status))
          throw new DomainError(
            'The invite was already used.',
            'INVITE_ALREADY_USED',
            409,
          );
        await this.capacity(
          tx,
          row.familyId,
          row.status === 'PENDING' && row.expiresAt > new Date() ? 0 : 1,
        );
        await this.validateTargets(
          tx,
          row.familyId,
          parseCirclePayload(row.payload).grants,
        );
      } else if (
        !['PENDING', 'EXPIRED', 'AWAITING_APPROVAL', 'REVOKED'].includes(
          row.status,
        )
      )
        throw new DomainError(
          'The invite was already used.',
          'INVITE_ALREADY_USED',
          409,
        );
      const updated = await tx.familyInvite.update({
        where: { id },
        data: secrets
          ? {
              status: 'PENDING',
              expiresAt: secrets.expiresAt,
              tokenHash: new Uint8Array(secrets.tokenHash),
              codeHash: new Uint8Array(secrets.codeHash),
              acceptedByUserId: null,
              acceptedAt: null,
              decidedAt: null,
            }
          : { status: 'REVOKED', decidedAt: new Date() },
      });
      await this.bump(tx, row.familyId);
      return mapInvite(updated);
    }, options);
  }
  async listMembers(familyId: string) {
    return (
      await this.prisma.circleMember.findMany({
        where: { familyId, ...live },
        include: { circleGrants: grantsInclude },
        orderBy: [{ joinedAt: 'asc' }, { id: 'asc' }],
      })
    ).map(mapMember);
  }
  async findMember(id: string) {
    const row = await this.prisma.circleMember.findFirst({
      where: { id, ...live },
      include: { circleGrants: grantsInclude },
    });
    return row ? mapMember(row) : null;
  }
  async updateMember(
    userId: string,
    id: string,
    input: UpdateCircleMemberDto | 'PAUSED' | 'ACTIVE' | 'REMOVED',
  ) {
    await this.prisma.$transaction(async (tx) => {
      const found = await tx.circleMember.findFirst({ where: { id, ...live } });
      if (!found) throw new NotFoundError('Member was not found.');
      await this.lockFamily(tx, found.familyId);
      await this.parent(tx, userId, found.familyId);
      const row = await tx.circleMember.findFirst({ where: { id, ...live } });
      if (!row) throw new NotFoundError('Member was not found.');
      if (input === 'ACTIVE') await this.capacity(tx, row.familyId, 0);
      if (typeof input === 'string') {
        await tx.circleMember.update({
          where: { id },
          data: {
            status: input,
            ...(input === 'REMOVED'
              ? { endedAt: new Date(), deletedAt: new Date() }
              : {}),
          },
        });
        if (input === 'REMOVED') await this.revokeGrants(tx, id);
      } else {
        const grants = input.grants?.map((g) => ({
          ...g,
          allowDownload: input.allowDownload ?? g.allowDownload,
        }));
        if (grants) {
          await this.validateTargets(tx, row.familyId, grants);
          await this.revokeGrants(tx, id);
          await this.createGrants(tx, row.familyId, id, userId, grants);
        }
        if (input.allowDownload !== undefined && !grants)
          await tx.circleGrant.updateMany({
            where: { circleMemberId: id, deletedAt: null, status: 'ACTIVE' },
            data: { allowDownload: input.allowDownload },
          });
        const allowDownload = grants
          ? grants.some((g) => g.allowDownload)
          : input.allowDownload;
        await tx.circleMember.update({
          where: { id },
          data: {
            ...(input.displayName !== undefined
              ? { displayName: input.displayName.trim() }
              : {}),
            ...(allowDownload !== undefined ? { allowDownload } : {}),
          },
        });
      }
      await this.bump(tx, row.familyId);
    }, options);
  }
  async leave(userId: string, familyId: string) {
    await this.prisma.$transaction(async (tx) => {
      await this.lockFamily(tx, familyId);
      const rows = await tx.circleMember.findMany({
        where: { familyId, userId, ...live },
      });
      const pending = await tx.familyInvite.findMany({
        where: {
          familyId,
          type: 'CIRCLE',
          acceptedByUserId: userId,
          status: 'AWAITING_APPROVAL',
          deletedAt: null,
        },
      });
      if (!rows.length && !pending.length) {
        if (
          await tx.circleMember.count({
            where: { familyId, userId, status: 'LEFT' },
          })
        )
          return;
        throw new NotFoundError('Circle membership was not found.');
      }
      for (const row of rows) {
        await tx.circleMember.update({
          where: { id: row.id },
          data: { status: 'LEFT', endedAt: new Date(), deletedAt: new Date() },
        });
        await this.revokeGrants(tx, row.id);
      }
      await tx.familyInvite.updateMany({
        where: { id: { in: pending.map((i) => i.id) } },
        data: { status: 'DECLINED', decidedAt: new Date() },
      });
      await this.bump(tx, familyId);
    }, options);
  }
  async overview(familyId: string) {
    const family = await this.prisma.family.findFirstOrThrow({
      where: { id: familyId, deletedAt: null },
    });
    const [parents, children, pregnancies, count, pendingInvites, entitlement] =
      await Promise.all([
        this.prisma.familyParent.findMany({
          where: { familyId, ...activeParent() },
          orderBy: { slot: 'asc' },
          select: { userId: true, callName: true },
        }),
        this.prisma.child.findMany({
          where: { familyId, deletedAt: null, status: { not: 'DELETED' } },
          orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }],
        }),
        this.prisma.pregnancy.findMany({
          where: { familyId, deletedAt: null },
          orderBy: { seqNo: 'asc' },
        }),
        this.prisma.circleMember.count({ where: { familyId, ...live } }),
        this.pendingCount(this.prisma, familyId),
        this.prisma.familyEntitlement.findFirst({
          where: { familyId, deletedAt: null },
        }),
      ]);
    return new FamilyCircleOverview(
      { id: family.id, name: family.name, status: family.status },
      parents,
      subjects(children, pregnancies),
      { count, pendingInvites },
      {
        accessPhase: entitlement?.accessPhase ?? 'INCOMPLETE',
        validUntil: entitlement?.validUntil ?? null,
      },
    );
  }
  async myCircles(userId: string) {
    const rows = await this.prisma.circleMember.findMany({
      where: {
        userId,
        ...live,
        family: { deletedAt: null, status: { not: 'DELETED' } },
      },
      include: { family: true, circleGrants: grantsInclude },
      orderBy: { joinedAt: 'desc' },
    });
    const items: FamilyCircleBootstrap[] = [];
    for (const row of rows) {
      const enabled = await this.sharingEnabled(row.familyId);
      const active = row.status === 'ACTIVE' && enabled;
      items.push(
        new FamilyCircleBootstrap(
          row.familyId,
          row.family.name,
          active ? 'ACTIVE' : 'PAUSED',
          active
            ? (
                await this.grantedSubjects(
                  this.prisma,
                  row.familyId,
                  row.circleGrants.map((g) => ({
                    ...(g.childId
                      ? { childId: g.childId }
                      : { pregnancyId: g.pregnancyId! }),
                    allowDownload: g.allowDownload,
                  })),
                )
              ).map((subject) => {
                // The relative's own app needs per-subject rights (comment/post).
                const grant = row.circleGrants.find(
                  (g) => (g.childId ?? g.pregnancyId) === subject.id,
                );
                return {
                  ...subject,
                  permission: grant?.permission ?? 'VIEW',
                  allowDownload: grant?.allowDownload ?? false,
                };
              })
            : [],
          active && row.allowDownload,
        ),
      );
    }
    const waiting = await this.prisma.familyInvite.findMany({
      where: {
        type: 'CIRCLE',
        acceptedByUserId: userId,
        status: 'AWAITING_APPROVAL',
        deletedAt: null,
        family: { deletedAt: null, status: { not: 'DELETED' } },
      },
      include: { family: true },
      orderBy: { createdAt: 'desc' },
    });
    for (const row of waiting)
      if (!items.some((i) => i.familyId === row.familyId))
        items.push(
          new FamilyCircleBootstrap(
            row.familyId,
            row.family.name,
            'AWAITING_APPROVAL',
            [],
            false,
          ),
        );
    return items;
  }
  async resolveCircle(lookup: InviteLookup) {
    const row = await this.prisma.familyInvite.findFirst({
      where: { ...lookupWhere(lookup), type: 'CIRCLE', deletedAt: null },
      include: { family: true },
    });
    if (!row || row.family.deletedAt || row.family.status === 'DELETED')
      return null;
    this.usable(row);
    const payload = parseCirclePayload(row.payload);
    const inviter = await this.prisma.familyParent.findFirst({
      where: {
        familyId: row.familyId,
        userId: row.inviterUserId,
        ...activeParent(),
      },
    });
    return new FamilyCirclePreview(
      row.id,
      row.family.name,
      inviter?.callName ?? null,
      payload.relation,
      await this.grantedSubjects(this.prisma, row.familyId, payload.grants),
      row.expiresAt,
      payload.message,
    );
  }
  async acceptCircle(input: AcceptInviteInput): Promise<InviteDecisionResult> {
    return this.prisma.$transaction(async (tx) => {
      // Match account deletion's user -> family lock order.
      if (!(await this.lockActiveUser(tx, input.userId)))
        return { kind: 'NOT_FOUND' };
      const row = await this.lockInvite(tx, input.lookup);
      if (!row) return { kind: 'NOT_FOUND' };
      if (
        await tx.familyParent.count({
          where: {
            familyId: row.familyId,
            userId: input.userId,
            ...activeParent(),
          },
        })
      )
        throw new DomainError(
          'A Parent cannot join the same family as a relative.',
          'ALREADY_PARENT_OF_FAMILY',
          409,
        );
      if (
        row.acceptedByUserId === input.userId &&
        row.status === 'AWAITING_APPROVAL'
      )
        return { kind: 'AWAITING_APPROVAL', familyId: row.familyId };
      if (row.acceptedByUserId === input.userId && row.status === 'ACCEPTED') {
        if (
          await tx.circleMember.count({
            where: { familyId: row.familyId, userId: input.userId, ...live },
          })
        )
          return { kind: 'JOINED', familyId: row.familyId, trialEndsAt: null };
        return { kind: 'ALREADY_USED' };
      }
      this.usable(row);
      if (row.inviterUserId === input.userId) return { kind: 'SELF_INVITE' };
      if (
        await tx.circleMember.count({
          where: { familyId: row.familyId, userId: input.userId, ...live },
        })
      )
        return { kind: 'ALREADY_USED' };
      await this.capacity(tx, row.familyId, 0);
      await this.validateTargets(
        tx,
        row.familyId,
        parseCirclePayload(row.payload).grants,
      );
      await tx.user.updateMany({
        where: { id: input.userId, onboardingRole: null, deletedAt: null },
        data: { onboardingRole: 'CIRCLE' },
      });
      if (row.requireFinalApproval) {
        await tx.familyInvite.update({
          where: { id: row.id },
          data: {
            status: 'AWAITING_APPROVAL',
            acceptedByUserId: input.userId,
            acceptedAt: input.now,
          },
        });
        return { kind: 'AWAITING_APPROVAL', familyId: row.familyId };
      }
      return this.activate(tx, row, input.userId, input.now);
    }, options);
  }
  async decideCircle(input: DecideInviteInput): Promise<InviteDecisionResult> {
    return this.prisma.$transaction(async (tx) => {
      const candidate = input.approve
        ? await tx.familyInvite.findFirst({
            where: { id: input.inviteId, type: 'CIRCLE', deletedAt: null },
          })
        : null;
      const recipientId = candidate?.acceptedByUserId;
      const recipientActive = recipientId
        ? await this.lockActiveUser(tx, recipientId)
        : false;
      const row = await this.lockInvite(tx, { id: input.inviteId });
      if (!row) return { kind: 'NOT_FOUND' };
      await this.parent(tx, input.userId, row.familyId);
      if (row.status !== 'AWAITING_APPROVAL' || !row.acceptedByUserId)
        return { kind: 'ALREADY_USED' };
      if (!input.approve) {
        await tx.familyInvite.update({
          where: { id: row.id },
          data: { status: 'DECLINED', decidedAt: input.now },
        });
        return { kind: 'DECLINED', familyId: row.familyId };
      }
      if (recipientId !== row.acceptedByUserId) return { kind: 'ALREADY_USED' };
      if (!recipientActive) return { kind: 'NOT_FOUND' };
      await this.capacity(tx, row.familyId, 0);
      if (
        await tx.familyParent.count({
          where: {
            familyId: row.familyId,
            userId: row.acceptedByUserId,
            ...activeParent(),
          },
        })
      )
        throw new DomainError(
          'A Parent cannot join as a relative.',
          'ALREADY_PARENT_OF_FAMILY',
          409,
        );
      if (
        await tx.circleMember.count({
          where: {
            familyId: row.familyId,
            userId: row.acceptedByUserId,
            ...live,
          },
        })
      )
        return { kind: 'ALREADY_USED' };
      await this.validateTargets(
        tx,
        row.familyId,
        parseCirclePayload(row.payload).grants,
      );
      return this.activate(tx, row, row.acceptedByUserId, input.now);
    }, options);
  }
  private async activate(
    tx: Tx,
    row: FamilyInvite,
    userId: string,
    now: Date,
  ): Promise<InviteDecisionResult> {
    const payload = parseCirclePayload(row.payload);
    const member = await tx.circleMember.create({
      data: {
        familyId: row.familyId,
        userId,
        relation: payload.relation,
        displayName: payload.displayName,
        allowDownload: payload.allowDownload,
        invitedBy: row.inviterUserId,
        joinedAt: now,
      },
    });
    await this.createGrants(
      tx,
      row.familyId,
      member.id,
      row.inviterUserId,
      payload.grants,
    );
    await tx.familyInvite.update({
      where: { id: row.id },
      data: {
        status: 'ACCEPTED',
        acceptedByUserId: userId,
        acceptedAt: row.acceptedAt ?? now,
        decidedAt: now,
      },
    });
    await this.bump(tx, row.familyId);
    return { kind: 'JOINED', familyId: row.familyId, trialEndsAt: null };
  }
  private usable(row: FamilyInvite) {
    if (row.status !== 'PENDING')
      throw new DomainError(
        'The invite is no longer valid.',
        row.status === 'EXPIRED' ? 'INVITE_EXPIRED' : 'INVITE_ALREADY_USED',
        row.status === 'EXPIRED' ? 410 : 409,
      );
    if (row.expiresAt <= new Date())
      throw new DomainError('The invite has expired.', 'INVITE_EXPIRED', 410);
  }
  private async lockActiveUser(tx: Tx, id: string): Promise<boolean> {
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM app.users WHERE id = ${id}::uuid AND status = 'ACTIVE' AND deleted_at IS NULL FOR UPDATE`;
    return rows.length > 0;
  }
  private async lockFamily(tx: Tx, id: string) {
    const rows = await tx.$queryRaw<
      { id: string }[]
    >`SELECT id FROM app.families WHERE id = ${id}::uuid AND deleted_at IS NULL FOR UPDATE`;
    if (!rows.length) throw new NotFoundError('Family was not found.');
  }
  private async parent(tx: Tx, userId: string, familyId: string) {
    if (
      !(await tx.familyParent.count({
        where: { familyId, userId, ...activeParent() },
      }))
    )
      throw new NotFoundError('Family was not found.');
  }
  private async lockInvite(tx: Tx, lookup: InviteLookup | { id: string }) {
    const where = 'id' in lookup ? { id: lookup.id } : lookupWhere(lookup);
    const first = await tx.familyInvite.findFirst({
      where: { ...where, type: 'CIRCLE', deletedAt: null },
    });
    if (!first) return null;
    await this.lockFamily(tx, first.familyId);
    // Re-read hash as well as ID after family lock: an old token must fail after renew.
    return tx.familyInvite.findFirst({
      where: { ...where, id: first.id, type: 'CIRCLE', deletedAt: null },
    });
  }
  private pendingCount(tx: Tx, familyId: string) {
    return tx.familyInvite.count({
      where: {
        familyId,
        type: 'CIRCLE',
        deletedAt: null,
        OR: [
          { status: 'PENDING', expiresAt: { gt: new Date() } },
          { status: 'AWAITING_APPROVAL' },
        ],
      },
    });
  }
  private async capacity(tx: Tx, familyId: string, delta: number) {
    const entitlement = await tx.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      include: {
        family: true,
        familyLicense: true,
        planVersion: { include: { plan: true } },
      },
    });
    if (
      entitlement?.familyLicense.blockedAt ||
      entitlement?.familyLicense.blockReasonCode ||
      entitlement?.accessPhase === 'BLOCKED'
    )
      throw new DomainError('License blocked.', 'LICENSE_BLOCKED', 403);
    if (
      !entitlement ||
      entitlement.family.deletedAt ||
      entitlement.family.status !== 'ACTIVE' ||
      (await tx.familyParent.count({
        where: { familyId, ...activeParent() },
      })) !== 2
    )
      throw new DomainError('Family is not active.', 'FAMILY_NOT_ACTIVE', 403);
    const now = new Date();
    if (
      entitlement.familyLicense.deletedAt ||
      !['PAID', 'TRIAL'].includes(entitlement.accessPhase) ||
      !entitlement.validUntil ||
      entitlement.validUntil <= now ||
      (entitlement.accessPhase === 'TRIAL' &&
        (!entitlement.trialEndsAt || entitlement.trialEndsAt <= now))
    )
      throw new DomainError(
        'Subscription required.',
        'SUBSCRIPTION_REQUIRED',
        402,
      );
    const version = entitlement.planVersion;
    const features = version?.features as Record<string, unknown> | undefined;
    const quotas = version?.quotas as Record<string, unknown> | undefined;
    if (
      !version ||
      version.deletedAt ||
      version.plan.deletedAt ||
      features?.['circle.enabled'] !== true
    )
      throw new DomainError(
        'Circle capability required.',
        'PLAN_REQUIRED_FAMILY',
        402,
      );
    const max = quotas?.circleMax;
    if (!(
      max === null ||
      (typeof max === 'number' && Number.isSafeInteger(max) && max >= 0)
    ))
      throw new DomainError(
        'Circle quota is unavailable.',
        'PLAN_REQUIRED_FAMILY',
        402,
      );
    const count =
      (await tx.circleMember.count({ where: { familyId, ...live } })) +
      (await this.pendingCount(tx, familyId));
    if (max !== null && count + delta > max)
      throw new DomainError(
        'Relative limit reached.',
        'CIRCLE_LIMIT_REACHED',
        422,
      );
  }
  private async sharingEnabled(familyId: string) {
    try {
      await this.capacity(this.prisma, familyId, 0);
      return true;
    } catch (error) {
      if (error instanceof DomainError) return false;
      throw error;
    }
  }
  private async validateTargets(
    tx: Tx,
    familyId: string,
    grants: CircleGrantInput[],
  ) {
    const visible = await this.grantedSubjects(tx, familyId, grants);
    if (visible.length !== grants.length)
      throw new DomainError(
        'A grant subject is not available in this family.',
        'CHILD_NOT_IN_FAMILY',
        422,
      );
  }
  private async grantedSubjects(
    tx: Tx,
    familyId: string,
    grants: CircleGrantInput[],
  ) {
    const [children, pregnancies] = await Promise.all([
      tx.child.findMany({
        where: {
          familyId,
          id: { in: grants.flatMap((g) => (g.childId ? [g.childId] : [])) },
          deletedAt: null,
          status: { not: 'DELETED' },
        },
        orderBy: [{ sortOrder: 'asc' }, { id: 'asc' }],
      }),
      tx.pregnancy.findMany({
        where: {
          familyId,
          id: {
            in: grants.flatMap((g) => (g.pregnancyId ? [g.pregnancyId] : [])),
          },
          deletedAt: null,
          status: { not: 'ENDED_PRIVATE' },
        },
        orderBy: { seqNo: 'asc' },
      }),
    ]);
    return subjects(children, pregnancies);
  }
  private createGrants(
    tx: Tx,
    familyId: string,
    circleMemberId: string,
    createdBy: string,
    grants: CircleGrantInput[],
  ) {
    return tx.circleGrant.createMany({
      data: grants.map((g) => ({
        familyId,
        circleMemberId,
        createdBy,
        childId: g.childId ?? null,
        pregnancyId: g.pregnancyId ?? null,
        permission: g.permission ?? 'VIEW',
        allowDownload: g.allowDownload,
      })),
    });
  }
  private revokeGrants(tx: Tx, circleMemberId: string) {
    return tx.circleGrant.updateMany({
      where: { circleMemberId, deletedAt: null },
      data: { status: 'REVOKED', deletedAt: new Date() },
    });
  }
  private bump(tx: Tx, familyId: string) {
    return tx.family.update({
      where: { id: familyId },
      data: { accessVersion: { increment: 1 } },
    });
  }
}
