import 'package:baby_family/data/dto/care_board.dart';
import 'package:baby_family/data/dto/mission_completion.dart';
import 'package:baby_family/data/dto/mission_draft.dart';
import 'package:baby_family/data/model/care/calendar_event.dart';
import 'package:baby_family/data/model/care/family_badge.dart';
import 'package:baby_family/data/model/care/family_tree.dart';
import 'package:baby_family/data/model/care/hearts_entry.dart';
import 'package:baby_family/data/model/care/hearts_summary.dart';
import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/mission_history_day.dart';
import 'package:baby_family/data/model/care/mission_settings.dart';
import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/data/model/care/swap_option.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/care.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/service/care.dart';
import 'package:baby_family/data/service_imp/child.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/child_age.dart';

class CareServiceImp extends MockServiceImp implements ICareService {
  CareServiceImp(
    super.sessionRepository,
    super.clock,
    this._repository,
    this._childRepository,
    this._familyRepository,
    this._memoryRepository,
    this._usRepository,
  );

  final ICareRepository _repository;
  final IChildRepository _childRepository;
  final IFamilyRepository _familyRepository;
  final IMemoryRepository _memoryRepository;
  final IUsRepository _usRepository;

  String _childNames(List childIds) => childIds
      .map((id) => _childRepository.child(id as String)?['name'] as String?)
      .nonNulls
      .join(' & ');

  String _title(JsonMap row) {
    final template = _repository.template(row['templateId'] as String?);
    final title =
        (row['title'] as String?) ?? (template?['title'] as String?) ?? '';
    return title.replaceAll('{child}', _childNames(row['childIds'] as List));
  }

  MissionOwnerKind _owner(JsonMap row) {
    if (row['together'] == true) {
      return MissionOwnerKind.together;
    }
    return row['ownerUserId'] == myUserId
        ? MissionOwnerKind.me
        : MissionOwnerKind.partner;
  }

  Mission _toMission(JsonMap row) {
    final owner = _owner(row);
    final template = _repository.template(row['templateId'] as String?);
    return Mission.fromJson({
      ...row,
      'title': _title(row),
      'ownerKind': owner.name,
      // BR-018: never expose the partner's Hearts.
      'hearts': owner == MissionOwnerKind.partner ? null : row['hearts'],
      'icon': row['icon'] ?? template?['icon'],
      'durationMin': row['durationMin'] ?? template?['durationMin'],
      // Thanks are only meaningful for the partner's tab.
      'thankedByPartner': row['thankedByPartner'] ?? false,
    });
  }

  bool _onDay(JsonMap row, DateTime day) =>
      MockServiceImp.sameDay(DateTime.parse(row['date'] as String), day);

  List<JsonMap> _dayRows(DateTime day) => _repository
      .missions(familyId)
      .where(
        (row) =>
            _onDay(row, day) && row['status'] != MissionStatus.removed.name,
      )
      .toList();

  int _swapsLeft() => (kValueMissionSwapLimit - _repository.swapsUsed(myUserId))
      .clamp(0, kValueMissionSwapLimit);

  @override
  Future<CareBoard> board({DateTime? date, String? childId}) async {
    await ready();
    final day = date ?? today;
    final missions = _dayRows(day)
        .where(
          (row) =>
              childId == null ||
              (row['childIds'] as List).isEmpty ||
              (row['childIds'] as List).contains(childId),
        )
        .map(_toMission)
        .toList();
    final hearts = await myHearts();
    return CareBoard(
      date: day,
      mine: missions
          .where((mission) => mission.ownerKind == MissionOwnerKind.me)
          .toList(),
      partner: missions
          .where((mission) => mission.ownerKind == MissionOwnerKind.partner)
          .toList(),
      together: missions
          .where((mission) => mission.ownerKind == MissionOwnerKind.together)
          .toList(),
      heartsToday: MockServiceImp.sameDay(day, today) ? hearts.today : 0,
      swapsLeft: _swapsLeft(),
    );
  }

  @override
  Future<Mission?> mission(String id) async {
    await ready();
    final row = _repository.mission(id);
    return row == null ? null : _toMission(row);
  }

