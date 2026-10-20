import { Inject, Injectable, Logger } from '@nestjs/common';
import type { OnApplicationBootstrap, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { UnrecoverableError, Worker } from 'bullmq';
import type { Job } from 'bullmq';
import type { Redis } from 'ioredis';
import { PermanentJobError } from '../common/errors/job.error';
import type { Environment } from '../config/environment';
import { EVENT_REMINDER_POLICY } from '../config/event-reminder-policy';
import { JOBS, QUEUES } from '../config/jobs';
import { EVENT_REMINDER_SCHEDULE_SERVICE } from '../interfaces/services/event-reminder-schedule-service.interface';
import type { IEventReminderScheduleService } from '../interfaces/services/event-reminder-schedule-service.interface';
import { JOB_QUEUE_SERVICE } from '../interfaces/services/job-queue-service.interface';
import type { IJobQueueService } from '../interfaces/services/job-queue-service.interface';
import { JOB_RUNNER_SERVICE } from '../interfaces/services/job-runner-service.interface';
import type { IJobRunnerService } from '../interfaces/services/job-runner-service.interface';
import {
  createQueueConnection,
  drainWorker,
  postponeIfBusy,
} from './queue-connection';
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
@Injectable()
export class EventReminderQueueWorker
  implements OnApplicationBootstrap, OnModuleDestroy
{
  private readonly logger = new Logger(EventReminderQueueWorker.name);
  private worker: Worker | null = null;
  private connection: Redis | null = null;
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
    @Inject(JOB_RUNNER_SERVICE) private readonly runner: IJobRunnerService,
    @Inject(EVENT_REMINDER_SCHEDULE_SERVICE)
    private readonly reminders: IEventReminderScheduleService,
  ) {}
  async onApplicationBootstrap(): Promise<void> {
    const url = this.config.get('REDIS_URL', { infer: true });
    if (!url) throw new Error('REDIS_URL is required for the worker.');
    await this.queue.schedule(
      JOBS.planEventReminders,
      EVENT_REMINDER_POLICY.plannerEveryMs,
    );
    await this.queue.schedule(
      JOBS.dispatchEventReminders,
      EVENT_REMINDER_POLICY.dispatcherEveryMs,
    );
    this.worker = new Worker(
      QUEUES.eventReminders,
      (job, token) => this.handle(job, token),
      {
        connection: (this.connection = createQueueConnection(url)),
        maxStalledCount: JOBS.planEventReminders.maxAttempts,
        concurrency: 2,
      },
    );
    this.worker.on('failed', (job, error) =>
      this.logger.warn(`Job ${job?.name ?? '?'} failed: ${error.name}`),
    );
  }
  async onModuleDestroy(): Promise<void> {
    await drainWorker(this.worker, this.connection);
  }
  private async handle(job: Job, token?: string): Promise<string> {
    const planner = job.name === JOBS.planEventReminders.name;
    if (!planner && job.name !== JOBS.dispatchEventReminders.name)
      throw new UnrecoverableError('Invalid reminder job.');
    // Existing relay passes aggregate id as assetId and the outbox event id as eventId.
    const data = job.data as { assetId?: unknown; eventId?: unknown };
    const changedEventId = data.assetId;
    if (
      changedEventId !== undefined &&
      (!planner ||
        typeof changedEventId !== 'string' ||
        !UUID.test(changedEventId) ||
        typeof data.eventId !== 'string' ||
        !UUID.test(data.eventId))
    )
      throw new UnrecoverableError('Invalid event change reference.');
    const policy = planner
      ? JOBS.planEventReminders
      : JOBS.dispatchEventReminders;
    const every = planner
      ? EVENT_REMINDER_POLICY.plannerEveryMs
      : EVENT_REMINDER_POLICY.dispatcherEveryMs;
    const period = new Date(Math.floor(job.timestamp / every) * every);
    try {
      return await this.runner.execute(
        policy,
        {
          scopeKey:
            typeof changedEventId === 'string' ? changedEventId : 'GLOBAL',
          scheduledFor:
            typeof changedEventId === 'string'
              ? new Date(job.timestamp)
              : period,
          idempotencyKey: `${policy.name}:${typeof changedEventId === 'string' ? String(data.eventId) : period.toISOString()}`,
        },
        (context) =>
          planner
            ? this.reminders.plan(
                new Date(),
                context,
                typeof changedEventId === 'string' ? changedEventId : undefined,
              )
            : this.reminders.dispatch(new Date(), context),
      );
    } catch (error) {
      if (error instanceof PermanentJobError)
        throw new UnrecoverableError(error.code);
      await postponeIfBusy(error, job, token);
      throw error;
    }
  }
}
