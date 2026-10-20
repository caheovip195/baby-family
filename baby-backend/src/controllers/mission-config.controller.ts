import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  UpdateMissionFamilySettingsDto,
  UpdateMissionPreferencesDto,
} from '../dto/mission/mission-config.dto';
import { MISSION_CONFIG_SERVICE } from '../interfaces/services/mission-config-service.interface';
import type { IMissionConfigService } from '../interfaces/services/mission-config-service.interface';

/** CARE-12 mission settings (BF-20261019-003). */
@ApiTags('Daily missions')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId')
export class MissionConfigController {
  constructor(
    @Inject(MISSION_CONFIG_SERVICE)
    private readonly service: IMissionConfigService,
  ) {}

  @Get('mission-settings')
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.get(actor, familyId);
  }

  @Patch('mission-settings')
  updateFamily(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: UpdateMissionFamilySettingsDto,
  ) {
    return this.service.updateFamily(actor, familyId, input);
  }

  @Patch('mission-preferences')
  updateMine(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: UpdateMissionPreferencesDto,
  ) {
    return this.service.updateMine(actor, familyId, input);
  }
}
