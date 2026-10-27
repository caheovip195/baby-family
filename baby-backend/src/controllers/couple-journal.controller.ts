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
  CreateJournalEntryDto,
  UpdateJournalEntryDto,
  JournalListQueryDto,
  ShareJournalExcerptDto,
} from '../dto/us/journal.dto';
import { COUPLE_JOURNAL_SERVICE } from '../interfaces/services/couple-journal-service.interface';
import type { ICoupleJournalService } from '../interfaces/services/couple-journal-service.interface';

@ApiTags('Couple journal')
@ApiBearerAuth()
@UseGuards(AccessTokenGuard)
@Controller('families/:familyId/us/journal')
export class CoupleJournalController {
  constructor(
    @Inject(COUPLE_JOURNAL_SERVICE)
    private readonly service: ICoupleJournalService,
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}

  @Post()
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  create(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Body() input: CreateJournalEntryDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      {
        operation: 'couple.journal.create',
        actor,
        familyId,
        body: input,
      },
      () => this.service.create(actor, familyId, input),
      () => this.service.list(actor, familyId, {}),
    );
  }

  @Get()
  list(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Query() query: JournalListQueryDto,
  ) {
    return this.service.list(actor, familyId, query);
  }

  @Get(':id')
  findById(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.findById(actor, familyId, id);
  }

  @Patch(':id')
  update(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: UpdateJournalEntryDto,
  ) {
    return this.service.update(actor, familyId, id, input);
  }

  @Delete(':id')
  @HttpCode(204)
  delete(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.service.delete(actor, familyId, id);
  }

  @Post(':id/share')
  share(
    @CurrentActor() actor: AuthPrincipal,
    @Param('familyId', ParseUUIDPipe) familyId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() input: ShareJournalExcerptDto,
  ) {
    return this.service.share(actor, familyId, id, input);
  }
}
