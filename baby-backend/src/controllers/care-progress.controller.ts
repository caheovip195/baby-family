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
import { HeartsMeQueryDto } from '../dto/care/hearts-me.dto';
import { CareMissionHistoryQueryDto } from '../dto/care/care-mission-history.dto';
import { CARE_PROGRESS_SERVICE } from '../interfaces/services/care-progress-service.interface';
import type { ICareProgressService } from '../interfaces/services/care-progress-service.interface';

@ApiTags('Care progress')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId')
export class CareProgressController {
  constructor(
    @Inject(CARE_PROGRESS_SERVICE)
    private readonly service: ICareProgressService,
  ) {}

  @Get('hearts/me')
  getHeartsMe(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: HeartsMeQueryDto,
  ) {
    return this.service.getHeartsMe(actor, familyId, query);
  }

  @Get('family-tree')
  getFamilyTree(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.getFamilyTree(actor, familyId);
  }

  @Get('badges')
  getBadges(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.getBadges(actor, familyId);
  }

  @Get('missions')
  getMissionHistory(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: CareMissionHistoryQueryDto,
  ) {
    return this.service.getMissionHistory(actor, familyId, query);
  }
}
