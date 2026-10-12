import { Inject, Injectable } from '@nestjs/common';
import { NotFoundError, ValidationError } from '../common/errors/domain.error';
import type {
  Paginated,
  PaginationInput,
} from '../common/pagination/pagination.types';
import type { CreateNoteDto } from '../dto/note/create-note.dto';
import type { UpdateNoteDto } from '../dto/note/update-note.dto';
import { NOTE_REPOSITORY } from '../interfaces/repositories/note-repository.interface';
import type { INoteRepository } from '../interfaces/repositories/note-repository.interface';
import type { INoteService } from '../interfaces/services/note-service.interface';
import type { Note } from '../models/note.model';

@Injectable()
export class NoteService implements INoteService {
  constructor(
    @Inject(NOTE_REPOSITORY) private readonly repository: INoteRepository,
  ) {}

  list(input: PaginationInput): Promise<Paginated<Note>> {
    return this.repository.list(input);
  }

  async getById(id: string): Promise<Note> {
    const note = await this.repository.findById(id);
    if (!note) throw new NotFoundError(`Note ${id} was not found.`);
    return note;
  }

  create(input: CreateNoteDto): Promise<Note> {
    return this.repository.create({
      ...input,
      title: this.normalizeTitle(input.title),
    });
  }

  async update(id: string, input: UpdateNoteDto): Promise<Note> {
    if (input.title === undefined && input.content === undefined) {
      throw new ValidationError('Provide at least one field to update.');
    }
    const data = { ...input };
    if (data.title !== undefined) data.title = this.normalizeTitle(data.title);
    const note = await this.repository.update(id, data);
    if (!note) throw new NotFoundError(`Note ${id} was not found.`);
    return note;
  }

  async remove(id: string): Promise<void> {
    if (!(await this.repository.remove(id))) {
      throw new NotFoundError(`Note ${id} was not found.`);
    }
  }

  private normalizeTitle(title: string): string {
    const normalized = title.trim();
    if (!normalized || normalized.length > 200) {
      throw new ValidationError(
        'Title must contain between 1 and 200 characters.',
      );
    }
    return normalized;
  }
}
