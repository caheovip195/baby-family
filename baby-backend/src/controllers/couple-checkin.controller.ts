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
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  CreateCheckinDto,
  CheckinHistoryQueryDto,
  CreateCheckinResponseDto,
} from '../dto/us/checkin.dto';
import { COUPLE_CHECKIN_SERVICE } from '../interfaces/services/couple-checkin-service.interface';
import type { ICoupleCheckinService } from '../interfaces/services/couple-checkin-service.interface';
@ApiTags('Couple check-ins')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/us/checkins')
export class CoupleCheckinController {
  constructor(
    @Inject(COUPLE_CHECKIN_SERVICE)
    private readonly service: ICoupleCheckinService,
  ) {}
  @Post()
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: CreateCheckinDto,
  ) {
    return this.service.create(actor, familyId, input);
  }
  @Get('today')
  today(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.today(actor, familyId);
  }
  @Get()
  history(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: CheckinHistoryQueryDto,
  ) {
    return this.service.history(actor, familyId, query);
  }
  @Post(':id/responses')
  respond(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: CreateCheckinResponseDto,
  ) {
    return this.service.respond(actor, familyId, id, input);
  }
  @Delete()
  @HttpCode(204)
  deleteHistory(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.deleteHistory(actor, familyId);
  }
}
