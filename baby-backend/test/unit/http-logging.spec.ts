import { createServer } from 'node:http';
import pinoHttp from 'pino-http';
import request from 'supertest';
import { Writable } from 'node:stream';
import type { IncomingMessage, ServerResponse } from 'node:http';
import pino from 'pino';
import {
  completionFields,
  httpLoggingOptions,
  requestId,
  safeRoute,
} from '../../src/common/observability/http-logging';

describe('HTTP observability privacy', () => {
  it('only emits matched route template and response metadata', () => {
    const req = {
      id: 'safe-id',
      route: { path: '/children/:id' },
      url: '/children/private?otp=123456',
      body: { memory: 'private' },
    } as unknown as IncomingMessage;
    expect(
      completionFields(req, { statusCode: 201 } as ServerResponse, 2),
    ).toEqual({
      requestId: 'safe-id',
      route: '/children/:id',
      status: 201,
      durationMs: 2,
    });
    expect(safeRoute({ url: '/secret' } as IncomingMessage)).toBe('unmatched');
  });
  it('validates request ID', () => {
    expect(
      requestId({
        headers: { 'x-request-id': '4dce68a1-c55a-4c88-8d03-907fa6c15771' },
      } as unknown as IncomingMessage),
    ).toBe('4dce68a1-c55a-4c88-8d03-907fa6c15771');
    expect(
      requestId({
        headers: { 'x-request-id': 'Bearer secret\n' },
      } as unknown as IncomingMessage),
    ).toMatch(/^[0-9a-f-]{36}$/);
  });
  it('emits JSON level/time and redacts exceptions and secrets', () => {
    let output = '';
    const sink = new Writable({
      write(chunk: Buffer, _encoding, callback) {
        output += chunk.toString();
        callback();
      },
    });
    const options = httpLoggingOptions('info', 'json');
    const logger = pino(
      {
        level: options.level,
        serializers: options.serializers,
        redact: options.redact,
        formatters: options.formatters,
      },
      sink,
    );
    logger.error(
      {
        err: new Error('token OTP child memory secret'),
        token: 'secret',
        otp: '123456',
        req: {
          id: 'r1',
          body: { memory: 'secret' },
          headers: { authorization: 'secret' },
        },
        ...completionFields(
          { route: { path: '/children/:id' } } as unknown as IncomingMessage,
          { statusCode: 500 } as ServerResponse,
          5,
        ),
      },
      'Request failed',
    );
    const record = JSON.parse(output) as Record<string, unknown>;
    expect(record).toMatchObject({
      level: 'error',
      status: 500,
      route: '/children/:id',
      durationMs: 5,
    });
    expect(typeof record.time).toBe('number');
    expect(output).not.toContain('secret');
    expect(output).not.toContain('123456');
    expect(output).not.toContain('memory');
  });
  it('records actual HTTP completion without leaking URL, body or headers', async () => {
    let output = '';
    const sink = new Writable({
      write(chunk: Buffer, _encoding, callback) {
        output += chunk.toString();
        callback();
      },
    });
    const middleware = pinoHttp(httpLoggingOptions('info', 'json'), sink);
    const server = createServer((req, res) => {
      middleware(req, res);
      res.statusCode = 500;
      res.end();
    });
    const response = await request(server)
      .post('/private-child?otp=123456')
      .set('Authorization', 'Bearer private-token')
      .send({ memory: 'private-memory' });
    expect(response.headers['x-request-id']).toMatch(/^[0-9a-f-]{36}$/);
    const record = JSON.parse(output) as Record<string, unknown>;
    expect(record).toMatchObject({
      level: 'error',
      status: 500,
      route: 'unmatched',
    });
    expect(typeof record.durationMs).toBe('number');
    for (const secret of [
      'private-child',
      '123456',
      'private-token',
      'private-memory',
    ])
      expect(output).not.toContain(secret);
  });
  it('enables pretty transport explicitly', () => {
    expect(httpLoggingOptions('warn', 'json').transport).toBeUndefined();
    expect(httpLoggingOptions('warn', 'pretty').transport).toMatchObject({
      target: 'pino-pretty',
    });
  });
});
