import { Injectable } from '@nestjs/common';
import type { OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createTransport } from 'nodemailer';
import type { Transporter } from 'nodemailer';
import {
  ServiceUnavailableError,
  ValidationError,
} from '../common/errors/domain.error';
import type { Environment } from '../config/environment';
import type {
  IMailService,
  MailMessage,
  SentMail,
} from '../interfaces/services/mail-service.interface';

const MAX_RECIPIENTS = 50;
// Pragmatic address check; nodemailer still validates/encodes headers itself.
const ADDRESS_PATTERN = /^[^\s@<>",;]+@[^\s@<>",;]+\.[^\s@<>",;]+$/;

@Injectable()
/** SMTP adapter (Mailpit locally). */
export class MailService implements IMailService, OnModuleDestroy {
  private readonly transporter: Transporter | null;
  private readonly from: string;

  constructor(config: ConfigService<Environment, true>) {
    this.from = config.get('SMTP_FROM', { infer: true });
    const host = config.get('SMTP_HOST', { infer: true });
    const user = config.get('SMTP_USER', { infer: true });
    const pass = config.get('SMTP_PASSWORD', { infer: true });
    this.transporter = host
      ? createTransport({
          host,
          port: config.get('SMTP_PORT', { infer: true }),
          secure: config.get('SMTP_SECURE', { infer: true }),
          requireTLS: config.get('SMTP_REQUIRE_TLS', { infer: true }),
          auth: user && pass ? { user, pass } : undefined,
          connectionTimeout: 5000,
          greetingTimeout: 5000,
          socketTimeout: 10000,
        })
      : null;
  }

  isConfigured(): boolean {
    return this.transporter !== null;
  }

  async send(message: MailMessage): Promise<SentMail> {
    if (!this.transporter) {
      throw new ServiceUnavailableError('Mail is not configured.');
    }
    const to = Array.isArray(message.to) ? message.to : [message.to];
    if (
      to.length === 0 ||
      to.length > MAX_RECIPIENTS ||
      to.some((address) => !ADDRESS_PATTERN.test(address))
    ) {
      throw new ValidationError('Mail recipients are invalid.');
    }
    if (message.subject.trim().length === 0 || /[\r\n]/.test(message.subject)) {
      throw new ValidationError('Mail subject is invalid.');
    }
    try {
      const info = await this.transporter.sendMail({
        from: this.from,
        to,
        subject: message.subject,
        text: message.text,
        html: message.html,
      });
      return { messageId: String(info.messageId) };
    } catch {
      // SMTP errors may echo addresses; keep them out of API responses/logs.
      throw new ServiceUnavailableError('Mail delivery is unavailable.');
    }
  }

  onModuleDestroy(): void {
    this.transporter?.close();
  }
}
