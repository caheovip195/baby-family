import { randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import { AppModule } from '../../src/app.module';
import { configureApp } from '../../src/bootstrap';
import { PrismaService } from '../../src/database/prisma.service';
import { NOTE_SERVICE } from '../../src/interfaces/services/note-service.interface';
import type { INoteService } from '../../src/interfaces/services/note-service.interface';
import { Note } from '../../src/models/note.model';

describe('Notes API + real PostgreSQL + real DI', () => {
  let app: INestApplication<Server>;
  const createdIds: string[] = [];
  beforeAll(async () => {
    const database = new URL(process.env.DATABASE_URL ?? '').pathname;
    if (!database.endsWith('_test'))
      throw new Error(
        'Integration tests require a dedicated database whose name ends with _test. Set TEST_DATABASE_URL.',
      );
    const module = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>({
      bufferLogs: true,
    });
    configureApp(app);
    await app.init();
  });
  afterAll(async () => {
    if (app) {
      await app
        .get(PrismaService)
        .note.deleteMany({ where: { id: { in: createdIds } } });
      await app.close();
    }
  });
  it('persists a full CRUD flow and maps missing-row errors', async () => {
    await request(app.getHttpServer()).get('/health/ready').expect(200);
    const created = await request(app.getHttpServer())
      .post('/api/v1/notes')
      .send({
        title: `integration-${randomUUID()}`,
        content: 'Persisted in PostgreSQL',
      })
      .expect(201);
    const body = created.body as { id: string; title: string };
    createdIds.push(body.id);
    const model = await app.get<INoteService>(NOTE_SERVICE).getById(body.id);
    expect(model).toBeInstanceOf(Note);
    expect(model.hasContent()).toBe(true);

    const read = await request(app.getHttpServer())
      .get(`/api/v1/notes/${body.id}`)
      .expect(200);
    expect(read.body).toMatchObject({
      id: body.id,
      title: body.title,
      content: 'Persisted in PostgreSQL',
    });
    const listed = await request(app.getHttpServer())
      .get('/api/v1/notes?limit=100')
      .expect(200);
    expect(listed.body).toMatchObject({
      meta: { page: 1, limit: 100, total: expect.any(Number) },
    });
    await request(app.getHttpServer())
      .patch(`/api/v1/notes/${body.id}`)
      .send({ title: 'Updated through service and repository' })
      .expect(200);
    const stored = await app
      .get(PrismaService)
      .note.findUniqueOrThrow({ where: { id: body.id } });
    expect(stored.title).toBe('Updated through service and repository');
    await request(app.getHttpServer())
      .delete(`/api/v1/notes/${body.id}`)
      .expect(204);
    await request(app.getHttpServer())
      .get(`/api/v1/notes/${body.id}`)
      .expect(404);
    await request(app.getHttpServer())
      .patch(`/api/v1/notes/${body.id}`)
      .send({ title: 'Missing' })
      .expect(404);
    await request(app.getHttpServer())
      .delete(`/api/v1/notes/${body.id}`)
      .expect(404);
  });
});
