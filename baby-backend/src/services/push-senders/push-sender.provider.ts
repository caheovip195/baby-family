import type { FactoryProvider } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { readFile } from 'node:fs/promises';
import type { Environment } from '../../config/environment';
import {
  PUSH_SENDER,
  type IPushSender,
} from '../../interfaces/services/push-sender.interface';
import { FcmPushSender } from './fcm-push-sender';
import { LogPushSender } from './log-push-sender';

export const PUSH_SENDER_PROVIDER: FactoryProvider<IPushSender> = {
  provide: PUSH_SENDER,
  inject: [ConfigService],
  useFactory: async (config: ConfigService<Environment, true>) => {
    // Test composition roots never access credentials or the network.
    if (config.get('NODE_ENV', { infer: true }) === 'test')
      return new LogPushSender();
    const projectId = config.get('FCM_PROJECT_ID', { infer: true });
    const json = config.get('FCM_SERVICE_ACCOUNT_JSON', { infer: true });
    const file = config.get('FCM_SERVICE_ACCOUNT_FILE', { infer: true });
    if (!projectId && !json && !file) return new LogPushSender();
    if (!projectId || Boolean(json) === Boolean(file))
      throw new Error(
        'FCM requires project ID and exactly one credential source',
      );
    let credentials: string;
    try {
      credentials = json ?? (await readFile(file!, 'utf8'));
    } catch {
      throw new Error('Cannot read FCM service-account credentials');
    }
    return new FcmPushSender(projectId, credentials);
  },
};
