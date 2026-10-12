import 'package:baby_family/data/dto/fetal_size.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/child/child_profile.dart';
import 'package:baby_family/data/model/memory/chapter_summary.dart';
import 'package:baby_family/data/model/memory/child_memory_stats.dart';
import 'package:baby_family/data/model/memory/week_summary.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/service/child.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';

class ChildServiceImp extends MockServiceImp implements IChildService {
  ChildServiceImp(
    super.sessionRepository,
    super.clock,
    this._repository,
    this._memoryRepository,
  );

  final IChildRepository _repository;
  final IMemoryRepository _memoryRepository;

  /// Marker of memories created during the session (on top of fixture counters).
  static const localKey = 'local';

  @override
  Future<List<Child>> children({bool includeArchived = false}) async {
    await ready();
    final rows = _repository.children(familyId);
    // CHD-03 drag-and-drop order (`order`), else creation order.
    final ordered = [
      for (var index = 0; index < rows.length; index++)
        (order: (rows[index]['order'] as int?) ?? index, row: rows[index]),
    ]..sort((a, b) => a.order.compareTo(b.order));
    return ordered
        .map((entry) => Child.fromJson(entry.row))
        .where((child) => includeArchived || !child.archived)
        .toList();
  }

  @override
  Future<Child?> child(String id) async {
    await ready();
    final row = _repository.child(id);
    return row == null ? null : Child.fromJson(row);
  }

  int _nextColor() => _repository.children(familyId).length;

  @override
  Future<Child> addChild({
    required String name,
    DateTime? birthDate,
    ChildGender gender = ChildGender.unknown,
    String? avatarAsset,
  }) async {
    await ready();
    return Child.fromJson(
      _repository.addChild({
        'familyId': familyId,
        'name': name.trim(),
        'kind': ChildKind.baby.name,
        'birthDate': (birthDate ?? today).toIso8601String(),
        'colorIndex': _nextColor(),
        'gender': gender.name,
        'avatarAsset': ?avatarAsset,
      }),
    );
  }

  @override
  Future<Child> addPregnancy({
    required String name,
    DateTime? dueDate,
    int babyCount = 1,
  }) async {
    await ready();
    final order = _repository.children(familyId).length + 1;
    return Child.fromJson(
      _repository.addChild({
        'familyId': familyId,
        'name': name.trim(),
        'kind': ChildKind.pregnancy.name,
        'dueDate': (dueDate ?? dueDateFromWeek(20, today)).toIso8601String(),
        'colorIndex': _nextColor(),
        'carrierUserId': myUserId,
        'pregnancyOrder': order,
        'babyCount': babyCount,
      }),
    );
  }

  @override
  Future<void> updateChild(Child child) async {
    await ready();
    _repository.updateChild(child.id, child.toJson());
  }

  List<JsonMap> _memoriesOf(String childId) => _memoryRepository
      .memories(familyId)
      .where((row) => (row['childIds'] as List).contains(childId))
      .toList();

  static bool _isFirst(JsonMap row) => row['kind'] == MemoryKind.milestone.name;

  @override
  Future<ChildMemoryStats> stats(String childId) async {
    await ready();
    final base =
        (_repository.stats()['children'] as Map?)?[childId] as JsonMap?;
    final memories = _memoriesOf(childId);
    final counted = base == null
        ? memories
        : memories.where((row) => row[localKey] == true).toList();
    int count(bool Function(JsonMap row) test) => counted.where(test).length;
    return ChildMemoryStats(
      childId: childId,
      memories: ((base?['memories'] as int?) ?? 0) + counted.length,
      firsts: ((base?['firsts'] as int?) ?? 0) + count(_isFirst),
      voices:
          ((base?['voices'] as int?) ?? 0) +
          count((row) => row['kind'] == MemoryKind.voice.name),
      quotes:
          ((base?['quotes'] as int?) ?? 0) +
          count((row) => row['kind'] == MemoryKind.quote.name),
    );
  }

  @override
  Future<List<ChapterSummary>> chapters(String childId) async {
    final child = await this.child(childId);
    final birth = child?.birthDate;
    if (child == null || child.isPregnancy || birth == null) {
      return const [];
    }
    final fixtures = [
      for (final row in (_repository.stats()['chapters'] as List? ?? const []))
        if ((row as JsonMap)['childId'] == childId) row,
    ];
    final memories = _memoriesOf(childId);
    final current = childMonthIndex(birth, today);
    return [
      for (var index = current; index >= 1; index--)
        _chapter(child.id, birth, index, current, fixtures, memories),
    ];
  }