  bool _fitsChild(JsonMap template, String? childId) {
    final child = childId == null ? null : _childRepository.child(childId);
    if (child == null) {
      return true;
    }
    if (child['kind'] == ChildKind.pregnancy.name) {
      return template['forPregnancy'] == true;
    }
    if (template['forPregnancy'] == true) {
      return false;
    }
    final days = childAgeInDays(
      DateTime.parse(child['birthDate'] as String),
      today,
    );
    final min = template['minAgeDays'] as int?;
    final max = template['maxAgeDays'] as int?;
    return (min == null || days >= min) && (max == null || days <= max);
  }

  MissionTemplate _template(JsonMap row, List childIds) =>
      MissionTemplate.fromJson({
        ...row,
        'title': (row['title'] as String).replaceAll(
          '{child}',
          _childNames(childIds),
        ),
      });

  @override
  Future<List<MissionTemplate>> templates({String? childId}) async {
    await ready();
    return [
      for (final row in _repository.templates())
        if (_fitsChild(row, childId))
          _template(row, childId == null ? const [] : [childId]),
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
    MissionReminder reminder = MissionReminder.none,
    String? icon,
  }) async {
    await ready();
    if (ownerKind == MissionOwnerKind.partner) {
      throw ArgumentError.value(ownerKind, 'ownerKind', 'BR-020');
    }
    final template = _repository.template(templateId);
    final day = date ?? today;
    final row = _repository.addMission({
      'familyId': familyId,
      'date': DateTime(day.year, day.month, day.day).toIso8601String(),
      'ownerUserId': ownerKind == MissionOwnerKind.together ? null : myUserId,
      'together': ownerKind == MissionOwnerKind.together,
      'templateId': ?templateId,
      if (template == null) 'title': (title ?? '').trim(),
      'childIds': childIds,
      'status': MissionStatus.todo.name,
      'hearts': template?['hearts'] ?? kValueCustomMissionHearts,
      'category': template?['category'] ?? MissionCategory.custom.name,
      'source': template == null
          ? MissionSource.custom.name
          : MissionSource.library.name,
      'dueTime': ?dueTime,
      'repeat': repeat.name,
      'reminder': reminder.name,
      'icon': ?(template?['icon'] ?? icon),
    });
    return _toMission(row);
  }

  @override
  Future<MissionDraft> missionDraft({
    String? childId,
    String? templateId,
  }) async {
    await ready();
    final template = _repository.template(templateId);
    final draft = _repository.missionDraft();
    final childIds = childId != null
        ? [childId]
        : template != null
        ? const <String>[]
        : [for (final id in (draft['childIds'] as List?) ?? const []) '$id'];
    final rawTitle =
        (template?['title'] as String?) ?? (draft['title'] as String?) ?? '';
    T? byName<T extends Enum>(List<T> values, Object? name) =>
        values.where((value) => value.name == name).firstOrNull;
    if (template != null) {
      return MissionDraft(
        title: rawTitle.replaceAll('{child}', _childNames(childIds)),
        templateId: template['id'] as String,
        icon: template['icon'] as String?,
        childIds: childIds,
      );
    }
    return MissionDraft(
      title: rawTitle.replaceAll('{child}', _childNames(childIds)),
      icon: draft['icon'] as String?,
      childIds: childIds,
      ownerKind:
          byName(MissionOwnerKind.values, draft['ownerKind']) ??
          MissionOwnerKind.me,
      dueTime: draft['dueTime'] as String?,
      repeat:
          byName(MissionRepeat.values, draft['repeat']) ?? MissionRepeat.none,
      repeatDays: [
        for (final day in (draft['repeatDays'] as List?) ?? const [])
          day as int,
      ],
      reminder:
          byName(MissionReminder.values, draft['reminder']) ??
          MissionReminder.none,
      memoryPrompt: (draft['memoryPrompt'] as bool?) ?? true,
    );
  }

  @override
  Future<Set<DateTime>> missionDays(DateTime from, DateTime to) async {
    await ready();
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    return {
      for (final row in _repository.missions(familyId))
        if (row['status'] != MissionStatus.removed.name)
          DateTime.parse(row['date'] as String),
    }.map((day) => DateTime(day.year, day.month, day.day)).where((day) {
      return !day.isBefore(start) && !day.isAfter(end);
    }).toSet();
  }

