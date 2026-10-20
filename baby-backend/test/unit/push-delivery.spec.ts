import { afterPushQuiet, pushTimezone } from '../../src/config/push-policy';
import { PushCandidate } from '../../src/interfaces/repositories/push-delivery-repository.interface';
import type {
  IPushDeliveryRepository,
  PushDecision,
} from '../../src/interfaces/repositories/push-delivery-repository.interface';
import type { IPushSender } from '../../src/interfaces/services/push-sender.interface';
import { PushDeliveryService } from '../../src/services/push-delivery.service';
import { JobLease } from '../../src/models/job-lease.model';

function candidate(): PushCandidate {
  return new PushCandidate(
    'delivery',
    1,
    'token',
    'vi',
    'Asia/Ho_Chi_Minh',
    'notification',
    'MEMORIES',
    'NORMAL',
    false,
    'babyfamily://care/badges',
    { actorName: 'Papa', secret: 'private' },
    'Hello {{actorName}}',
    '{{secret}} update',
    null,
    null,
    '22:00',
    '06:30',
    null,
    false,
    0,
  );
}

describe('Push delivery policy', () => {
  it('delays overnight hours to the local end, including DST transition', () => {
    expect(
      afterPushQuiet(
        new Date('2030-01-01T16:00Z'),
        'Asia/Ho_Chi_Minh',
        '22:00',
        '06:30',
      ),
    ).toEqual(new Date('2030-01-01T23:30Z'));
    expect(
      afterPushQuiet(
        new Date('2026-03-08T06:30Z'),
        'America/New_York',
        '22:00',
        '06:30',
      ),
    ).toEqual(new Date('2026-03-08T10:30Z'));
    const now = new Date('2030-01-01T23:30Z');
    expect(afterPushQuiet(now, 'Asia/Ho_Chi_Minh', '22:00', '06:30')).toEqual(
      now,
    );
    expect(pushTimezone('invalid/timezone')).toBe('Asia/Ho_Chi_Minh');
  });

  async function deliver(
    value: PushCandidate,
    now = new Date('2030-01-01T02:00Z'),
    fail = false,
  ) {
    let decision: PushDecision | undefined;
    let claimed = false;
    const finish = jest.fn(() => Promise.resolve());
    const repository: IPushDeliveryRepository = {
      claim: (_now, _lease, decide) => {
        if (claimed) return Promise.resolve(null);
        claimed = true;
        decision = decide(value);
        return Promise.resolve(decision.action === 'send' ? value : null);
      },
      finish,
    };
    const send = jest.fn<
      ReturnType<IPushSender['send']>,
      Parameters<IPushSender['send']>
    >();
    if (fail) send.mockRejectedValue(new Error('Provider leaked secret'));
    else send.mockResolvedValue({ status: 'sent', messageId: 'provider' });
    await new PushDeliveryService(repository, { send }).deliver(now, {
      signal: new AbortController().signal,
      lease: new JobLease('run', 1, 1n, 3, 'test'),
    });
    return { decision, send, finish };
  }

  it('only interpolates approved parameters and sends only identifiers in data', async () => {
    const result = await deliver(candidate());
    expect(result.send.mock.calls[0]?.[0]).toEqual({
      token: 'token',
      title: 'Hello Papa',
      body: ' update',
      data: {
        notificationId: 'notification',
        deepLink: 'babyfamily://care/badges',
      },
    });
  });
  it('always hides sensitive content even when template has unsafe copy', async () => {
    const result = await deliver({
      ...candidate(),
      sensitive: true,
      title: 'secret',
      body: 'private',
    });
    expect(result.send.mock.calls[0]?.[0]).toMatchObject({
      title: 'Baby Family',
      body: 'Bạn có một cập nhật mới từ Papa & Mama',
    });
  });
  it('caps normal pushes and postpones quiet hours without invoking sender', async () => {
    const capped = await deliver({ ...candidate(), sentToday: 3 });
    expect(capped.decision).toEqual({ action: 'skip', code: 'SKIPPED_CAP' });
    expect(capped.send).not.toHaveBeenCalled();
    const quiet = await deliver(candidate(), new Date('2030-01-01T16:00Z'));
    expect(quiet.decision).toEqual({
      action: 'delay',
      at: new Date('2030-01-01T23:30Z'),
    });
    expect(quiet.send).not.toHaveBeenCalled();
  });
  it('honors an already-authorized urgent quiet-hours bypass decision', async () => {
    const result = await deliver(
      {
        ...candidate(),
        category: 'REQUESTS',
        priority: 'HIGH',
        bypass: true,
        sentToday: 3,
      },
      new Date('2030-01-01T16:00Z'),
    );
    expect(result.decision).toEqual({ action: 'send' });
    expect(result.send).toHaveBeenCalledTimes(1);
  });
  it('rechecks the clock when a batch crosses into quiet hours', async () => {
    const started = 1000;
    const clock = jest.spyOn(Date, 'now').mockReturnValue(started);
    const decisions: PushDecision[] = [];
    let claimed = 0;
    const repository: IPushDeliveryRepository = {
      claim: (_now, _lease, decide) => {
        const decision = decide(candidate());
        decisions.push(decision);
        return Promise.resolve(
          claimed++ === 0 && decision.action === 'send' ? candidate() : null,
        );
      },
      finish: () => Promise.resolve(),
    };
    const sender: IPushSender = {
      send: () => {
        clock.mockReturnValue(started + 2000);
        return Promise.resolve({ status: 'sent', messageId: 'provider' });
      },
    };
    try {
      await new PushDeliveryService(repository, sender).deliver(
        new Date('2030-01-01T14:59:59Z'),
        {
          signal: new AbortController().signal,
          lease: new JobLease('run', 1, 1n, 3, 'test'),
        },
      );
      expect(decisions).toEqual([
        { action: 'send' },
        { action: 'delay', at: new Date('2030-01-01T23:30Z') },
      ]);
    } finally {
      clock.mockRestore();
    }
  });
  it('sanitizes thrown provider errors for durable retry', async () => {
    const result = await deliver(candidate(), undefined, true);
    expect(result.finish.mock.calls[0]).toContainEqual({
      status: 'transient',
      code: 'PUSH_TRANSPORT_ERROR',
    });
  });
});
