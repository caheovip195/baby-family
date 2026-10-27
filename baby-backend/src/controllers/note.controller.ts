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
  HttpStatus,
  Inject,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { PaginationQueryDto } from '../dto/common/pagination-query.dto';
import { NOTE_SERVICE } from '../interfaces/services/note-service.interface';
import type { INoteService } from '../interfaces/services/note-service.interface';
import { CreateNoteDto } from '../dto/note/create-note.dto';
import { UpdateNoteDto } from '../dto/note/update-note.dto';
import { NotePageDto, NoteResponseDto } from '../dto/note/note-response.dto';
import { RawResponse } from '../common/http/response-envelope.interceptor';

@ApiTags('Notes (example)')
@RawResponse()
@Controller('notes')
export class NoteController {
  constructor(
    @Inject(NOTE_SERVICE) private readonly service: INoteService,
    @Optional()
    @Inject(OFFLINE_COMMAND_SERVICE)
    private readonly offline?: IOfflineCommandService,
  ) {}
  @Get()
  @ApiOkResponse({ type: NotePageDto })
  list(@Query() query: PaginationQueryDto) {
    return this.service.list(query);
  }
  @Get(':id')
  @ApiOkResponse({ type: NoteResponseDto })
  @ApiNotFoundResponse()
  getById(@Param('id', new ParseUUIDPipe({ version: '4' })) id: string) {
    return this.service.getById(id);
  }
  @Post()
  @ApiCreatedResponse({ type: NoteResponseDto })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  create(@Body() input: CreateNoteDto, @OptionalIdempotencyKey() key?: string) {
    return offlineCommand(
      this.offline,
      key,
      { operation: 'note.create', body: input },
      () => this.service.create(input),
    );
  }
  @Patch(':id')
  @ApiOkResponse({ type: NoteResponseDto })
  @ApiNotFoundResponse()
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  update(
    @Param('id', new ParseUUIDPipe({ version: '4' })) id: string,
    @Body() input: UpdateNoteDto,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      { operation: 'note.update', resourceId: id, body: input },
      () => this.service.update(id, input),
    );
  }
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  @ApiNotFoundResponse()
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Optional UUID; replay returns the original response.',
  })
  remove(
    @Param('id', new ParseUUIDPipe({ version: '4' })) id: string,
    @OptionalIdempotencyKey() key?: string,
  ) {
    return offlineCommand(
      this.offline,
      key,
      { operation: 'note.remove', resourceId: id },
      () => this.service.remove(id),
    );
  }
}
