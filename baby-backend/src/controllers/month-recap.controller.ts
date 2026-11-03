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
import { MonthRecapQueryDto } from '../dto/memory/month-recap.dto';
import { MONTH_RECAP_SERVICE } from '../interfaces/services/month-recap-service.interface';
import type { IMonthRecapService } from '../interfaces/services/month-recap-service.interface';

/** REC-03 Tổng kết tháng tuổi. */
@ApiTags('Recaps')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('children/:childId/month-recap')
export class MonthRecapController {
  constructor(
    @Inject(MONTH_RECAP_SERVICE)
    private readonly service: IMonthRecapService,
  ) {}

  @Get()
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
    @Query() query: MonthRecapQueryDto,
  ) {
    return this.service.get(actor, childId, query);
  }
}
