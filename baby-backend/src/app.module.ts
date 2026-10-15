import { randomUUID } from 'node:crypto';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_FILTER, APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { LoggerModule } from 'nestjs-pino';
import { HttpExceptionFilter } from './common/errors/http-exception.filter';
import { validateEnvironment } from './config/environment';
import type { Environment } from './config/environment';
import { ValkeyThrottlerStorage } from './common/throttling/valkey-throttler.storage';
import { DatabaseModule } from './database/database.module';
import { ValkeyConnection } from './database/valkey.connection';
import { DATABASE_REPOSITORY_PROVIDERS } from './database/repository.providers';
import {
  APPLICATION_CONTROLLERS,
  APPLICATION_PROVIDERS,
} from './common/application/application.providers';
import { HealthController } from './controllers/health.controller';
import { NoteController } from './controllers/note.controller';
import { NOTE_REPOSITORY } from './interfaces/repositories/note-repository.interface';
import { NOTE_SERVICE } from './interfaces/services/note-service.interface';
import { CACHE_REPOSITORY } from './interfaces/repositories/cache-repository.interface';
import { MAIL_SERVICE } from './interfaces/services/mail-service.interface';
import { OBJECT_STORAGE_SERVICE } from './interfaces/services/object-storage-service.interface';
import { NoteRepository } from './repositories/note.repository';
import { NoteService } from './services/note.service';
import { CacheRepository } from './repositories/cache.repository';
import { MailService } from './services/mail.service';
import { ObjectStorageService } from './services/object-storage.service';
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
      imports: [DatabaseModule],
      inject: [ConfigService, ValkeyConnection],
      useFactory: (
        config: ConfigService<Environment, true>,
        valkey: ValkeyConnection,
      ) => ({
        throttlers: [
          {
            ttl: config.get('THROTTLE_TTL_MS', { infer: true }),
            limit: config.get('THROTTLE_LIMIT', { infer: true }),
          },
        ],
        // Shared across replicas when REDIS_URL is set; in-memory otherwise.
        storage: valkey.client
          ? new ValkeyThrottlerStorage(valkey.client)
          : undefined,
      }),
    }),
    DatabaseModule,
  ],
  controllers: [
    ...APPLICATION_CONTROLLERS,
    HealthController,
    NoteController,
    // generator:controllers
  ],
  providers: [
    ...APPLICATION_PROVIDERS,
    ...DATABASE_REPOSITORY_PROVIDERS,
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: CACHE_REPOSITORY, useClass: CacheRepository },
    { provide: OBJECT_STORAGE_SERVICE, useClass: ObjectStorageService },
    { provide: MAIL_SERVICE, useClass: MailService },
    { provide: NOTE_REPOSITORY, useClass: NoteRepository },
    { provide: NOTE_SERVICE, useClass: NoteService },
    // generator:providers
  ],
})
export class AppModule {}
