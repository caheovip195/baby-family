import { Optional } from '@nestjs/common';
import { ApiHeader } from '@nestjs/swagger';
import { offlineCommand } from '../common/http/offline-command';
import { OFFLINE_COMMAND_SERVICE } from '../interfaces/services/offline-command-service.interface';
import type { IOfflineCommandService } from '../interfaces/services/offline-command-service.interface';
import type { ArgumentsHost, ExceptionFilter } from '@nestjs/common';
import type { Request, Response } from 'express';
import { CoupleRequestResendBlockedError } from '../models/couple-request-resend-blocked.model';
import {
  Body,
  Catch,
  UseFilters,
  Controller,
  Get,
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
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import {
  CreateRequestDto,
  RequestAcknowledgeDto,
  RequestDeclineDto,
  RequestListQueryDto,
  RequestReminderDto,
} from '../dto/us/request.dto';
import { COUPLE_REQUEST_SERVICE } from '../interfaces/services/couple-request-service.interface';
import type { ICoupleRequestService } from '../interfaces/services/couple-request-service.interface';
/** Preserve the documented retry deadline without changing the shared HTTP filter. */
@Catch(CoupleRequestResendBlockedError)
class RequestResendBlockedFilter implements ExceptionFilter {
  catch(error: CoupleRequestResendBlockedError, host: ArgumentsHost): void {
    const context = host.switchToHttp();
    const request = context.getRequest<Request & { id?: string }>();
    context
      .getResponse<Response>()
      .status(error.statusCode)
      .json({
        error: {
          code: error.code,
          message: error.message,
          details: { retryAfter: error.retryAfter },
        },
        requestId: request.id,
        path: request.path,
        timestamp: new Date().toISOString(),
      });
  }
}
@ApiTags('Couple requests')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@UseFilters(RequestResendBlockedFilter)
@Controller('families/:familyId/us/requests')
export class CoupleRequestController {
  constructor(
    @Inject(COUPLE_REQUEST_SERVICE)
    private readonly service: ICoupleRequestService,
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}
  @Post()
  @ApiHeader({
    name: 'Idempotency-Key',
    required: true,
    description: 'UUID; replay returns the original response.',
  })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: CreateRequestDto,
    @IdempotencyKey() key: string,
  ) {
    // The native transactional ledger remains safe while the new provider is staged.
    if (!this.offline) return this.service.create(actor, familyId, input, key);
    return offlineCommand(
      this.offline,
      key,
      { operation: 'couple.request.create', actor, familyId, body: input },
      () => this.service.create(actor, familyId, input, key),
      () => this.service.list(actor, familyId, {}),
    );
  }
  @Get()
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: RequestListQueryDto,
  ) {
    return this.service.list(actor, familyId, query);
  }
  @Get(':id')
  find(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.find(actor, familyId, id);
  }
  @Post(':id/seen')
  seen(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.act(actor, familyId, id, 'seen');
  }
  @Post(':id/accept')
  accept(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.act(actor, familyId, id, 'accept');
  }
  @Post(':id/decline')
  decline(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: RequestDeclineDto,
  ) {
    return this.service.act(actor, familyId, id, 'decline', input);
  }
  @Post(':id/acknowledge')
  acknowledge(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: RequestAcknowledgeDto,
  ) {
    return this.service.act(actor, familyId, id, 'acknowledge', input);
  }
  @Post(':id/done')
  done(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.act(actor, familyId, id, 'done');
  }
  @Post(':id/remind-me')
  remind_me(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: RequestReminderDto,
  ) {
    return this.service.act(actor, familyId, id, 'remind-me', input);
  }
  @Post(':id/cancel')
  cancel(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.act(actor, familyId, id, 'cancel');
  }
}
