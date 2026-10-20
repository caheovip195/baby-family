import { Inject, Injectable, Optional } from '@nestjs/common';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { DomainError } from '../common/errors/domain.error';
import type {
  NotificationListQueryDto,
  NotificationListResponseDto,
  NotificationReadDto,
} from '../dto/notification/notification-inbox.dto';
import { NOTIFICATION_INBOX_REPOSITORY } from '../interfaces/repositories/notification-inbox-repository.interface';
import type { INotificationInboxRepository } from '../interfaces/repositories/notification-inbox-repository.interface';
import type { INotificationInboxService } from '../interfaces/services/notification-inbox-service.interface';

import { NOTIFICATION_TEXT_SERVICE } from '../interfaces/services/notification-text-service.interface';
import type { INotificationTextService } from '../interfaces/services/notification-text-service.interface';

@Injectable()
export class NotificationInboxService implements INotificationInboxService {
  constructor(
    @Inject(NOTIFICATION_INBOX_REPOSITORY)
    private readonly repository: INotificationInboxRepository,
    @Optional()
    @Inject(NOTIFICATION_TEXT_SERVICE)
    private readonly text?: INotificationTextService,
  ) {}

  async list(
    actor: AuthPrincipal,
    query: NotificationListQueryDto,
  ): Promise<NotificationListResponseDto> {
    const result = await this.repository.list(actor.userId, query);
    const text = await this.text?.renderInbox(result.items);
    return {
      items: result.items.map((row) => ({
        id: row.id,
        tab: row.tab,
        category: row.category,
        templateCode: row.templateCode,
        ...text?.get(row.id),
        params: row.params,
        createdAt: row.createdAt.toISOString(),
        readAt: row.readAt?.toISOString() ?? null,
        deepLink: row.deepLink,
      })),
      nextCursor: result.nextCursor,
    };
  }

  async unreadCount(actor: AuthPrincipal): Promise<{ count: number }> {
    return { count: await this.repository.unreadCount(actor.userId) };
  }

  async markRead(
    actor: AuthPrincipal,
    input: NotificationReadDto,
  ): Promise<{ updatedCount: number }> {
    if (
      (input.all === true) === (input.ids !== undefined) ||
      (input.all !== undefined && input.all !== true) ||
      (input.ids !== undefined &&
        (!Array.isArray(input.ids) || input.ids.length === 0))
    ) {
      throw new DomainError(
        'Provide either notification ids or all: true.',
        'NOTIFICATION_READ_SELECTION_INVALID',
        422,
      );
    }
    return {
      updatedCount: await this.repository.markRead(actor.userId, input),
    };
  }
}
