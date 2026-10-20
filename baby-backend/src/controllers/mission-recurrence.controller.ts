import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CreateMissionSeriesDto,
  PauseMissionSeriesDto,
} from '../dto/mission/mission-recurrence.dto';
import { MISSION_RECURRENCE_SERVICE } from '../interfaces/services/mission-recurrence-service.interface';
import type { IMissionRecurrenceService } from '../interfaces/services/mission-recurrence-service.interface';

/** Custom repeating missions (spec §7.13.6, BF-20261019-003). */
@ApiTags('Daily missions')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class MissionRecurrenceController {
  constructor(
    @Inject(MISSION_RECURRENCE_SERVICE)
    private readonly service: IMissionRecurrenceService,
  ) {}

  @Post('families/:familyId/mission-series')
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: CreateMissionSeriesDto,
  ) {
    return this.service.create(actor, familyId, input);
  }

  @Get('families/:familyId/mission-series')
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.list(actor, familyId);
  }

  @Post('mission-series/:id/pause')
  @HttpCode(200)
  pause(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: PauseMissionSeriesDto,
  ) {
    return this.service.pause(actor, id, input);
  }

  @Delete('mission-series/:id')
  @HttpCode(204)
  end(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.end(actor, id);
  }
}
