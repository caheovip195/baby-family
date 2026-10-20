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
  ) {}
  @Get('perspectives')
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('memoryId', new ParseUUIDPipe()) memoryId: string,
  ) {
    return this.service.list(actor, memoryId);
  }
  @Put('perspective')
  put(
    @CurrentActor() actor: AuthPrincipal,
    @Param('memoryId', new ParseUUIDPipe()) memoryId: string,
    @Body() input: PutPerspectiveContentDto,
  ) {
    return this.service.put(actor, memoryId, input);
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
