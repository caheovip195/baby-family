import { Inject, Injectable, Optional } from '@nestjs/common';
import { NOTIFICATION_POLICY as POLICY } from '../config/notification-policy';
import type { NotificationCategory } from '../config/notification-policy';
import { NOTIFICATION_INBOX_REPOSITORY } from '../interfaces/repositories/notification-inbox-repository.interface';
import type { INotificationInboxRepository } from '../interfaces/repositories/notification-inbox-repository.interface';
import { REALTIME_REPOSITORY } from '../interfaces/repositories/realtime-repository.interface';
import type { IRealtimeRepository } from '../interfaces/repositories/realtime-repository.interface';
import type { INotificationDispatchService } from '../interfaces/services/notification-dispatch-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import type {
  NotificationDispatchDecision,
  NotificationDispatchSnapshot,
  NotificationRecipient,
} from '../models/notification-inbox-dispatch.model';

interface EventPolicy {
  template: string;
  category: NotificationCategory;
  sensitive: boolean;
  grouped?: boolean;
  audience:
    | 'partner'
    | 'comments'
    | 'author'
    | 'target'
    | 'parents'
    | 'circle'
    | 'members';
  /** Bỏ hẳn người nhận đang kết nối realtime (chat: đã thấy tin trong app). */
  skipOnline?: boolean;
  identifiersOnly?: boolean;
  /** Đích mở khi chạm (mặc định ký ức của sự kiện). */
  deepLink?: string;
}

const REVIEW_REQUESTED: EventPolicy = {
  template: 'NOTI_MEMORY_REVIEW_REQUESTED',
  category: 'MEMORIES',
  sensitive: false,
  audience: 'parents',
  identifiersOnly: true,
};

const EVENTS: Record<string, EventPolicy> = {
  'memory.review_requested': REVIEW_REQUESTED,
  'memory.submitted': REVIEW_REQUESTED,
  'memory.approved': {
    template: 'NOTI_MEMORY_APPROVED',
    category: 'MEMORIES',
    sensitive: false,
    audience: 'author',
    identifiersOnly: true,
  },
  'memory.rejected': {
    template: 'NOTI_MEMORY_REJECTED',
    category: 'MEMORIES',
    sensitive: false,
    audience: 'author',
    identifiersOnly: true,
  },
  'memory.published': {
    template: 'NOTI_MEMORY_PUBLISHED',
    category: 'MEMORIES',
    sensitive: false,
    audience: 'partner',
  },
  'comment.created': {
    template: 'NOTI_COMMENT_CREATED',
    category: 'MEMORIES',
    sensitive: false,
    grouped: true,
    audience: 'comments',
  },
  'reaction.changed': {
    template: 'NOTI_REACTION_CHANGED',
    category: 'MEMORIES',
    sensitive: false,
    grouped: true,
    audience: 'author',
  },
  'us.request.sent': {
    template: 'NOTI_REQUEST_CREATED',
    category: 'REQUESTS',
    sensitive: true,
    audience: 'target',
  },
  'us.request.created': {
    template: 'NOTI_REQUEST_CREATED',
    category: 'REQUESTS',
    sensitive: true,
    audience: 'target',
  },
  'us.request.accept': {
    template: 'NOTI_REQUEST_ACCEPTED',
    category: 'REQUESTS',
    sensitive: true,
    audience: 'target',
  },
  'us.request.done': {
    template: 'NOTI_REQUEST_DONE',
    category: 'REQUESTS',
    sensitive: true,
    audience: 'target',
  },
  'us.request.decline': {
    template: 'NOTI_REQUEST_DECLINED',
    category: 'REQUESTS',
    sensitive: true,
    audience: 'target',
  },
  'us.request.acknowledge': {
    template: 'NOTI_REQUEST_ACKNOWLEDGED',
    category: 'REQUESTS',
    sensitive: true,
    audience: 'target',
  },
  'us.checkin.shared': {
    template: 'NOTI_CHECKIN_SHARED',
    category: 'US',
    sensitive: true,
    audience: 'partner',
  },
  'us.appreciation.created': {
    template: 'NOTI_APPRECIATION_CREATED',
    category: 'APPRECIATION',
    sensitive: true,
    audience: 'target',
  },
  // Cầu nối (BF-20261028-008): lời mời trung tính, không chi tiết.
  'us.bridge.invited': {
    template: 'NOTI_BRIDGE_INVITED',
    category: 'US',
    sensitive: true,
    audience: 'target',
  },
  // Bàn giao ca (BF-20261028-007): chỉ người nhận ca.
  'us.handoff.created': {
    template: 'NOTI_HANDOFF_CREATED',
    category: 'US',
    sensitive: true,
    audience: 'target',
  },
  // §7.25.1: người thân rời gia đình → Parent, câu trung tính (không lộ nội
  // dung có bị gỡ hay không).
  'circle.left': {
    template: 'NOTI_CIRCLE_LEFT',
    category: 'MEMORIES',
    sensitive: false,
    audience: 'parents',
    identifiersOnly: true,
    deepLink: 'babyfamily://family/circle',
  },
  // REC-04 bản cho ông bà (BF-20261030-002/003): người thân được xem sách.
  'yearbook.shared': {
    template: 'NOTI_YEARBOOK_SHARED',
    category: 'MEMORIES',
    sensitive: false,
    audience: 'circle',
    deepLink: 'babyfamily://year-books',
  },
  // REC-02 (BF-20261030-004): recap tuần Bố Mẹ chia sẻ cho người thân.
  'recap.weekly.shared': {
    template: 'NOTI_WEEKLY_RECAP_SHARED',
    category: 'MEMORIES',
    sensitive: false,
    audience: 'circle',
    deepLink: 'babyfamily://recaps/weekly',
  },
};

