import 'package:baby_family/data/model/care/badge_progress_record.dart';
import 'package:baby_family/data/model/care/badge_record.dart';
import 'package:baby_family/data/model/care/calendar_event.dart';
import 'package:baby_family/data/model/care/calendar_event_record.dart';
import 'package:baby_family/data/model/care/calendar_record.dart';
import 'package:baby_family/data/model/care/calendar_special_day_record.dart';
import 'package:baby_family/data/model/care/event_participant_record.dart';
import 'package:baby_family/data/model/care/event_reminder_rule_record.dart';
import 'package:baby_family/data/model/care/family_tree_record.dart';
import 'package:baby_family/data/model/care/family_tree_today_record.dart';
import 'package:baby_family/data/model/care/heart_history_record.dart';
import 'package:baby_family/data/model/care/hearts_me_record.dart';
import 'package:baby_family/data/model/care/mission_board_record.dart';
import 'package:baby_family/data/model/care/mission_history_page.dart';
import 'package:baby_family/data/model/care/mission_preferences_record.dart';
import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:baby_family/data/model/care/mission_result_record.dart';
import 'package:baby_family/data/model/care/mission_series_record.dart';
import 'package:baby_family/data/model/care/mission_settings_record.dart';
import 'package:baby_family/data/model/care/mission_swap_options_record.dart';
import 'package:baby_family/data/model/care/mission_template_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/care_remote.dart';
import 'package:baby_family/data/repository/couple_remote.dart';
import 'package:baby_family/data/service_imp/care_remote.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../helpers/design_qa.dart';

/// API nhiệm vụ giả (BF-20261018-007).
class _FakeCare implements ICareRemoteRepository {
  final tabs = <String>[];
  final actions = <String>[];
  final created = <JsonMap>[];
  final keys = <String>[];
  bool failComplete = false;
  CalendarRecord? calendarRecord;
  final createdEvents = <JsonMap>[];
  final moments = <(String, String, JsonMap)>[];
  final series = <JsonMap>[];
  final settingsCalls = <String>[];
  MissionSettingsRecord settings = const MissionSettingsRecord(
    boardLevel: 'MEDIUM',
    preferences: MissionPreferencesRecord(
      disabledCategories: ['PLAY'],
      boardPushTime: '06:30',
      eveningCarryOver: false,
      defaultReminderMin: 30,
    ),
  );

  final seriesCalls = <String>[];

  @override
  Future<List<MissionSeriesRecord>> missionSeries(String familyId) async => [
    const MissionSeriesRecord(
      id: 's-mine',
      title: 'Uống vitamin',
      ownerKind: 'ME',
      mine: true,
      scheduledTime: '08:30',
      days: ['MO', 'WE', 'SU'],
      pausedRanges: [
        {'from': '2000-01-01', 'to': '2000-01-07'},
        {'from': '2999-01-01', 'to': '2999-01-07'},
      ],
    ),
    const MissionSeriesRecord(
      id: 's-partner',
      title: 'Đi bộ',
      ownerKind: 'PARTNER',
    ),
    const MissionSeriesRecord(
      id: 's-old',
      title: 'Đã hết hạn',
      ownerKind: 'TOGETHER',
      endDate: '2000-01-01',
    ),
  ];

  @override
  Future<void> pauseSeries(String seriesId, String from, String to) async =>
      seriesCalls.add('pause $seriesId $from..$to');

  @override
  Future<void> endSeries(String seriesId) async =>
      seriesCalls.add('end $seriesId');

  @override
  Future<MemoryRecord?> saveMoment(
    String missionId,
    String idempotencyKey,
    JsonMap body,
  ) async {
    moments.add((missionId, idempotencyKey, body));
    return const MemoryRecord(id: 'srv-moment');
  }

  @override
  Future<MissionSeriesRecord?> createSeries(
    String familyId,
    JsonMap body,
  ) async {
    series.add(body);
    return const MissionSeriesRecord(id: 'ser-1');
  }

  @override
  Future<MissionSettingsRecord?> missionSettings(String familyId) async =>
      settings;

