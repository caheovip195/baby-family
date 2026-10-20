import type {
  CircleInvitePayload,
  CircleGrantInput,
} from '../config/circle-policy';
export interface CircleSubject {
  id: string;
  name: string;
  kind: 'CHILD' | 'PREGNANCY';
  /** Only on `GET /me/circles`: the relative's own grant for this subject. */
  permission?: string;
  allowDownload?: boolean;
}
export class FamilyCircleMember {
  constructor(
    public readonly id: string,
    public readonly familyId: string,
    public readonly userId: string,
    public readonly displayName: string,
    public readonly relation: string,
    public readonly status: string,
    public readonly allowDownload: boolean,
    public readonly grants: CircleGrantInput[],
    public readonly joinedAt: Date,
  ) {}
}
export class FamilyCircleInvite {
  constructor(
    public readonly id: string,
    public readonly familyId: string,
    public readonly status: string,
    public readonly payload: CircleInvitePayload,
    public readonly requireFinalApproval: boolean,
    public readonly createdAt: Date,
    public readonly expiresAt: Date,
  ) {}
}
export class FamilyCirclePreview {
  readonly type = 'CIRCLE';
  constructor(
    public readonly inviteId: string,
    public readonly familyName: string,
    public readonly inviterCallName: string | null,
    public readonly relation: string,
    public readonly children: CircleSubject[],
    public readonly expiresAt: Date,
    public readonly message: string | null,
  ) {}
}
export class FamilyCircleBootstrap {
  constructor(
    public readonly familyId: string,
    public readonly familyName: string,
    public readonly status: string,
    public readonly children: CircleSubject[],
    public readonly allowDownload: boolean,
  ) {}
}
export class FamilyCircleOverview {
  constructor(
    public readonly family: { id: string; name: string; status: string },
    public readonly parents: { userId: string; callName: string }[],
    public readonly children: CircleSubject[],
    public readonly circle: { count: number; pendingInvites: number },
    public readonly plan: { accessPhase: string; validUntil: Date | null },
  ) {}
}
