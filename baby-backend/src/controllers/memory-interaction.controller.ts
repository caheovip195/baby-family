import { ApiHeader } from '@nestjs/swagger';
import { Optional } from '@nestjs/common';
import { OptionalIdempotencyKey } from '../common/http/offline-idempotency-key.decorator';
import { offlineCommand } from '../common/http/offline-command';
import { OFFLINE_COMMAND_SERVICE } from '../interfaces/services/offline-command-service.interface';
import type { IOfflineCommandService } from '../interfaces/services/offline-command-service.interface';
import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Put,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CommentListResponseDto,
  CommentResponseDto,
  ReactionResponseDto,
} from '../dto/memory/comment-response.dto';
import { CreateCommentDto } from '../dto/memory/create-comment.dto';
import { SetReactionDto } from '../dto/memory/set-reaction.dto';
import { UpdateCommentDto } from '../dto/memory/update-comment.dto';
import { MEMORY_INTERACTION_SERVICE } from '../interfaces/services/memory-interaction-service.interface';
import type { IMemoryInteractionService } from '../interfaces/services/memory-interaction-service.interface';

/** MEM-07 reactions and MEM-10 comments (spec §7.12). */
@ApiTags('Memory')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class MemoryInteractionController {
  constructor(
    @Inject(MEMORY_INTERACTION_SERVICE)
    private readonly service: IMemoryInteractionService,
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}

  @Get('memories/:id/comments')
  @ApiOkResponse({ type: CommentListResponseDto })
  listComments(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.listComments(actor, id);
  }

  @Post('memories/:id/comments')
  @ApiCreatedResponse({ type: CommentResponseDto })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  addComment(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: CreateCommentDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      {
        operation: 'memory.comment.create',
        actor,
        memoryId: id,
        body: input,
      },
      () => this.service.addComment(actor, id, input),
    );
  }

  @Patch('comments/:id')
  @ApiOkResponse({ type: CommentResponseDto })
  editComment(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: UpdateCommentDto,
  ) {
    return this.service.editComment(actor, id, input);
  }

  @Delete('comments/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  deleteComment(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.deleteComment(actor, id);
  }

  @Put('memories/:id/reaction')
  @ApiOkResponse({ type: ReactionResponseDto })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  setReaction(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: SetReactionDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      {
        operation: 'memory.reaction.set',
        actor,
        memoryId: id,
        body: input,
      },
      () => this.service.setReaction(actor, id, input),
    );
  }

  @Delete('memories/:id/reaction')
  @ApiOkResponse({ type: ReactionResponseDto })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  clearReaction(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      { operation: 'memory.reaction.clear', actor, memoryId: id },
      () => this.service.clearReaction(actor, id),
    );
  }
}
