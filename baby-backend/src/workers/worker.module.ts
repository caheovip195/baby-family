import { MEMORY_CAPSULE_REPOSITORY } from '../interfaces/repositories/memory-capsule-repository.interface';
import { MEMORY_CAPSULE_SERVICE } from '../interfaces/services/memory-capsule-service.interface';
import { MemoryCapsuleRepository } from '../repositories/memory-capsule.repository';
import { MemoryCapsuleService } from '../services/memory-capsule.service';
import { MemoryQueueWorker } from './memory.worker';
import { MissionQueueWorker } from './mission.worker';
import { MISSION_BOARD_REPOSITORY } from '../interfaces/repositories/mission-board-repository.interface';
import { MISSION_SCHEDULE_SERVICE } from '../interfaces/services/mission-schedule-service.interface';
import { MissionBoardRepository } from '../repositories/mission-board.repository';
import { MissionScheduleService } from '../services/mission-schedule.service';
import { PUSH_DELIVERY_REPOSITORY } from '../interfaces/repositories/push-delivery-repository.interface';
import { PUSH_DELIVERY_SERVICE } from '../interfaces/services/push-delivery-service.interface';
import { PushDeliveryRepository } from '../repositories/push-delivery.repository';
import { PushDeliveryService } from '../services/push-delivery.service';
import { PUSH_SENDER_PROVIDER } from '../services/push-senders/push-sender.provider';
import { PushQueueWorker } from './push.worker';
import { BADGE_AWARD_REPOSITORY } from '../interfaces/repositories/badge-award-repository.interface';
import { BADGE_AWARD_SERVICE } from '../interfaces/services/badge-award-service.interface';
import { BadgeAwardRepository } from '../repositories/badge-award.repository';
import { BadgeAwardService } from '../services/badge-award.service';
import { CareQueueWorker } from './care.worker';
import { EVENT_REMINDER_SCHEDULE_REPOSITORY } from '../interfaces/repositories/event-reminder-schedule-repository.interface';
import { EVENT_REMINDER_SCHEDULE_SERVICE } from '../interfaces/services/event-reminder-schedule-service.interface';
import { EventReminderScheduleRepository } from '../repositories/event-reminder-schedule.repository';
import { EventReminderScheduleService } from '../services/event-reminder-schedule.service';
import { EventReminderQueueWorker } from './event-reminder.worker';
import { AUTH_ACCESS_REPOSITORY } from '../interfaces/repositories/auth-access-repository.interface';
import { APPLICATION_ACCESS_SERVICE } from '../interfaces/services/application-access-service.interface';
import { AuthAccessRepository } from '../repositories/auth-access.repository';
import { ApplicationAccessService } from '../services/application-access.service';
import { ACCOUNT_DELETION_REPOSITORY } from '../interfaces/repositories/account-deletion-repository.interface';
import { DATA_EXPORT_REPOSITORY } from '../interfaces/repositories/data-export-repository.interface';
import { ACCOUNT_DELETION_SERVICE } from '../interfaces/services/account-deletion-service.interface';
import { DATA_EXPORT_SERVICE } from '../interfaces/services/data-export-service.interface';
import { AccountDeletionRepository } from '../repositories/account-deletion.repository';
import { DataExportRepository } from '../repositories/data-export.repository';
import { AccountDeletionService } from '../services/account-deletion.service';
import { DataExportService } from '../services/data-export.service';
import { NOTIFICATION_INBOX_REPOSITORY } from '../interfaces/repositories/notification-inbox-repository.interface';
import { NOTIFICATION_DISPATCH_SERVICE } from '../interfaces/services/notification-dispatch-service.interface';
import { NotificationInboxRepository } from '../repositories/notification-inbox.repository';
import { NotificationDispatchService } from '../services/notification-dispatch.service';
import { NotificationQueueWorker } from './notification.worker';
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { validateEnvironment } from '../config/environment';
import type { Environment } from '../config/environment';
import { DatabaseModule } from '../database/database.module';
import { JOB_EXECUTION_REPOSITORY } from '../interfaces/repositories/job-execution-repository.interface';
import { MEDIA_REPOSITORY } from '../interfaces/repositories/media-repository.interface';
import { MEMORY_CONTENT_REPOSITORY } from '../interfaces/repositories/memory-content-repository.interface';
import { OUTBOX_RELAY_REPOSITORY } from '../interfaces/repositories/outbox-relay-repository.interface';
import { IMAGE_PROCESSOR_SERVICE } from '../interfaces/services/image-processor-service.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import { MEDIA_MAINTENANCE_SERVICE } from '../interfaces/services/media-maintenance-service.interface';
import { MEDIA_PROCESSING_SERVICE } from '../interfaces/services/media-processing-service.interface';
import { MEDIA_TRANSCODER_SERVICE } from '../interfaces/services/media-transcoder-service.interface';
import { MEMORY_MAINTENANCE_SERVICE } from '../interfaces/services/memory-maintenance-service.interface';
import { OBJECT_STORAGE_SERVICE } from '../interfaces/services/object-storage-service.interface';
import { OUTBOX_RELAY_SERVICE } from '../interfaces/services/outbox-relay-service.interface';
import { JobExecutionRepository } from '../repositories/job-execution.repository';
import { MediaRepository } from '../repositories/media.repository';
import { MemoryContentRepository } from '../repositories/memory-content.repository';
import { OutboxRelayRepository } from '../repositories/outbox-relay.repository';
import { ImageProcessorService } from '../services/image-processor.service';
import { JobQueueService } from '../services/job-queue.service';
import { JobRunnerService } from '../services/job-runner.service';
import { MediaMaintenanceService } from '../services/media-maintenance.service';
import { MediaProcessingService } from '../services/media-processing.service';
import { MediaTranscoderService } from '../services/media-transcoder.service';
import { MemoryMaintenanceService } from '../services/memory-maintenance.service';
import { ObjectStorageService } from '../services/object-storage.service';
import { OutboxRelayService } from '../services/outbox-relay.service';
import { MaintenanceQueueWorker } from './maintenance.worker';
import { MediaQueueWorker } from './media.worker';
import { OutboxRelayLoop } from './outbox-relay.loop';
import { WorkerHeartbeat } from './worker-heartbeat';
import { WeeklyRecapQueueWorker } from './weekly-recap.worker';
import { FamilyErasureQueueWorker } from './family-erasure.worker';
import { FamilyErasureService } from '../services/family-erasure.service';
import { FamilyErasureRepository } from '../repositories/family-erasure.repository';
import { FAMILY_ERASURE_SERVICE } from '../interfaces/services/family-erasure-service.interface';
import { FAMILY_ERASURE_REPOSITORY } from '../interfaces/repositories/family-erasure-repository.interface';
import { PROFILE_IMAGE_CLEANUP_SERVICE } from '../interfaces/services/profile-image-cleanup-service.interface';
import { PROFILE_IMAGE_CLEANUP_REPOSITORY } from '../interfaces/repositories/profile-image-cleanup-repository.interface';
import { ProfileImageCleanupService } from '../services/profile-image-cleanup.service';
import { ProfileImageCleanupRepository } from '../repositories/profile-image-cleanup.repository';
import { WeeklyRecapRepository } from '../repositories/weekly-recap.repository';
import { WeeklyRecapService } from '../services/weekly-recap.service';
import { WEEKLY_RECAP_REPOSITORY } from '../interfaces/repositories/weekly-recap-repository.interface';
import { WEEKLY_RECAP_SERVICE } from '../interfaces/services/weekly-recap-service.interface';
import { MODERATION_WORKFLOW_SERVICE } from '../interfaces/services/moderation-workflow-service.interface';
import { MODERATION_WORKFLOW_REPOSITORY } from '../interfaces/repositories/moderation-workflow-repository.interface';
import { ModerationWorkflowService } from '../services/moderation-workflow.service';
import { ModerationWorkflowRepository } from '../repositories/moderation-workflow.repository';
import { SUBSCRIPTION_REMINDER_SERVICE } from '../interfaces/services/subscription-reminder-service.interface';
import { SubscriptionReminderService } from '../services/subscription-reminder.service';
import { SUBSCRIPTION_REMINDER_REPOSITORY } from '../interfaces/repositories/subscription-reminder-repository.interface';
import { SubscriptionReminderRepository } from '../repositories/subscription-reminder.repository';
import { SubscriptionReminderQueueWorker } from './subscription-reminder.worker';
import {
  IAP_BILLING_CONFIG,
  createIapBillingConfig,
} from '../config/iap-billing-policy';
import { IAP_BILLING_REPOSITORY } from '../interfaces/repositories/iap-billing-repository.interface';
import { IapBillingRepository } from '../repositories/iap-billing.repository';
import { IAP_BILLING_SERVICE } from '../interfaces/services/iap-billing-service.interface';
import { IapBillingService } from '../services/iap-billing.service';
import { STORE_PUBLISHER } from '../interfaces/services/store-publisher.interface';
import { StorePublisherService } from '../services/store-publisher.service';
import { STORE_VERIFIER } from '../interfaces/services/store-verifier.interface';
import { StoreVerifierService } from '../services/store-verifier.service';
import { CATALOG_QUERY_REPOSITORY } from '../interfaces/repositories/catalog-query-repository.interface';
import { CatalogQueryRepository } from '../repositories/catalog-query.repository';
import { FAMILY_BILLING_SERVICE } from '../interfaces/services/family-billing-service.interface';
import { FamilyBillingService } from '../services/family-billing.service';
import { IapBillingQueueWorker } from './iap-billing.worker';
import { TRANSACTIONAL_MAIL_SERVICE } from '../interfaces/services/transactional-mail-service.interface';
import { TRANSACTIONAL_MAIL_REPOSITORY } from '../interfaces/repositories/transactional-mail-repository.interface';
import { TransactionalMailService } from '../services/transactional-mail.service';
import { TransactionalMailRepository } from '../repositories/transactional-mail.repository';
import { TransactionalMailQueueWorker } from './transactional-mail.worker';
import { MAIL_SERVICE } from '../interfaces/services/mail-service.interface';
import { MailService } from '../services/mail.service';
import { MEMORY_HEART_AWARD_SERVICE } from '../interfaces/services/memory-heart-award-service.interface';
import { MEMORY_HEART_AWARD_REPOSITORY } from '../interfaces/repositories/memory-heart-award-repository.interface';
import { MemoryHeartAwardService } from '../services/memory-heart-award.service';
import { MemoryHeartAwardRepository } from '../repositories/memory-heart-award.repository';

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
    { provide: MEMORY_HEART_AWARD_SERVICE, useClass: MemoryHeartAwardService },
    {
      provide: MEMORY_HEART_AWARD_REPOSITORY,
      useClass: MemoryHeartAwardRepository,
    },
    { provide: MAIL_SERVICE, useClass: MailService },
    { provide: TRANSACTIONAL_MAIL_SERVICE, useClass: TransactionalMailService },
    {
      provide: TRANSACTIONAL_MAIL_REPOSITORY,
      useClass: TransactionalMailRepository,
    },
    TransactionalMailQueueWorker,
    { provide: IAP_BILLING_CONFIG, useFactory: createIapBillingConfig },
    { provide: IAP_BILLING_REPOSITORY, useClass: IapBillingRepository },
    { provide: IAP_BILLING_SERVICE, useClass: IapBillingService },
    { provide: STORE_PUBLISHER, useClass: StorePublisherService },
    { provide: STORE_VERIFIER, useClass: StoreVerifierService },
    { provide: CATALOG_QUERY_REPOSITORY, useClass: CatalogQueryRepository },
    { provide: FAMILY_BILLING_SERVICE, useClass: FamilyBillingService },
    IapBillingQueueWorker,
    {
      provide: SUBSCRIPTION_REMINDER_REPOSITORY,
      useClass: SubscriptionReminderRepository,
    },
    {
      provide: SUBSCRIPTION_REMINDER_SERVICE,
      useClass: SubscriptionReminderService,
    },
    SubscriptionReminderQueueWorker,
    {
      provide: MODERATION_WORKFLOW_SERVICE,
      useClass: ModerationWorkflowService,
    },
    {
      provide: MODERATION_WORKFLOW_REPOSITORY,
      useClass: ModerationWorkflowRepository,
    },
    { provide: MEMORY_CAPSULE_REPOSITORY, useClass: MemoryCapsuleRepository },
    { provide: MEMORY_CAPSULE_SERVICE, useClass: MemoryCapsuleService },
    MemoryQueueWorker,
    { provide: MISSION_BOARD_REPOSITORY, useClass: MissionBoardRepository },
    { provide: MISSION_SCHEDULE_SERVICE, useClass: MissionScheduleService },
    MissionQueueWorker,
    { provide: PUSH_DELIVERY_REPOSITORY, useClass: PushDeliveryRepository },
    { provide: PUSH_DELIVERY_SERVICE, useClass: PushDeliveryService },
    PUSH_SENDER_PROVIDER,
    PushQueueWorker,
    { provide: BADGE_AWARD_REPOSITORY, useClass: BadgeAwardRepository },
    { provide: BADGE_AWARD_SERVICE, useClass: BadgeAwardService },
    CareQueueWorker,
    {
      provide: EVENT_REMINDER_SCHEDULE_REPOSITORY,
      useClass: EventReminderScheduleRepository,
    },
    {
      provide: EVENT_REMINDER_SCHEDULE_SERVICE,
      useClass: EventReminderScheduleService,
    },
    EventReminderQueueWorker,
    { provide: AUTH_ACCESS_REPOSITORY, useClass: AuthAccessRepository },
    { provide: APPLICATION_ACCESS_SERVICE, useClass: ApplicationAccessService },
    {
      provide: ACCOUNT_DELETION_REPOSITORY,
      useClass: AccountDeletionRepository,
    },
    { provide: ACCOUNT_DELETION_SERVICE, useClass: AccountDeletionService },
    { provide: DATA_EXPORT_REPOSITORY, useClass: DataExportRepository },
    { provide: DATA_EXPORT_SERVICE, useClass: DataExportService },
    {
      provide: NOTIFICATION_INBOX_REPOSITORY,
      useClass: NotificationInboxRepository,
    },
    {
      provide: NOTIFICATION_DISPATCH_SERVICE,
      useClass: NotificationDispatchService,
    },
    NotificationQueueWorker,
    { provide: WEEKLY_RECAP_REPOSITORY, useClass: WeeklyRecapRepository },
    { provide: WEEKLY_RECAP_SERVICE, useClass: WeeklyRecapService },
    WeeklyRecapQueueWorker,
    { provide: FAMILY_ERASURE_REPOSITORY, useClass: FamilyErasureRepository },
    { provide: FAMILY_ERASURE_SERVICE, useClass: FamilyErasureService },
    FamilyErasureQueueWorker,
    {
      provide: PROFILE_IMAGE_CLEANUP_SERVICE,
      useClass: ProfileImageCleanupService,
    },
    {
      provide: PROFILE_IMAGE_CLEANUP_REPOSITORY,
      useClass: ProfileImageCleanupRepository,
    },
    { provide: MEDIA_REPOSITORY, useClass: MediaRepository },
    { provide: JOB_EXECUTION_REPOSITORY, useClass: JobExecutionRepository },
    { provide: OUTBOX_RELAY_REPOSITORY, useClass: OutboxRelayRepository },
    { provide: OBJECT_STORAGE_SERVICE, useClass: ObjectStorageService },
    { provide: IMAGE_PROCESSOR_SERVICE, useClass: ImageProcessorService },
    { provide: MEDIA_TRANSCODER_SERVICE, useClass: MediaTranscoderService },
    { provide: MEDIA_PROCESSING_SERVICE, useClass: MediaProcessingService },
    { provide: MEDIA_MAINTENANCE_SERVICE, useClass: MediaMaintenanceService },
    { provide: MEMORY_CONTENT_REPOSITORY, useClass: MemoryContentRepository },
    { provide: MEMORY_MAINTENANCE_SERVICE, useClass: MemoryMaintenanceService },
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
