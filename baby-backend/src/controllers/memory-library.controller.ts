import { ApiHeader } from '@nestjs/swagger';
import { Optional } from '@nestjs/common';
import { OptionalIdempotencyKey } from '../common/http/offline-idempotency-key.decorator';
import { offlineCommand } from '../common/http/offline-command';
import { OFFLINE_COMMAND_SERVICE } from '../interfaces/services/offline-command-service.interface';
import type { IOfflineCommandService } from '../interfaces/services/offline-command-service.interface';
import {
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { LibraryQueryDto } from '../dto/memory-library/library-query.dto';
import { MEMORY_LIBRARY_SERVICE } from '../interfaces/services/memory-library-service.interface';
import type { IMemoryLibraryService } from '../interfaces/services/memory-library-service.interface';
@UseGuards(AccessTokenGuard)
@Controller()
export class MemoryLibraryController {
  constructor(
    @Inject(MEMORY_LIBRARY_SERVICE)
    private readonly service: IMemoryLibraryService,
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}
  @Put('memories/:id/favorite')
  @HttpCode(204)
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  favorite(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      { operation: 'memory.favorite.set', actor, memoryId: id },
      () => this.service.favorite(actor, id, true),
    );
  }
  @Delete('memories/:id/favorite')
  @HttpCode(204)
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  unfavorite(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      { operation: 'memory.favorite.clear', actor, memoryId: id },
      () => this.service.favorite(actor, id, false),
    );
  }
  @Get('families/:fid/favorites')
  favorites(
    @CurrentActor() actor: AuthPrincipal,
    @Param('fid', new ParseUUIDPipe()) fid: string,
    @Query() query: LibraryQueryDto,
  ) {
    return this.service.favorites(actor, fid, query);
  }
  @Post('memories/:id/download-urls')
  @HttpCode(200)
  download(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.download(actor, id);
  }
}
