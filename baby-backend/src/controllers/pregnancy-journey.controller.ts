import {
  Controller,
  Get,
  Headers,
  Inject,
  Param,
  ParseUUIDPipe,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import {
  JourneyQueryDto,
  JourneyMemoriesQueryDto,
} from '../dto/pregnancy/journey-query.dto';
import { PREGNANCY_JOURNEY_SERVICE } from '../interfaces/services/pregnancy-journey-service.interface';
import type { IPregnancyJourneyService } from '../interfaces/services/pregnancy-journey-service.interface';
@ApiTags('Pregnancy')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('pregnancies/:id')
export class PregnancyJourneyController {
  constructor(
    @Inject(PREGNANCY_JOURNEY_SERVICE)
    private readonly service: IPregnancyJourneyService,
  ) {}
  @Get('journey') journey(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query() query: JourneyQueryDto,
    @Headers('accept-language') language?: string,
  ) {
    return this.service.journey(actor, id, query, language);
  }
  @Get('memories') memories(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query() query: JourneyMemoriesQueryDto,
  ) {
    return this.service.memories(actor, id, query);
  }
}
