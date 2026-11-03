import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  ShareWeeklyRecapDto,
  WeeklyRecapQueryDto,
} from '../dto/recap/weekly-recap.dto';
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
  /** REC-02 chia sẻ với người thân (BF-20261030-004). */
  @Put('recaps/weekly/:id/share') share(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: ShareWeeklyRecapDto,
  ) {
    return this.service.share(actor, fid, id, input.shared);
  }
  /** REC-02 lưu vào timeline: một ký ức mỗi recap, gọi lại trả ký ức cũ. */
  @Post('recaps/weekly/:id/timeline')
  @HttpCode(200)
  saveToTimeline(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.saveToTimeline(actor, fid, id);
  }
  @Get('home/week-stats') stats(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', ParseUUIDPipe) fid: string,
  ) {
    return this.service.stats(actor, fid);
  }
}
