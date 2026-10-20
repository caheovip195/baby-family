import { TimelineQueryDto } from '../dto/memory/timeline-query.dto';
import { TimelineResponseDto } from '../dto/memory/timeline-response.dto';
import { MediaGridQueryDto } from '../dto/memory/media-grid-query.dto';
import { MediaGridResponseDto } from '../dto/memory/media-grid-response.dto';
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
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiHeader,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import { IfMatchVersion } from '../common/http/if-match.decorator';
import { CreateMemoryDto } from '../dto/memory/create-memory.dto';
import { MemoryFeedQueryDto } from '../dto/memory/memory-feed-query.dto';
import {
  MemorySearchQueryDto,
  OnThisDayQueryDto,
  OnThisDayResponseDto,
  TodayStoryQueryDto,
  TodayStoryResponseDto,
} from '../dto/memory/memory-search-query.dto';
import { MemoryTrashQueryDto } from '../dto/memory/memory-trash-query.dto';
import { UpdateMemoryDto } from '../dto/memory/update-memory.dto';
import {
  MemoryFeedResponseDto,
  MemoryResponseDto,
} from '../dto/memory/memory-response.dto';
import { MEMORY_CONTENT_SERVICE } from '../interfaces/services/memory-content-service.interface';
import type { IMemoryContentService } from '../interfaces/services/memory-content-service.interface';

@ApiTags('Memory')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class MemoryController {
  constructor(
    @Inject(MEMORY_CONTENT_SERVICE)
    private readonly service: IMemoryContentService,
  ) {}

  @Get('families/:familyId/timeline')
  @ApiOkResponse({ type: TimelineResponseDto })
  timeline(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: TimelineQueryDto,
  ) {
    return this.service.timeline(actor, familyId, query);
  }

  @Get('families/:familyId/media-grid')
  @ApiOkResponse({ type: MediaGridResponseDto })
  mediaGrid(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: MediaGridQueryDto,
  ) {
    return this.service.mediaGrid(actor, familyId, query);
  }

  @Get('me/drafts')
  drafts(
    @CurrentActor() actor: AuthPrincipal,
    @Query('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.drafts(actor, familyId);
  }

  @Post('memories/:id/publish')
  @HttpCode(HttpStatus.OK)
  publish(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.publish(actor, id);
  }

  @Post('memories')
  @ApiHeader({
    name: 'Idempotency-Key',
    required: true,
    description: 'UUID; replaying the same request returns the same memory.',
  })
  @ApiCreatedResponse({ type: MemoryResponseDto })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @IdempotencyKey() idempotencyKey: string,
    @Body() input: CreateMemoryDto,
  ) {
    return this.service.create(actor, idempotencyKey, input);
  }

  @Get('memories/:id')
  @ApiOkResponse({ type: MemoryResponseDto })
  getById(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.getById(actor, id);
  }

  /** MEM-09: `If-Match: <version>` required (428 without, 412 when stale). */
  @Patch('memories/:id')
  @ApiHeader({
    name: 'If-Match',
    required: true,
    description: 'Current memory `version`.',
  })
  @ApiOkResponse({ type: MemoryResponseDto })
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @IfMatchVersion() version: number,
    @Body() input: UpdateMemoryDto,
  ) {
    return this.service.update(actor, id, version, input);
  }

  @Get('families/:familyId/feed')
  @ApiOkResponse({ type: MemoryFeedResponseDto })
  feed(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: MemoryFeedQueryDto,
  ) {
    return this.service.feed(actor, familyId, query);
  }

  /** MEM-15: tìm ký ức theo chữ (bỏ dấu), cùng quyền xem với bảng tin. */
  @Get('families/:familyId/search')
  @ApiOkResponse({ type: MemoryFeedResponseDto })
  search(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: MemorySearchQueryDto,
  ) {
    return this.service.search(actor, familyId, query);
  }

  /** MEM-25: ký ức của bé trong một ngày, dạng trình chiếu. */
  @Get('children/:childId/today-story')
  @ApiOkResponse({ type: TodayStoryResponseDto })
  todayStory(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', new ParseUUIDPipe()) childId: string,
    @Query() query: TodayStoryQueryDto,
  ) {
    return this.service.todayStory(actor, childId, query);
  }

  /** MEM-16: ngày này các năm trước (ngày theo múi giờ gia đình). */
  @Get('families/:familyId/on-this-day')
  @ApiOkResponse({ type: OnThisDayResponseDto })
  onThisDay(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: OnThisDayQueryDto,
  ) {
    return this.service.onThisDay(actor, familyId, query);
  }

  /** MEM-07 “Xoá”: moves the memory to the trash for 30 days (idempotent). */
  @Delete('memories/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  trash(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.trash(actor, id);
  }

  @Get('families/:familyId/trash')
  @ApiOkResponse({ type: MemoryFeedResponseDto })
  listTrash(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: MemoryTrashQueryDto,
  ) {
    return this.service.listTrash(actor, familyId, query);
  }

  @Post('memories/:id/restore')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ type: MemoryResponseDto })
  restore(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.restore(actor, id);
  }

  /** MEM-17 “Xoá vĩnh viễn”. */
  @Delete('memories/:id/purge')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  purge(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.purge(actor, id);
  }
}
