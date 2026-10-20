import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import {
  CreateMissionDto,
  CompleteMissionDto,
  MissionBoardQueryDto,
  MissionTemplateQueryDto,
  SwapMissionDto,
} from '../dto/mission/mission.dto';
import { SaveMissionMomentDto } from '../dto/mission/mission-moment.dto';
import { MISSION_BOARD_SERVICE } from '../interfaces/services/mission-board-service.interface';
import { MISSION_MOMENT_SERVICE } from '../interfaces/services/mission-moment-service.interface';
import type { IMissionMomentService } from '../interfaces/services/mission-moment-service.interface';
import type { IMissionBoardService } from '../interfaces/services/mission-board-service.interface';

@ApiTags('Daily missions')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/missions')
export class MissionBoardController {
  constructor(
    @Inject(MISSION_BOARD_SERVICE)
    private readonly service: IMissionBoardService,
  ) {}
  @Get('board')
  board(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: MissionBoardQueryDto,
  ) {
    return this.service.board(actor, familyId, query);
  }
}

@ApiTags('Daily missions')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('missions')
export class MissionController {
  constructor(
    @Inject(MISSION_BOARD_SERVICE)
    private readonly service: IMissionBoardService,
    @Inject(MISSION_MOMENT_SERVICE)
    private readonly moments: IMissionMomentService,
  ) {}
  @Get('templates')
  templates(
    @CurrentActor() actor: AuthPrincipal,
    @Query() query: MissionTemplateQueryDto,
  ) {
    return this.service.templates(actor, query);
  }
  @Post()
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Body() input: CreateMissionDto,
    @IdempotencyKey() key: string,
  ) {
    return this.service.create(actor, input, key);
  }
  @Get(':id')
  find(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.find(actor, id);
  }
  @Post(':id/complete')
  complete(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
    @IdempotencyKey() key: string,
    @Body() input: CompleteMissionDto,
  ) {
    return this.service.act(actor, id, 'complete', key, input);
  }
  @Post(':id/undo')
  undo(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.act(actor, id, 'undo');
  }
  @Get(':id/swap-options')
  swapOptions(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.swapOptions(actor, id);
  }
  @Post(':id/swap')
  swap(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: SwapMissionDto,
  ) {
    return this.service.act(actor, id, 'swap', undefined, input);
  }
  /** CARE-06 “Lưu lại khoảnh khắc” → family memory linked to the mission. */
  @Post(':id/moment')
  saveMoment(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: SaveMissionMomentDto,
    @IdempotencyKey() key: string,
  ) {
    return this.moments.save(actor, id, key, input);
  }
  @Post(':id/remove')
  remove(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.act(actor, id, 'remove');
  }
}
