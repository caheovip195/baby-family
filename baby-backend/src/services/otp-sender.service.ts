import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Environment } from '../config/environment';
import { ServiceUnavailableError } from '../common/errors/domain.error';
import { MAIL_SERVICE } from '../interfaces/services/mail-service.interface';
import type { IMailService } from '../interfaces/services/mail-service.interface';
import type {
  IOtpSenderService,
  OtpChannel,
  OtpMessage,
} from '../interfaces/services/otp-sender-service.interface';

/**
 * OTP delivery selected by AUTH_OTP_DELIVERY. `mail` is a development sink only
 * (environment validation rejects it in production); no real SMS/Zalo provider is
 * integrated yet, so `disabled` fails closed.
 */
@Injectable()
export class OtpSenderService implements IOtpSenderService {
  constructor(
    private readonly config: ConfigService<Environment, true>,
    @Inject(MAIL_SERVICE) private readonly mail: IMailService,
  ) {}

  isConfigured(): boolean {
    return (
      this.config.get('AUTH_OTP_DELIVERY', { infer: true }) === 'mail' &&
      this.mail.isConfigured()
    );
  }

  async send(message: OtpMessage): Promise<{ channelUsed: OtpChannel }> {
    if (!this.isConfigured())
      throw new ServiceUnavailableError('Sign-in codes cannot be sent now.');
    const masked = `${message.phoneE164.slice(0, 4)}••••${message.phoneE164.slice(-3)}`;
    await this.mail.send({
      to: this.config.get('AUTH_OTP_MAIL_TO', { infer: true }),
      subject: `[DEV OTP] ${masked}`,
      text: `Baby Family sign-in code for ${message.phoneE164}: ${message.code}\nRequested channel: ${message.requestedChannel}. This local sink replaces SMS/Zalo in development.`,
    });
    return { channelUsed: 'MAIL' };
  }
}
