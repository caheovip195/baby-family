import {
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { WeeklyRecapQueryDto } from '../dto/recap/weekly-recap.dto';
import {
  WEEKLY_RECAP_SERVICE,
  type IWeeklyRecapService,
} from '../interfaces/services/weekly-recap-service.interface';
@UseGuards(AccessTokenGuard)
@Controller('families/:fid')
export class WeeklyRecapController {
  constructor(
    @Inject(WEEKLY_RECAP_SERVICE) private readonly service: IWeeklyRecapService,
  ) {}
  @Get('recaps/weekly/latest') latest(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
  ) {
    return this.service.latest(actor, fid);
  }
  @Get('recaps/weekly') list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
    @Query() query: WeeklyRecapQueryDto,
  ) {
    return this.service.list(actor, fid, query);
  }
  @Get('home/week-stats') stats(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
  ) {
    return this.service.stats(actor, fid);
  }
}
