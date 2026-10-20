import type {
  FamilyStatus,
  InviteStatus,
  InviteType,
  ParentKind,
  ParentSlot,
} from '../common/database.enums';

export interface InvitePreviewAttributes {
  inviteId: string;
  type: InviteType;
  status: InviteStatus;
  expiresAt: Date;
  familyId: string;
  familyName: string;
  familyStatus: FamilyStatus;
  inviterCallName: string | null;
  inviterKind: ParentKind | null;
  /** Role offered to the invitee (PARTNER payload `kind`). */
  proposedKind: ParentKind | null;
  message: string | null;
}

/** What INV-01 may show before accepting (spec §11.3 `/invites/resolve`). */
export class InvitePreview implements InvitePreviewAttributes {
  readonly inviteId: string;
  readonly type: InviteType;
  readonly status: InviteStatus;
  readonly expiresAt: Date;
  readonly familyId: string;
  readonly familyName: string;
  readonly familyStatus: FamilyStatus;
  readonly inviterCallName: string | null;
  readonly inviterKind: ParentKind | null;
  readonly proposedKind: ParentKind | null;
  readonly message: string | null;

  constructor(attributes: InvitePreviewAttributes) {
    this.inviteId = attributes.inviteId;
    this.type = attributes.type;
    this.status = attributes.status;
    this.expiresAt = attributes.expiresAt;
    this.familyId = attributes.familyId;
    this.familyName = attributes.familyName;
    this.familyStatus = attributes.familyStatus;
    this.inviterCallName = attributes.inviterCallName;
    this.inviterKind = attributes.inviterKind;
    this.proposedKind = attributes.proposedKind;
    this.message = attributes.message;
  }

  isExpiredAt(now: Date): boolean {
    return (
      this.status === 'EXPIRED' || this.expiresAt.getTime() <= now.getTime()
    );
  }
}

export interface BootstrapParentAttributes {
  userId: string;
  slot: ParentSlot;
  kind: ParentKind;
  callName: string;
  displayName: string;
}

export interface BootstrapSubjectAttributes {
  type: 'CHILD' | 'PREGNANCY';
  id: string;
  displayName: string;
  /** Child: legal name and nickname; pregnancy: nickname only. */
  name: string | null;
  nickname: string | null;
  birthDate: Date | null;
  dueDate: Date | null;
  colorIndex: number | null;
  gender: string | null;
  expectedCount: number | null;
  seqNo: number | null;
  status: string;
}

export interface FamilyBootstrapStateAttributes {
  familyId: string;
  name: string;
  status: FamilyStatus;
  timezone: string;
  settings: unknown;
  accessVersion: number;
  activatedAt: Date | null;
  me: BootstrapParentAttributes;
  parents: BootstrapParentAttributes[];
  coupleLinked: boolean;
  subjects: BootstrapSubjectAttributes[];
}

/** Read model behind `GET /families/{fid}/bootstrap` (spec §11.4). */
export class FamilyBootstrapState implements FamilyBootstrapStateAttributes {
  readonly familyId: string;
  readonly name: string;
  readonly status: FamilyStatus;
  readonly timezone: string;
  readonly settings: unknown;
  readonly accessVersion: number;
  readonly activatedAt: Date | null;
  readonly me: BootstrapParentAttributes;
  readonly parents: BootstrapParentAttributes[];
  readonly coupleLinked: boolean;
  readonly subjects: BootstrapSubjectAttributes[];

  constructor(attributes: FamilyBootstrapStateAttributes) {
    this.familyId = attributes.familyId;
    this.name = attributes.name;
    this.status = attributes.status;
    this.timezone = attributes.timezone;
    this.settings = attributes.settings;
    this.accessVersion = attributes.accessVersion;
    this.activatedAt = attributes.activatedAt;
    this.me = attributes.me;
    this.parents = attributes.parents;
    this.coupleLinked = attributes.coupleLinked;
    this.subjects = attributes.subjects;
  }
}
