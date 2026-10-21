import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  JOB_QUEUE_SERVICE,
  type IJobQueueService,
} from '../interfaces/services/job-queue-service.interface';
import { TRANSACTIONAL_MAIL_JOBS } from '../config/transactional-mail-policy';
import { DomainError } from '../common/errors/domain.error';
import { PermanentJobError } from '../common/errors/job.error';
import {
  TRANSACTIONAL_MAIL_POLICY as POLICY,
  TRANSACTIONAL_MAIL_TEMPLATES as TEMPLATES,
} from '../config/transactional-mail-policy';
import {
  TRANSACTIONAL_MAIL_REPOSITORY,
  type ITransactionalMailRepository,
} from '../interfaces/repositories/transactional-mail-repository.interface';
import {
  MAIL_SERVICE,
  type IMailService,
} from '../interfaces/services/mail-service.interface';
import {
  OBJECT_STORAGE_SERVICE,
  type IObjectStorageService,
} from '../interfaces/services/object-storage-service.interface';
import type { ITransactionalMailService } from '../interfaces/services/transactional-mail-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';

@Injectable()
export class TransactionalMailService implements ITransactionalMailService {
  private readonly logger = new Logger(TransactionalMailService.name);
  constructor(
    @Inject(TRANSACTIONAL_MAIL_REPOSITORY)
    private readonly repository: ITransactionalMailRepository,
    @Inject(MAIL_SERVICE) private readonly mail: IMailService,
    @Inject(OBJECT_STORAGE_SERVICE)
    private readonly storage: IObjectStorageService,
    private readonly config: ConfigService,
    @Inject(JOB_QUEUE_SERVICE) private readonly queue: IJobQueueService,
  ) {}
  async deliver(eventId: string, context: JobContext) {
    context.signal.throwIfAborted();
    const row = await this.repository.find(eventId, new Date());
    if (!row) {
      await this.repository.checkpoint(
        eventId,
        'READY',
        'SKIPPED',
        context.lease,
      );
      return { sent: 0 };
    }
    if (row.state === 'SENT' || row.state === 'SKIPPED') return { sent: 0 };
    if (row.state === 'SENDING' || row.state === 'UNKNOWN') {
      await this.repository.checkpoint(
        eventId,
        row.state,
        'UNKNOWN',
        context.lease,
      );
      this.logger.error(
        'Transactional SMTP outcome unknown; inspect delivery checkpoint before manual recovery.',
      );
      throw new PermanentJobError(
        'MAIL_OUTCOME_UNKNOWN',
        'SMTP outcome requires reconciliation.',
      );
    }
    if (!row.email) {
      await this.repository.checkpoint(
        eventId,
        'READY',
        'SKIPPED',
        context.lease,
      );
      return { sent: 0 };
    }
    if (
      !this.mail.isConfigured() ||
      (this.config.get<string>('NODE_ENV') === 'production' &&
        !this.config.get<string>('MAIL_HOST'))
    )
      throw new DomainError(
        'Transactional mail unavailable.',
        'TRANSACTIONAL_MAIL_UNAVAILABLE',
        503,
      );
    const locale = row.locale.startsWith('en') ? 'en' : 'vi';
    const [subject, body] = TEMPLATES[locale][row.kind];
    const formatTime = (date: Date) =>
      new Intl.DateTimeFormat(locale, {
        timeZone: row.timezone,
        dateStyle: 'long',
        timeStyle: 'short',
      }).format(date) + ` (${row.timezone})`;
    let suffix = row.deadline ? formatTime(row.deadline) : '';
    if (row.storageKey && row.deadline) {
      const signed = await this.storage.createDownloadUrl({
        bucket: 'exports',
        key: row.storageKey,
        expiresInSeconds: Math.min(
          POLICY.downloadTtlSeconds,
          Math.max(1, Math.floor((row.deadline.getTime() - Date.now()) / 1000)),
        ),
      });
      suffix = `${signed.url}\n${formatTime(signed.expiresAt)}`;
    }
    context.signal.throwIfAborted();
    if (
      !(await this.repository.checkpoint(
        eventId,
        'READY',
        'SENDING',
        context.lease,
      ))
    )
      return { sent: 0 };
    try {
      await this.mail.send({
        to: row.email,
        subject,
        text: `${body}\n${suffix}\n\nBaby Family · v${POLICY.version}`,
        messageId: `<bf-${eventId}@transactional.babyfamily.vn>`,
      });
    } catch (error) {
      // A socket failure can occur after SMTP accepted the message. Do not auto-resend
      // an ambiguous outcome. Pre-send failures (configuration/storage) retry normally.
      await this.repository.checkpoint(
        eventId,
        'SENDING',
        error instanceof DomainError && error.code === 'MAIL_DELIVERY_RETRYABLE'
          ? 'READY'
          : 'UNKNOWN',
        context.lease,
      );
      throw error;
    }
    context.signal.throwIfAborted();
    if (
      !(await this.repository.checkpoint(
        eventId,
        'SENDING',
        'SENT',
        context.lease,
      ))
    )
      throw new DomainError('Job lease expired.', 'JOB_LEASE_LOST', 409);
    return { sent: 1 };
  }
  async reconcile(
    now: Date,
    context: JobContext,
    familyId?: string,
    userId?: string,
  ) {
    context.signal.throwIfAborted();
    const planned = await this.repository.reconcile(
      now,
      context.lease,
      familyId,
      userId,
    );
    let recovered = 0;
    for (const eventId of await this.repository.pending(
      POLICY.batchSize,
      familyId,
      userId,
    )) {
      context.signal.throwIfAborted();
      await this.queue.enqueue(
        TRANSACTIONAL_MAIL_JOBS.deliver,
        `evt-${eventId}`,
        { eventId },
      );
      recovered++;
    }
    return { planned, recovered };
  }
}
