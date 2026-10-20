import {
  Controller,
  Get,
  Inject,
  Param,
  ParseUUIDPipe,
  UseGuards,
} from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../common/auth/access-token.guard';
import type { AuthPrincipal } from '../common/auth/auth-principal';
import { CurrentActor } from '../common/auth/current-actor.decorator';
import { MEMORY_CAPSULE_SERVICE } from '../interfaces/services/memory-capsule-service.interface';
import type { IMemoryCapsuleService } from '../interfaces/services/memory-capsule-service.interface';

@ApiTags('Memory letters')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('children/:id/letters')
export class MemoryLetterController {
  constructor(
    @Inject(MEMORY_CAPSULE_SERVICE)
    private readonly service: IMemoryCapsuleService,
  ) {}
  @Get()
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('id', new ParseUUIDPipe()) id: string,
  ) {
    return this.service.list(actor, id);
  }
}