  @override
  Future<MissionCompletion> completeMission(String id) async {
    await ready();
    final row = _repository.mission(id);
    if (row == null) {
      throw StateError('Mission $id not found');
    }
    final owner = _owner(row);
    if (owner == MissionOwnerKind.partner) {
      throw StateError('BR-024: only the owner completes a mission');
    }
    _repository.updateMission(id, {
      'status': MissionStatus.done.name,
      'completedAt': now.toIso8601String(),
      'completedByUserId': myUserId,
    });
    final hearts = (row['hearts'] as int?) ?? 0;
    final receivers = owner == MissionOwnerKind.together
        ? _parentUserIds()
        : [myUserId];
    for (final userId in receivers) {
      _repository.addHearts({
        'familyId': familyId,
        'userId': userId,
        'hearts': hearts,
        'missionId': id,
        'together': owner == MissionOwnerKind.together,
        'title': _title(row),
        'at': now.toIso8601String(),
      });
    }
    return MissionCompletion(
      mission: _toMission(_repository.mission(id)!),
      heartsEarned: hearts,
      undoUntil: now.add(kValueMissionUndoWindow),
    );
  }

  List<String> _parentUserIds() => [
    for (final member in _familyRepository.members(familyId))
      if (member['role'] != FamilyRole.relative.name &&
          member['userId'] != null)
        member['userId'] as String,
  ];

  @override
  Future<void> undoCompletion(String id) async {
    await ready();
    _repository.updateMission(id, {
      'status': MissionStatus.todo.name,
      'completedAt': null,
      'completedByUserId': null,
    });
    _repository.removeHearts((entry) => entry['missionId'] == id);
  }

  @override
  Future<SwapOption> swapOptions(String missionId) async {
    await ready();
    final row = _repository.mission(missionId);
    if (row == null) {
      return SwapOption(missionId: missionId);
    }
    final childIds = row['childIds'] as List;
    final onBoard = _dayRows(today).map((item) => item['templateId']).toSet();
    final hearts = (row['hearts'] as int?) ?? 0;
    final options = [
      for (final template in _repository.templates())
        if (!onBoard.contains(template['id']) &&
            ((template['hearts'] as int) - hearts).abs() <=
                kValueSwapHeartsTolerance &&
            (template['perChild'] == true) == childIds.isNotEmpty &&
            _fitsChild(template, childIds.firstOrNull as String?))
          _template(template, childIds),
    ].take(kValueSwapOptionCount).toList();
    return SwapOption(
      missionId: missionId,
      options: options,
      swapsLeft: _swapsLeft(),
    );
  }

  @override
  Future<void> swapMission(String missionId, String templateId) async {
    await ready();
    final template = _repository.template(templateId);
    if (template == null || _swapsLeft() == 0) {
      return;
    }
    _repository.updateMission(missionId, {
      'templateId': templateId,
      'title': null,
      'hearts': template['hearts'],
      'category': template['category'],
      'icon': template['icon'],
      'durationMin': template['durationMin'],
      'source': MissionSource.system.name,
    });
    _repository.setSwapsUsed(myUserId, _repository.swapsUsed(myUserId) + 1);
  }

  @override
  Future<void> removeFromToday(String missionId) async {
    await ready();
    _repository.updateMission(missionId, {
      'status': MissionStatus.removed.name,
    });
  }

  @override
  Future<void> thankPartner(String missionId) async {
    await ready();
    final row = _repository.mission(missionId);
    if (row == null) {
      return;
    }
    _repository.updateMission(missionId, {'thankedByPartner': true});
    _usRepository.addThanks({
      'familyId': familyId,
      'fromUserId': myUserId,
      'toUserId': row['ownerUserId'],
      'body': _title(row),
      'sticker': '💛',
      'missionId': missionId,
      'createdAt': now.toIso8601String(),
    });
  }

  @override
  Future<void> saveMoment(
    String missionId, {
    String? asset,
    String? note,
  }) async {
    await ready();
    final row = _repository.mission(missionId);
    if (row == null) {
      return;
    }
    _memoryRepository.addMemory({
      'familyId': familyId,
      'kind': MemoryKind.fromMission.name,
      'title': _title(row),
      'body': ?note,
      'childIds': row['childIds'],
      'authorId': myUserId,
      'occurredAt': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
      'mediaAssets': [?asset],
      'visibility': MemoryVisibility.family.name,
      'missionId': missionId,
      ChildServiceImp.localKey: true,
    });
  }

