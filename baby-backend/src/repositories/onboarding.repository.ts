import { Inject, Injectable, Optional } from '@nestjs/common';
import { FAMILY_CIRCLE_REPOSITORY } from '../interfaces/repositories/family-circle-repository.interface';
import type { IFamilyCircleRepository } from '../interfaces/repositories/family-circle-repository.interface';
import type { FamilyCirclePreview } from '../models/family-circle-state.model';
import { Prisma } from '../generated/prisma/client';
import type {
  Family as FamilyRow,
  FamilyInvite as FamilyInviteRow,
} from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { cloneDatabaseJson } from '../common/database.types';
import type { ParentKind, ParentSlot } from '../common/database.enums';
import type {
  AcceptInviteInput,
  CancelFamilyResult,
  CreateFamilyInput,
  CreateFamilyResult,
  CreatePartnerInviteInput,
  CreatePartnerInviteResult,
  DecideInviteInput,
  InviteDecisionResult,
  InviteLookup,
  IOnboardingRepository,
} from '../interfaces/repositories/onboarding-repository.interface';
import { Family } from '../models/family.model';
import { FamilyInvite } from '../models/family-invite.model';
import {
  FamilyBootstrapState,
  InvitePreview,
} from '../models/onboarding-state.model';

type Tx = Prisma.TransactionClient;

interface PartnerPayload {
  kind: ParentKind | null;
  message: string | null;
  acceptedCallName: string | null;
}

const TRANSACTION_OPTIONS = { timeout: 15_000 } as const;
const DEFAULT_TRIAL_POLICY_SETTING = 'billing.defaultTrialPolicyCode';
const activeParent = { status: 'ACTIVE' as const, deletedAt: null };
const DEFAULT_CALL_NAME: Record<ParentKind, string> = {
  FATHER: 'Papa',
  MOTHER: 'Mama',
};

function mapFamily(row: FamilyRow): Family {
  return new Family({ ...row, settings: cloneDatabaseJson(row.settings) });
}

function mapInvite(row: FamilyInviteRow): FamilyInvite {
  return new FamilyInvite({
    ...row,
    tokenHash: new Uint8Array(row.tokenHash),
    codeHash: new Uint8Array(row.codeHash),
    payload: cloneDatabaseJson(row.payload),
  });
}

function partnerPayload(value: unknown): PartnerPayload {
  const raw =
    value && typeof value === 'object'
      ? (value as Record<string, unknown>)
      : {};
  const kind = raw.kind === 'FATHER' || raw.kind === 'MOTHER' ? raw.kind : null;
  return {
    kind,
    message: typeof raw.message === 'string' ? raw.message : null,
    acceptedCallName:
      typeof raw.acceptedCallName === 'string' ? raw.acceptedCallName : null,
  };
}

function opposite(kind: ParentKind): ParentKind {
  return kind === 'FATHER' ? 'MOTHER' : 'FATHER';
}

function lookupWhere(lookup: InviteLookup) {
  return 'tokenHash' in lookup
    ? Prisma.sql`token_hash = ${new Uint8Array(lookup.tokenHash)}`
    : Prisma.sql`code_hash = ${new Uint8Array(lookup.codeHash)}`;
}

@Injectable()
export class OnboardingRepository implements IOnboardingRepository {
  constructor(
    private readonly prisma: PrismaService,
    @Optional()
    @Inject(FAMILY_CIRCLE_REPOSITORY)
    private readonly circles?: IFamilyCircleRepository,
  ) {}

