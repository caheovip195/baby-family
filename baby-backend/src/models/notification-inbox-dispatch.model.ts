export class NotificationRecipient {
  userId!: string;
  role!: 'PARENT' | 'CIRCLE';
  canView!: boolean;
  isAuthor!: boolean;
  isParticipant!: boolean;
  isPartner!: boolean;
  isTarget!: boolean;
  locale!: string;
  timezone!: string;
  prefs!: Record<string, unknown>;
  quietStart!: string;
  quietEnd!: string;
  requestSoonBypassQuiet!: boolean;
  pushCountToday!: number;
  childIds?: string[];
  childNames?: string[];
  quietUntil?: Date;
  constructor(values: NotificationRecipient) {
    Object.assign(this, values);
  }
}

export class NotificationDispatchSnapshot {
  eventId!: string;
  eventType!: string;
  familyId!: string;
  subjectId!: string;
  createdAt!: Date;
  now!: Date;
  actorUserId!: string;
  candidates!: NotificationRecipient[];
  params!: Record<string, string | string[]>;
  urgency!: 'SOON' | 'NORMAL';
  requestKind!: 'TASK' | 'NEED';
  reactionRemoved!: boolean;
  constructor(values: NotificationDispatchSnapshot) {
    Object.assign(this, values);
  }
}

export class NotificationDispatchDecision {
  recipientUserId!: string;
  templateCode!: string;
  category!: string;
  tab!: 'FAMILY' | 'US';
  sensitive!: boolean;
  priority!: 'NORMAL' | 'HIGH';
  params!: Record<string, string | string[]>;
  deepLink!: string;
  groupKey!: string | null;
  pushAt!: Date | null;
  constructor(values: NotificationDispatchDecision) {
    Object.assign(this, values);
  }
}
