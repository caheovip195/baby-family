import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Optional,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiHeader, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { OptionalIdempotencyKey } from '../common/http/offline-idempotency-key.decorator';
import { offlineCommand } from '../common/http/offline-command';
import { OFFLINE_COMMAND_SERVICE } from '../interfaces/services/offline-command-service.interface';
import type { IOfflineCommandService } from '../interfaces/services/offline-command-service.interface';
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
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}

  @Post('families/:familyId/mission-series')
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: CreateMissionSeriesDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    // Offline-first (BF-20261029-002): gửi lại cùng key không tạo chuỗi trùng.
    return offlineCommand(
      this.offline,
      key,
      {
        operation: 'mission.series.create',
        actor,
        familyId,
        body: input,
      },
      () => this.service.create(actor, familyId, input),
    );
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