  async createFamily(input: CreateFamilyInput): Promise<CreateFamilyResult> {
    try {
      return await this.prisma.$transaction(async (tx) => {
        const user = await this.lockUser(tx, input.userId);
        if (
          !user ||
          (user.onboarding_role !== 'PARENT_FATHER' &&
            user.onboarding_role !== 'PARENT_MOTHER')
        )
          return { kind: 'ROLE_REQUIRED' };
        if (await this.hasActiveParentMembership(tx, input.userId))
          return { kind: 'ALREADY_PARENT' };
        const family = await tx.family.create({
          data: {
            name: input.name,
            timezone: input.timezone,
            createdBy: input.userId,
          },
        });
        await tx.familyParent.create({
          data: {
            familyId: family.id,
            userId: input.userId,
            slot: 'A',
            kind: input.kind,
            callName: input.callName,
            joinedAt: input.now,
          },
        });
        const license = await tx.familyLicense.create({
          data: { familyId: family.id },
        });
        await tx.familyUsage.create({ data: { familyId: family.id } });
        // BR-052: no feature is usable until both Parents joined.
        await tx.familyEntitlement.create({
          data: {
            familyId: family.id,
            licenseId: license.id,
            accessPhase: 'INCOMPLETE',
            computedAt: input.now,
          },
        });
        await tx.outboxEvent.create({
          data: {
            eventType: 'FamilyCreated',
            aggregateId: family.id,
            familyId: family.id,
            payload: { familyId: family.id },
          },
        });
        return { kind: 'CREATED', family: mapFamily(family) };
      }, TRANSACTION_OPTIONS);
    } catch (error) {
      // uq_parent_one_family: a concurrent request already made this user a Parent.
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      )
        return { kind: 'ALREADY_PARENT' };
      throw error;
    }
  }

  cancelFamily(
    userId: string,
    familyId: string,
    now: Date,
  ): Promise<CancelFamilyResult> {
    return this.prisma.$transaction(async (tx) => {
      const family = await this.lockFamily(tx, familyId);
      if (!family || !(await this.isActiveParent(tx, familyId, userId)))
        return { kind: 'NOT_FOUND' };
      if (family.status !== 'WAITING_PARTNER') return { kind: 'NOT_WAITING' };
      await this.retireWaitingFamily(tx, familyId, now);
      // ONB-WAIT “Huỷ gia đình này”: the user chooses a role again.
      await tx.user.update({
        where: { id: userId },
        data: { onboardingRole: null },
      });
      return { kind: 'CANCELLED' };
    }, TRANSACTION_OPTIONS);
  }

  createPartnerInvite(
    input: CreatePartnerInviteInput,
  ): Promise<CreatePartnerInviteResult> {
    return this.prisma.$transaction(async (tx) => {
      const family = await this.lockFamily(tx, input.familyId);
      const inviter = family
        ? await tx.familyParent.findFirst({
            where: {
              familyId: input.familyId,
              userId: input.userId,
              ...activeParent,
            },
          })
        : null;
      if (!family || !inviter) return { kind: 'NOT_FOUND' };
      if (
        family.status !== 'WAITING_PARTNER' &&
        family.status !== 'PARTNER_LEFT'
      )
        return { kind: 'FAMILY_COMPLETE' };
      const recent = await tx.familyInvite.count({
        where: {
          familyId: input.familyId,
          type: 'PARTNER',
          createdAt: { gt: new Date(input.now.getTime() - 24 * 3600 * 1000) },
        },
      });
      if (recent >= input.dailyLimit) return { kind: 'LIMIT_REACHED' };
      // §7.3: a new invite invalidates the previous one.
      await tx.familyInvite.updateMany({
        where: {
          familyId: input.familyId,
          type: 'PARTNER',
          status: { in: ['PENDING', 'AWAITING_APPROVAL'] },
          deletedAt: null,
        },
        data: { status: 'REVOKED', decidedAt: input.now },
      });
      const payload: PartnerPayload = {
        kind: input.kind ?? opposite(inviter.kind),
        message: input.message,
        acceptedCallName: null,
      };
      const invite = await tx.familyInvite.create({
        data: {
          familyId: input.familyId,
          type: 'PARTNER',
          inviterUserId: input.userId,
          tokenHash: new Uint8Array(input.tokenHash),
          codeHash: new Uint8Array(input.codeHash),
          payload: { ...payload },
          requireFinalApproval: input.requireFinalApproval,
          expiresAt: input.expiresAt,
        },
      });
      return { kind: 'CREATED', invite: mapInvite(invite) };
    }, TRANSACTION_OPTIONS);
  }

  async findLatestPartnerInvite(
    userId: string,
    familyId: string,
  ): Promise<FamilyInvite | null | 'NOT_FOUND'> {
    const member = await this.prisma.familyParent.findFirst({
      where: {
        familyId,
        userId,
        ...activeParent,
        family: { deletedAt: null, status: { not: 'DELETED' } },
      },
      select: { id: true },
    });
    if (!member) return 'NOT_FOUND';
    const invite = await this.prisma.familyInvite.findFirst({
      where: { familyId, type: 'PARTNER', deletedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    return invite ? mapInvite(invite) : null;
  }

  async activeChildren(
    familyId: string,
  ): Promise<{ id: string; name: string }[]> {
    const rows = await this.prisma.child.findMany({
      where: { familyId, status: 'ACTIVE', deletedAt: null },
      orderBy: [{ birthDate: 'asc' }, { id: 'asc' }],
      select: { id: true, name: true, nickname: true },
    });
    return rows.map((row) => ({
      id: row.id,
      name: row.nickname ?? row.name ?? '',
    }));
  }

  async resolveInvite(
    lookup: InviteLookup,
  ): Promise<InvitePreview | FamilyCirclePreview | null> {
    const rows = await this.prisma.$queryRaw<{ id: string }[]>`
      SELECT id FROM app.family_invites
      WHERE ${lookupWhere(lookup)} AND deleted_at IS NULL`;
    const id = rows[0]?.id;
    if (!id) return null;
    const invite = await this.prisma.familyInvite.findUnique({
      where: { id },
      include: { family: true },
    });
    if (
      !invite ||
      invite.family.deletedAt ||
      invite.family.status === 'DELETED'
    )
      return null;
    if (invite.type === 'CIRCLE')
      return this.circles?.resolveCircle(lookup) ?? null;
    const inviter = await this.prisma.familyParent.findFirst({
      where: { familyId: invite.familyId, userId: invite.inviterUserId },
      orderBy: { joinedAt: 'desc' },
    });
    const payload = partnerPayload(invite.payload);
    return new InvitePreview({
      inviteId: invite.id,
      type: invite.type,
      status: invite.status,
      expiresAt: invite.expiresAt,
      familyId: invite.familyId,
      familyName: invite.family.name,
      familyStatus: invite.family.status,
      inviterCallName: inviter?.callName ?? null,
      inviterKind: inviter?.kind ?? null,
      proposedKind: payload.kind,
      message: payload.message,
    });
  }

  async acceptInvite(input: AcceptInviteInput): Promise<InviteDecisionResult> {
    if (this.circles && (await this.isCircleLookup(input.lookup)))
      return this.circles.acceptCircle(input);
    return this.prisma.$transaction(async (tx) => {
      const invite = await this.lockInvite(tx, input.lookup);
      if (!invite) return { kind: 'NOT_FOUND' };
      if (invite.type !== 'PARTNER') return { kind: 'NOT_SUPPORTED' };
      // Replays by the same user are answered with the current outcome.
      if (invite.acceptedByUserId === input.userId) {
        if (invite.status === 'AWAITING_APPROVAL')
          return { kind: 'AWAITING_APPROVAL', familyId: invite.familyId };
        if (invite.status === 'ACCEPTED')
          return {
            kind: 'JOINED',
            familyId: invite.familyId,
            trialEndsAt: await this.trialEndsAt(tx, invite.familyId),
          };
      }
      if (invite.status !== 'PENDING') return { kind: 'ALREADY_USED' };
      if (invite.expiresAt <= input.now) {
        await tx.familyInvite.update({
          where: { id: invite.id },
          data: { status: 'EXPIRED' },
        });
        return { kind: 'EXPIRED' };
      }
      if (invite.inviterUserId === input.userId) return { kind: 'SELF_INVITE' };
      const blocked = await this.joinBlocker(tx, invite, input.userId);
      if (blocked) return blocked;
      const payload = partnerPayload(invite.payload);
      const callName =
        input.callName ?? DEFAULT_CALL_NAME[payload.kind ?? 'FATHER'];
      if (invite.requireFinalApproval) {
        await tx.familyInvite.update({
          where: { id: invite.id },
          data: {
            status: 'AWAITING_APPROVAL',
            acceptedByUserId: input.userId,
            acceptedAt: input.now,
            payload: { ...payload, acceptedCallName: callName },
          },
        });
        await this.setParentRole(tx, input.userId, payload.kind);
        return { kind: 'AWAITING_APPROVAL', familyId: invite.familyId };
      }
      return this.activate(tx, invite, input.userId, callName, input);
    }, TRANSACTION_OPTIONS);
  }

  declineInvite(
    userId: string,
    lookup: InviteLookup,
    now: Date,
  ): Promise<InviteDecisionResult> {
    return this.prisma.$transaction(async (tx) => {
      const invite = await this.lockInvite(tx, lookup);
      if (!invite) return { kind: 'NOT_FOUND' };
      if (invite.inviterUserId === userId) return { kind: 'SELF_INVITE' };
      if (invite.status !== 'PENDING') return { kind: 'ALREADY_USED' };
      await tx.familyInvite.update({
        where: { id: invite.id },
        data: { status: 'DECLINED', decidedAt: now },
      });
      return { kind: 'DECLINED', familyId: invite.familyId };
    }, TRANSACTION_OPTIONS);
  }

  async decideInvite(input: DecideInviteInput): Promise<InviteDecisionResult> {
    if (
      this.circles &&
      (await this.prisma.familyInvite.count({
        where: { id: input.inviteId, type: 'CIRCLE', deletedAt: null },
      }))
    )
      return this.circles.decideCircle(input);
    return this.prisma.$transaction(async (tx) => {
      const invite = await this.lockInvite(tx, { id: input.inviteId });
      if (
        !invite ||
        !(await this.isActiveParent(tx, invite.familyId, input.userId))
      )
        return { kind: 'NOT_FOUND' };
      if (invite.type === 'CIRCLE') return { kind: 'NOT_SUPPORTED' };
      if (invite.status !== 'AWAITING_APPROVAL' || !invite.acceptedByUserId)
        return { kind: 'ALREADY_USED' };
      if (!input.approve) {
        await tx.familyInvite.update({
          where: { id: invite.id },
          data: { status: 'DECLINED', decidedAt: input.now },
        });
        await tx.user.update({
          where: { id: invite.acceptedByUserId },
          data: { onboardingRole: null },
        });
        return { kind: 'DECLINED', familyId: invite.familyId };
      }
      // Re-check: the joiner may have created/joined another family meanwhile.
      const blocked = await this.joinBlocker(
        tx,
        invite,
        invite.acceptedByUserId,
      );
      if (blocked) return blocked;
      const payload = partnerPayload(invite.payload);
      return this.activate(
        tx,
        invite,
        invite.acceptedByUserId,
        payload.acceptedCallName ?? DEFAULT_CALL_NAME[payload.kind ?? 'FATHER'],
        input,
      );
    }, TRANSACTION_OPTIONS);
  }

  async findBootstrap(
    userId: string,
    familyId: string,
  ): Promise<FamilyBootstrapState | null> {
    const family = await this.prisma.family.findFirst({
      where: { id: familyId, deletedAt: null, status: { not: 'DELETED' } },
      include: {
        familyParents: {
          where: activeParent,
          include: { user: { select: { displayName: true } } },
          orderBy: { slot: 'asc' },
        },
      },
    });
    const parents = (family?.familyParents ?? []).map((parent) => ({
      userId: parent.userId,
      slot: parent.slot,
      kind: parent.kind,
      callName: parent.callName,
      displayName: parent.user.displayName,
    }));
    const me = parents.find((parent) => parent.userId === userId);
    if (!family || !me) return null;
    const [couple, children, pregnancies] = await Promise.all([
      this.prisma.coupleSpace.count({
        where: { familyId, status: 'ACTIVE', deletedAt: null },
      }),
      this.prisma.child.findMany({
        where: { familyId, status: 'ACTIVE', deletedAt: null },
        orderBy: [{ sortOrder: 'asc' }, { birthDate: 'asc' }],
      }),
      this.prisma.pregnancy.findMany({
        where: { familyId, status: 'ACTIVE', deletedAt: null },
        orderBy: { seqNo: 'asc' },
      }),
    ]);
    return new FamilyBootstrapState({
      familyId: family.id,
      name: family.name,
      status: family.status,
      timezone: family.timezone,
      settings: cloneDatabaseJson(family.settings),
      accessVersion: family.accessVersion,
      activatedAt: family.activatedAt,
      me,
      parents,
      coupleLinked: couple > 0,
      subjects: [
        ...children.map((child) => ({
          type: 'CHILD' as const,
          id: child.id,
          displayName: child.nickname ?? child.name ?? '',
          name: child.name,
          nickname: child.nickname,
          birthDate: child.birthDate,
          dueDate: null,
          colorIndex: child.colorIndex,
          gender: child.gender,
          expectedCount: null,
          seqNo: null,
          status: child.status,
        })),
        ...pregnancies.map((pregnancy) => ({
          type: 'PREGNANCY' as const,
          id: pregnancy.id,
          displayName: pregnancy.nickname,
          name: null,
          nickname: pregnancy.nickname,
          birthDate: null,
          dueDate: pregnancy.dueDate,
          colorIndex: null,
          gender: null,
          expectedCount: pregnancy.expectedCount,
          seqNo: pregnancy.seqNo,
          status: pregnancy.status,
        })),
      ],
    });
  }

  /** Spec §6.5 activation: Parent B joins, family ACTIVE, couple space, trial (once). */
  private async activate(
    tx: Tx,
    invite: FamilyInviteRow,
    joinerId: string,
    callName: string,
    input: {
      now: Date;
      identityHash: (provider: string, providerUid: string) => Buffer;
    },
  ): Promise<InviteDecisionResult> {
    const { now } = input;
    const familyId = invite.familyId;
    await this.lockFamily(tx, familyId);
    // §7.3: an empty WAITING_PARTNER family of the joiner is retired, never merged.
    const own = await tx.familyParent.findMany({
      where: { userId: joinerId, ...activeParent, familyId: { not: familyId } },
      include: { family: { select: { status: true } } },
    });
    for (const membership of own)
      if (membership.family.status === 'WAITING_PARTNER')
        await this.retireWaitingFamily(tx, membership.familyId, now);
    const parents = await tx.familyParent.findMany({
      where: { familyId, ...activeParent },
    });
    const takenSlots = new Set<ParentSlot>(
      parents.map((parent) => parent.slot),
    );
    const slot: ParentSlot | undefined = (['A', 'B'] as const).find(
      (candidate) => !takenSlots.has(candidate),
    );
    if (!slot) return { kind: 'SLOTS_FULL' };
    const payload = partnerPayload(invite.payload);
    const kind = payload.kind ?? 'FATHER';
    const joined = await tx.familyParent.create({
      data: { familyId, userId: joinerId, slot, kind, callName, joinedAt: now },
    });
    await this.setParentRole(tx, joinerId, kind);
    await tx.familyInvite.update({
      where: { id: invite.id },
      data: {
        status: 'ACCEPTED',
        acceptedByUserId: joinerId,
        acceptedAt: invite.acceptedAt ?? now,
        decidedAt: now,
      },
    });
    const all = [
      ...parents.map((parent) => ({
        id: parent.id,
        userId: parent.userId,
        slot: parent.slot,
      })),
      { id: joined.id, userId: joinerId, slot },
    ];
    const parentA = all.find((parent) => parent.slot === 'A')!;
    const parentB = all.find((parent) => parent.slot === 'B')!;
    const family = await tx.family.update({
      where: { id: familyId },
      data: {
        status: 'ACTIVE',
        activatedAt: now,
        accessVersion: { increment: 1 },
      },
    });
    const couples = await tx.coupleSpace.aggregate({
      where: { familyId },
      _max: { pairVersion: true },
    });
    await tx.coupleSpace.updateMany({
      where: { familyId, status: 'ACTIVE', deletedAt: null },
      data: { status: 'UNLINKED', disabledAt: now },
    });
    await tx.coupleSpace.create({
      data: {
        familyId,
        parentAUserId: parentA.userId,
        parentBUserId: parentB.userId,
        parentAMembershipId: parentA.id,
        parentBMembershipId: parentB.id,
        pairVersion: (couples._max.pairVersion ?? 0) + 1,
        updatedBy: joinerId,
      },
    });
    const trialEndsAt = await this.grantTrialOnce(
      tx,
      familyId,
      [parentA.userId, parentB.userId],
      input,
    );
    await tx.outboxEvent.createMany({
      data: [
        {
          eventType: 'PartnerLinked',
          aggregateId: familyId,
          familyId,
          payload: { familyId, accessVersion: family.accessVersion },
        },
        ...(trialEndsAt
          ? [
              {
                eventType: 'TrialStarted',
                aggregateId: familyId,
                familyId,
                payload: { familyId, trialEndsAt: trialEndsAt.toISOString() },
              },
            ]
          : []),
      ],
    });
    return { kind: 'JOINED', familyId, trialEndsAt };
  }

  /**
   * BR-054: trial starts when both Parents joined, at most once per person/identity.
   * Returns the trial end, or null when the family must choose a plan.
   */
  private async grantTrialOnce(
    tx: Tx,
    familyId: string,
    userIds: string[],
    input: {
      now: Date;
      identityHash: (provider: string, providerUid: string) => Buffer;
    },
  ): Promise<Date | null> {
    const { now } = input;
    const entitlement = await tx.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
    });
    if (!entitlement) return null;
    if (
      entitlement.accessPhase === 'PAID' ||
      entitlement.accessPhase === 'BLOCKED'
    )
      return null;
    // A new partner after PARTNER_LEFT keeps the family's running trial; the
    // once-per-identity rule only limits granting a new one.
    if (
      entitlement.accessPhase === 'TRIAL' &&
      entitlement.trialEndsAt &&
      entitlement.trialEndsAt > now
    )
      return entitlement.trialEndsAt;
    const identities = await tx.authIdentity.findMany({
      where: { userId: { in: userIds }, deletedAt: null },
      select: { userId: true, provider: true, providerUid: true },
    });
    const hashes = identities.map((identity) => ({
      userId: identity.userId,
      hash: new Uint8Array(
        input.identityHash(identity.provider, identity.providerUid),
      ),
    }));
    const consumed = await tx.trialConsumption.count({
      where: {
        deletedAt: null,
        OR: [
          { userId: { in: userIds } },
          ...(hashes.length
            ? [{ identityHash: { in: hashes.map((item) => item.hash) } }]
            : []),
        ],
      },
    });
    const policy =
      consumed === 0 ? await this.defaultTrialPolicy(tx, now) : null;
    if (!policy) {
      await tx.familyEntitlement.update({
        where: { familyId },
        data: {
          accessPhase: 'EXPIRED',
          computedAt: now,
          version: { increment: 1 },
        },
      });
      return null;
    }
    const endsAt = new Date(
      now.getTime() + Number(policy.durationSeconds) * 1000,
    );
    const grant = await tx.licenseGrant.create({
      data: {
        familyId,
        licenseId: entitlement.licenseId,
        planVersionId: policy.planVersionId,
        source: 'TRIAL',
        trialPolicyId: policy.id,
        provenanceKey: `trial:${familyId}:${policy.id}`,
        validFrom: now,
        validUntil: endsAt,
      },
    });
    await tx.familyEntitlement.update({
      where: { familyId },
      data: {
        accessPhase: 'TRIAL',
        effectivePlanVersionId: policy.planVersionId,
        sourceGrantId: grant.id,
        trialStartedAt: now,
        trialEndsAt: endsAt,
        validUntil: endsAt,
        inGrace: false,
        computedAt: now,
        version: { increment: 1 },
      },
    });
    if (hashes.length)
      await tx.trialConsumption.createMany({
        data: hashes.map((item) => ({
          trialPolicyId: policy.id,
          userId: item.userId,
          identityHash: item.hash,
          familyId,
          grantId: grant.id,
          startedAt: now,
        })),
      });
    return endsAt;
  }

  private async defaultTrialPolicy(tx: Tx, now: Date) {
    const setting = await tx.appConfig.findFirst({
      where: { key: DEFAULT_TRIAL_POLICY_SETTING, deletedAt: null },
    });
    const code = typeof setting?.value === 'string' ? setting.value : null;
    if (!code) return null;
    return tx.trialPolicy.findFirst({
      where: {
        code,
        active: true,
        deletedAt: null,
        publishedAt: { lte: now },
        OR: [{ retiredAt: null }, { retiredAt: { gt: now } }],
      },
      orderBy: { version: 'desc' },
    });
  }

  /** Why the user cannot join this invite's family, or null when they can. */
  private async joinBlocker(
    tx: Tx,
    invite: FamilyInviteRow,
    userId: string,
  ): Promise<InviteDecisionResult | null> {
    const family = await this.lockFamily(tx, invite.familyId);
    if (
      !family ||
      (family.status !== 'WAITING_PARTNER' && family.status !== 'PARTNER_LEFT')
    )
      return { kind: 'SLOTS_FULL' };
    const memberships = await tx.familyParent.findMany({
      where: { userId, ...activeParent },
      include: { family: { select: { status: true, deletedAt: true } } },
    });
    for (const membership of memberships) {
      if (membership.familyId === invite.familyId)
        return { kind: 'ALREADY_USED' };
      // Only an empty waiting family may be dropped (§7.3); an activated one blocks.
      if (
        membership.family.deletedAt === null &&
        membership.family.status !== 'WAITING_PARTNER' &&
        membership.family.status !== 'DELETED'
      )
        return { kind: 'ALREADY_PARENT' };
    }
    return null;
  }

  private async retireWaitingFamily(
    tx: Tx,
    familyId: string,
    now: Date,
  ): Promise<void> {
    await tx.familyInvite.updateMany({
      where: {
        familyId,
        status: { in: ['PENDING', 'AWAITING_APPROVAL'] },
        deletedAt: null,
      },
      data: { status: 'REVOKED', decidedAt: now },
    });
    await tx.familyParent.updateMany({
      where: { familyId, ...activeParent },
      data: { status: 'LEFT', leftAt: now },
    });
    await tx.family.update({
      where: { id: familyId },
      data: {
        status: 'DELETED',
        deletedAt: now,
        accessVersion: { increment: 1 },
      },
    });
  }

  private async setParentRole(
    tx: Tx,
    userId: string,
    kind: ParentKind | null,
  ): Promise<void> {
    if (!kind) return;
    await tx.user.update({
      where: { id: userId },
      data: {
        onboardingRole: kind === 'FATHER' ? 'PARENT_FATHER' : 'PARENT_MOTHER',
      },
    });
  }

  private async trialEndsAt(tx: Tx, familyId: string): Promise<Date | null> {
    const entitlement = await tx.familyEntitlement.findFirst({
      where: { familyId, deletedAt: null },
      select: { trialEndsAt: true, accessPhase: true },
    });
    return entitlement?.accessPhase === 'TRIAL'
      ? entitlement.trialEndsAt
      : null;
  }

  private async isCircleLookup(lookup: InviteLookup): Promise<boolean> {
    return (
      (await this.prisma.familyInvite.count({
        where: {
          ...('tokenHash' in lookup
            ? { tokenHash: new Uint8Array(lookup.tokenHash) }
            : { codeHash: new Uint8Array(lookup.codeHash) }),
          type: 'CIRCLE',
          deletedAt: null,
        },
      })) > 0
    );
  }

  private async lockUser(tx: Tx, userId: string) {
    const rows = await tx.$queryRaw<
      { id: string; onboarding_role: string | null }[]
    >`
      SELECT id, onboarding_role::text AS onboarding_role FROM app.users
      WHERE id = ${userId}::uuid AND deleted_at IS NULL AND status = 'ACTIVE'
      FOR UPDATE`;
    return rows[0] ?? null;
  }

  private async lockFamily(tx: Tx, familyId: string) {
    const rows = await tx.$queryRaw<{ id: string }[]>`
      SELECT id FROM app.families
      WHERE id = ${familyId}::uuid AND deleted_at IS NULL FOR UPDATE`;
    return rows[0] ? tx.family.findUnique({ where: { id: familyId } }) : null;
  }

  /**
   * Locks the invite's family, then the invite, and re-reads it. Every writer
   * (create/accept/decline/decide) locks family → invite in this order, so
   * concurrent resend and accept cannot deadlock.
   */
  private async lockInvite(
    tx: Tx,
    lookup: InviteLookup | { id: string },
  ): Promise<FamilyInviteRow | null> {
    const where =
      'id' in lookup
        ? Prisma.sql`id = ${lookup.id}::uuid`
        : lookupWhere(lookup);
    const found = await tx.$queryRaw<{ id: string; family_id: string }[]>`
      SELECT id, family_id FROM app.family_invites
      WHERE ${where} AND deleted_at IS NULL`;
    const target = found[0];
    if (!target) return null;
    await this.lockFamily(tx, target.family_id);
    const locked = await tx.$queryRaw<{ id: string }[]>`
      SELECT id FROM app.family_invites
      WHERE id = ${target.id}::uuid AND deleted_at IS NULL FOR UPDATE`;
    return locked[0]
      ? tx.familyInvite.findUnique({ where: { id: target.id } })
      : null;
  }

  private async isActiveParent(
    tx: Tx,
    familyId: string,
    userId: string,
  ): Promise<boolean> {
    return (
      (await tx.familyParent.count({
        where: { familyId, userId, ...activeParent },
      })) > 0
    );
  }

  private async hasActiveParentMembership(
    tx: Tx,
    userId: string,
  ): Promise<boolean> {
    return (
      (await tx.familyParent.count({
        where: {
          userId,
          ...activeParent,
          family: { deletedAt: null, status: { not: 'DELETED' } },
        },
      })) > 0
    );
  }
}