  @override
  Future<HeartsSummary> myHearts() async {
    await ready();
    final baseline = _repository.heartsBaseline(myUserId);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final entries = [
      for (final row in _repository.heartsLedger(familyId))
        if (row['userId'] == myUserId) HeartsEntry.fromJson(row),
    ]..sort((a, b) => b.at.compareTo(a.at));
    int sum(Iterable<HeartsEntry> items) =>
        items.fold(0, (total, entry) => total + entry.hearts);
    return HeartsSummary(
      today: sum(
        entries.where((entry) => MockServiceImp.sameDay(entry.at, today)),
      ),
      week:
          ((baseline['weekBefore'] as int?) ?? 0) +
          sum(entries.where((entry) => !entry.at.isBefore(monday))),
      total: ((baseline['totalBefore'] as int?) ?? 0) + sum(entries),
      recent: entries,
    );
  }

  @override
  Future<FamilyTree> tree() async {
    await ready();
    final ledger = _repository.heartsLedger(familyId);
    var total = 0;
    for (final userId in _parentUserIds()) {
      total += (_repository.heartsBaseline(userId)['totalBefore'] as int?) ?? 0;
    }
    for (final entry in ledger) {
      total += (entry['hearts'] as int?) ?? 0;
    }
    final levels = _repository.treeLevels();
    var current = levels.first;
    JsonMap? next;
    for (final level in levels) {
      if (total >= (level['minHearts'] as int)) {
        current = level;
      } else {
        next = level;
        break;
      }
    }
    final from = current['minHearts'] as int;
    final progress = next == null
        ? 100
        : ((total - from) * 100 ~/ ((next['minHearts'] as int) - from));
    final todayRows = _dayRows(today);
    final done = todayRows
        .where((row) => row['status'] == MissionStatus.done.name)
        .length;
    final stats = _repository.treeStats();
    return FamilyTree(
      level: current['level'] as int,
      name: (current['name'] as String?) ?? '',
      nextName: next?['name'] as String?,
      nextReward: next?['reward'] as String?,
      progressPercent: progress,
      todayLeaves: done,
      todayTotal: todayRows.length,
      bloomed: todayRows.isNotEmpty && done == todayRows.length,
      weekCareMoments: (stats['weekCareMoments'] as int?) ?? 0,
      weekTogether: (stats['weekTogether'] as int?) ?? 0,
      weekBloomDays: (stats['weekBloomDays'] as int?) ?? 0,
    );
  }

  // ------------------------------------------------------------ batch 2

  @override
  Future<List<CalendarEvent>> calendarEvents(DateTime from, DateTime to) async {
    await ready();
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
    final events = _repository
        .calendarEvents(familyId)
        .map(CalendarEvent.fromJson)
        .where(
          (event) => !event.date.isBefore(start) && !event.date.isAfter(end),
        )
        .toList();
    int minutes(CalendarEvent event) {
      if (event.allDay || event.time == null) {
        return -1;
      }
      final parts = event.time!.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    return events..sort((a, b) {
      final day = a.date.compareTo(b.date);
      return day != 0 ? day : minutes(a).compareTo(minutes(b));
    });
  }

  @override
  Future<CalendarEvent> eventDraft() async {
    await ready();
    return CalendarEvent.fromJson(_repository.eventDraft());
  }

  @override
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    await ready();
    final json = event.toJson()..remove('id');
    return CalendarEvent.fromJson(
      _repository.addCalendarEvent({...json, 'familyId': familyId}),
    );
  }

  @override
  Future<List<MissionHistoryDay>> missionHistory() async {
    await ready();
    final days = _repository.missionHistory().map(MissionHistoryDay.fromJson);
    return [
      for (final day in days)
        day.copyWith(
          entries: [
            for (final entry in day.entries)
              if (entry.ownerKind != MissionOwnerKind.partner || entry.done)
                entry.ownerKind == MissionOwnerKind.partner
                    ? entry.copyWith(hearts: null)
                    : entry,
          ],
        ),
    ]..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<FamilyBadge>> badges() async {
    await ready();
    final all = _repository.badges(familyId).map(FamilyBadge.fromJson).toList();
    return [
      ...all.where((badge) => badge.achieved),
      ...all.where((badge) => !badge.achieved),
    ];
  }

  @override
  Future<MissionSettings> missionSettings() async {
    await ready();
    return MissionSettings.fromJson(_repository.missionSettings());
  }

  @override
  Future<void> saveMissionSettings(MissionSettings settings) async {
    await ready();
    _repository.saveMissionSettings(settings.toJson());
  }
}
