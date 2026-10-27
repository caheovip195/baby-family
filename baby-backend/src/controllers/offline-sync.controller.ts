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
import { RawResponse } from '../common/http/response-envelope.interceptor';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { ChangesQueryDto } from '../dto/offline-sync/changes-query.dto';
import {
  OFFLINE_SYNC_SERVICE,
  type IOfflineSyncService,
} from '../interfaces/services/offline-sync-service.interface';
@RawResponse()
@ApiTags('Offline sync')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/changes')
export class OfflineSyncController {
  constructor(
    @Inject(OFFLINE_SYNC_SERVICE) private readonly service: IOfflineSyncService,
  ) {}
  @Get()
  changes(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() query: ChangesQueryDto,
  ) {
    return this.service.changes(actor, familyId, query);
  }
}
