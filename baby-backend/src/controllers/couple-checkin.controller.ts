import { ApiHeader } from '@nestjs/swagger';
import { Optional } from '@nestjs/common';
import { OptionalIdempotencyKey } from '../common/http/offline-idempotency-key.decorator';
import { offlineCommand } from '../common/http/offline-command';
import { OFFLINE_COMMAND_SERVICE } from '../interfaces/services/offline-command-service.interface';
import type { IOfflineCommandService } from '../interfaces/services/offline-command-service.interface';
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
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}
  @Post()
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: CreateCheckinDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      {
        operation: 'couple.checkin.create',
        actor,
        familyId,
        body: input,
      },
      () => this.service.create(actor, familyId, input),
      () => this.service.today(actor, familyId),
    );
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
