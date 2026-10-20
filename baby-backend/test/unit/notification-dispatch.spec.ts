import { NotificationDispatchService } from '../../src/services/notification-dispatch.service';
import type { INotificationInboxRepository } from '../../src/interfaces/repositories/notification-inbox-repository.interface';
import type { JobContext } from '../../src/interfaces/services/job-runner-service.interface';
import { JobLease } from '../../src/models/job-lease.model';
import {
  NotificationDispatchSnapshot,
  NotificationRecipient,
} from '../../src/models/notification-inbox-dispatch.model';
import type { NotificationDispatchDecision } from '../../src/models/notification-inbox-dispatch.model';

const recipient = (overrides: Partial<NotificationRecipient> = {}) =>
  new NotificationRecipient({
    userId: 'partner',
    role: 'PARENT',
    canView: true,
    isAuthor: true,
    isParticipant: false,
    isPartner: true,
    isTarget: true,
    locale: 'vi',
    timezone: 'Asia/Ho_Chi_Minh',
    prefs: {},
    quietStart: '22:00',
    quietEnd: '06:30',
    requestSoonBypassQuiet: false,
    pushCountToday: 0,
    ...overrides,
  });
const snapshot = (overrides: Partial<NotificationDispatchSnapshot> = {}) =>
  new NotificationDispatchSnapshot({
    eventId: 'event',
    eventType: 'memory.published',
    familyId: 'family',
    subjectId: 'memory',
    createdAt: new Date('2026-10-18T03:00:00Z'),
    now: new Date('2026-10-18T03:00:00Z'),
    actorUserId: 'actor',
    candidates: [recipient()],
    params: {
      memoryId: 'memory',
      childIds: ['a', 'b'],
      childNames: ['A', 'B'],
    },
    urgency: 'NORMAL',
    requestKind: 'TASK',
    reactionRemoved: false,
    ...overrides,
  });
