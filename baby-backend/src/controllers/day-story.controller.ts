import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  DayStoryDto,
  DayStoryQueryDto,
  SaveDayStoryDto,
  SavedDayStoryDto,
} from '../dto/day-story/day-story.dto';
import { DAY_STORY_RECAP_SERVICE } from '../interfaces/services/day-story-recap-service.interface';
import type { IDayStoryRecapService } from '../interfaces/services/day-story-recap-service.interface';

/** REC-01 Câu chuyện ngày (BF-20261028-006). */
@ApiTags('Recaps')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('children/:childId/day-story')
export class DayStoryController {
  constructor(
    @Inject(DAY_STORY_RECAP_SERVICE)
    private readonly service: IDayStoryRecapService,
  ) {}

  @Get()
  @ApiOkResponse({ type: DayStoryDto })
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
    @Query() query: DayStoryQueryDto,
  ) {
    return this.service.get(actor, childId, query.date);
  }

  @Put(':date')
  @ApiOkResponse({ type: SavedDayStoryDto })
  save(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
    @Param('date') date: string,
    @Body() input: SaveDayStoryDto,
  ) {
    return this.service.save(actor, childId, date, input);
  }

  @Delete(':date')
  @HttpCode(204)
  @ApiNoContentResponse()
  async remove(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
    @Param('date') date: string,
  ) {
    await this.service.remove(actor, childId, date);
  }
}
