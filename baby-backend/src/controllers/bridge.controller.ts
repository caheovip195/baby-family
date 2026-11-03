import {
  Body,
  Controller,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { IdempotencyKey } from '../common/http/idempotency-key.decorator';
import {
  BridgeNextStepInputDto,
  BridgeSessionDto,
  ClarifyBridgeDto,
  CreateBridgeDto,
} from '../dto/us/bridge.dto';
import { BRIDGE_SERVICE } from '../interfaces/services/bridge-service.interface';
import type {
  BridgeAction,
  IBridgeService,
} from '../interfaces/services/bridge-service.interface';

/** US-08…12 Cầu nối khi bất đồng (7.17, BF-20261028-008). */
@ApiTags('Papa & Mama')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/us/bridges')
export class BridgeController {
  constructor(
    @Inject(BRIDGE_SERVICE)
    private readonly service: IBridgeService,
  ) {}

  /** Gửi lời mời (hoặc góp ý của mình vào phiên bạn đời đã mời). */
  @Post()
  @ApiOkResponse({ type: BridgeSessionDto })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @IdempotencyKey() key: string,
    @Body() input: CreateBridgeDto,
  ) {
    return this.service.create(actor, familyId, key, input);
  }

  @Get()
  @ApiOkResponse({ type: BridgeSessionDto, isArray: true })
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
  ) {
    return this.service.list(actor, familyId);
  }

  @Get(':sessionId')
  @ApiOkResponse({ type: BridgeSessionDto })
  get(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
  ) {
    return this.service.get(actor, familyId, sessionId);
  }

  /** Bạn đời tham gia (lời mời đang chờ / tạm dừng). */
  @Post(':sessionId/join')
  @HttpCode(200)
  @ApiOkResponse({ type: BridgeSessionDto })
  join(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
  ) {
    return this.act(actor, familyId, sessionId, 'join');
  }

  /** Tạm dừng — ai cũng được, không báo gì tiêu cực. */
  @Post(':sessionId/pause')
  @HttpCode(200)
  @ApiOkResponse({ type: BridgeSessionDto })
  pause(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
  ) {
    return this.act(actor, familyId, sessionId, 'pause');
  }

  /** “Mình hiểu”. */
  @Post(':sessionId/understood')
  @HttpCode(200)
  @ApiOkResponse({ type: BridgeSessionDto })
  understood(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
  ) {
    return this.act(actor, familyId, sessionId, 'understood');
  }

  /** Đồng ý bước tiếp theo. */
  @Post(':sessionId/confirm')
  @HttpCode(200)
  @ApiOkResponse({ type: BridgeSessionDto })
  confirm(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
  ) {
    return this.act(actor, familyId, sessionId, 'confirm');
  }

  /** Đồng ý đóng phiên (cả hai → CLOSED). */
  @Post(':sessionId/close')
  @HttpCode(200)
  @ApiOkResponse({ type: BridgeSessionDto })
  close(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
  ) {
    return this.act(actor, familyId, sessionId, 'close');
  }

  private act(
    actor: AuthPrincipal,
    familyId: string,
    sessionId: string,
    action: BridgeAction,
  ) {
    return this.service.act(actor, familyId, sessionId, action);
  }

  @Post(':sessionId/clarify')
  @HttpCode(200)
  @ApiOkResponse({ type: BridgeSessionDto })
  clarify(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
    @Body() input: ClarifyBridgeDto,
  ) {
    return this.service.clarify(actor, familyId, sessionId, input);
  }

  @Put(':sessionId/next-step')
  @ApiOkResponse({ type: BridgeSessionDto })
  nextStep(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('sessionId', ParseUUIDPipe) sessionId: string,
    @Body() input: BridgeNextStepInputDto,
  ) {
    return this.service.nextStep(actor, familyId, sessionId, input);
  }
}