  @override
  Future<MissionSettingsRecord?> updateBoardLevel(
    String familyId,
    String level,
  ) async {
    settingsCalls.add('level:$level');
    return settings;
  }

  @override
  Future<MissionSettingsRecord?> updatePreferences(
    String familyId,
    JsonMap patch,
  ) async {
    settingsCalls.add('prefs:$patch');
    return settings;
  }

  static MissionRecord record(
    String id, {
    bool mine = true,
    String status = 'TODO',
    int? hearts = 3,
  }) => MissionRecord(
    id: id,
    title: 'Đọc truyện cho bé',
    category: 'BONDING',
    mine: mine,
    source: 'SYSTEM',
    hearts: hearts,
    status: status,
    scheduledTime: '19:30:00',
    boardDate: '2026-10-10',
    canSwap: true,
  );

  @override
  Future<MissionBoardRecord?> board(
    String familyId, {
    required String tab,
    String? date,
    String? childId,
  }) async {
    tabs.add('$tab@$date');
    return switch (tab) {
      'MINE' => MissionBoardRecord(
        items: [record('m-mine')],
        myHeartsToday: 7,
        swapsLeft: 2,
      ),
      // The server never sends Hearts for the partner's missions.
      'PARTNER' => MissionBoardRecord(
        items: [record('m-partner', mine: false, status: 'DONE', hearts: null)],
      ),
      _ => MissionBoardRecord(items: [record('m-together')]),
    };
  }

  @override
  Future<List<MissionTemplateRecord>> templates(
    String familyId, {
    String? childId,
  }) async => const [
    MissionTemplateRecord(
      id: 't1',
      title: 'Tắm cho bé',
      category: 'CARE',
      hearts: 3,
    ),
  ];

  @override
  Future<MissionRecord?> mission(String missionId) async => record(missionId);

  @override
  Future<MissionResultRecord?> createMission(
    String idempotencyKey,
    JsonMap body,
  ) async {
    created.add(body);
    return MissionResultRecord(mission: record('m-new'));
  }

  @override
  Future<MissionResultRecord?> complete(
    String missionId,
    String idempotencyKey, [
    JsonMap body = const {},
  ]) async {
    keys.add(idempotencyKey);
    if (failComplete) {
      failComplete = false;
      throw DioException(requestOptions: RequestOptions(path: '/complete'));
    }
    return MissionResultRecord(
      mission: record(missionId, status: 'DONE'),
      myHeartsAwarded: 3,
    );
  }

  @override
  Future<MissionResultRecord?> action(
    String missionId,
    String action, [
    JsonMap body = const {},
  ]) async {
    actions.add('$action:$missionId:${body['optionsToken'] ?? ''}');
    return null;
  }

  final historyCalls = <String>[];

  @override
  Future<HeartsMeRecord?> myHearts(String familyId, {int? limit}) async =>
      HeartsMeRecord(
        today: 5,
        week: 12,
        total: 40,
        history: [
          HeartHistoryRecord(
            at: DateTime.utc(2026, 10, 10),
            amount: 3,
            title: 'Tắm cho bé',
          ),
          HeartHistoryRecord(
            at: DateTime.utc(2026, 10, 9),
            amount: 5,
            reason: 'REQUEST_DONE',
          ),
        ],
      );

  @override
  Future<FamilyTreeRecord?> familyTree(String familyId) async =>
      const FamilyTreeRecord(
        level: 3,
        levelName: 'Cây non',
        progressPercent: 42,
        bloomedDaysThisWeek: 2,
        today: FamilyTreeTodayRecord(leaves: 4, total: 6),
      );

  @override
  Future<List<BadgeRecord>> badges(String familyId) async => [
    BadgeRecord(
      code: 'FIRST_WEEK',
      title: 'First week',
      titleI18n: const {'vi': 'Tuần đầu tiên'},
      earned: true,
      achievedAt: DateTime.utc(2026, 10, 1),
    ),
    const BadgeRecord(
      code: 'TEN_TOGETHER',
      title: 'Ten together',
      progress: BadgeProgressRecord(current: 3, target: 10, percent: 30),
    ),
  ];

