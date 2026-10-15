import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { validateEnvironment } from '../config/environment';
import type { Environment } from '../config/environment';
import { DatabaseModule } from '../database/database.module';
import { JOB_EXECUTION_REPOSITORY } from '../interfaces/repositories/job-execution-repository.interface';
import { MEDIA_REPOSITORY } from '../interfaces/repositories/media-repository.interface';
import { OUTBOX_RELAY_REPOSITORY } from '../interfaces/repositories/outbox-relay-repository.interface';
import { IMAGE_PROCESSOR_SERVICE } from '../interfaces/services/image-processor-service.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import { MEDIA_MAINTENANCE_SERVICE } from '../interfaces/services/media-maintenance-service.interface';
import { MEDIA_PROCESSING_SERVICE } from '../interfaces/services/media-processing-service.interface';
import { MEDIA_TRANSCODER_SERVICE } from '../interfaces/services/media-transcoder-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import { OUTBOX_RELAY_SERVICE } from '../interfaces/services/outbox-relay-service.interface';
import { JobExecutionRepository } from '../repositories/job-execution.repository';
import { MediaRepository } from '../repositories/media.repository';
import { OutboxRelayRepository } from '../repositories/outbox-relay.repository';
import { ImageProcessorService } from '../services/image-processor.service';
import { JobQueueService } from '../services/job-queue.service';
import { JobRunnerService } from '../services/job-runner.service';
import { MediaMaintenanceService } from '../services/media-maintenance.service';
import { MediaProcessingService } from '../services/media-processing.service';
import { MediaTranscoderService } from '../services/media-transcoder.service';
import { ObjectStorageService } from '../services/object-storage.service';
import { OutboxRelayService } from '../services/outbox-relay.service';
import { MaintenanceQueueWorker } from './maintenance.worker';
import { MediaQueueWorker } from './media.worker';
import { OutboxRelayLoop } from './outbox-relay.loop';
import { WorkerHeartbeat } from './worker-heartbeat';

/** Composition root of the background worker process (no HTTP). */
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
        pinoHttp: { level: config.get('LOG_LEVEL', { infer: true }) },
      }),
    }),
    DatabaseModule,
  ],
  providers: [
    { provide: MEDIA_REPOSITORY, useClass: MediaRepository },
    { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
    { provide: OUTBOX_RELAY_REPOSITORY, useClass: OutboxRelayRepository },
    { provide: OBJECT_STORAGE_SERVICE, useClass: ObjectStorageService },
    { provide: IMAGE_PROCESSOR_SERVICE, useClass: ImageProcessorService },
    { provide: MEDIA_TRANSCODER_SERVICE, useClass: MediaTranscoderService },
    { provide: MEDIA_PROCESSING_SERVICE, useClass: MediaProcessingService },
    { provide: MEDIA_MAINTENANCE_SERVICE, useClass: MediaMaintenanceService },
    { provide: JOB_RUNNER_SERVICE, useClass: JobRunnerService },
    { provide: JOB_QUEUE_SERVICE, useClass: JobQueueService },
    { provide: OUTBOX_RELAY_SERVICE, useClass: OutboxRelayService },
    WorkerHeartbeat,
    OutboxRelayLoop,
    MediaQueueWorker,
    MaintenanceQueueWorker,
  ],
})
export class WorkerModule {}