/**
 * Nhắn tin (BF-20261101-001): người nhận là thành viên còn quyền và chưa đọc
 * tới tin đó; push ngay (không gộp, không tính trần ngày) nhưng vẫn theo giờ
 * yên tĩnh. Chat riêng Papa & Mama dùng nhóm US và bản xem trước ẩn.
 */
const CHAT_EVENTS: Record<'FAMILY' | 'COUPLE', EventPolicy> = {
  FAMILY: {
    template: 'NOTI_CHAT_FAMILY',
    category: 'CHAT',
    sensitive: false,
    audience: 'members',
    identifiersOnly: true,
    skipOnline: true,
  },
  COUPLE: {
    template: 'NOTI_CHAT_COUPLE',
    category: 'US',
    sensitive: true,
    audience: 'members',
    skipOnline: true,
  },
};

/** Resolves notification business rules; the repository owns atomic fenced persistence. */
@Injectable()
export class NotificationDispatchService implements INotificationDispatchService {
  constructor(
    @Inject(NOTIFICATION_INBOX_REPOSITORY)
    private readonly repository: INotificationInboxRepository,
    @Optional()
    @Inject(REALTIME_REPOSITORY)
    private readonly presence?: IRealtimeRepository,
  ) {}

  async dispatch(
    eventId: string,
    context: JobContext,
  ): Promise<Record<string, number>> {
    context.signal.throwIfAborted();
    const created = await this.repository.consume(
      eventId,
      context.lease,
      async (snapshot) => {
        const event = this.policy(snapshot);
        const online =
          event?.skipOnline && this.presence
            ? await this.presence.onlineUserIds(
                snapshot.candidates.map((c) => c.userId),
              )
            : new Set<string>();
        return this.decide(snapshot, online);
      },
    );
    return { created };
  }

  private policy(snapshot: NotificationDispatchSnapshot) {
    return snapshot.chatKind
      ? CHAT_EVENTS[snapshot.chatKind]
      : EVENTS[snapshot.eventType];
  }

  private decide(
    snapshot: NotificationDispatchSnapshot,
    online: ReadonlySet<string>,
  ): NotificationDispatchDecision[] {
    const event = this.policy(snapshot);
    if (!event || snapshot.reactionRemoved) return [];
    const seen = new Set<string>();
    return snapshot.candidates.flatMap((recipient) => {
      if (
        seen.has(recipient.userId) ||
        recipient.userId === snapshot.actorUserId ||
        !recipient.canView ||
        (event.skipOnline && online.has(recipient.userId))
      )
        return [];
      seen.add(recipient.userId);
      if (event.sensitive && recipient.role !== 'PARENT') return [];
      if (
        snapshot.eventType === 'memory.published' &&
        recipient.role !== 'PARENT'
      )
        return [];
      if (
        !this.matchesAudience(recipient, event.audience) ||
        !this.enabled(recipient, event.category, snapshot.actorUserId)
      )
        return [];
      const tab = event.sensitive ? 'US' : 'FAMILY';
      const params = Object.fromEntries(
        Object.entries(snapshot.params).filter(
          ([key, value]) =>
            POLICY.safeParamKeys.some((allowed) => allowed === key) &&
            (!(event.sensitive || event.identifiersOnly) ||
              ['actorUserId', 'familyId', 'entityId'].includes(key)) &&
            (typeof value === 'string' ||
              (Array.isArray(value) &&
                value.every((item) => typeof item === 'string'))),
        ),
      );
      if (!event.sensitive && !event.identifiersOnly) {
        if (recipient.childIds !== undefined)
          params.childIds = recipient.childIds;
        if (recipient.childNames !== undefined)
          params.childNames = recipient.childNames;
      }
      const priority =
        snapshot.chatKind ||
        (event.category === 'REQUESTS' &&
          ['us.request.sent', 'us.request.created'].includes(
            snapshot.eventType,
          ) &&
          snapshot.urgency === 'SOON')
          ? 'HIGH'
          : 'NORMAL';
      let pushAt: Date | null = new Date(
        snapshot.now.getTime() + (event.grouped ? POLICY.groupWindowMs : 0),
      );
      if (
        pushAt &&
        !(priority === 'HIGH' && recipient.requestSoonBypassQuiet)
      ) {
        if (recipient.quietUntil && recipient.quietUntil > pushAt)
          pushAt = recipient.quietUntil;
        pushAt = this.afterQuietHours(pushAt, recipient);
      }
      return [
        {
          recipientUserId: recipient.userId,
          templateCode: event.template,
          category: event.category,
          tab,
          sensitive: event.sensitive,
          priority,
          params,
          deepLink: snapshot.chatConversationId
            ? `babyfamily://chats/${snapshot.chatConversationId}`
            : event.sensitive
              ? 'babyfamily://us'
              : (event.deepLink ??
                `babyfamily://memories/${snapshot.subjectId}`),
          groupKey: event.grouped
            ? `${event.template}:${snapshot.subjectId}`
            : null,
          pushAt,
        } satisfies NotificationDispatchDecision,
      ];
    });
  }

