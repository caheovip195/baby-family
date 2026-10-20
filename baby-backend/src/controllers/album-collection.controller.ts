import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import {
  AddAlbumMemoriesDto,
  AlbumMemoriesQueryDto,
  CreateAlbumDto,
  UpdateAlbumDto,
} from '../dto/album/album-collection.dto';
import { ALBUM_COLLECTION_SERVICE } from '../interfaces/services/album-collection-service.interface';
import type { IAlbumCollectionService } from '../interfaces/services/album-collection-service.interface';

@ApiTags('Albums')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class AlbumCollectionController {
  constructor(
    @Inject(ALBUM_COLLECTION_SERVICE)
    private readonly service: IAlbumCollectionService,
  ) {}
  @Get('families/:familyId/albums')
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
  ) {
    return this.service.list(actor, familyId);
  }
  @Post('families/:familyId/albums')
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Body() input: CreateAlbumDto,
  ) {
    return this.service.create(actor, familyId, input);
  }
  @Patch('albums/:id')
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: UpdateAlbumDto,
  ) {
    return this.service.update(actor, id, input);
  }
  @Delete('albums/:id')
  @HttpCode(204)
  remove(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.remove(actor, id);
  }
  @Get('albums/:id/memories')
  memories(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Query() query: AlbumMemoriesQueryDto,
  ) {
    return this.service.memories(actor, id, query);
  }
  @Post('albums/:id/memories')
  @HttpCode(204)
  addMemories(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() input: AddAlbumMemoriesDto,
  ) {
    return this.service.addMemories(actor, id, input);
  }
  @Delete('albums/:id/memories/:memoryId')
  @HttpCode(204)
  removeMemory(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('memoryId', new ParseUUIDPipe()) memoryId: string,
  ) {
    return this.service.removeMemory(actor, id, memoryId);
  }
}
