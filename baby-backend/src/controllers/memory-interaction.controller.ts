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
  addComment(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: CreateCommentDto,
  ) {
    return this.service.addComment(actor, id, input);
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
  setReaction(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: SetReactionDto,
  ) {
    return this.service.setReaction(actor, id, input);
  }

  @Delete('memories/:id/reaction')
  @ApiOkResponse({ type: ReactionResponseDto })
  clearReaction(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.clearReaction(actor, id);
  }
}