  private matchesAudience(
    recipient: NotificationRecipient,
    audience: EventPolicy['audience'],
  ): boolean {
    switch (audience) {
      case 'parents':
        return recipient.role === 'PARENT';
      case 'circle':
        return recipient.role === 'CIRCLE';
      case 'partner':
        return recipient.isPartner;
      case 'comments':
        return recipient.isAuthor || recipient.isParticipant;
      case 'author':
        return recipient.isAuthor;
      case 'target':
        return recipient.isTarget;
      case 'members':
        return true;
    }
  }

  private enabled(
    recipient: NotificationRecipient,
    category: NotificationCategory,
    actor: string | null,
  ): boolean {
    const nested = recipient.prefs.categories;
    const categories =
      nested && typeof nested === 'object' && !Array.isArray(nested)
        ? (nested as Record<string, unknown>)
        : recipient.prefs;
    const keys: readonly string[] = [
      category,
      ...POLICY.categoryAliases[category],
    ];
    const values = keys.flatMap((key) => [
      categories[key],
      recipient.prefs[key],
    ]);
    // A disabled legacy alias wins over a conflicting enabled canonical key.
    if (values.includes(false)) return false;
    if (!values.includes(true) && !POLICY.categoryDefaults[category])
      return false;
    for (const key of ['mutedUserIds', 'blockedUserIds']) {
      const users = recipient.prefs[key];
      if (actor && Array.isArray(users) && users.includes(actor)) return false;
    }
    return true;
  }

  private afterQuietHours(
    instant: Date,
    recipient: NotificationRecipient,
  ): Date {
    const parse = (value: string, fallback: string) => {
      const safe = /^([01]\d|2[0-3]):[0-5]\d/.test(value) ? value : fallback;
      return Number(safe.slice(0, 2)) * 60 + Number(safe.slice(3, 5));
    };
    const start = parse(recipient.quietStart, POLICY.quietStart);
    const end = parse(recipient.quietEnd, POLICY.quietEnd);
    if (start === end) return instant;
    let formatter: Intl.DateTimeFormat;
    try {
      formatter = new Intl.DateTimeFormat('en-GB', {
        timeZone: recipient.timezone,
        hour: '2-digit',
        minute: '2-digit',
        hourCycle: 'h23',
      });
    } catch {
      formatter = new Intl.DateTimeFormat('en-GB', {
        timeZone: POLICY.defaultTimezone,
        hour: '2-digit',
        minute: '2-digit',
        hourCycle: 'h23',
      });
    }
    const quiet = (date: Date) => {
      const parts = formatter.formatToParts(date);
      const minutes =
        Number(parts.find((part) => part.type === 'hour')!.value) * 60 +
        Number(parts.find((part) => part.type === 'minute')!.value);
      return start > end
        ? minutes >= start || minutes < end
        : minutes >= start && minutes < end;
    };
    if (!quiet(instant)) return instant;
    // Walk real instants across DST transitions rather than assuming every local day is 24h.
    let candidate = new Date(
      Math.floor(instant.getTime() / 60000) * 60000 + 60000,
    );
    for (let minutes = 0; minutes < 26 * 60; minutes++) {
      if (!quiet(candidate)) return candidate;
      candidate = new Date(candidate.getTime() + 60000);
    }
    return candidate;
  }
}
