import { randomUUID } from 'node:crypto';
import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { Server } from 'node:http';
import { AppModule } from '../../src/app.module';
import { configureApp } from '../../src/bootstrap';
import { PrismaService } from '../../src/database/prisma.service';
import { NOTE_REPOSITORY } from '../../src/interfaces/repositories/note-repository.interface';
import type { INoteRepository } from '../../src/interfaces/repositories/note-repository.interface';
import { Note } from '../../src/models/note.model';

describe('HTTP application (repository replaced through DI)', () => {
  let app: INestApplication<Server>;
  const note = new Note({
    id: randomUUID(),
    title: 'Example',
    content: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  });
  const repository: jest.Mocked<INoteRepository> = {
    list: jest.fn().mockResolvedValue({
      data: [note],
      meta: { page: 1, limit: 20, total: 1, totalPages: 1 },
    }),
    findById: jest.fn().mockResolvedValue(null),
    create: jest
      .fn()
      .mockImplementation((input: { title: string; content?: string }) =>
        Promise.resolve(new Note({ ...note, ...input })),
      ),
    update: jest.fn().mockResolvedValue(note),
    remove: jest.fn().mockResolvedValue(true),
  };
  beforeAll(async () => {
    const module = await Test.createTestingModule({ imports: [AppModule] })
      .overrideProvider(PrismaService)
      .useValue({ $queryRaw: jest.fn().mockResolvedValue([{ '?column?': 1 }]) })
      .overrideProvider(NOTE_REPOSITORY)
      .useValue(repository)
      .compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
  });
  afterAll(async () => {
    await app.close();
  });

  it('exposes independent live/ready probes without the API prefix', async () => {
    await request(app.getHttpServer())
      .get('/health/live')
      .expect(200, { status: 'ok' });
    await request(app.getHttpServer())
      .get('/health/ready')
      .expect(200, { status: 'ok', database: 'up' });
  });
  it('validates and trims creation input before calling the service', async () => {
    const response = await request(app.getHttpServer())
      .post('/api/v1/notes')
      .send({ title: '  Hello  ' })
      .expect(201);
    expect(response.body).toMatchObject({ title: 'Hello' });
    expect(repository.create).toHaveBeenCalledWith(
      expect.objectContaining({ title: 'Hello' }),
    );
  });
  it.each([
    { title: ' ' },
    { title: 'ok', extra: true },
    { title: null },
    { title: 'ok', content: null },
  ])('rejects invalid create payload %j', async (payload) => {
    await request(app.getHttpServer())
      .post('/api/v1/notes')
      .send(payload)
      .expect(400);
  });
  it('bounds pagination and converts query strings to numbers', async () => {
    await request(app.getHttpServer())
      .get('/api/v1/notes?page=2&limit=5')
      .expect(200);
    expect(repository.list).toHaveBeenCalledWith(
      expect.objectContaining({ page: 2, limit: 5 }),
    );
    await request(app.getHttpServer())
      .get('/api/v1/notes?limit=101')
      .expect(400);
    await request(app.getHttpServer())
      .get('/api/v1/notes?page=1.5')
      .expect(400);
  });
  it('returns structured errors with a request ID', async () => {
    const response = await request(app.getHttpServer())
      .get(`/api/v1/notes/${randomUUID()}`)
      .set('X-Request-Id', 'test-request-123')
      .expect(404);
    expect(response.body).toMatchObject({
      error: { code: 'NOT_FOUND' },
      requestId: 'test-request-123',
    });
    expect(response.headers['x-request-id']).toBe('test-request-123');
  });
  it('rejects empty updates, null titles and invalid identifiers', async () => {
    await request(app.getHttpServer())
      .patch(`/api/v1/notes/${note.id}`)
      .send({})
      .expect(400);
    await request(app.getHttpServer())
      .patch(`/api/v1/notes/${note.id}`)
      .send({ title: null })
      .expect(400);
    await request(app.getHttpServer())
      .get('/api/v1/notes/not-a-uuid')
      .expect(400);
  });
  it('serves a generated OpenAPI contract', async () => {
    const response = await request(app.getHttpServer())
      .get('/docs-json')
      .expect(200);
    expect(response.body).toMatchObject({
      paths: expect.objectContaining({ '/api/v1/notes': expect.anything() }),
    });
  });
});
