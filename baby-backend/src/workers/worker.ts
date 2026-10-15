import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { Logger } from 'nestjs-pino';
import type { Environment } from '../config/environment';
import { WorkerModule } from './worker.module';

/** Background worker entry point: `node dist/workers/worker.js`. */
async function bootstrap(): Promise<void> {
  const app = await NestFactory.createApplicationContext(WorkerModule, {
    bufferLogs: true,
  });
  app.useLogger(app.get(Logger));
  const config = app.get(ConfigService<Environment, true>);
  const required = ['REDIS_URL', 'S3_ENDPOINT'] as const;
  if (required.some((name) => !config.get(name, { infer: true }))) {
    await app.close();
    throw new Error('The worker requires REDIS_URL and S3_* configuration.');
  }
  app.enableShutdownHooks();
}

void bootstrap().catch((error: unknown) => {
  console.error('Worker startup failed.', error);
  process.exitCode = 1;
});
