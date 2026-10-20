import { Inject, Injectable } from '@nestjs/common';
import { afterPushQuiet, PUSH_POLICY } from '../config/push-policy';
import { PUSH_DELIVERY_REPOSITORY } from '../interfaces/repositories/push-delivery-repository.interface';
import type {
  IPushDeliveryRepository,
  PushCandidate,
  PushDecision,
} from '../interfaces/repositories/push-delivery-repository.interface';
import type { IPushDeliveryService } from '../interfaces/services/push-delivery-service.interface';
import type { JobContext } from '../interfaces/services/job-runner-service.interface';
import { PUSH_SENDER } from '../interfaces/services/push-sender.interface';
import type {
  IPushSender,
  PushSendResult,
} from '../interfaces/services/push-sender.interface';

@Injectable()
export class PushDeliveryService implements IPushDeliveryService {
  constructor(
    @Inject(PUSH_DELIVERY_REPOSITORY)
    private readonly repository: IPushDeliveryRepository,
    @Inject(PUSH_SENDER) private readonly sender: IPushSender,
  ) {}
  async deliver(
    now: Date,
    context: JobContext,
  ): Promise<Record<string, number>> {
    const started = Date.now();
    const currentTime = () =>
      new Date(now.getTime() + Math.max(0, Date.now() - started));
    let processed = 0;
    for (; processed < PUSH_POLICY.batchSize; processed++) {
      context.signal.throwIfAborted();
      const instant = currentTime();
      const candidate = await this.repository.claim(
        instant,
        context.lease,
        (c) => this.decide(c, instant),
      );
      if (!candidate) break;
      const sensitive =
        candidate.sensitive ||
        ['US', 'REQUESTS', 'APPRECIATION', 'BRIDGE'].includes(
          candidate.category,
        );
      const english = candidate.locale.startsWith('en');
      const render = (value: string) =>
        value.replace(/\{\{?(\w+)\}?\}/g, (_match, key: string) => {
          if (!PUSH_POLICY.safeParamKeys.some((allowed) => allowed === key))
            return '';
          const param = candidate.params[key];
          return typeof param === 'string'
            ? param
            : Array.isArray(param)
              ? param
                  .filter((v): v is string => typeof v === 'string')
                  .join(' & ')
              : '';
        });
      let result: PushSendResult;
      try {
        result = await this.sender.send(
          {
            token: candidate.token,
            title: sensitive ? 'Baby Family' : render(candidate.title),
            body: sensitive
              ? english
                ? 'You have a new update from Papa & Mama'
                : 'Bạn có một cập nhật mới từ Papa & Mama'
              : render(candidate.body),
            data: {
              notificationId: candidate.notificationId,
              deepLink: candidate.deepLink,
            },
          },
          context.signal,
        );
      } catch {
        result = { status: 'transient', code: 'PUSH_TRANSPORT_ERROR' };
      }
      context.signal.throwIfAborted();
      await this.repository.finish(
        candidate,
        result,
        currentTime(),
        context.lease,
      );
    }
    return { processed };
  }
  private decide(c: PushCandidate, now: Date): PushDecision {
    if (
      c.category !== 'REQUESTS' &&
      c.priority === 'NORMAL' &&
      c.sentToday >= PUSH_POLICY.nonUrgentPushDailyCap
    )
      return { action: 'skip', code: 'SKIPPED_CAP' };
    let at = now;
    if (!c.bypass) {
      if (c.quietUntil && c.quietUntil > at) at = c.quietUntil;
      at = afterPushQuiet(at, c.timezone, c.quietStart, c.quietEnd);
    }
    return at > now ? { action: 'delay', at } : { action: 'send' };
  }
}
