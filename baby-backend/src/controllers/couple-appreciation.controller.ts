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
  CreateAppreciationDto,
  AppreciationListQueryDto,
  ReactAppreciationDto,
  ShareRespondAppreciationDto,
} from '../dto/us/appreciation.dto';
import { COUPLE_APPRECIATION_SERVICE } from '../interfaces/services/couple-appreciation-service.interface';
import type { ICoupleAppreciationService } from '../interfaces/services/couple-appreciation-service.interface';

@ApiTags('Couple appreciations')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/us/appreciations')
export class CoupleAppreciationController {
  constructor(
    @Inject(COUPLE_APPRECIATION_SERVICE)
    private readonly service: ICoupleAppreciationService,
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
    @Body() input: CreateAppreciationDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      {
        operation: 'couple.appreciation.create',
        actor,
        familyId,
        body: input,
      },
      () => this.service.create(actor, familyId, input),
      () => this.service.list(actor, familyId, {}),
    );
  }

  @Get()
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: AppreciationListQueryDto,
  ) {
    return this.service.list(actor, familyId, query);
  }

  @Post(':id/react')
  @HttpCode(200)
  react(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: ReactAppreciationDto,
  ) {
    return this.service.react(actor, familyId, id, input);
  }

  @Post(':id/share-request')
  @HttpCode(200)
  requestShare(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.requestShare(actor, familyId, id);
  }

  @Post(':id/share-respond')
  @HttpCode(200)
  respondShare(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: ShareRespondAppreciationDto,
  ) {
    return this.service.respondShare(actor, familyId, id, input);
  }

  @Delete(':id')
  @HttpCode(204)
  delete(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.delete(actor, familyId, id);
  }
}
