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
  Put,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { PutPerspectiveContentDto } from '../dto/memory-library/perspective-content.dto';
import { MEMORY_PERSPECTIVE_CONTENT_SERVICE } from '../interfaces/services/memory-perspective-content-service.interface';
import type { IMemoryPerspectiveContentService } from '../interfaces/services/memory-perspective-content-service.interface';
@ApiTags('Memory perspectives')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('memories/:memoryId')
export class MemoryPerspectiveContentController {
  constructor(
    @Inject(MEMORY_PERSPECTIVE_CONTENT_SERVICE)
    private readonly service: IMemoryPerspectiveContentService,
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}
  @Get('perspectives')
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('memoryId', new ParseUUIDPipe()) memoryId: string,
  ) {
    return this.service.list(actor, memoryId);
  }
  @Put('perspective')
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  put(
    @CurrentActor() actor: AuthPrincipal,
    @Param('memoryId', new ParseUUIDPipe()) memoryId: string,
    @Body() input: PutPerspectiveContentDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      {
        operation: 'memory.perspective.put',
        parentOnly: true,
        actor,
        memoryId,
        body: input,
      },
      () => this.service.put(actor, memoryId, input),
      () => this.service.list(actor, memoryId),
    );
  }
  @Delete('perspective')
  @HttpCode(204)
  remove(
    @CurrentActor() actor: AuthPrincipal,
    @Param('memoryId', new ParseUUIDPipe()) memoryId: string,
  ) {
    return this.service.remove(actor, memoryId);
  }
}
