import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  NotificationListQueryDto,
  NotificationReadDto,
} from '../dto/notification/notification-inbox.dto';
import { NOTIFICATION_INBOX_SERVICE } from '../interfaces/services/notification-inbox-service.interface';
import type { INotificationInboxService } from '../interfaces/services/notification-inbox-service.interface';

@ApiTags('Notifications')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('notifications')
export class NotificationInboxController {
  constructor(
    @Inject(NOTIFICATION_INBOX_SERVICE)
    private readonly service: INotificationInboxService,
  ) {}

  @Get()
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Query() query: NotificationListQueryDto,
  ) {
    return this.service.list(actor, query);
  }

  @Get('unread-count')
  unreadCount(@CurrentActor() actor: AuthPrincipal) {
    return this.service.unreadCount(actor);
  }

  @Post('read')
  @HttpCode(200)
  markRead(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: NotificationReadDto,
  ) {
    return this.service.markRead(actor, input);
  }
}
