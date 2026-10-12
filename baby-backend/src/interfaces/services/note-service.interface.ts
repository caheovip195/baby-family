import type {
  Paginated,
  PaginationInput,
} from '../../common/pagination/pagination.types';
import type { CreateNoteDto } from '../../dto/note/create-note.dto';
import type { UpdateNoteDto } from '../../dto/note/update-note.dto';
import type { Note } from '../../models/note.model';

export const NOTE_SERVICE = Symbol('NOTE_SERVICE');

export interface INoteService {
  list(input: PaginationInput): Promise<Paginated<Note>>;
  getById(id: string): Promise<Note>;
  create(input: CreateNoteDto): Promise<Note>;
  update(id: string, input: UpdateNoteDto): Promise<Note>;
  remove(id: string): Promise<void>;
}
