import {
  Body,
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { PaginationQueryDto } from '../dto/common/pagination-query.dto';
import { UpdatePregnancyDto } from '../dto/pregnancy/update-pregnancy.dto';
import { CreatePregnancyDto } from '../dto/pregnancy/create-pregnancy.dto';
import {
  PregnancyResponseDto,
  PregnancyPageDto,
} from '../dto/pregnancy/pregnancy-response.dto';
import { PREGNANCY_SERVICE } from '../interfaces/services/pregnancy-service.interface';
import type { IPregnancyService } from '../interfaces/services/pregnancy-service.interface';

@ApiTags('Pregnancy')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/pregnancies')
export class PregnancyController {
  constructor(
    @Inject(PREGNANCY_SERVICE) private readonly service: IPregnancyService,
  ) {}

  @Post()
  @ApiCreatedResponse({ type: PregnancyResponseDto })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: CreatePregnancyDto,
  ) {
    return this.service.create(actor, familyId, input);
  }

  @Get()
  @ApiOkResponse({ type: PregnancyPageDto })
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: PaginationQueryDto,
  ) {
    return this.service.list(actor, familyId, query);
  }

  @Get(':id')
  @ApiOkResponse({ type: PregnancyResponseDto })
  getById(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.getById(actor, familyId, id);
  }

  @Patch(':id')
  @ApiOkResponse({ type: PregnancyResponseDto })
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: UpdatePregnancyDto,
  ) {
    return this.service.update(actor, familyId, id, input);
  }
}
