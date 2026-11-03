import { RequestMethod, ValidationPipe } from '@nestjs/common';
import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import { Logger } from 'nestjs-pino';
import type { Environment } from './config/environment';
import { RedisIoAdapter } from './common/realtime/redis-io.adapter';

export function configureApp(app: INestApplication): void {
  const config = app.get(ConfigService<Environment, true>);
  app.useLogger(app.get(Logger));
  app.use(helmet());
  app.enableCors({ origin: config.get('CORS_ORIGINS', { infer: true }) });
  app.setGlobalPrefix('api/v1', {
    exclude: [
      { path: 'health/{*path}', method: RequestMethod.ALL },
      { path: 'metrics', method: RequestMethod.ALL },
      // Admin CMS is a separate surface (own auth) at /admin/v1/*.
      { path: 'admin/v1/{*path}', method: RequestMethod.ALL },
    ],
  });
  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: true,
      forbidUnknownValues: true,
    }),
  );
  // Realtime Socket.IO qua Valkey để nhiều instance API cùng phát (§12).
  app.useWebSocketAdapter(
    new RedisIoAdapter(app, config.get('REDIS_URL', { infer: true })),
  );
  app.enableShutdownHooks();
  if (config.get('SWAGGER_ENABLED', { infer: true })) {
    const options = new DocumentBuilder()
      .setTitle('Baby Family API')
      .setDescription(
        'Three-layer backend. Domain endpoints require an ES256 access token and a live session. Notes remain an unauthenticated example resource.',
      )
      .addBearerAuth()
      .setVersion('0.1.0')
      .build();
    SwaggerModule.setup('docs', app, () =>
      SwaggerModule.createDocument(app, options),
    );
  }
}
