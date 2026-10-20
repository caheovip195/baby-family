import 'package:baby_family/data/dto/care_board.dart';
import 'package:baby_family/data/dto/mission_completion.dart';
import 'package:baby_family/data/dto/mission_series_info.dart';
import 'package:baby_family/data/model/care/calendar_event.dart';
import 'package:baby_family/data/model/care/calendar_event_record.dart';
import 'package:baby_family/data/model/care/calendar_special_day_record.dart';
import 'package:baby_family/data/model/care/family_badge.dart';
import 'package:baby_family/data/model/care/family_tree.dart';
import 'package:baby_family/data/model/care/heart_history_record.dart';
import 'package:baby_family/data/model/care/hearts_entry.dart';
import 'package:baby_family/data/model/care/hearts_summary.dart';
import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/mission_history_day.dart';
import 'package:baby_family/data/model/care/mission_history_entry.dart';
import 'package:baby_family/data/model/care/mission_record.dart';
import 'package:baby_family/data/model/care/mission_settings.dart';
import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/data/model/care/mission_template_record.dart';
import 'package:baby_family/data/model/care/swap_option.dart';
import 'package:baby_family/data/repository/care.dart';
import 'package:baby_family/data/repository/care_remote.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/couple_remote.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/service_imp/care.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Nhiệm vụ hằng ngày qua server thật (CARE-01…06 — BF-20261018-007): bảng ngày
/// (server tự bày, chia đều hai Parent), chi tiết, thư viện, tự thêm, hoàn
/// thành/hoàn tác, đổi, bỏ khỏi hôm nay. Hearts do server ghi; nhiệm vụ của bạn
/// đời không có Hearts (BR-018). Lịch, lịch sử, huy hiệu, cây gia đình, thống kê
/// và “lưu khoảnh khắc” vẫn dùng dữ liệu trên máy cho tới khi có API.
class CareRemoteServiceImp extends CareServiceImp {
  CareRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._store,
    IChildRepository childRepository,
    this._family,
    IMemoryRepository memoryRepository,
    IUsRepository usRepository,
    this._remote,
    this._couple, {
    AppLocalizations Function()? l10n,
    this.uploader,
  }) : _l10n = l10n ?? currentL10n,
       super(
         sessionRepository,
         clock,
         _store,
         childRepository,
         _family,
         memoryRepository,
         usRepository,
       );

  final ICareRepository _store;
  final IFamilyRepository _family;
  final ICareRemoteRepository _remote;
  final ICoupleRemoteRepository _couple;
  final AppLocalizations Function() _l10n;

  /// Tải ảnh khoảnh khắc (CARE-06) lên server; null trong test không cần ảnh.
  final MediaUploader? uploader;

  /// CARE-08 hiển thị 30 ngày gần nhất (server cho tối đa 92 ngày/lần).
  static const _historyDays = 30;

  static const _uuid = Uuid();
  static final _day = DateFormat('yyyy-MM-dd');

  /// Loại server → loại của app (các loại chưa có trên app gộp vào loại gần nhất).
  static const _categories = {
    'CARE': MissionCategory.care,
    'PREP': MissionCategory.care,
    'BONDING': MissionCategory.bonding,
    'PLAY': MissionCategory.bonding,
    'OUTDOOR': MissionCategory.outing,
    'MEMORY': MissionCategory.memory,
    'SUPPORT': MissionCategory.support,
    'SELF': MissionCategory.self,
    'TOGETHER': MissionCategory.together,
    'COUPLE': MissionCategory.couple,
  };

  /// Nhiệm vụ server đã đọc (id → bản của app) — để biết đi đường server.
  final _missions = <String, Mission>{};

  /// Idempotency-Key của lần hoàn thành / tạo đang dở (giữ khi bấm lại).
  final _pendingKeys = <String, String>{};

  /// `optionsToken` của lần xem lựa chọn đổi gần nhất theo nhiệm vụ.
  final _swapTokens = <String, String>{};

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  bool _isServer(String missionId) =>
      _serverFamilyId != null && _missions.containsKey(missionId);

  @override
  Future<CareBoard> board({DateTime? date, String? childId}) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.board(date: date, childId: childId);
    }
    await ready();
    final day = date ?? today;
    Future<List<Mission>> tab(String name, MissionOwnerKind owner) async {
      final record = await _remote.board(
        serverFamilyId,
        tab: name,
        date: _day.format(day),
        childId: childId,
      );
      return [
        for (final item in record?.items ?? const <MissionRecord>[])
          ?_toMission(item, owner, day),
      ];
    }

    final mineRecord = await _remote.board(
      serverFamilyId,
      tab: 'MINE',
      date: _day.format(day),
      childId: childId,
    );
    final (partner, together) = await (
      tab('PARTNER', MissionOwnerKind.partner),
      tab('TOGETHER', MissionOwnerKind.together),
    ).wait;
    return CareBoard(
      date: day,
      mine: [
        for (final item in mineRecord?.items ?? const <MissionRecord>[])
          ?_toMission(item, MissionOwnerKind.me, day),
      ],
      partner: partner,
      together: together,
      heartsToday: mineRecord?.myHeartsToday ?? 0,
      swapsLeft: mineRecord?.swapsLeft ?? 0,
    );
  }

  @override
  Future<Mission?> mission(String id) async {
    if (!_isServer(id)) {
      return super.mission(id);
    }
    final known = _missions[id]!;
    final record = await _remote.mission(id);
    return record == null
        ? known
        : _toMission(record, known.ownerKind, known.date) ?? known;
  }

  @override
  Future<List<MissionTemplate>> templates({String? childId}) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.templates(childId: childId);
    }
    return [
      for (final record in await _remote.templates(
        serverFamilyId,
        childId: childId,
      ))
        ?_toTemplate(record),
    ];
  }

  @override
  Future<Mission> createMission({
    String? title,
    String? templateId,
    MissionOwnerKind ownerKind = MissionOwnerKind.me,
    List<String> childIds = const [],
    DateTime? date,
    String? dueTime,
    MissionRepeat repeat = MissionRepeat.none,
    List<int> repeatDays = const [],
    MissionReminder reminder = MissionReminder.none,
    String? icon,
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.createMission(
        title: title,
        templateId: templateId,
        ownerKind: ownerKind,
        childIds: childIds,
        date: date,
        dueTime: dueTime,
        repeat: repeat,
        repeatDays: repeatDays,
        reminder: reminder,
        icon: icon,
      );
    }
    if (ownerKind == MissionOwnerKind.partner) {
      // BR-020: nhờ bạn đời dùng Lời nhờ, không giao nhiệm vụ.
      throw ArgumentError.value(ownerKind, 'ownerKind', 'BR-020');
    }
    await ready();
    final day = date ?? today;
    // Lặp lại chỉ cho việc tự gõ (mục 7.13.6): tạo chuỗi thay cho một việc.
    if (repeat != MissionRepeat.none &&
        templateId == null &&
        title != null &&
        title.trim().isNotEmpty) {
      return _createSeries(
        serverFamilyId,
        title: title,
        ownerKind: ownerKind,
        childIds: childIds,
        day: day,
        dueTime: dueTime,
        repeat: repeat,
        repeatDays: repeatDays,
      );
    }
    final body = <String, dynamic>{
      'familyId': serverFamilyId,
      'owner': ownerKind == MissionOwnerKind.together ? 'TOGETHER' : 'ME',
      'templateId': ?templateId,
      if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
      'date': _day.format(day),
      'scheduledTime': ?dueTime,
      if (childIds.isNotEmpty) 'childIds': childIds,
    };
    final fingerprint = 'create:${body.toString()}';
    final result = await _remote.createMission(
      _pendingKeys[fingerprint] ??= _uuid.v4(),
      body,
    );
    _pendingKeys.remove(fingerprint);
    final record = result?.mission;
    final mission = record == null ? null : _toMission(record, ownerKind, day);
    if (mission == null) {
      throw StateError('Mission was not created');
    }
    _store.touch();
    return mission;
  }

  @override
  Future<MissionCompletion> completeMission(String id) async {
    if (!_isServer(id)) {
      return super.completeMission(id);
    }
    await ready();
    final fingerprint = 'complete:$id';
    final result = await _remote.complete(
      id,
      _pendingKeys[fingerprint] ??= _uuid.v4(),
    );
    _pendingKeys.remove(fingerprint);
    final known = _missions[id]!;
    final record = result?.mission;
    final mission = record == null
        ? known.copyWith(status: MissionStatus.done, completedAt: now)
        : _toMission(record, known.ownerKind, known.date) ?? known;
    _store.touch();
    return MissionCompletion(
      mission: mission,
      heartsEarned: result?.myHeartsAwarded ?? 0,
      undoUntil: now.add(kValueMissionUndoWindow),
    );
  }

  @override
  Future<void> undoCompletion(String id) =>
      _act(id, 'undo', () => super.undoCompletion(id));

  @override
  Future<void> removeFromToday(String missionId) =>
      _act(missionId, 'remove', () => super.removeFromToday(missionId));

  /// 💛 trên việc bạn đời đã xong → lời cảm ơn nhanh của server (câu mặc định
  /// do server điền, gắn nhiệm vụ — US-05).
  @override
  Future<void> thankPartner(String missionId) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null || !_isServer(missionId)) {
      return super.thankPartner(missionId);
    }
    await ready();
    await _couple.createAppreciation(serverFamilyId, {
      'quick': true,
      'linkedType': 'MISSION',
      'linkedId': missionId,
    });
    final known = _missions[missionId];
    if (known != null) {
      _missions[missionId] = known.copyWith(thankedByPartner: true);
    }
    _store.touch();
  }

  @override
  Future<SwapOption> swapOptions(String missionId) async {
    if (!_isServer(missionId)) {
      return super.swapOptions(missionId);
    }
    final record = await _remote.swapOptions(missionId);
    final token = record?.optionsToken;
    if (token != null) {
      _swapTokens[missionId] = token;
    }
    return SwapOption(
      missionId: missionId,
      options: [
        for (final option in record?.options ?? const <MissionTemplateRecord>[])
          ?_toTemplate(option),
      ],
      swapsLeft: record?.swapsLeft ?? 0,
    );
  }

  @override
  Future<void> swapMission(String missionId, String templateId) async {
    if (!_isServer(missionId)) {
      return super.swapMission(missionId, templateId);
    }
    final token = _swapTokens[missionId] ?? '';
    await _act(missionId, 'swap', () async {}, {
      'templateId': templateId,
      'optionsToken': token,
    });
    _swapTokens.remove(missionId);
  }

  /// Hearts của CHÍNH tôi (BR-018) — server không có đường đọc Hearts người khác.
  @override
  Future<HeartsSummary> myHearts() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.myHearts();
    }
    final record = await _remote.myHearts(serverFamilyId, limit: 20);
    final l10n = _l10n();
    final history = record?.history ?? const <HeartHistoryRecord>[];
    return HeartsSummary(
      today: record?.today ?? 0,
      week: record?.week ?? 0,
      total: record?.total ?? 0,
      recent: [
        for (var i = 0; i < history.length; i++)
          HeartsEntry(
            id: 'hearts-$i',
            hearts: history[i].amount,
            title: history[i].title?.trim().isNotEmpty ?? false
                ? history[i].title!
                : switch (history[i].reason) {
                    'REQUEST_DONE' => l10n.heartsReasonRequest,
                    final String reason when reason.startsWith('MISSION') =>
                      l10n.heartsReasonMission,
                    _ => l10n.heartsReasonOther,
                  },
            at: (history[i].at ?? now).toLocal(),
          ),
      ],
    );
  }

  /// CARE-09: cấp + % của server; số liệu tuần chưa có API thì để 0 (không lấy
  /// số mẫu).
  @override
  Future<FamilyTree> tree() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.tree();
    }
    final record = await _remote.familyTree(serverFamilyId);
    return FamilyTree(
      level: record?.level ?? 1,
      name: record?.levelName ?? '',
      progressPercent: record?.progressPercent ?? 0,
      todayLeaves: record?.today?.leaves ?? 0,
      todayTotal: record?.today?.total ?? 0,
      bloomed: record?.today?.bloomed ?? false,
      weekBloomDays: record?.bloomedDaysThisWeek ?? 0,
    );
  }

  /// CARE-10: đã đạt trước, sắp mở sau (thứ tự server); tên theo ngôn ngữ app.
  @override
  Future<List<FamilyBadge>> badges() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.badges();
    }
    final locale = _l10n().localeName;
    return [
      for (final badge in await _remote.badges(serverFamilyId))
        if (badge.code != null)
          FamilyBadge(
            code: badge.code!,
            title: badge.titleI18n[locale] ?? badge.title ?? badge.code!,
            icon: badge.icon,
            achievedAt: badge.earned ? badge.achievedAt?.toLocal() : null,
            hint: badge.descI18n[locale] ?? badge.description,
            progress: badge.earned ? null : badge.progress?.current,
            target: badge.earned ? null : badge.progress?.target,
          ),
    ];
  }

  /// CARE-08: 30 ngày gần nhất của tôi, Cùng nhau và việc bạn đời đã xong
  /// (không Hearts — BR-018), nhóm theo ngày, mới nhất trước.
  @override
  Future<List<MissionHistoryDay>> missionHistory() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.missionHistory();
    }
    await ready();
    final to = today;
    final from = to.subtract(const Duration(days: _historyDays));
    Future<List<(MissionRecord, MissionOwnerKind)>> owner(
      String name,
      MissionOwnerKind kind,
    ) async {
      final rows = <(MissionRecord, MissionOwnerKind)>[];
      String? cursor;
      for (var page = 0; page < kValueRemoteFeedMaxPages; page++) {
        final result = await _remote.missionHistory(
          serverFamilyId,
          from: _day.format(from),
          to: _day.format(to),
          owner: name,
          cursor: cursor,
        );
        rows.addAll([
          for (final item in result?.items ?? const []) (item, kind),
        ]);
        final next = result?.nextCursor;
        if (next == null || next == cursor) {
          break;
        }
        cursor = next;
      }
      return rows;
    }

    final (mine, partner, together) = await (
      owner('ME', MissionOwnerKind.me),
      owner('PARTNER', MissionOwnerKind.partner),
      owner('TOGETHER', MissionOwnerKind.together),
    ).wait;
    final days = <DateTime, List<MissionHistoryEntry>>{};
    for (final (record, kind) in [...mine, ...partner, ...together]) {
      final title = record.title;
      if (title == null) {
        continue;
      }
      final date =
          DateTime.tryParse(record.boardDate ?? '') ??
          record.completedAt?.toLocal() ??
          to;
      final day = DateTime(date.year, date.month, date.day);
      final completed = record.completedAt?.toLocal();
      (days[day] ??= []).add(
        MissionHistoryEntry.fromJson({
          'title': title,
          'ownerKind': kind.name,
          'done': record.status == 'DONE',
          'completedTime': completed == null
              ? null
              : DateFormat('HH:mm').format(completed),
          'categoryCode':
              (_categories[record.category] ?? MissionCategory.custom).name,
          if (kind != MissionOwnerKind.partner) 'hearts': ?record.hearts,
          'childIds': record.childIds,
          'couple': record.category == 'COUPLE',
        }),
      );
    }
    return [
      for (final entry in days.entries)
        MissionHistoryDay(date: entry.key, entries: entry.value),
    ]..sort((a, b) => b.date.compareTo(a.date));
  }

  /// CARE-07 qua server (BF-20261018-013): sự kiện (đã trải lặp hằng năm, cả
  /// âm lịch), nhiệm vụ trong khoảng ngày (việc của bạn đời không Hearts) và
  /// sinh nhật/tròn tháng của bé do server tính. Server giới hạn ≤ 62 ngày.
  @override
  Future<List<CalendarEvent>> calendarEvents(DateTime from, DateTime to) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.calendarEvents(from, to);
    }
    await ready();
    final calendar = await _remote.calendar(
      serverFamilyId,
      from: _day.format(from),
      to: _day.format(to),
    );
    final l10n = _l10n();
    final items = <CalendarEvent>[
      for (final record in calendar?.events ?? const <CalendarEventRecord>[])
        ?_toCalendarEvent(record),
      for (final record in calendar?.missions ?? const <MissionRecord>[])
        ?_calendarMission(record),
      for (final day
          in calendar?.specialDays ?? const <CalendarSpecialDayRecord>[])
        ?_specialDay(day, l10n),
    ];
    int minutes(CalendarEvent event) {
      final time = event.time;
      if (event.allDay || time == null) {
        return -1;
      }
      final parts = time.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    return items..sort((a, b) {
      final day = a.date.compareTo(b.date);
      return day != 0 ? day : minutes(a).compareTo(minutes(b));
    });
  }

  /// CAL-02 qua server: nhắc gửi cho chính người tạo; “Mời cả nhà” chỉ cho
  /// loại không riêng tư (server chặn `COUPLE`/`NOTE`/nhắc kỷ niệm).
  @override
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.createEvent(event);
    }
    await ready();
    final type = _eventTypes[event.kind] ?? 'FAMILY';
    final date = DateTime(event.date.year, event.date.month, event.date.day);
    final startMinutes = event.allDay ? 0 : _minutesOf(event.time);
    final start = date.add(Duration(minutes: startMinutes));
    final me =
        sessionRepository.session()[kValueSessionKeyServerUserId] as String?;
    final private = const {'COUPLE', 'NOTE', 'MEMORY_REMINDER'}.contains(type);
    final offsets = {
      for (final code in event.reminders) ?_reminderOffset(code, startMinutes),
    };
    // Người tham gia (tôi / bạn đời) → id server; nhắc gửi cho từng người, không
    // chọn ai thì chỉ nhắc tôi.
    final participants = {
      for (final userId in event.participantUserIds) ?_serverUserId(userId),
    };
    final recipients = participants.isEmpty ? {?me} : participants;
    final record = await _remote.createEvent({
      'familyId': serverFamilyId,
      'type': type,
      'title': event.title,
      'notes': ?event.note,
      'allDay': event.allDay,
      'startAt': start.toUtc().toIso8601String(),
      'localStartDate': _day.format(date),
      if (event.lunar) ...{
        'isLunar': true,
        'lunarMonth': ?event.lunarMonth,
        'lunarDay': ?event.lunarDay,
      },
      'repeatYearly': event.repeatYearly,
      'inviteCircle': event.inviteFamily && !private,
      'childIds': event.childIds,
      if (participants.isNotEmpty)
        'participants': [
          for (final userId in participants) {'userId': userId},
        ],
      if (offsets.isNotEmpty && recipients.isNotEmpty)
        'reminderRules': [
          for (final userId in recipients)
            for (final offset in offsets)
              {'recipientUserId': userId, 'offsetMinutes': offset},
        ],
    });
    final created = record == null ? null : _toCalendarEvent(record);
    _store.touch();
    return created ?? event;
  }

  CalendarEvent? _toCalendarEvent(CalendarEventRecord record) {
    final id = record.id;
    final title = record.title;
    final day =
        DateTime.tryParse(record.occurrenceDate ?? '') ??
        DateTime.tryParse(record.localStartDate ?? '') ??
        record.startAt?.toLocal();
    if (id == null || title == null || day == null) {
      return null;
    }
    final kind =
        _eventTypes.entries
            .where((entry) => entry.value == record.type)
            .firstOrNull
            ?.key ??
        CalendarEventKind.family;
    final start = record.startAt?.toLocal();
    final startMinutes = start == null ? 0 : start.hour * 60 + start.minute;
    return CalendarEvent(
      id: id,
      title: title,
      kind: kind,
      date: DateTime(day.year, day.month, day.day),
      time: record.allDay || start == null
          ? null
          : DateFormat('HH:mm').format(start),
      allDay: record.allDay,
      icon: _eventIcons[kind],
      childIds: record.childIds,
      lunar: record.isLunar,
      lunarDay: record.lunarDay,
      lunarMonth: record.lunarMonth,
      repeatYearly: record.repeatYearly,
      inviteFamily: record.inviteCircle,
      participantUserIds: [
        for (final participant in record.participants)
          ?_localUserId(participant.userId),
      ],
      // Mã nhắc của chính tôi (không lặp theo từng người nhận).
      reminders: {
        for (final rule in record.reminderRules)
          if (rule.enabled && rule.recipientUserId == _serverMe)
            ?_reminderCode(rule.offsetMinutes, startMinutes),
      }.toList(),
      note: record.notes,
    );
  }

  String? get _serverMe =>
      sessionRepository.session()[kValueSessionKeyServerUserId] as String?;

  String? get _serverPartner =>
      sessionRepository.session()[kValueSessionKeyServerPartnerUserId]
          as String?;

  /// Id bạn đời trên máy (Parent còn lại trong gia đình).
  String? get _localPartner =>
      _family
              .members(familyId)
              .where(
                (member) =>
                    member['userId'] != myUserId &&
                    member['role'] != FamilyRole.relative.name,
              )
              .firstOrNull?['userId']
          as String?;

  /// Id trên máy → id server: tôi, hoặc bạn đời (khi đã biết id server).
  String? _serverUserId(String localUserId) {
    if (localUserId == myUserId) {
      return _serverMe;
    }
    return localUserId == _localPartner ? _serverPartner : null;
  }

  String? _localUserId(String? serverUserId) {
    if (serverUserId == null) {
      return null;
    }
    if (serverUserId == _serverMe) {
      return myUserId;
    }
    return serverUserId == _serverPartner ? _localPartner : null;
  }

  /// Nhiệm vụ trên lịch: `TOGETHER` → Cùng nhau, không phải của tôi → bạn đời.
  CalendarEvent? _calendarMission(MissionRecord record) {
    final id = record.id;
    final title = record.title;
    final day = DateTime.tryParse(record.boardDate ?? '');
    if (id == null || title == null || day == null) {
      return null;
    }
    final owner = record.ownerKind == 'TOGETHER'
        ? MissionOwnerKind.together
        : record.mine == false
        ? MissionOwnerKind.partner
        : MissionOwnerKind.me;
    return CalendarEvent(
      id: 'mission-$id',
      title: title,
      kind: CalendarEventKind.mission,
      date: DateTime(day.year, day.month, day.day),
      // `19:30:00` → `19:30`.
      time: (record.scheduledTime?.length ?? 0) >= 5
          ? record.scheduledTime!.substring(0, 5)
          : null,
      icon: 'list-checks',
      childIds: record.childIds,
      ownerKind: owner,
      missionId: id,
    );
  }

  static CalendarEvent? _specialDay(
    CalendarSpecialDayRecord record,
    AppLocalizations l10n,
  ) {
    final day = DateTime.tryParse(record.date ?? '');
    final childId = record.childId;
    final name = record.childName ?? '';
    if (day == null || childId == null) {
      return null;
    }
    final title = switch (record.type) {
      'BIRTHDAY' => l10n.calendarChildBirthday(name, record.ageYears ?? 0),
      'MONTHIVERSARY' => l10n.calendarChildMonthiversary(
        name,
        record.ageMonths ?? 0,
      ),
      _ => null,
    };
    if (title == null) {
      return null;
    }
    return CalendarEvent(
      id: 'special-${record.type}-$childId-${record.date}',
      title: title,
      kind: CalendarEventKind.child,
      date: DateTime(day.year, day.month, day.day),
      allDay: true,
      icon: 'cake',
      childIds: [childId],
    );
  }

  static int _minutesOf(String? time) {
    final parts = (time ?? '').split(':');
    if (parts.length != 2) {
      return 9 * 60;
    }
    return (int.tryParse(parts[0]) ?? 9) * 60 + (int.tryParse(parts[1]) ?? 0);
  }

  /// Mã nhắc của form CAL-02 → số phút trước giờ bắt đầu (server: 0…10080).
  static int? _reminderOffset(String code, int startMinutes) {
    final offset = switch (code) {
      'atTime' => 0,
      'hourBefore' => 60,
      'weekBefore' => 7 * 24 * 60,
      // 9:00 hôm trước.
      'dayBefore0900' => 15 * 60 + startMinutes,
      // 7:00 sáng hôm đó (sự kiện trước 7:00 thì nhắc đúng giờ).
      'morning' => startMinutes - _morningMinutes,
      _ => null,
    };
    return offset?.clamp(0, 7 * 24 * 60);
  }

  static String? _reminderCode(int? offset, int startMinutes) {
    if (offset == null) {
      return null;
    }
    for (final code in const ['atTime', 'hourBefore', 'weekBefore']) {
      if (_reminderOffset(code, startMinutes) == offset) {
        return code;
      }
    }
    if (offset == 15 * 60 + startMinutes) {
      return 'dayBefore0900';
    }
    if (startMinutes > _morningMinutes &&
        offset == startMinutes - _morningMinutes) {
      return 'morning';
    }
    return null;
  }

  static const _morningMinutes = 7 * 60;

  static const _eventTypes = {
    CalendarEventKind.child: 'CHILD',
    CalendarEventKind.family: 'FAMILY',
    CalendarEventKind.couple: 'COUPLE',
    CalendarEventKind.anniversary: 'MEMORY_REMINDER',
    CalendarEventKind.health: 'NOTE',
  };

  static const _eventIcons = {
    CalendarEventKind.child: 'backpack',
    CalendarEventKind.family: 'house-heart',
    CalendarEventKind.couple: 'lock',
    CalendarEventKind.anniversary: 'calendar-heart',
    CalendarEventKind.health: 'notebook-pen',
  };

  // ------------------------------------------------------------ CARE-06/12, lặp lại

  /// CARE-06 qua server (BF-20261019-003): nhiệm vụ đã xong → ký ức gia đình
  /// (`POST /missions/:id/moment`, Idempotency-Key giữ khi thử lại). Ảnh chọn
  /// từ máy tải lên trước; ký ức hiện ra ở bảng tin sau lần đồng bộ kế tiếp.
  @override
  Future<void> saveMoment(
    String missionId, {
    String? asset,
    String? note,
  }) async {
    if (!_isServer(missionId)) {
      return super.saveMoment(missionId, asset: asset, note: note);
    }
    final serverFamilyId = _serverFamilyId!;
    final assetIds = <String>[];
    final uploader = this.uploader;
    if (asset != null && !asset.startsWith('assets/') && uploader != null) {
      assetIds.add(
        await uploader.uploadImage(serverFamilyId, asset, purpose: 'MEMORY'),
      );
    }
    final fingerprint = 'moment:$missionId';
    await _remote
        .saveMoment(missionId, _pendingKeys[fingerprint] ??= _uuid.v4(), {
          if (note != null && note.trim().isNotEmpty) 'body': note.trim(),
          if (assetIds.isNotEmpty) 'assetIds': assetIds,
        });
    _pendingKeys.remove(fingerprint);
    _store.touch();
  }

  /// CARE-12: mức bảng (cả nhà) + tuỳ chọn của tôi từ server; tên/biểu tượng
  /// danh mục vẫn theo catalog của app.
  @override
  Future<MissionSettings> missionSettings() async {
    final local = await super.missionSettings();
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return local;
    }
    final record = await _remote.missionSettings(serverFamilyId);
    if (record == null) {
      return local;
    }
    final disabled = record.preferences?.disabledCategories.toSet() ?? {};
    return local.copyWith(
      level:
          _levels.entries
              .where((entry) => entry.value == record.boardLevel)
              .firstOrNull
              ?.key ??
          local.level,
      categories: [
        for (final category in local.categories)
          category.copyWith(
            enabled: !(_settingCategories[category.code] ?? const []).any(
              disabled.contains,
            ),
          ),
      ],
      boardTime: record.preferences?.boardPushTime ?? local.boardTime,
      askAtNight: record.preferences?.eveningCarryOver ?? local.askAtNight,
      defaultReminder:
          _reminders.entries
              .where(
                (entry) =>
                    entry.value == record.preferences?.defaultReminderMin,
              )
              .firstOrNull
              ?.key ??
          MissionReminder.none,
    );
  }

  /// Mức bảng là của cả nhà (một trong hai Parent đổi); các tuỳ chọn còn lại
  /// chỉ của tôi. Chỉ gửi phần đã đổi.
  @override
  Future<void> saveMissionSettings(MissionSettings settings) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.saveMissionSettings(settings);
    }
    final before = await missionSettings();
    if (settings.level != before.level) {
      await _remote.updateBoardLevel(serverFamilyId, _levels[settings.level]!);
    }
    final patch = <String, dynamic>{
      if (!_sameCategories(settings, before))
        'disabledCategories': [
          for (final category in settings.categories)
            if (!category.enabled) ...?_settingCategories[category.code],
        ],
      if (settings.boardTime != before.boardTime)
        'boardPushTime': settings.boardTime,
      if (settings.askAtNight != before.askAtNight)
        'eveningCarryOver': settings.askAtNight,
      if (settings.defaultReminder != before.defaultReminder)
        'defaultReminderMin': _reminders[settings.defaultReminder],
    };
    if (patch.isNotEmpty) {
      await _remote.updatePreferences(serverFamilyId, patch);
    }
    await super.saveMissionSettings(settings);
  }

  static bool _sameCategories(MissionSettings a, MissionSettings b) {
    final on = {
      for (final category in b.categories) category.code: category.enabled,
    };
    return a.categories.every(
      (category) => on[category.code] == category.enabled,
    );
  }

  /// Nhiệm vụ lặp lại tự thêm (mục 7.13.6): tạo chuỗi trên server; mỗi ngày
  /// server bày một nhiệm vụ của chuỗi lên bảng.
  Future<Mission> _createSeries(
    String serverFamilyId, {
    required String title,
    required MissionOwnerKind ownerKind,
    required List<String> childIds,
    required DateTime day,
    required String? dueTime,
    required MissionRepeat repeat,
    required List<int> repeatDays,
  }) async {
    final days = switch (repeat) {
      MissionRepeat.weekdays => const ['MO', 'TU', 'WE', 'TH', 'FR'],
      MissionRepeat.weekends => const ['SA', 'SU'],
      MissionRepeat.customDays => [
        for (final weekday in repeatDays) _weekdays[(weekday - 1) % 7],
      ],
      _ => const <String>[],
    };
    final record = await _remote.createSeries(serverFamilyId, {
      'title': title.trim(),
      'owner': ownerKind == MissionOwnerKind.together ? 'TOGETHER' : 'ME',
      if (childIds.isNotEmpty) 'childIds': childIds,
      'scheduledTime': ?dueTime,
      'startDate': _day.format(day),
      if (days.isNotEmpty) 'days': days,
    });
    final id = record?.id;
    if (id == null) {
      throw StateError('Series was not created');
    }
    _store.touch();
    return Mission(
      id: 'series-$id',
      title: title.trim(),
      ownerKind: ownerKind,
      date: day,
      dueTime: dueTime,
      childIds: childIds,
      hearts: 2,
      repeat: repeat,
    );
  }

  static const _weekdays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

  static const _levels = {
    MissionLoadLevel.light: 'LIGHT',
    MissionLoadLevel.medium: 'MEDIUM',
    MissionLoadLevel.heavy: 'HEAVY',
  };

  static const _reminders = {
    MissionReminder.none: null,
    MissionReminder.atTime: 0,
    MissionReminder.before15: 15,
    MissionReminder.before30: 30,
    MissionReminder.before60: 60,
  };

  /// Mã danh mục ở CARE-12 → danh mục server.
  static const _settingCategories = {
    'care': ['CARE', 'PREP'],
    'bonding': ['BONDING'],
    'play': ['PLAY'],
    'outing': ['OUTDOOR'],
    'memory': ['MEMORY'],
    'support': ['SUPPORT'],
  };

  Future<void> _act(
    String missionId,
    String action,
    Future<void> Function() local, [
    Map<String, dynamic> body = const {},
  ]) async {
    if (!_isServer(missionId)) {
      return local();
    }
    await ready();
    await _remote.action(missionId, action, body);
    _store.touch();
  }

  /// Bản ghi server → [Mission] của app; nhớ lại để các thao tác sau đi server.
  Mission? _toMission(
    MissionRecord record,
    MissionOwnerKind owner,
    DateTime day,
  ) {
    final id = record.id;
    final title = record.title;
    if (id == null || title == null) {
      return null;
    }
    final kind = record.mine == false && owner == MissionOwnerKind.me
        ? MissionOwnerKind.partner
        : owner;
    final mission = Mission.fromJson({
      'id': id,
      'title': title,
      'category': (_categories[record.category] ?? MissionCategory.custom).name,
      // Hearts chỉ có ở nhiệm vụ của tôi / Cùng nhau (BR-018).
      if (kind != MissionOwnerKind.partner) 'hearts': ?record.hearts,
      'ownerKind': kind.name,
      'source': switch (record.source) {
        'CUSTOM' => MissionSource.custom.name,
        'LIBRARY' => MissionSource.library.name,
        'SERIES' => MissionSource.series.name,
        _ => MissionSource.system.name,
      },
      'templateId': record.templateId,
      'childIds': record.childIds,
      'date': (DateTime.tryParse(record.boardDate ?? '') ?? day)
          .toIso8601String(),
      'dueTime': record.scheduledTime?.substring(
        0,
        record.scheduledTime!.length < 5 ? null : 5,
      ),
      'status':
          MissionStatus.values
              .where((value) => value.name == record.status?.toLowerCase())
              .firstOrNull
              ?.name ??
          MissionStatus.todo.name,
      'late': record.late,
      'completedAt': record.completedAt?.toLocal().toIso8601String(),
      // Server chưa trả cờ đã cảm ơn của tôi: giữ cờ đã biết trong phiên.
      'thankedByPartner':
          record.thanked || (_missions[id]?.thankedByPartner ?? false),
      'note': record.note,
    });
    _missions[id] = mission;
    return mission;
  }

  /// CARE-03 chuỗi lặp lại tự thêm (mục 7.13.6): chỉ chuỗi còn chạy.
  @override
  Future<List<MissionSeriesInfo>> missionSeries() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.missionSeries();
    }
    final records = await _remote.missionSeries(serverFamilyId);
    final todayKey = _day.format(today);
    return [
      for (final record in records)
        if (record.id != null &&
            record.title != null &&
            record.status != _seriesEnded &&
            (record.endDate == null ||
                record.endDate!.compareTo(todayKey) >= 0))
          MissionSeriesInfo(
            id: record.id!,
            title: record.title!,
            weekdays: [
              for (final day in record.days)
                if (_weekdays.contains(day)) _weekdays.indexOf(day) + 1,
            ],
            scheduledTime: record.scheduledTime,
            pausedUntil: _pausedUntil(record.pausedRanges, todayKey),
            canManage: record.mine || record.ownerKind == _togetherOwner,
          ),
    ];
  }

  /// Tạm dừng [days] ngày kể từ hôm nay (server bỏ qua các ngày đó).
  @override
  Future<void> pauseSeries(String seriesId, {int days = 7}) async {
    if (_serverFamilyId == null) {
      return super.pauseSeries(seriesId, days: days);
    }
    await _remote.pauseSeries(
      seriesId,
      _day.format(today),
      _day.format(today.add(Duration(days: days - 1))),
    );
  }

  @override
  Future<void> endSeries(String seriesId) async {
    if (_serverFamilyId == null) {
      return super.endSeries(seriesId);
    }
    await _remote.endSeries(seriesId);
  }

  /// Ngày cuối của khoảng tạm dừng đang/ sắp áp dụng (to ≥ hôm nay).
  static DateTime? _pausedUntil(
    List<Map<String, dynamic>> ranges,
    String todayKey,
  ) {
    String? latest;
    for (final range in ranges) {
      final to = range['to'];
      if (to is String &&
          to.compareTo(todayKey) >= 0 &&
          (latest == null || to.compareTo(latest) > 0)) {
        latest = to;
      }
    }
    return latest == null ? null : DateTime.tryParse(latest);
  }

  static const _seriesEnded = 'ENDED';
  static const _togetherOwner = 'TOGETHER';

  static MissionTemplate? _toTemplate(MissionTemplateRecord record) {
    final id = record.id;
    final title = record.title;
    if (id == null || title == null) {
      return null;
    }
    return MissionTemplate.fromJson({
      'id': id,
      'title': title,
      'category': (_categories[record.category] ?? MissionCategory.custom).name,
      'hearts': record.hearts,
      'durationMin': record.durationMin,
      'perChild': !record.multiChildOk,
    });
  }
}
