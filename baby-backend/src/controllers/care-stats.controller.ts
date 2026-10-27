import {
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { CareStatsQueryDto } from '../dto/care/care-stats.dto';
import {
  CARE_STATS_SERVICE,
  type ICareStatsService,
} from '../interfaces/services/care-stats-service.interface';

@ApiTags('Care statistics')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/care-stats')
export class CareStatsController {
  constructor(
    @Inject(CARE_STATS_SERVICE)
    private readonly service: ICareStatsService,
  ) {}

  @Get()
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: CareStatsQueryDto,
  ) {
    return this.service.get(actor, familyId, query);
  }
}