  @override
  Future<CalendarRecord?> calendar(
    String familyId, {
    required String from,
    required String to,
  }) async => calendarRecord;

  @override
  Future<CalendarEventRecord?> createEvent(JsonMap body) async {
    createdEvents.add(body);
    return CalendarEventRecord(
      id: 'ev-new',
      type: body['type'] as String?,
      title: body['title'] as String?,
      allDay: body['allDay'] as bool? ?? false,
      startAt: DateTime.parse(body['startAt'] as String),
      localStartDate: body['localStartDate'] as String?,
    );
  }

  @override
  Future<MissionHistoryPage?> missionHistory(
    String familyId, {
    required String from,
    required String to,
    required String owner,
    String? cursor,
  }) async {
    historyCalls.add(owner);
    return MissionHistoryPage(
      items: [
        record(
          'h-$owner',
          mine: owner != 'PARTNER',
          status: 'DONE',
          hearts: owner == 'PARTNER' ? null : 3,
        ).copyWith(completedAt: DateTime.utc(2026, 10, 10, 12)),
      ],
    );
  }

  @override
  Future<MissionSwapOptionsRecord?> swapOptions(String missionId) async =>
      const MissionSwapOptionsRecord(
        options: [MissionTemplateRecord(id: 't2', title: 'Đi dạo', hearts: 2)],
        optionsToken: 'token-1',
        swapsLeft: 2,
      );
}

/// Chỉ dùng phần cảm ơn của API Papa & Mama (💛 trên việc bạn đời).
class _FakeThanks implements ICoupleRemoteRepository {
  final bodies = <JsonMap>[];

