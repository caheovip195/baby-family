import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../database/prisma.service';
import { paginate } from '../common/pagination/pagination';
import type {
  Paginated,
  PaginationInput,
} from '../common/pagination/pagination.types';
import type { CreateNoteDto } from '../dto/note/create-note.dto';
import type { UpdateNoteDto } from '../dto/note/update-note.dto';
import type { INoteRepository } from '../interfaces/repositories/note-repository.interface';
import { Note } from '../models/note.model';

@Injectable()
export class NoteRepository implements INoteRepository {
  constructor(private readonly prisma: PrismaService) {}

  async list(input: PaginationInput): Promise<Paginated<Note>> {
    const [rows, total] = await this.prisma.$transaction(
      [
        this.prisma.note.findMany({
          where: { deletedAt: null },
          skip: (input.page - 1) * input.limit,
          take: input.limit,
          orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
        }),
        this.prisma.note.count({ where: { deletedAt: null } }),
      ],
      { isolationLevel: Prisma.TransactionIsolationLevel.RepeatableRead },
    );
    return paginate(
      rows.map((row) => new Note(row)),
      total,
      input,
    );
  }

  async findById(id: string): Promise<Note | null> {
    const row = await this.prisma.note.findUnique({
      where: { id, deletedAt: null },
    });
    return row ? new Note(row) : null;
  }

  async create(input: CreateNoteDto): Promise<Note> {
    const row = await this.prisma.note.create({ data: input });
    return new Note(row);
  }

  async update(id: string, input: UpdateNoteDto): Promise<Note | null> {
    try {
      const row = await this.prisma.note.update({
        where: { id, deletedAt: null },
        data: input,
      });
      return new Note(row);
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2025'
      )
        return null;
      throw error;
    }
  }

  async remove(id: string): Promise<boolean> {
    try {
      await this.prisma.note.update({
        where: { id, deletedAt: null },
        data: { deletedAt: new Date() },
      });
      return true;
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2025'
      )
        return false;
      throw error;
    }
  }
}
