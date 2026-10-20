export const OTP_SENDER_SERVICE = Symbol('OTP_SENDER_SERVICE');

export type OtpChannel = 'ZALO' | 'SMS' | 'MAIL';

export interface OtpMessage {
  phoneE164: string;
  code: string;
  locale: string;
  requestedChannel: OtpChannel;
}

/**
 * Delivers sign-in codes (spec §5.3 `OtpSender`). The local implementation writes to
 * the Mailpit sink; Zalo ZNS/SMS providers plug in behind the same contract.
 * Throws ServiceUnavailableError when no delivery channel is configured.
 */
export interface IOtpSenderService {
  isConfigured(): boolean;
  send(message: OtpMessage): Promise<{ channelUsed: OtpChannel }>;
}
