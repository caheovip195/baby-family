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
import {
  MilestoneCatalogQueryDto,
  MilestoneListQueryDto,
} from '../dto/milestone/milestone-query.dto';
import { MILESTONE_CATALOG_SERVICE } from '../interfaces/services/milestone-catalog-service.interface';
import type { IMilestoneCatalogService } from '../interfaces/services/milestone-catalog-service.interface';
@ApiTags('Milestones')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class MilestoneController {
  constructor(
    @Inject(MILESTONE_CATALOG_SERVICE)
    private readonly service: IMilestoneCatalogService,
  ) {}
  @Get('milestone-templates')
  catalog(
    @CurrentActor() actor: AuthPrincipal,
    @Query() query: MilestoneCatalogQueryDto,
  ) {
    return this.service.catalog(actor, query);
  }
  @Get('children/:id/milestones')
  child(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query() query: MilestoneListQueryDto,
  ) {
    return this.service.list(actor, id, false, query);
  }
  @Get('pregnancies/:id/milestones')
  pregnancy(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query() query: MilestoneListQueryDto,
  ) {
    return this.service.list(actor, id, true, query);
  }
}