  @override
  Future<AppreciationRecord?> createAppreciation(
    String familyId,
    JsonMap body,
  ) async {
    bodies.add(body);
    return const AppreciationRecord(id: 'srv-thanks');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeCare remote;
  late _FakeThanks couple;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeCare();
    couple = _FakeThanks();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({
      kValueSessionKeyServerFamilyId: 'srv-family',
      kValueSessionKeyServerUserId: 'srv-me',
    });
  });

  CareRemoteServiceImp service() => CareRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(careRepositoryProvider),
    container.read(childRepositoryProvider),
    container.read(familyRepositoryProvider),
    container.read(memoryRepositoryProvider),
    container.read(usRepositoryProvider),
    remote,
    couple,
    l10n: () => lookupAppLocalizations(const Locale('vi')),
  );

  test(
    'CARE-01: the board comes from the server, partner without Hearts',
    () async {
      final care = service();
      final board = await care.board(date: DateTime(2026, 10, 10));
      expect(
        remote.tabs,
        containsAll(['MINE@2026-10-10', 'PARTNER@2026-10-10']),
      );
      expect(board.mine.single.id, 'm-mine');
      expect(board.mine.single.hearts, 3);
      expect(board.mine.single.dueTime, '19:30');
      expect(board.mine.single.category, MissionCategory.bonding);
      expect(board.partner.single.ownerKind, MissionOwnerKind.partner);
      expect(board.partner.single.hearts, isNull);
      expect(board.partner.single.isDone, isTrue);
      expect(board.together.single.ownerKind, MissionOwnerKind.together);
      expect(board.heartsToday, 7);
      expect(board.swapsLeft, 2);
      expect((await care.templates()).single.title, 'Tắm cho bé');
    },
  );

  test(
    'CARE-06: completing keeps its Idempotency-Key on retry; undo, swap, remove go to the server',
    () async {
      final care = service();
      await care.board(date: DateTime(2026, 10, 10));
      final revision = container.read(mockStoreProvider).revision;
      remote.failComplete = true;
      await expectLater(
        care.completeMission('m-mine'),
        throwsA(isA<DioException>()),
      );
      final done = await care.completeMission('m-mine');
      expect(remote.keys, hasLength(2));
      expect(remote.keys.first, remote.keys.last);
      expect(done.heartsEarned, 3);
      expect(done.mission.isDone, isTrue);
      // The board is re-read by the screens after a server change.
      expect(container.read(mockStoreProvider).revision, greaterThan(revision));

      await care.undoCompletion('m-mine');
      final options = await care.swapOptions('m-mine');
      expect(options.options.single.id, 't2');
      await care.swapMission('m-mine', 't2');
      await care.removeFromToday('m-together');
      expect(remote.actions, [
        'undo:m-mine:',
        'swap:m-mine:token-1',
        'remove:m-together:',
      ]);
    },
  );

  test(
    'CARE-03: only ME or TOGETHER missions are created on the server',
    () async {
      final care = service();
      final mission = await care.createMission(
        title: ' Gấp đồ cho bé ',
        ownerKind: MissionOwnerKind.together,
        date: DateTime(2026, 10, 11),
        dueTime: '20:00',
      );
      expect(remote.created.single, {
        'familyId': 'srv-family',
        'owner': 'TOGETHER',
        'title': 'Gấp đồ cho bé',
        'date': '2026-10-11',
        'scheduledTime': '20:00',
      });
      expect(mission.id, 'm-new');
      await expectLater(
        care.createMission(title: 'x', ownerKind: MissionOwnerKind.partner),
        throwsArgumentError,
      );
      expect(remote.created, hasLength(1));
    },
  );

  test(
    "CARE-01: 💛 on the partner's finished mission is a quick server thanks",
    () async {
      final care = service();
      final board = await care.board(date: DateTime(2026, 10, 10));
      await care.thankPartner(board.partner.single.id);
      expect(couple.bodies.single, {
        'quick': true,
        'linkedType': 'MISSION',
        'linkedId': 'm-partner',
      });
      final again = await care.board(date: DateTime(2026, 10, 10));
      expect(again.partner.single.thankedByPartner, isTrue);
    },
  );

  test(
    'CARE-08/09/10: my Hearts, tree, badges and history come from the server',
    () async {
      final care = service();
      final hearts = await care.myHearts();
      expect((hearts.today, hearts.week, hearts.total), (5, 12, 40));
      expect(hearts.recent.map((entry) => entry.title), [
        'Tắm cho bé',
        'Giúp bạn đời một lời nhờ',
      ]);

      final tree = await care.tree();
      expect(tree.level, 3);
      expect(tree.name, 'Cây non');
      expect(tree.progressPercent, 42);
      expect(
        (tree.todayLeaves, tree.todayTotal, tree.weekBloomDays),
        (4, 6, 2),
      );
      // No sample numbers where the server has no weekly figures yet.
      expect(tree.weekCareMoments, 0);

      final badges = await care.badges();
      expect(badges.first.title, 'Tuần đầu tiên');
      expect(badges.first.achievedAt, isNotNull);
      expect((badges.last.progress, badges.last.target), (3, 10));
      expect(badges.last.achievedAt, isNull);

      final history = await care.missionHistory();
      expect(remote.historyCalls, containsAll(['ME', 'PARTNER', 'TOGETHER']));
      final entries = history.expand((day) => day.entries).toList();
      expect(entries, hasLength(3));
      final partner = entries.firstWhere(
        (entry) => entry.ownerKind == MissionOwnerKind.partner,
      );
      expect(partner.hearts, isNull);
      expect(partner.done, isTrue);
      expect(
        entries
            .firstWhere((entry) => entry.ownerKind == MissionOwnerKind.me)
            .hearts,
        3,
      );
    },
  );

  test(
    'CARE-07/CAL-02: calendar maps server events, missions and special days',
    () async {
      remote.calendarRecord = CalendarRecord(
        events: [
          CalendarEventRecord(
            id: 'ev-1',
            type: 'COUPLE',
            title: 'Hẹn hai ta',
            startAt: DateTime(2026, 10, 12, 20, 30).toUtc(),
            localStartDate: '2026-10-12',
            reminderRules: const [
              EventReminderRuleRecord(
                recipientUserId: 'srv-me',
                offsetMinutes: 60,
              ),
            ],
          ),
          CalendarEventRecord(
            id: 'ev-2',
            type: 'NOTE',
            title: 'Giỗ ông',
            allDay: true,
            isLunar: true,
            lunarMonth: 9,
            lunarDay: 1,
            repeatYearly: true,
            startAt: DateTime(2025, 10, 21).toUtc(),
            localStartDate: '2025-10-21',
            occurrenceDate: '2026-10-10',
          ),
        ],
        missions: [_FakeCare.record('m-p', mine: false, status: 'DONE')],
        specialDays: const [
          CalendarSpecialDayRecord(
            date: '2026-10-11',
            type: 'MONTHIVERSARY',
            childId: 'c-1',
            childName: 'Na',
            ageMonths: 7,
          ),
        ],
      );
      final care = service();
      final items = await care.calendarEvents(
        DateTime(2026, 10),
        DateTime(2026, 10, 31),
      );
      final couple = items.firstWhere((item) => item.id == 'ev-1');
      expect(couple.kind, CalendarEventKind.couple);
      expect(couple.time, '20:30');
      expect(couple.reminders, ['hourBefore']);
      final lunar = items.firstWhere((item) => item.id == 'ev-2');
      expect(lunar.kind, CalendarEventKind.health);
      expect(lunar.date, DateTime(2026, 10, 10));
      expect((lunar.lunar, lunar.lunarMonth, lunar.lunarDay), (true, 9, 1));
      final mission = items.firstWhere(
        (item) => item.kind == CalendarEventKind.mission,
      );
      expect(mission.ownerKind, MissionOwnerKind.partner);
      expect(mission.missionId, 'm-p');
      expect(
        items.firstWhere((item) => item.id.startsWith('special-')).title,
        'Na tròn 7 tháng',
      );

      await care.createEvent(
        CalendarEvent(
          id: '',
          title: 'Hẹn hai ta',
          kind: CalendarEventKind.couple,
          date: DateTime(2026, 10, 20),
          time: '20:00',
          inviteFamily: true,
          reminders: const ['hourBefore', 'dayBefore0900', 'morning'],
        ),
      );
      final body = remote.createdEvents.single;
      expect(body['type'], 'COUPLE');
      expect(body['localStartDate'], '2026-10-20');
      expect(
        DateTime.parse(body['startAt'] as String).toLocal(),
        DateTime(2026, 10, 20, 20),
      );
      // Sự kiện riêng tư không bao giờ mời Circle.
      expect(body['inviteCircle'], isFalse);
      expect(
        [
          for (final rule in body['reminderRules'] as List)
            (rule as Map)['offsetMinutes'],
        ],
        [60, 15 * 60 + 20 * 60, 20 * 60 - 7 * 60],
      );
    },
  );

  test('CAL-02: the partner is invited and reminded with server ids', () async {
    final care = service();
    final session = container.read(sessionRepositoryProvider);
    session.patchSession({kValueSessionKeyServerPartnerUserId: 'srv-partner'});
    final myId = session.session()['userId'] as String?;
    final family = container.read(familyRepositoryProvider);
    final familyId = session.session()['familyId'] as String;
    final partnerId =
        family
                .members(familyId)
                .where(
                  (member) =>
                      member['userId'] != myId &&
                      member['role'] != FamilyRole.relative.name,
                )
                .first['userId']
            as String;
    await care.createEvent(
      CalendarEvent(
        id: '',
        title: 'Khám thai',
        kind: CalendarEventKind.health,
        date: DateTime(2026, 10, 22),
        time: '09:00',
        participantUserIds: [?myId, partnerId],
        reminders: const ['hourBefore'],
      ),
    );
    final body = remote.createdEvents.single;
    expect(body['participants'], [
      {'userId': 'srv-me'},
      {'userId': 'srv-partner'},
    ]);
    expect(body['reminderRules'], [
      {'recipientUserId': 'srv-me', 'offsetMinutes': 60},
      {'recipientUserId': 'srv-partner', 'offsetMinutes': 60},
    ]);

    remote.calendarRecord = CalendarRecord(
      events: [
        CalendarEventRecord(
          id: 'ev-3',
          type: 'NOTE',
          title: 'Khám thai',
          startAt: DateTime(2026, 10, 22, 9).toUtc(),
          localStartDate: '2026-10-22',
          participants: const [
            EventParticipantRecord(userId: 'srv-me'),
            EventParticipantRecord(userId: 'srv-partner'),
          ],
          reminderRules: const [
            EventReminderRuleRecord(
              recipientUserId: 'srv-partner',
              offsetMinutes: 60,
            ),
            EventReminderRuleRecord(
              recipientUserId: 'srv-me',
              offsetMinutes: 7 * 24 * 60,
            ),
          ],
        ),
      ],
    );
    final event = (await care.calendarEvents(
      DateTime(2026, 10, 20),
      DateTime(2026, 10, 25),
    )).single;
    expect(event.participantUserIds, [?myId, partnerId]);
    // Only my own reminders show on my form.
    expect(event.reminders, ['weekBefore']);
  });

  test(
    'CARE-06: a finished server mission is saved as a family moment',
    () async {
      final care = service();
      await care.board(date: DateTime(2026, 10, 10));
      await care.saveMoment('m-mine', note: '  Con cười  ');
      await care.saveMoment('m-mine', note: 'Lần hai');
      expect(remote.moments.map((call) => call.$1), ['m-mine', 'm-mine']);
      expect(remote.moments.first.$3, {'body': 'Con cười'});
      // Each successful save releases its Idempotency-Key.
      expect(remote.moments.first.$2, isNot(remote.moments.last.$2));
    },
  );

  test(
    'CARE-12: settings come from the server; only changes are sent',
    () async {
      final care = service();
      final settings = await care.missionSettings();
      expect(settings.level, MissionLoadLevel.medium);
      expect(settings.boardTime, '06:30');
      expect(settings.askAtNight, isFalse);
      expect(settings.defaultReminder, MissionReminder.before30);
      expect(
        settings.categories.firstWhere((item) => item.code == 'play').enabled,
        isFalse,
      );
      expect(
        settings.categories.firstWhere((item) => item.code == 'care').enabled,
        isTrue,
      );
      await care.saveMissionSettings(
        settings.copyWith(level: MissionLoadLevel.light, boardTime: '07:15'),
      );
      expect(remote.settingsCalls, [
        'level:LIGHT',
        'prefs:{boardPushTime: 07:15}',
      ]);
    },
  );

  test('a repeating custom mission becomes a series on the server', () async {
    final care = service();
    final mission = await care.createMission(
      title: 'Uống vitamin',
      date: DateTime(2026, 10, 10),
      dueTime: '08:30',
      repeat: MissionRepeat.customDays,
      repeatDays: const [1, 3, 7],
    );
    expect(remote.series.single, {
      'title': 'Uống vitamin',
      'owner': 'ME',
      'scheduledTime': '08:30',
      'startDate': '2026-10-10',
      'days': ['MO', 'WE', 'SU'],
    });
    expect(mission.repeat, MissionRepeat.customDays);
    await care.createMission(
      title: 'Tập thể dục',
      date: DateTime(2026, 10, 10),
      repeat: MissionRepeat.daily,
    );
    expect(remote.series.last.containsKey('days'), isFalse);
  });

  test('CARE-03: series list, pause a week from today, stop', () async {
    final care = service();
    final series = await care.missionSeries();
    expect(series.map((item) => item.id), ['s-mine', 's-partner']);
    expect(series.first.weekdays, [1, 3, 7]);
    expect(series.first.pausedUntil, DateTime(2999, 1, 7));
    expect(series.first.canManage, isTrue);
    expect(series.last.weekdays, isEmpty);
    expect(series.last.canManage, isFalse);
    await care.pauseSeries('s-mine');
    await care.endSeries('s-mine');
    final day = DateFormat('yyyy-MM-dd');
    expect(remote.seriesCalls, [
      'pause s-mine ${day.format(care.today)}..'
          '${day.format(care.today.add(const Duration(days: 6)))}',
      'end s-mine',
    ]);
  });
}
