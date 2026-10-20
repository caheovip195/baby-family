import { Logger } from '@nestjs/common';
import type {
  IPushSender,
  PushMessage,
  PushSendResult,
} from '../../interfaces/services/push-sender.interface';

/** Disabled sink: no content/token is logged, and a skipped send is never success. */
export class LogPushSender implements IPushSender {
  private readonly logger = new Logger(LogPushSender.name);

  send(_message: PushMessage, _signal: AbortSignal): Promise<PushSendResult> {
    this.logger.debug('Push provider disabled; no push sent');
    return Promise.resolve({ status: 'disabled', code: 'PUSH_DISABLED' });
  }
}
