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
  GrowthEntryDto,
  GrowthListDto,
  UpsertGrowthDto,
} from '../dto/growth/growth.dto';
import { GROWTH_SERVICE } from '../interfaces/services/growth-service.interface';
import type { IGrowthService } from '../interfaces/services/growth-service.interface';

/** CHD-06 Tăng trưởng (BF-20261028-004). */
@ApiTags('Children')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('children/:childId/growth')
export class GrowthController {
  constructor(
    @Inject(GROWTH_SERVICE)
    private readonly service: IGrowthService,
  ) {}

  @Get()
  @ApiOkResponse({ type: GrowthListDto })
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
  ) {
    return this.service.list(actor, childId);
  }

  @Put(':date')
  @ApiOkResponse({ type: GrowthEntryDto })
  upsert(
    @CurrentActor() actor: AuthPrincipal,
    @Param('childId', ParseUUIDPipe) childId: string,
    @Param('date') date: string,
    @Body() input: UpsertGrowthDto,
  ) {
    return this.service.upsert(actor, childId, date, input);
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