  ChapterSummary _chapter(
    String childId,
    DateTime birth,
    int index,
    int current,
    List<JsonMap> fixtures,
    List<JsonMap> memories,
  ) {
    final range = childMonthRange(birth, index);
    final inRange = memories.where((row) {
      final at = DateTime.parse(row['occurredAt'] as String);
      return !at.isBefore(range.start) && at.isBefore(range.end);
    }).toList();
    final fixture = fixtures
        .where((row) => row['monthIndex'] == index)
        .firstOrNull;
    final local = fixture == null
        ? inRange
        : inRange.where((row) => row[localKey] == true).toList();
    final photo = memories.any(
      (row) =>
          row['kind'] == MemoryKind.monthlyPhoto.name &&
          row['monthIndex'] == index,
    );
    final cover = inRange
        .map((row) => (row['mediaAssets'] as List?)?.firstOrNull as String?)
        .nonNulls
        .firstOrNull;
    return ChapterSummary(
      childId: childId,
      monthIndex: index,
      start: range.start,
      end: range.end,
      memoryCount: ((fixture?['memories'] as int?) ?? 0) + local.length,
      firstsCount:
          ((fixture?['firsts'] as int?) ?? 0) + local.where(_isFirst).length,
      voiceCount:
          ((fixture?['voices'] as int?) ?? 0) +
          local.where((row) => row['kind'] == MemoryKind.voice.name).length,
      hasMonthlyPhoto: photo,
      coverAsset: (fixture?['coverAsset'] as String?) ?? cover,
      current: index == current,
    );
  }

  @override
  Future<WeekSummary> weekSummary() async {
    await ready();
    final base = _repository.stats()['week'] as JsonMap?;
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final week = _memoryRepository.memories(familyId).where((row) {
      final at = DateTime.parse(row['occurredAt'] as String);
      return !at.isBefore(monday) && (base == null || row[localKey] == true);
    }).toList();
    return WeekSummary(
      moments: ((base?['moments'] as int?) ?? 0) + week.length,
      firsts: ((base?['firsts'] as int?) ?? 0) + week.where(_isFirst).length,
      quotes:
          ((base?['quotes'] as int?) ?? 0) +
          week.where((row) => row['kind'] == MemoryKind.quote.name).length,
      thumbnails: [
        ...((base?['thumbnails'] as List?)?.cast<String>() ?? const []),
      ],
    );
  }

  @override
  Future<FetalSize?> fetalSize(String pregnancyId) async {
    await ready();
    final due = (await child(pregnancyId))?.dueDate;
    if (due == null) {
      return null;
    }
    final week = pregnancyWeek(due, today).week;
    final rows =
        ((_memoryRepository.catalog()['fetalSizes'] as List?) ?? const [])
            .cast<JsonMap>()
            .where((row) => (row['week'] as int) <= week)
            .toList();
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.last;
    return FetalSize(
      week: row['week'] as int,
      emoji: row['emoji'] as String,
      fruit: row['fruit'] as String,
      lengthCm: row['lengthCm'] as int,
    );
  }

  // ------------------------------------------------------------ batch 2

  @override
  Future<ChildProfile?> profile(String childId) async {
    await ready();
    final row = _repository.profile(childId);
    return row == null ? null : ChildProfile.fromJson(row);
  }

  @override
  Future<void> saveProfile(ChildProfile profile) async {
    await ready();
    _repository.saveProfile(profile.toJson());
  }

  @override
  Future<List<Child>> archivedChildren() async => (await children(
    includeArchived: true,
  )).where((child) => child.archived).toList();

  @override
  Future<void> archiveChild(String childId) async {
    await ready();
    _repository.updateChild(childId, {
      'archived': true,
      'archivedAt': now.toIso8601String(),
    });
  }

  @override
  Future<void> restoreChild(String childId) async {
    await ready();
    _repository.updateChild(childId, {'archived': false, 'archivedAt': null});
  }

  @override
  Future<void> reorderChildren(List<String> childIds) async {
    await ready();
    for (var index = 0; index < childIds.length; index++) {
      _repository.updateChild(childIds[index], {'order': index});
    }
  }
}
