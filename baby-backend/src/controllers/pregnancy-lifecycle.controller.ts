import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { PaginationQueryDto } from '../dto/common/pagination-query.dto';
import { LifecycleArchivePregnancyDto } from '../dto/pregnancy/lifecycle-pregnancy.dto';
import {
  PregnancyPageDto,
  PregnancyResponseDto,
} from '../dto/pregnancy/pregnancy-response.dto';
import { PREGNANCY_LIFECYCLE_SERVICE } from '../interfaces/services/pregnancy-lifecycle-service.interface';
import type { IPregnancyLifecycleService } from '../interfaces/services/pregnancy-lifecycle-service.interface';

@ApiTags('Pregnancy')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class PregnancyLifecycleController {
  constructor(
    @Inject(PREGNANCY_LIFECYCLE_SERVICE)
    private readonly service: IPregnancyLifecycleService,
  ) {}

  @Post('pregnancies/:id/archive')
  @HttpCode(200)
  @ApiOkResponse({ type: PregnancyResponseDto })
  archive(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: LifecycleArchivePregnancyDto,
  ) {
    return this.service.archive(actor, id, input);
  }

  @Post('pregnancies/:id/restore')
  @HttpCode(200)
  @ApiOkResponse({ type: PregnancyResponseDto })
  restore(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.restore(actor, id);
  }

  // Distinct route avoids shadowing the existing PregnancyController.list.
  // Its status=archived query must be delegated here by that controller when
  // its owner integrates the lifecycle service.
  @Get('families/:familyId/pregnancies/archived')
  @ApiOkResponse({ type: PregnancyPageDto })
  listArchived(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: PaginationQueryDto,
  ) {
    return this.service.listArchived(actor, familyId, query);
  }
}
