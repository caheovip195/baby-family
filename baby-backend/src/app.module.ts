import { randomUUID } from 'node:crypto';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { LoggerModule } from 'nestjs-pino';
import { HttpExceptionFilter } from './common/errors/http-exception.filter';
import { validateEnvironment } from './config/environment';
import type { Environment } from './config/environment';
import { DatabaseModule } from './database/database.module';
import { HealthController } from './controllers/health.controller';
import { NoteController } from './controllers/note.controller';
import { NOTE_REPOSITORY } from './interfaces/repositories/note-repository.interface';
import { NOTE_SERVICE } from './interfaces/services/note-service.interface';
import { NoteRepository } from './repositories/note.repository';
import { NoteService } from './services/note.service';
// generator:imports

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      validate: validateEnvironment,
    }),
    LoggerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Environment, true>) => ({
        pinoHttp: {
          level: config.get('LOG_LEVEL', { infer: true }),
          genReqId: (req, res) => {
            const incoming = req.headers['x-request-id'];
            const id =
              typeof incoming === 'string' &&
              /^[a-zA-Z0-9_-]{1,100}$/.test(incoming)
                ? incoming
                : randomUUID();
            res.setHeader('X-Request-Id', id);
            return id;
          },
          serializers: {
            req: (request: { id?: string; method?: string; url?: string }) => ({
              id: request.id,
              method: request.method,
              url: request.url?.split('?')[0],
            }),
          },
          redact: [
            'req.headers.authorization',
            'req.headers.cookie',
            'res.headers["set-cookie"]',
          ],
        },
      }),
    }),
    ThrottlerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Environment, true>) => [
        {
          ttl: config.get('THROTTLE_TTL_MS', { infer: true }),
          limit: config.get('THROTTLE_LIMIT', { infer: true }),
        },
      ],
    }),
    DatabaseModule,
  ],
  controllers: [
    HealthController,
    NoteController,
    // generator:controllers
  ],
  providers: [
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: NOTE_REPOSITORY, useClass: NoteRepository },
    { provide: NOTE_SERVICE, useClass: NoteService },
    // generator:providers
  ],
})
export class AppModule {}
