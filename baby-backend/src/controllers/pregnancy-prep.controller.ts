import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CreatePregnancyPrepDto,
  UpdatePregnancyPrepDto,
} from '../dto/pregnancy/prep.dto';
import { PREGNANCY_PREP_SERVICE } from '../interfaces/services/pregnancy-prep-service.interface';
import type { IPregnancyPrepService } from '../interfaces/services/pregnancy-prep-service.interface';

@ApiTags('Pregnancy preparation')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class PregnancyPrepController {
  constructor(
    @Inject(PREGNANCY_PREP_SERVICE)
    private readonly service: IPregnancyPrepService,
  ) {}
  @Get('pregnancies/:id/prep-items')
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.list(actor, id);
  }
  @Post('pregnancies/:id/prep-items')
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: CreatePregnancyPrepDto,
  ) {
    return this.service.create(actor, id, input);
  }
  @Patch('prep-items/:id')
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: UpdatePregnancyPrepDto,
  ) {
    return this.service.update(actor, id, input);
  }
  @Delete('prep-items/:id')
  @HttpCode(204)
  remove(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.remove(actor, id);
  }
}
