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
  constructor(@Inject(NOTE_SERVICE) private readonly service: INoteService) {}
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
  create(@Body() input: CreateNoteDto) {
    return this.service.create(input);
  }
  @Patch(':id')
  @ApiOkResponse({ type: NoteResponseDto })
  @ApiNotFoundResponse()
  update(
    @Param('id', new ParseUUIDPipe({ version: '4' })) id: string,
    @Body() input: UpdateNoteDto,
  ) {
    return this.service.update(id, input);
  }
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  @ApiNotFoundResponse()
  remove(@Param('id', new ParseUUIDPipe({ version: '4' })) id: string) {
    return this.service.remove(id);
  }
}
