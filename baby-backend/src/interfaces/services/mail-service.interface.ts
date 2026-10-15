export const MAIL_SERVICE = Symbol('MAIL_SERVICE');

export interface MailMessage {
  to: string | string[];
  subject: string;
  text: string;
  html?: string;
}

export interface SentMail {
  messageId: string;
}

/** Outbound email (SMTP; Mailpit locally). Throws ServiceUnavailableError when not configured. */
export interface IMailService {
  isConfigured(): boolean;
  send(message: MailMessage): Promise<SentMail>;
}
