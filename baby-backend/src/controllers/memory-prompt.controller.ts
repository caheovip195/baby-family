import {
  Body,
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
import { MemoryPromptSubjectDto } from '../dto/memory-library/memory-prompt.dto';
import { MEMORY_PROMPT_SERVICE } from '../interfaces/services/memory-prompt-service.interface';
import type { IMemoryPromptService } from '../interfaces/services/memory-prompt-service.interface';
@ApiTags('Memory prompts')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller()
export class MemoryPromptController {
  constructor(
    @Inject(MEMORY_PROMPT_SERVICE)
    private readonly service: IMemoryPromptService,
  ) {}
  @Get('families/:familyId/memory-prompts')
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', new ParseUUIDPipe()) familyId: string,
    @Query() input: MemoryPromptSubjectDto,
  ) {
    return this.service.list(actor, familyId, input);
  }
  @Post('memory-prompts/:code/dismiss')
  dismiss(
    @CurrentActor() actor: AuthPrincipal,
    @Param('code') code: string,
    @Body() input: MemoryPromptSubjectDto,
  ) {
    return this.service.dismiss(actor, code, input);
  }
}
