import type {
  Paginated,
  PaginationInput,
} from '../../common/pagination/pagination.types';
import type { CreateNoteDto } from '../../dto/note/create-note.dto';
import type { UpdateNoteDto } from '../../dto/note/update-note.dto';
import type { Note } from '../../models/note.model';

export const NOTE_REPOSITORY = Symbol('NOTE_REPOSITORY');

export interface INoteRepository {
  list(input: PaginationInput): Promise<Paginated<Note>>;
  findById(id: string): Promise<Note | null>;
  create(input: CreateNoteDto): Promise<Note>;
  update(id: string, input: UpdateNoteDto): Promise<Note | null>;
  remove(id: string): Promise<boolean>;
}
