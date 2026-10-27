import { randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import { ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { PinoLogger } from 'nestjs-pino';
import request from 'supertest';
import { DomainError } from '../../src/common/errors/domain.error';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { NoteController } from '../../src/controllers/note.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { NOTE_REPOSITORY } from '../../src/interfaces/repositories/note-repository.interface';
import { OFFLINE_COMMAND_REPOSITORY } from '../../src/interfaces/repositories/offline-command-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../../src/interfaces/services/application-access-service.interface';
import { MEMORY_CONTENT_SERVICE } from '../../src/interfaces/services/memory-content-service.interface';
import { NOTE_SERVICE } from '../../src/interfaces/services/note-service.interface';
import { OFFLINE_COMMAND_SERVICE } from '../../src/interfaces/services/offline-command-service.interface';
import { NoteRepository } from '../../src/repositories/note.repository';
import { OfflineCommandRepository } from '../../src/repositories/offline-command.repository';
import { NoteService } from '../../src/services/note.service';
import { OfflineCommandService } from '../../src/services/offline-command.service';

describe('Offline optional idempotency (isolated Nest module + PostgreSQL ledger)', () => {
  let app: INestApplication<Server>;
  let prisma: PrismaService;
  let service: OfflineCommandService;
  const keys: string[] = [];
  const noteIds: string[] = [];
  const userIds: string[] = [];
  const key = () => {
    const value = randomUUID();
    keys.push(value);
    return value;
  };
  const memories = { getById: jest.fn() };
  const access = { requireParent: jest.fn(), requireContentAccess: jest.fn() };
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('This spec requires baby_family_test.');
    const module = await Test.createTestingModule({
      controllers: [NoteController],
      providers: [
        {
          provide: ConfigService,
          useValue: new ConfigService({
            DATABASE_URL: process.env.DATABASE_URL,
            DATABASE_POOL_SIZE: 4,
            AUTH_SECRET_PEPPER: 'offline-spec-key-not-a-production-secret',
          }),
        },
        PrismaService,
        {
          provide: PinoLogger,
          useValue: { error: jest.fn(), warn: jest.fn() },
        },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: NOTE_SERVICE, useClass: NoteService },
        { provide: NOTE_REPOSITORY, useClass: NoteRepository },
        { provide: OFFLINE_COMMAND_SERVICE, useClass: OfflineCommandService },
        {
          provide: OFFLINE_COMMAND_REPOSITORY,
          useClass: OfflineCommandRepository,
        },
        { provide: MEMORY_CONTENT_SERVICE, useValue: memories },
        { provide: APPLICATION_ACCESS_SERVICE, useValue: access },
      ],
    }).compile();
    app = module.createNestApplication<INestApplication<Server>>();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    );
    await app.init();
    prisma = app.get(PrismaService);
    service = app.get(OFFLINE_COMMAND_SERVICE);
  });
  afterAll(async () => {
    if (!app) return;
    await prisma.idempotencyRecord.deleteMany({
      where: { idempotencyKey: { in: keys } },
    });
    await prisma.note.deleteMany({ where: { id: { in: noteIds } } });
    await prisma.user.deleteMany({ where: { id: { in: userIds } } });
    await app.close();
  });
  it('accepts missing header and rejects malformed UUID before mutation', async () => {
    const result = await request(app.getHttpServer())
      .post('/api/v1/notes')
      .send({ title: 'Legacy note' })
      .expect(201);
    noteIds.push((result.body as { id: string }).id);
    await request(app.getHttpServer())
      .post('/api/v1/notes')
      .set('Idempotency-Key', 'not-a-uuid')
      .send({ title: 'Invalid key' })
      .expect(400);
  });
  it('replays exact create JSON after the entity changes; different body returns 409', async () => {
    const idempotencyKey = key();
    const result = await request(app.getHttpServer())
      .post('/api/v1/notes')
      .set('Idempotency-Key', idempotencyKey)
      .send({ title: 'Original', content: 'Sensitive example' })
      .expect(201);
    const id = (result.body as { id: string }).id;
    noteIds.push(id);
    await request(app.getHttpServer())
      .patch(`/api/v1/notes/${id}`)
      .send({ title: 'Changed later' })
      .expect(200);
    const replay = await request(app.getHttpServer())
      .post('/api/v1/notes')
      .set('Idempotency-Key', idempotencyKey.toUpperCase())
      .send({ content: 'Sensitive example', title: 'Original' })
      .expect(201);
    expect(replay.body).toEqual(result.body);
    const conflict = await request(app.getHttpServer())
      .post('/api/v1/notes')
      .set('Idempotency-Key', idempotencyKey)
      .send({ title: 'Different' })
      .expect(409);
    expect(conflict.body).toMatchObject({
      error: { code: 'IDEMPOTENCY_KEY_REUSED' },
    });
    const row = await prisma.idempotencyRecord.findFirstOrThrow({
      where: { idempotencyKey },
    });
    expect(JSON.stringify(row.responseReference)).not.toContain(
      'Sensitive example',
    );
    expect(await prisma.note.count({ where: { id } })).toBe(1);
  });
  it('replays a patch snapshot and an empty 204 delete', async () => {
    const result = await request(app.getHttpServer())
      .post('/api/v1/notes')
      .send({ title: 'Update/delete target' })
      .expect(201);
    const id = (result.body as { id: string }).id;
    noteIds.push(id);
    const patchKey = key();
    const first = await request(app.getHttpServer())
      .patch(`/api/v1/notes/${id}`)
      .set('Idempotency-Key', patchKey)
      .send({ title: 'Updated' })
      .expect(200);
    const again = await request(app.getHttpServer())
      .patch(`/api/v1/notes/${id}`)
      .set('Idempotency-Key', patchKey)
      .send({ title: 'Updated' })
      .expect(200);
    expect(again.body).toEqual(first.body);
    const deleteKey = key();
    await request(app.getHttpServer())
      .delete(`/api/v1/notes/${id}`)
      .set('Idempotency-Key', deleteKey)
      .expect(204);
    const deleted = await request(app.getHttpServer())
      .delete(`/api/v1/notes/${id}`)
      .set('Idempotency-Key', deleteKey)
      .expect(204);
    expect(deleted.text).toBe('');
  });
  it('serializes a racing key with one side effect and replays after completion', async () => {
    const idempotencyKey = key();
    let unblock!: () => void;
    const gate = new Promise<void>((resolve) => {
      unblock = resolve;
    });
    let started!: () => void;
    const begun = new Promise<void>((resolve) => {
      started = resolve;
    });
    const work = jest.fn(async () => {
      started();
      await gate;
      return { id: randomUUID(), count: 1 };
    });
    const command = { operation: 'spec.race', body: { x: 1 } };
    const first = service.execute(command, idempotencyKey, work);
    await begun;
    await expect(
      service.execute(command, idempotencyKey, work),
    ).rejects.toMatchObject({ code: 'IDEMPOTENCY_COMMAND_PENDING' });
    unblock();
    const result = await first;
    expect(await service.execute(command, idempotencyKey, work)).toEqual(
      result,
    );
    expect(work).toHaveBeenCalledTimes(1);
  });
  it('replays a deterministic 4xx without calling the workflow twice', async () => {
    const idempotencyKey = key();
    const work = jest.fn(() =>
      Promise.reject(new DomainError('Invalid command.', 'SPEC_INVALID', 422)),
    );
    const command = { operation: 'spec.invalid' };
    await expect(
      service.execute(command, idempotencyKey, work),
    ).rejects.toMatchObject({ code: 'SPEC_INVALID', statusCode: 422 });
    await expect(
      service.execute(command, idempotencyKey, work),
    ).rejects.toMatchObject({ code: 'SPEC_INVALID', statusCode: 422 });
    expect(work).toHaveBeenCalledTimes(1);
  });
  it('does not repeat an uncertain workflow after an unexpected exception', async () => {
    const idempotencyKey = key();
    const work = jest.fn(() =>
      Promise.reject(new Error('Unknown commit outcome')),
    );
    await expect(
      service.execute({ operation: 'spec.uncertain' }, idempotencyKey, work),
    ).rejects.toThrow('Unknown commit outcome');
    await expect(
      service.execute({ operation: 'spec.uncertain' }, idempotencyKey, work),
    ).rejects.toMatchObject({ code: 'IDEMPOTENCY_COMMAND_PENDING' });
    expect(work).toHaveBeenCalledTimes(1);
  });
  it('checks current scope again before replaying a successful snapshot', async () => {
    const idempotencyKey = key();
    const command = { operation: 'spec.revoked-scope' };
    const work = jest.fn(() => Promise.resolve({ value: 'private' }));
    const authorize = jest.fn(() => Promise.resolve());
    await service.execute(command, idempotencyKey, work, authorize);
    authorize.mockRejectedValueOnce(
      new DomainError('Not found.', 'NOT_FOUND', 404),
    );
    await expect(
      service.execute(command, idempotencyKey, work, authorize),
    ).rejects.toMatchObject({ statusCode: 404 });
    expect(work).toHaveBeenCalledTimes(1);
    expect(authorize).toHaveBeenCalledTimes(2);
  });
  it('rejects a Parent-only perspective replay after demotion even when the memory remains visible', async () => {
    const userId = randomUUID();
    userIds.push(userId);
    await prisma.user.create({
      data: { id: userId, displayName: 'Offline perspective spec' },
    });
    const idempotencyKey = key();
    const familyId = randomUUID();
    const work = jest.fn(() =>
      Promise.resolve({ body: 'Private perspective' }),
    );
    const command = {
      operation: 'memory.perspective.put',
      parentOnly: true,
      actor: { userId, sessionId: randomUUID(), tokenVersion: 1 },
      memoryId: randomUUID(),
    };
    memories.getById.mockResolvedValue({ familyId });
    access.requireParent.mockResolvedValueOnce(undefined);
    const first = await service.execute(command, idempotencyKey, work);
    expect(first).toEqual({ body: 'Private perspective' });
    expect(
      await prisma.idempotencyRecord.count({
        where: { idempotencyKey, actorUserId: userId, status: 'SUCCEEDED' },
      }),
    ).toBe(1);
    access.requireParent.mockRejectedValueOnce(
      new DomainError('Not found.', 'NOT_FOUND', 404),
    );
    await expect(
      service.execute(command, idempotencyKey, work),
    ).rejects.toMatchObject({ code: 'NOT_FOUND', statusCode: 404 });
    expect(memories.getById).toHaveBeenCalledTimes(2);
    expect(access.requireParent).toHaveBeenLastCalledWith(
      command.actor,
      familyId,
      'write',
    );
    expect(access.requireContentAccess).toHaveBeenCalledTimes(1);
    expect(work).toHaveBeenCalledTimes(1);
  });
  it('checks current memory ACL before claiming a command', async () => {
    const work = jest.fn(() => Promise.resolve({ id: randomUUID() }));
    memories.getById.mockRejectedValueOnce(
      new DomainError('Not found.', 'NOT_FOUND', 404),
    );
    await expect(
      service.execute(
        {
          operation: 'spec.acl',
          actor: {
            userId: randomUUID(),
            sessionId: randomUUID(),
            tokenVersion: 1,
          },
          memoryId: randomUUID(),
        },
        key(),
        work,
      ),
    ).rejects.toMatchObject({ statusCode: 404 });
    expect(work).not.toHaveBeenCalled();
  });
});
