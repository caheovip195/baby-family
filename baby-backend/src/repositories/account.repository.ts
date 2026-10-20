import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service';
import type { OnboardingRole } from '../common/database.enums';
import type {
  ConsentInput,
  IAccountRepository,
  RegisterDeviceInput,
  SetOnboardingRoleResult,
} from '../interfaces/repositories/account-repository.interface';
import { AccountOverview } from '../models/account-overview.model';
import type { ParentKind } from '../common/database.enums';
import { User } from '../models/user.model';
import { UserDevice } from '../models/user-device.model';

const activeParent = { status: 'ACTIVE' as const, deletedAt: null };
const liveFamily = { deletedAt: null, status: { not: 'DELETED' as const } };

@Injectable()
export class AccountRepository implements IAccountRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findOverview(userId: string): Promise<AccountOverview | null> {
    const user = await this.prisma.user.findFirst({
      where: { id: userId, deletedAt: null },
    });
    if (!user) return null;
    const [parents, consents, awaiting] = await Promise.all([
      this.prisma.familyParent.findMany({
        where: { userId, ...activeParent, family: liveFamily },
        include: { family: { select: { id: true, name: true, status: true } } },
        orderBy: { joinedAt: 'asc' },
      }),
      this.prisma.userConsent.findMany({
        where: { userId, deletedAt: null },
        orderBy: { createdAt: 'desc' },
        select: { document: true, granted: true },
      }),
      this.prisma.familyInvite.findMany({
        where: {
          acceptedByUserId: userId,
          type: 'PARTNER',
          status: 'AWAITING_APPROVAL',
          deletedAt: null,
          family: liveFamily,
        },
        include: { family: { select: { name: true } } },
      }),
    ]);
    // Latest decision per document wins (rows are append-only).
    const decided = new Map<string, boolean>();
    for (const consent of consents)
      if (!decided.has(consent.document))
        decided.set(consent.document, consent.granted);
    return new AccountOverview({
      user: new User({ ...user }),
      parentMemberships: parents.map((parent) => ({
        familyId: parent.family.id,
        familyName: parent.family.name,
        familyStatus: parent.family.status,
        slot: parent.slot,
        kind: parent.kind,
        callName: parent.callName,
      })),
      grantedDocuments: [...decided]
        .filter(([, granted]) => granted)
        .map(([document]) => document),
      awaitingApproval: awaiting.map((invite) => ({
        inviteId: invite.id,
        familyName: invite.family.name,
        kind: inviteKind(invite.payload),
      })),
    });
  }

  setOnboardingRole(
    userId: string,
    role: OnboardingRole,
  ): Promise<SetOnboardingRoleResult> {
    return this.prisma.$transaction(async (tx) => {
      const locked = await tx.$queryRaw<{ id: string }[]>`
        SELECT id FROM app.users
        WHERE id = ${userId}::uuid AND deleted_at IS NULL FOR UPDATE`;
      if (!locked[0]) return { kind: 'NOT_FOUND' };
      const membership = await tx.familyParent.count({
        where: { userId, ...activeParent, family: liveFamily },
      });
      if (membership > 0) return { kind: 'LOCKED' };
      const user = await tx.user.update({
        where: { id: userId },
        data: { onboardingRole: role },
      });
      return { kind: 'UPDATED', user: new User({ ...user }) };
    });
  }

  registerDevice(
    userId: string,
    sessionId: string,
    input: RegisterDeviceInput,
    now: Date,
  ): Promise<UserDevice> {
    return this.prisma.$transaction(async (tx) => {
      const session = await tx.userSession.findFirstOrThrow({
        where: { id: sessionId, userId, deletedAt: null },
        select: { id: true, deviceId: true },
      });
      // A push token belongs to one installation: detach it from any other row first.
      if (input.pushToken)
        await tx.userDevice.updateMany({
          where: {
            pushToken: input.pushToken,
            ...(session.deviceId ? { id: { not: session.deviceId } } : {}),
          },
          data: { pushToken: null, pushEnabled: false },
        });
      const data = { ...input, lastSeenAt: now };
      const existing = session.deviceId
        ? await tx.userDevice.findFirst({
            where: { id: session.deviceId, userId, deletedAt: null },
          })
        : null;
      const device = existing
        ? await tx.userDevice.update({ where: { id: existing.id }, data })
        : await tx.userDevice.create({ data: { ...data, userId } });
      if (!existing)
        await tx.userSession.update({
          where: { id: session.id },
          data: { deviceId: device.id },
        });
      return new UserDevice({ ...device });
    });
  }

  async recordConsents(
    userId: string,
    consents: ConsentInput[],
    context: { platform: 'IOS' | 'ANDROID' | 'WEB' | null; ip: string | null },
  ): Promise<void> {
    await this.prisma.userConsent.createMany({
      data: consents.map((consent) => ({
        userId,
        document: consent.document,
        version: consent.version,
        granted: consent.granted,
        platform: context.platform,
        ip: context.ip,
      })),
    });
  }
}

function inviteKind(payload: unknown): ParentKind | null {
  const kind =
    payload && typeof payload === 'object' && 'kind' in payload
      ? payload.kind
      : null;
  return kind === 'FATHER' || kind === 'MOTHER' ? kind : null;
}
