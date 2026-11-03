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
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import {
  CreateHandoffDto,
  HandoffDto,
  HandoffListQueryDto,
} from '../dto/us/handoff.dto';
import { HANDOFF_SERVICE } from '../interfaces/services/handoff-service.interface';
import type { IHandoffService } from '../interfaces/services/handoff-service.interface';

/** Bàn giao ca giữa hai Parent (7.13.8, BF-20261028-007). */
@ApiTags('Papa & Mama')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/us/handoffs')
export class HandoffController {
  constructor(
    @Inject(HANDOFF_SERVICE)
    private readonly service: IHandoffService,
  ) {}

  @Post()
  @ApiOkResponse({ type: HandoffDto })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @IdempotencyKey() key: string,
    @Body() input: CreateHandoffDto,
  ) {
    return this.service.create(actor, familyId, key, input);
  }

  @Get()
  @ApiOkResponse({ type: HandoffDto, isArray: true })
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: HandoffListQueryDto,
  ) {
    return this.service.list(actor, familyId, query);
  }

  @Post(':handoffId/acknowledge')
  @HttpCode(200)
  @ApiOkResponse({ type: HandoffDto })
  acknowledge(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('handoffId', ParseUUIDPipe) handoffId: string,
  ) {
    return this.service.acknowledge(actor, familyId, handoffId);
  }
}
