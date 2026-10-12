import { Test } from '@nestjs/testing';
import {
  NotFoundError,
  ValidationError,
} from '../../src/common/errors/domain.error';
import { NOTE_REPOSITORY } from '../../src/interfaces/repositories/note-repository.interface';
import type { INoteRepository } from '../../src/interfaces/repositories/note-repository.interface';
import { NoteService } from '../../src/services/note.service';

describe('NoteService', () => {
  let service: NoteService;
  let repository: jest.Mocked<INoteRepository>;
  beforeEach(async () => {
    repository = {
      list: jest.fn(),
      findById: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      remove: jest.fn(),
    };
    const module = await Test.createTestingModule({
      providers: [
        NoteService,
        { provide: NOTE_REPOSITORY, useValue: repository },
      ],
    }).compile();
    service = module.get(NoteService);
  });
  it('resolves the repository interface through a DI token', async () => {
    repository.findById.mockResolvedValue(null);
    await expect(service.getById('missing')).rejects.toBeInstanceOf(
      NotFoundError,
    );
    expect(repository.findById).toHaveBeenCalledWith('missing');
  });
  it('rejects an empty update before persistence', async () => {
    await expect(service.update('id', {})).rejects.toBeInstanceOf(
      ValidationError,
    );
    expect(repository.update).not.toHaveBeenCalled();
  });
  it('handles a record removed concurrently during an update', async () => {
    repository.update.mockResolvedValue(null);
    await expect(
      service.update('missing', { title: 'Changed' }),
    ).rejects.toBeInstanceOf(NotFoundError);
  });
  it('turns a missing delete into a domain not-found error', async () => {
    repository.remove.mockResolvedValue(false);
    await expect(service.remove('missing')).rejects.toBeInstanceOf(
      NotFoundError,
    );
  });
  it('normalizes creation input in the service before calling CRUD', async () => {
    await service.create({ title: '  Normalized title  ' });
    expect(repository.create).toHaveBeenCalledWith({
      title: 'Normalized title',
    });
  });
  it('rejects invalid titles when called outside an HTTP controller', () => {
    expect(() => service.create({ title: '   ' })).toThrow(ValidationError);
    expect(repository.create).not.toHaveBeenCalled();
  });
});
