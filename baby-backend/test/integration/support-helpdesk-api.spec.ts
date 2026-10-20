import { randomBytes, randomUUID } from 'node:crypto';
import type { Server } from 'node:http';
import {
  ValidationPipe,
  UnauthorizedException,
  type INestApplication,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { Test } from '@nestjs/testing';
import { LoggerModule } from 'nestjs-pino';
import request from 'supertest';
import { AccessTokenGuard } from '../../src/common/auth/access-token.guard';
import { HttpExceptionFilter } from '../../src/common/errors/http-exception.filter';
import { ResponseEnvelopeInterceptor } from '../../src/common/http/response-envelope.interceptor';
import { SupportHelpdeskController } from '../../src/controllers/support-helpdesk.controller';
import { PrismaService } from '../../src/database/prisma.service';
import { SUPPORT_HELPDESK_REPOSITORY } from '../../src/interfaces/repositories/support-helpdesk-repository.interface';
import { SUPPORT_HELPDESK_SERVICE } from '../../src/interfaces/services/support-helpdesk-service.interface';
import { AUTHENTICATION_SERVICE } from '../../src/interfaces/services/authentication-service.interface';
import { SupportHelpdeskRepository } from '../../src/repositories/support-helpdesk.repository';
import { SupportHelpdeskService } from '../../src/services/support-helpdesk.service';
import type {
  SupportHelpdeskDetail,
  SupportHelpdeskReceipt,
} from '../../src/dto/support-helpdesk/support-helpdesk.dto';
const data = <T>(r: { body: unknown }): T => (r.body as { data: T }).data;
const code = (r: { body: unknown }) =>
  (r.body as { error: { code: string } }).error.code;
describe('Support helpdesk (focused HTTP module + PostgreSQL; token verifier stub)', () => {
  let app: INestApplication<Server>,
    prisma: PrismaService,
    config: ConfigService;
  const owner = randomUUID(),
    other = randomUUID(),
    familyId = randomUUID();
  const assetId = randomUUID(),
    foreignAssetId = randomUUID(),
    avatarAssetId = randomUUID();
  const key = randomBytes(32).toString('base64');
  let ticket: SupportHelpdeskReceipt;
  const input = {
    category: 'MEDIA',
    subject: 'Không thấy ảnh',
    body: 'Nội dung người gửi tự nhập',
    familyId,
    attachmentAssetIds: [assetId],
  };
  const call = (method: 'get' | 'post', url: string, actor = owner) => {
    const client = request(app.getHttpServer());
    return client[method](`/api/v1${url}`).set(
      'Authorization',
      `Bearer ${actor}`,
    );
  };
  beforeAll(async () => {
    if (
      new URL(process.env.DATABASE_URL ?? '').pathname !== '/baby_family_test'
    )
      throw new Error('Requires baby_family_test');
    config = new ConfigService({
      DATABASE_URL: process.env.DATABASE_URL,
      DATABASE_POOL_SIZE: 3,
      SUPPORT_ENCRYPTION_KEY: key,
    });
    const module = await Test.createTestingModule({
      imports: [LoggerModule.forRoot({ pinoHttp: { level: 'silent' } })],
      controllers: [SupportHelpdeskController],
      providers: [
        PrismaService,
        AccessTokenGuard,
        { provide: ConfigService, useValue: config },
        {
          provide: AUTHENTICATION_SERVICE,
          useValue: {
            verifyAccessToken: (token: string) => {
              if (token !== owner && token !== other)
                throw new UnauthorizedException();
              return {
                userId: token,
                sessionId: randomUUID(),
                tokenVersion: 1,
              };
            },
          },
        },
        { provide: SUPPORT_HELPDESK_SERVICE, useClass: SupportHelpdeskService },
        {
          provide: SUPPORT_HELPDESK_REPOSITORY,
          useClass: SupportHelpdeskRepository,
        },
        { provide: APP_FILTER, useClass: HttpExceptionFilter },
        { provide: APP_INTERCEPTOR, useClass: ResponseEnvelopeInterceptor },
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
    await prisma.user.createMany({
      data: [owner, other].map((id) => ({
        id,
        displayName: 'Synthetic support user',
      })),
    });
    await prisma.family.create({
      data: {
        id: familyId,
        name: 'Synthetic support family',
        createdBy: owner,
      },
    });
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: owner,
        slot: 'A',
        kind: 'FATHER',
        callName: 'Papa',
      },
    });
    await prisma.userAsset.createMany({
      data: [assetId, foreignAssetId].map((id, index) => ({
        id,
        ownerUserId: index ? other : owner,
        purpose: 'SUPPORT',
        status: 'READY',
        storageKey: `support-spec/${id}`,
        mime: 'image/png',
        declaredSize: 100n,
        sizeBytes: 100n,
      })),
    });
    await prisma.userAsset.create({
      data: {
        id: avatarAssetId,
        ownerUserId: owner,
        purpose: 'AVATAR',
        status: 'READY',
        storageKey: `support-spec/${avatarAssetId}`,
        mime: 'image/png',
        declaredSize: 100n,
        sizeBytes: 100n,
      },
    });
  });
  afterAll(async () => {
    try {
      if (prisma) {
        const at = new Date();
        await prisma.supportTicketMessage.updateMany({
          where: { supportTicket: { requesterUserId: { in: [owner, other] } } },
          data: { deletedAt: at },
        });
        await prisma.supportTicketAttachment.updateMany({
          where: { ownerUserId: { in: [owner, other] } },
          data: { deletedAt: at },
        });
        await prisma.supportTicket.updateMany({
          where: { requesterUserId: { in: [owner, other] } },
          data: { deletedAt: at },
        });
        await prisma.userAsset.updateMany({
          where: { ownerUserId: { in: [owner, other] } },
          data: { deletedAt: at },
        });
        await prisma.family.updateMany({
          where: { id: familyId },
          data: { deletedAt: at },
        });
        await prisma.user.updateMany({
          where: { id: { in: [owner, other] } },
          data: { deletedAt: at },
        });
      }
    } finally {
      await app?.close();
    }
  });
  it('requires auth, validates DTOs and exposes versioned categories', async () => {
    await request(app.getHttpServer())
      .get('/api/v1/support/categories')
      .expect(401);
    expect(
      data<{ version: number }>(
        await call('get', '/support/categories').expect(200),
      ).version,
    ).toBe(1);
    expect(
      code(
        await call('post', '/support/tickets')
          .send({ ...input, category: 'UNKNOWN' })
          .expect(422),
      ),
    ).toBe('SUPPORT_CATEGORY_INVALID');
    await call('post', '/support/tickets')
      .send({ ...input, subject: '  ' })
      .expect(400);
    await call('post', '/support/tickets')
      .send({ ...input, requesterUserId: other })
      .expect(400);
    await call('post', '/support/tickets')
      .send({ ...input, attachmentAssetIds: [assetId, assetId] })
      .expect(400);
    await call('post', '/support/tickets')
      .send({ ...input, familyId: randomUUID() })
      .expect(404);
    await call('post', '/support/tickets', other).send(input).expect(404);
  });
  it('rejects foreign/not-ready/wrong-purpose/soft-deleted attachments atomically', async () => {
    for (const asset of [foreignAssetId, randomUUID(), avatarAssetId])
      expect(
        code(
          await call('post', '/support/tickets')
            .send({ ...input, attachmentAssetIds: [asset] })
            .expect(422),
        ),
      ).toBe('SUPPORT_ATTACHMENT_INVALID');
    for (const change of [
      { status: 'PENDING_UPLOAD' as const },
      { deletedAt: new Date() },
    ]) {
      await prisma.userAsset.update({ where: { id: assetId }, data: change });
      await call('post', '/support/tickets').send(input).expect(422);
      await prisma.userAsset.update({
        where: { id: assetId },
        data: { status: 'READY', deletedAt: null },
      });
    }
    expect(
      await prisma.supportTicket.count({ where: { requesterUserId: owner } }),
    ).toBe(0);
  });
  it('persists encrypted subject/body and thread, isolated to creator even in same family', async () => {
    ticket = data<SupportHelpdeskReceipt>(
      await call('post', '/support/tickets').send(input).expect(201),
    );
    expect(ticket.status).toBe('OPEN');
    const row = await prisma.supportTicket.findUniqueOrThrow({
      where: { id: ticket.id },
    });
    expect(
      Buffer.from(row.messageEnc).includes(Buffer.from(input.subject)),
    ).toBe(false);
    expect(row.updatedAt).toBeInstanceOf(Date);
    expect(row.deletedAt).toBeNull();
    await prisma.familyParent.create({
      data: {
        familyId,
        userId: other,
        slot: 'B',
        kind: 'MOTHER',
        callName: 'Mama',
      },
    });
    await call('get', `/support/tickets/${ticket.id}`, other).expect(404);
    await call('post', `/support/tickets/${ticket.id}/messages`, other)
      .send({ body: 'private' })
      .expect(404);
    const message = data<{ id: string }>(
      await call('post', `/support/tickets/${ticket.id}/messages`)
        .send({ body: 'Thông tin bổ sung' })
        .expect(201),
    );
    const detail = data<SupportHelpdeskDetail>(
      await call('get', `/support/tickets/${ticket.id}`).expect(200),
    );
    expect(detail).toMatchObject({
      subject: input.subject,
      body: input.body,
      categoryVersion: 1,
      attachmentAssetIds: [assetId],
      messages: [{ id: message.id, body: 'Thông tin bổ sung', sender: 'USER' }],
    });
    await prisma.supportTicketMessage.update({
      where: { id: message.id },
      data: { deletedAt: new Date() },
    });
    await prisma.supportTicketAttachment.updateMany({
      where: { ticketId: ticket.id },
      data: { deletedAt: new Date() },
    });
    const deletedView = data<SupportHelpdeskDetail>(
      await call('get', `/support/tickets/${ticket.id}`).expect(200),
    );
    expect(deletedView.messages).toEqual([]);
    expect(deletedView.attachmentAssetIds).toEqual([]);
    expect(
      data<{ items: unknown[] }>(
        await call('get', '/me/support/tickets', other).expect(200),
      ).items,
    ).toEqual([]);
  });
  it('lists newest first with bounded pagination and allows support without family/subscription', async () => {
    const second = data<SupportHelpdeskReceipt>(
      await call('post', '/support/tickets')
        .send({ category: 'ACCOUNT', subject: 'Tài khoản', body: 'Trợ giúp' })
        .expect(201),
    );
    const firstPage = data<{
      items: SupportHelpdeskReceipt[];
      nextOffset: number;
    }>(await call('get', '/me/support/tickets?limit=1').expect(200));
    expect(firstPage.items[0]?.id).toBe(second.id);
    expect(firstPage.nextOffset).toBe(1);
    const next = data<{ items: SupportHelpdeskReceipt[] }>(
      await call('get', '/me/support/tickets?limit=1&offset=1').expect(200),
    );
    expect(next.items[0]?.id).toBe(ticket.id);
    await call('get', '/me/support/tickets?limit=51').expect(400);
  });
  it('rejects closed tickets, deleted content and tampered encryption without leaking data', async () => {
    await prisma.supportTicket.update({
      where: { id: ticket.id },
      data: { status: 'CLOSED' },
    });
    expect(
      code(
        await call('post', `/support/tickets/${ticket.id}/messages`)
          .send({ body: 'test' })
          .expect(409),
      ),
    ).toBe('SUPPORT_TICKET_CLOSED');
    await prisma.supportTicket.update({
      where: { id: ticket.id },
      data: { messageEnc: randomBytes(45) },
    });
    expect(
      code(await call('get', `/support/tickets/${ticket.id}`).expect(503)),
    ).toBe('SUPPORT_CONTENT_UNAVAILABLE');
    await prisma.supportTicket.update({
      where: { id: ticket.id },
      data: { deletedAt: new Date() },
    });
    await call('get', `/support/tickets/${ticket.id}`).expect(404);
    config.set('SUPPORT_ENCRYPTION_KEY', '');
    expect(
      code(await call('post', '/support/tickets').send(input).expect(503)),
    ).toBe('SUPPORT_ENCRYPTION_UNAVAILABLE');
    config.set('SUPPORT_ENCRYPTION_KEY', key);
  });
});
