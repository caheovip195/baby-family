import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import {
  ChatConversationDto,
  ChatMessageDto,
  ChatMessagePageDto,
  ChatMessagesQueryDto,
  ChatReadResultDto,
  MarkChatReadDto,
  SendChatMessageDto,
} from '../dto/chat/chat.dto';
import { CHAT_SERVICE } from '../interfaces/services/chat-service.interface';
import type { IChatService } from '../interfaces/services/chat-service.interface';

/** Nhắn tin trong gia đình (BF-20261101-001); realtime ở RealtimeGateway. */
@ApiTags('Chat')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/chats')
export class ChatController {
  constructor(
    @Inject(CHAT_SERVICE)
    private readonly service: IChatService,
  ) {}

  @Get()
  @ApiOkResponse({ type: ChatConversationDto, isArray: true })
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.list(actor, familyId);
  }

  @Get(':conversationId/messages')
  @ApiOkResponse({ type: ChatMessagePageDto })
  messages(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('conversationId', ParseUUIDPipe) conversationId: string,
    @Query() query: ChatMessagesQueryDto,
  ) {
    return this.service.messages(actor, familyId, conversationId, query);
  }

  @Post(':conversationId/messages')
  @ApiOkResponse({ type: ChatMessageDto })
  send(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('conversationId', ParseUUIDPipe) conversationId: string,
    @IdempotencyKey() key: string,
    @Body() input: SendChatMessageDto,
  ) {
    return this.service.send(actor, familyId, conversationId, key, input.body);
  }

  @Post(':conversationId/read')
  @HttpCode(200)
  @ApiOkResponse({ type: ChatReadResultDto })
  read(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('conversationId', ParseUUIDPipe) conversationId: string,
    @Body() input: MarkChatReadDto,
  ) {
    return this.service.markRead(actor, familyId, conversationId, input.seq);
  }
}