const context: JobContext = {
  signal: new AbortController().signal,
  lease: new JobLease('run', 1, 1n, 3, 'worker'),
};
async function resolve(value: NotificationDispatchSnapshot) {
  let decisions: NotificationDispatchDecision[] = [];
  const consume = jest.fn(
    (
      _id: string,
      _lease: JobLease,
      decide: (
        input: NotificationDispatchSnapshot,
      ) => NotificationDispatchDecision[],
    ) => {
      decisions = decide(value);
      return Promise.resolve(decisions.length);
    },
  );
  const service = new NotificationDispatchService({
    consume,
  } as unknown as INotificationInboxRepository);
  const outcome = await service.dispatch(value.eventId, context);
  return { decisions, consume, outcome };
}
describe('NotificationDispatchService', () => {
  it('deduplicates recipients across children and passes the event id and fence to persistence', async () => {
    const result = await resolve(
      snapshot({ candidates: [recipient(), recipient()] }),
    );
    expect(result.decisions).toHaveLength(1);
    expect(result.decisions[0]!.params.childIds).toEqual(['a', 'b']);
    expect(result.consume).toHaveBeenCalledWith(
      'event',
      context.lease,
      expect.any(Function),
    );
    expect(result.outcome).toEqual({ created: 1 });
  });
  it('does not notify a partner who cannot view a PRIVATE memory', async () => {
    expect(
      (await resolve(snapshot({ candidates: [recipient({ canView: false })] })))
        .decisions,
    ).toEqual([]);
  });
  it('notifies author and thread participants except commenter; groups push for 30 minutes', async () => {
    const result = await resolve(
      snapshot({
        eventType: 'comment.created',
        candidates: [
          recipient({ userId: 'actor' }),
          recipient(),
          recipient({
            userId: 'participant',
            isAuthor: false,
            isParticipant: true,
          }),
          recipient({ userId: 'unrelated', isAuthor: false }),
        ],
      }),
    );
    expect(result.decisions.map((item) => item.recipientUserId)).toEqual([
      'partner',
      'participant',
    ]);
    expect(result.decisions[0]!.groupKey).toBe('NOTI_COMMENT_CREATED:memory');
    expect(result.decisions[0]!.pushAt!.toISOString()).toBe(
      '2026-10-18T03:30:00.000Z',
    );
  });
  it('ignores reaction removals and does not notify unrelated participants', async () => {
    expect(
      (
        await resolve(
          snapshot({ eventType: 'reaction.changed', reactionRemoved: true }),
        )
      ).decisions,
    ).toEqual([]);
    const result = await resolve(
      snapshot({
        eventType: 'reaction.changed',
        candidates: [
          recipient(),
          recipient({
            userId: 'participant',
            isAuthor: false,
            isParticipant: true,
          }),
        ],
      }),
    );
    expect(result.decisions.map((item) => item.recipientUserId)).toEqual([
      'partner',
    ]);
  });
  it.each([
    'us.request.sent',
    'us.request.accept',
    'us.request.done',
    'us.request.decline',
    'us.request.acknowledge',
    'us.checkin.shared',
    'us.appreciation.created',
  ])('keeps %s sensitive and excludes Circle', async (eventType) => {
    const result = await resolve(
      snapshot({
        eventType,
        params: {
          actorUserId: 'actor',
          actorName: 'Name',
          childNames: ['Baby'],
          body: 'private',
          hearts: '100',
          checkinId: 'checkin',
        },
        candidates: [
          recipient(),
          recipient({ userId: 'circle', role: 'CIRCLE' }),
        ],
      }),
    );
    expect(result.decisions).toHaveLength(1);
    expect(result.decisions[0]).toMatchObject({
      sensitive: true,
      tab: 'US',
      params: { actorUserId: 'actor' },
    });
    expect(Object.keys(result.decisions[0]!.params)).toEqual(['actorUserId']);
  });
  it('respects category preferences and actor mute on the recipient only', async () => {
    for (const prefs of [
      { categories: { MEMORIES: false } },
      { MEMORIES: false },
      { MEMORY: false },
      { categories: { MEMORY: false } },
      { MEMORY: false, MEMORIES: true },
      { MEMORY: false, categories: { MEMORIES: true } },
      { mutedUserIds: ['actor'] },
      { blockedUserIds: ['actor'] },
    ])
      expect(
        (await resolve(snapshot({ candidates: [recipient({ prefs })] })))
          .decisions,
      ).toEqual([]);
  });
  it('delegates cap reservation to atomic persistence after quiet-hour scheduling', async () => {
    const result = await resolve(
      snapshot({
        now: new Date('2026-10-18T15:00:00Z'),
        candidates: [recipient({ pushCountToday: 3 })],
      }),
    );
    expect(result.decisions).toHaveLength(1);
    expect(result.decisions[0]!.pushAt!.toISOString()).toBe(
      '2026-10-18T23:30:00.000Z',
    );
  });
  it('delays quiet-hour pushes to 06:30 local time', async () => {
    const result = await resolve(
      snapshot({ now: new Date('2026-10-18T15:00:00Z') }),
    );
    expect(result.decisions[0]!.pushAt!.toISOString()).toBe(
      '2026-10-18T23:30:00.000Z',
    );
  });
  it('lets only recipient-opted-in SOON requests bypass quiet hours', async () => {
    const value = snapshot({
      eventType: 'us.request.sent',
      urgency: 'SOON',
      now: new Date('2026-10-18T15:00:00Z'),
    });
    expect((await resolve(value)).decisions[0]!.pushAt!.toISOString()).toBe(
      '2026-10-18T23:30:00.000Z',
    );
    value.candidates = [recipient({ requestSoonBypassQuiet: true })];
    expect((await resolve(value)).decisions[0]!.pushAt!.toISOString()).toBe(
      '2026-10-18T15:00:00.000Z',
    );
  });
  it('shapes child identifiers and names per Circle recipient', async () => {
    const result = await resolve(
      snapshot({
        eventType: 'comment.created',
        candidates: [
          recipient({ role: 'CIRCLE', childIds: ['a'], childNames: ['A'] }),
        ],
      }),
    );
    expect(result.decisions[0]!.params.childIds).toEqual(['a']);
    expect(result.decisions[0]!.params.childNames).toEqual(['A']);
  });
  it('respects an active shared quiet need before normal quiet hours', async () => {
    const result = await resolve(
      snapshot({
        candidates: [
          recipient({ quietUntil: new Date('2026-10-18T05:00:00Z') }),
        ],
      }),
    );
    expect(result.decisions[0]!.pushAt!.toISOString()).toBe(
      '2026-10-18T05:00:00.000Z',
    );
  });
  it.each([
    'memory.review_requested',
    'memory.submitted',
    'memory.approved',
    'memory.rejected',
  ])(
    'keeps %s generic, applies quiet hours and respects memory preferences',
    async (eventType) => {
      const pending = ['memory.review_requested', 'memory.submitted'].includes(
        eventType,
      );
      const candidates = [
        recipient({ userId: 'parent', isAuthor: false }),
        recipient({ userId: 'circle', role: 'CIRCLE', isAuthor: true }),
        recipient({ userId: 'other-circle', role: 'CIRCLE', isAuthor: false }),
      ];
      const value = snapshot({
        eventType,
        candidates,
        now: new Date('2026-10-18T15:00:00Z'),
        params: {
          actorUserId: 'actor',
          familyId: 'family',
          entityId: 'memory',
          childNames: ['Private name'],
          caption: 'Private caption',
          reason: 'Private reason',
        },
      });
      const result = await resolve(value);
      expect(result.decisions.map((row) => row.recipientUserId)).toEqual([
        pending ? 'parent' : 'circle',
      ]);
      expect(result.decisions[0]).toMatchObject({
        tab: 'FAMILY',
        category: 'MEMORIES',
        priority: 'NORMAL',
        params: {
          actorUserId: 'actor',
          familyId: 'family',
          entityId: 'memory',
        },
      });
      expect(result.decisions[0]!.pushAt!.toISOString()).toBe(
        '2026-10-18T23:30:00.000Z',
      );
      expect(JSON.stringify(result.decisions)).not.toContain('Private');
      value.candidates = candidates.map((row) =>
        recipient({ ...row, prefs: { MEMORY: false } }),
      );
      expect((await resolve(value)).decisions).toEqual([]);
    },
  );
  it('ignores silent transitions and unsupported events', async () => {
    for (const eventType of [
      'us.request.expired',
      'us.request.seen',
      'us.request.cancel',
      'us.appreciation.reacted',
    ])
      expect((await resolve(snapshot({ eventType }))).decisions).toEqual([]);
  });
});
