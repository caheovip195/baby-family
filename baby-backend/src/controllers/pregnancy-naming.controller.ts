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
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { CreatePregnancyNameDto } from '../dto/pregnancy/naming.dto';
import { PREGNANCY_NAMING_SERVICE } from '../interfaces/services/pregnancy-naming-service.interface';
import type { IPregnancyNamingService } from '../interfaces/services/pregnancy-naming-service.interface';

@ApiTags('Pregnancy names')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class PregnancyNamingController {
  constructor(
    @Inject(PREGNANCY_NAMING_SERVICE)
    private readonly service: IPregnancyNamingService,
  ) {}

  @Get('pregnancies/:pregnancyId/names')
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('pregnancyId', new ParseUUIDPipe()) pregnancyId: string,
  ) {
    return this.service.list(actor, pregnancyId);
  }

  @Post('pregnancies/:pregnancyId/names')
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('pregnancyId', new ParseUUIDPipe()) pregnancyId: string,
    @Body() input: CreatePregnancyNameDto,
  ) {
    return this.service.create(actor, pregnancyId, input);
  }

  @Put('pregnancy-names/:nameId/like')
  like(
    @CurrentActor() actor: AuthPrincipal,
    @Param('nameId', new ParseUUIDPipe()) nameId: string,
  ) {
    return this.service.like(actor, nameId, true);
  }

  @Delete('pregnancy-names/:nameId/like')
  unlike(
    @CurrentActor() actor: AuthPrincipal,
    @Param('nameId', new ParseUUIDPipe()) nameId: string,
  ) {
    return this.service.like(actor, nameId, false);
  }

  @Post('pregnancy-names/:nameId/choose')
  @HttpCode(200)
  choose(
    @CurrentActor() actor: AuthPrincipal,
    @Param('nameId', new ParseUUIDPipe()) nameId: string,
  ) {
    return this.service.choose(actor, nameId, true);
  }

  @Delete('pregnancy-names/:nameId/choose')
  unchoose(
    @CurrentActor() actor: AuthPrincipal,
    @Param('nameId', new ParseUUIDPipe()) nameId: string,
  ) {
    return this.service.choose(actor, nameId, false);
  }

  @Delete('pregnancy-names/:nameId')
  @HttpCode(204)
  remove(
    @CurrentActor() actor: AuthPrincipal,
    @Param('nameId', new ParseUUIDPipe()) nameId: string,
  ) {
    return this.service.remove(actor, nameId);
  }
}
