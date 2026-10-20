import 'package:baby_family/data/dto/memory_grid_photo.dart';
import 'package:baby_family/data/dto/memory_search_result.dart';
import 'package:baby_family/data/model/memory/album.dart';
import 'package:baby_family/data/model/memory/bump_photo.dart';
import 'package:baby_family/data/model/memory/collection_summary.dart';
import 'package:baby_family/data/model/memory/day_story.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/memory_draft_item.dart';
import 'package:baby_family/data/model/memory/memory_perspective.dart';
import 'package:baby_family/data/model/memory/memory_prompt.dart';
import 'package:baby_family/data/model/memory/milestone_group.dart';
import 'package:baby_family/data/model/memory/milestone_item.dart';
import 'package:baby_family/data/model/memory/milestone_option.dart';
import 'package:baby_family/data/model/memory/month_recap.dart';
import 'package:baby_family/data/model/memory/monthly_photo.dart';
import 'package:baby_family/data/model/memory/on_this_day_group.dart';
import 'package:baby_family/data/model/memory/report_reason.dart';
import 'package:baby_family/data/model/memory/report_receipt.dart';
import 'package:baby_family/data/model/memory/story_item.dart';
import 'package:baby_family/data/model/memory/weekly_recap.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/service/memory.dart';
import 'package:baby_family/data/service_imp/child.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';

class MemoryServiceImp extends MockServiceImp implements IMemoryService {
  MemoryServiceImp(
    super.sessionRepository,
    super.clock,
    this._repository,
    this._childRepository,
    this._familyRepository,
  );

  final IMemoryRepository _repository;
  final IChildRepository _childRepository;
  final IFamilyRepository _familyRepository;

  Memory _toMemory(JsonMap row) {
    final id = row['id'] as String;
    final perspectives = _repository.perspectives(id);
    final first = perspectives.firstOrNull;
    return Memory.fromJson({
      ...row,
      // Ký ức đồng bộ từ server giữ số bình luận server (bình luận ở trên server).
      'commentCount': row['remoteStatus'] != null
          ? row['commentCount'] ?? 0
          : _repository.comments(id).length,
      'perspectiveCount': perspectives.length,
      'perspectiveAuthorId': first?['authorId'],
      'perspectivePreview': first?['body'],
    });
  }

  bool _visible(JsonMap row) =>
      row['visibility'] != MemoryVisibility.onlyMe.name ||
      row['authorId'] == myUserId;

  static DateTime _at(JsonMap row) =>
      DateTime.parse(row['occurredAt'] as String);

  /// Dữ liệu trên máy không thay đổi ngoài tác động của người dùng.
  @override
  Duration? refreshDelay() => null;

  @override
  Future<List<Memory>> memories({
    String? childId,
    Set<MemoryKind>? kinds,
  }) async {
    await ready();
    final rows = _repository.memories(familyId).where((row) {
      if (!_visible(row)) {
        return false;
      }
      if (childId != null && !(row['childIds'] as List).contains(childId)) {
        return false;
      }
      return kinds == null ||
          kinds.contains(MemoryKind.values.byName(row['kind'] as String));
    }).toList()..sort((a, b) => _at(b).compareTo(_at(a)));
    return rows.map(_toMemory).toList();
  }

  @override
  Future<Memory?> memory(String id) async {
    await ready();
    final row = _repository.memory(id) ?? _batchMemory(id);
    return row == null ? null : _toMemory(row);
  }

  @override
  Future<List<Memory>> timeline({String? childId}) =>
      memories(childId: childId);

  @override
  Future<List<MemoryGridPhoto>> photos({String? childId}) async => [
    for (final memory in await memories(childId: childId))
      for (final asset in memory.mediaAssets)
        MemoryGridPhoto(asset: asset, memory: memory),
  ];

  @override
  Future<Memory> updateMemory(
    String memoryId, {
    String? title,
    String? body,
    List<String>? childIds,
    DateTime? occurredAt,
    MemoryVisibility? visibility,
    bool? commentsEnabled,
    List<String>? mediaAssets,
  }) async {
    await ready();
    String? blank(String value) => value.trim().isEmpty ? null : value.trim();
    _repository.updateMemory(memoryId, {
      if (title != null) 'title': blank(title),
      if (body != null) 'body': blank(body),
      'childIds': ?childIds,
      if (occurredAt != null) 'occurredAt': occurredAt.toIso8601String(),
      if (visibility != null) 'visibility': visibility.name,
      'commentsEnabled': ?commentsEnabled,
      'mediaAssets': ?mediaAssets,
    });
    final row = _repository.memory(memoryId);
    if (row == null) {
      throw StateError('Memory $memoryId not found');
    }
    return _toMemory(row);
  }

  /// Ký ức chỉ có trong dữ liệu MEM-15/16, REC-02 (kết quả tìm kiếm, năm
  /// xưa, điểm nhấn tuần) — để chạm vào vẫn mở được MEM-07/08.
  JsonMap? _batchMemory(String id) {
    final recap = _repository.weeklyRecap()['highlights'] as List? ?? const [];
    return [
      ..._repository.searchMemories(familyId),
      ..._repository.pastMemories(familyId),
      for (final row in recap) Map<String, dynamic>.from(row as Map),
    ].where((row) => row['id'] == id).firstOrNull;
  }

  @override
  Future<Memory> create({
    required MemoryKind kind,
    required List<String> childIds,
    String? title,
    String? body,
    String? quoteContext,
    List<String> mediaAssets = const [],
    MemoryVisibility visibility = MemoryVisibility.family,
    DateTime? occurredAt,
    String? feeling,
    List<String> people = const [],
    String? milestoneCode,
    String? milestoneTitle,
    int? monthIndex,
    int? pregnancyWeek,
    int? voiceDurationSec,
    DateTime? sealedUntil,
    String? missionId,
    bool deferUpload = false,
  }) async {
    await ready();
    if (kind == MemoryKind.monthlyPhoto && monthIndex != null) {
      _demoteMonthlyPhoto(childIds.firstOrNull, monthIndex);
    }
    final milestone = milestoneCode == null
        ? null
        : _catalogList(
            'milestones',
          ).where((row) => row['code'] == milestoneCode).firstOrNull;
    final row = _repository.addMemory({
      'familyId': familyId,
      'kind': kind.name,
      'title': ?title,
      'body': ?body,
      'quoteContext': ?quoteContext,
      'childIds': childIds,
      'authorId': myUserId,
      'occurredAt': (occurredAt ?? now).toIso8601String(),
      'createdAt': now.toIso8601String(),
      'mediaAssets': mediaAssets,
      'visibility': visibility.name,
      'feeling': ?feeling,
      'people': people,
      'milestoneCode': ?milestoneCode,
      'milestoneTitle': ?(milestone?['title'] ?? milestoneTitle),
      'monthIndex': ?monthIndex,
      'pregnancyWeek': ?pregnancyWeek,
      'voiceDurationSec': ?voiceDurationSec,
      'sealedUntil': ?sealedUntil?.toIso8601String(),
      'missionId': ?missionId,
      ChildServiceImp.localKey: true,
    });
    return _toMemory(row);
  }

  void _demoteMonthlyPhoto(String? childId, int monthIndex) {
    for (final row in _repository.memories(familyId)) {
      if (row['kind'] == MemoryKind.monthlyPhoto.name &&
          row['monthIndex'] == monthIndex &&
          (row['childIds'] as List).contains(childId)) {
        _repository.updateMemory(row['id'] as String, {
          'kind': MemoryKind.photo.name,
        });
      }
    }
  }

  @override
  Future<List<String>> downloadUrls(String memoryId) async => const [];

  @override
  Future<void> toggleFavorite(String memoryId) async {
    final current = await memory(memoryId);
    if (current != null) {
      _repository.updateMemory(memoryId, {'isFavorite': !current.isFavorite});
    }
  }

  @override
  Future<void> react(String memoryId, String emoji) async {
    final current = await memory(memoryId);
    if (current == null) {
      return;
    }
    final reactions = {...current.reactions};
    final previous = current.myReaction;
    if (previous != null) {
      final left = (reactions[previous] ?? 1) - 1;
      if (left > 0) {
        reactions[previous] = left;
      } else {
        reactions.remove(previous);
      }
    }
    final next = previous == emoji ? null : emoji;
    if (next != null) {
      reactions[next] = (reactions[next] ?? 0) + 1;
    }
    _repository.updateMemory(memoryId, {
      'reactions': reactions,
      'myReaction': next,
    });
  }

  @override
  Future<List<MemoryComment>> comments(String memoryId) async {
    await ready();
    return _repository.comments(memoryId).map(MemoryComment.fromJson).toList();
  }

  @override
  Future<MemoryComment> addComment(
    String memoryId,
    String body, {
    String? parentId,
  }) async {
    await ready();
    final me = _familyRepository.member(myMemberId);
    return MemoryComment.fromJson(
      _repository.addComment({
        'memoryId': memoryId,
        'parentId': ?parentId,
        'authorId': myUserId,
        'authorName': me?['displayName'] ?? '',
        'authorRole': me?['role'],
        'body': body.trim(),
        'createdAt': now.toIso8601String(),
      }),
    );
  }

  @override
  Future<List<MemoryPerspective>> perspectives(String memoryId) async {
    await ready();
    return _repository
        .perspectives(memoryId)
        .map(MemoryPerspective.fromJson)
        .toList();
  }

  @override
  Future<MemoryPerspective> savePerspective(
    String memoryId, {
    required String body,
    List<String> mediaAssets = const [],
  }) async {
    await ready();
    final mine = _repository
        .perspectives(memoryId)
        .where((row) => row['authorId'] == myUserId)
        .firstOrNull;
    if (mine != null) {
      // BR-071: one perspective per parent — update instead of adding.
      final id = mine['id'] as String;
      _repository.updatePerspective(id, {
        'body': body.trim(),
        'mediaAssets': mediaAssets,
      });
      return MemoryPerspective.fromJson({
        ...mine,
        'body': body.trim(),
        'mediaAssets': mediaAssets,
      });
    }
    return MemoryPerspective.fromJson(
      _repository.addPerspective({
        'memoryId': memoryId,
        'authorId': myUserId,
        'body': body.trim(),
        'mediaAssets': mediaAssets,
        'createdAt': now.toIso8601String(),
      }),
    );
  }

  @override
  Future<List<MonthlyPhoto>> monthlyPhotos(String childId) async {
    final rows = await memories(
      childId: childId,
      kinds: {MemoryKind.monthlyPhoto},
    );
    return [
      for (final memory in rows)
        MonthlyPhoto(
          id: memory.id,
          childId: childId,
          monthIndex: memory.monthIndex ?? 0,
          memoryId: memory.id,
          asset: memory.mediaAssets.firstOrNull,
          takenAt: memory.occurredAt,
        ),
    ]..sort((a, b) => a.monthIndex.compareTo(b.monthIndex));
  }

  @override
  Future<Memory> saveMonthlyPhoto(
    String childId, {
    required String asset,
    int? monthIndex,
  }) async {
    await ready();
    final birth = _childRepository.child(childId)?['birthDate'] as String?;
    final index =
        monthIndex ??
        (birth == null
            ? 1
            : childAgeInMonths(DateTime.parse(birth), today).clamp(1, 999));
    return create(
      kind: MemoryKind.monthlyPhoto,
      childIds: [childId],
      mediaAssets: [asset],
      monthIndex: index,
    );
  }

  @override
  Future<List<BumpPhoto>> bumpPhotos(String pregnancyId) async {
    final rows = await memories(childId: pregnancyId, kinds: {MemoryKind.bump});
    return [
      for (final memory in rows)
        BumpPhoto(
          id: memory.id,
          pregnancyId: pregnancyId,
          week: memory.pregnancyWeek ?? 0,
          asset: memory.mediaAssets.firstOrNull,
          memoryId: memory.id,
          takenAt: memory.occurredAt,
        ),
    ]..sort((a, b) => a.week.compareTo(b.week));
  }

  @override
  Future<List<StoryItem>> stories({String? childId}) async {
    await ready();
    return [
      for (final row in _repository.stories(familyId))
        if (childId == null || row['childId'] == childId)
          StoryItem.fromJson({
            ...row,
            'seen': (row['seenBy'] as List? ?? const []).contains(myUserId),
          }),
    ]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<void> markStorySeen(String storyId) async {
    await ready();
    final row = _repository.story(storyId);
    final seenBy = [...(row?['seenBy'] as List? ?? const [])];
    if (row != null && !seenBy.contains(myUserId)) {
      _repository.updateStory(storyId, {
        'seenBy': [...seenBy, myUserId],
      });
    }
  }

  static const _collectionKinds = <String, Set<MemoryKind>>{
    'monthly': {MemoryKind.monthlyPhoto},
    'firsts': {MemoryKind.milestone},
    'quotes': {MemoryKind.quote},
    'voices': {MemoryKind.voice},
    'letters': {MemoryKind.letter},
    'keepsakes': {MemoryKind.keepsake},
  };

  @override
  Future<List<CollectionSummary>> collections() async {
    await ready();
    final all = await memories();
    return [
      for (final row in _repository.collections())
        CollectionSummary.fromJson({
          ...row,
          'count': _collectionCount(all, row),
        }),
    ];
  }

  /// Fixture `count` = số liệu nền của thiết kế; cộng thêm ký ức tạo trong
  /// phiên (giống `ChildServiceImp.stats`).
  int _collectionCount(List<Memory> all, JsonMap row) {
    final items = _inCollection(all, row['code'] as String);
    final base = row['count'] as int?;
    if (base == null) {
      return items.length;
    }
    final local = {
      for (final memory in _repository.memories(familyId))
        if (memory[ChildServiceImp.localKey] == true) memory['id'],
    };
    return base + items.where((memory) => local.contains(memory.id)).length;
  }

  @override
  Future<int> sealedLetters() async {
    await ready();
    final row = _repository
        .collections()
        .where((row) => row['code'] == 'letters')
        .firstOrNull;
    final sealed = (await memories(kinds: {MemoryKind.letter})).where(
      (memory) =>
          memory.sealedUntil != null && memory.sealedUntil!.isAfter(now),
    );
    return ((row?['sealed'] as int?) ?? 0) + sealed.length;
  }

  List<String> get _usedDrafts => [
    ...((sessionRepository.session()['usedDrafts'] as List?) ?? const [])
        .cast<String>(),
  ];

  @override
  Future<Memory?> draft(MemoryKind kind) async {
    await ready();
    final drafts = _repository.catalog()['memoryDrafts'] as Map?;
    final row = drafts?[kind.name] as Map?;
    if (row == null || _usedDrafts.contains(kind.name)) {
      return null;
    }
    return Memory.fromJson({
      ...Map<String, dynamic>.from(row),
      'id': 'draft-${kind.name}',
      'familyId': familyId,
      'kind': kind.name,
      'authorId': myUserId,
      'occurredAt': now.toIso8601String(),
    });
  }

  @override
  Future<void> clearDraft(MemoryKind kind) async {
    await ready();
    if (!_usedDrafts.contains(kind.name)) {
      sessionRepository.patchSession({
        'usedDrafts': [..._usedDrafts, kind.name],
      });
    }
  }

  Iterable<Memory> _inCollection(List<Memory> all, String code) =>
      switch (code) {
        'together' => all.where((memory) => memory.bothTell),
        'best' => all.where((memory) => memory.isFavorite),
        _ => all.where(
          (memory) => _collectionKinds[code]?.contains(memory.kind) ?? false,
        ),
      };

  @override
  Future<List<Memory>> collectionMemories(String code) async =>
      _inCollection(await memories(), code).toList();

  List<JsonMap> _catalogList(String key) =>
      ((_repository.catalog()[key] as List?) ?? const []).cast<JsonMap>();

  @override
  Future<MemoryPrompt?> todayPrompt({String? childId}) async {
    await ready();
    final dismissed = sessionRepository.session()['promptDismissedOn'];
    if (dismissed == today.toIso8601String()) {
      return null;
    }
    final children = _childRepository
        .children(familyId)
        .where((row) => childId == null || row['id'] == childId)
        .where((row) => row['kind'] == ChildKind.baby.name)
        .toList();
    for (final prompt in _catalogList('prompts')) {
      for (final child in children) {
        final ageDays = childAgeInDays(
          DateTime.parse(child['birthDate'] as String),
          today,
        );
        final min = prompt['minAgeDays'] as int?;
        final max = prompt['maxAgeDays'] as int?;
        if ((min == null || ageDays >= min) &&
            (max == null || ageDays <= max)) {
          return MemoryPrompt(
            id: prompt['id'] as String,
            childId: child['id'] as String,
            kind: MemoryKind.values.byName(prompt['kind'] as String),
            text: (prompt['text'] as String).replaceAll(
              '{child}',
              child['name'] as String,
            ),
          );
        }
      }
    }
    return null;
  }

  @override
  Future<void> dismissPrompt() async {
    await ready();
    sessionRepository.patchSession({
      'promptDismissedOn': today.toIso8601String(),
    });
  }

  @override
  Future<List<MilestoneItem>> milestones(String childId) async {
    await ready();
    final child = _childRepository.child(childId);
    final pregnancy = child?['kind'] == ChildKind.pregnancy.name;
    final achieved = {
      for (final row in _repository.memories(familyId))
        if ((row['childIds'] as List).contains(childId) &&
            row['milestoneCode'] != null)
          row['milestoneCode']: row,
    };
    return [
      for (final row in _catalogList('milestones'))
        if ((row['forPregnancy'] == true) == pregnancy)
          MilestoneItem.fromJson({
            ...row,
            'memoryId': achieved[row['code']]?['id'],
            'achievedAt': achieved[row['code']]?['occurredAt'],
            'asset':
                (achieved[row['code']]?['mediaAssets'] as List?)?.firstOrNull,
          }),
    ];
  }

  @override
  Future<List<String>> monthlyStickers(String childId, int monthIndex) async {
    await ready();
    final name = _childRepository.child(childId)?['name'] as String? ?? '';
    return [
      for (final sticker in (_repository.catalog()['stickers'] as List? ?? []))
        (sticker as String)
            .replaceAll('{child}', name)
            .replaceAll('{month}', '$monthIndex'),
    ];
  }

  // ------------------------------------------------------------ batch 2

  @override
  Future<List<Album>> albums() async {
    await ready();
    final rows = _repository.albums(familyId).map(Album.fromJson).toList();
    return [
      ...rows.where((album) => album.isAuto),
      ...rows.where((album) => !album.isAuto),
    ];
  }

  @override
  Future<Album?> album(String id) async {
    await ready();
    final row = _repository.album(id);
    return row == null ? null : Album.fromJson(row);
  }

  @override
  Future<Album> createAlbum({
    required String title,
    List<String> childIds = const [],
  }) async {
    await ready();
    return Album.fromJson(
      _repository.addAlbum({
        'familyId': familyId,
        'title': title.trim(),
        'childIds': childIds,
        'createdByUserId': myUserId,
        'startDate': today.toIso8601String(),
      }),
    );
  }

  @override
  Future<void> renameAlbum(String id, String title) async {
    await ready();
    _repository.updateAlbum(id, {'title': title.trim()});
  }

  @override
  Future<void> changeAlbumCover(String id, String asset) async {
    await ready();
    _repository.updateAlbum(id, {'coverAsset': asset});
  }

  @override
  Future<void> deleteAlbum(String id) async {
    await ready();
    _repository.removeAlbum(id);
  }

  @override
  Future<void> editComment(String commentId, String body) async {
    await ready();
    _repository.updateComment(commentId, {'body': body.trim()});
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await ready();
    _repository.removeComment(commentId);
  }

  JsonMap get _picker => Map<String, dynamic>.from(
    (_repository.catalog()['milestonePicker'] as Map?) ?? const {},
  );

  @override
  Future<List<MilestoneGroup>> milestoneGroups() async {
    await ready();
    return [
      for (final row in (_picker['groups'] as List?) ?? const [])
        MilestoneGroup.fromJson(Map<String, dynamic>.from(row as Map)),
    ];
  }

  @override
  Future<List<MilestoneOption>> milestoneOptions(
    String childId, {
    String? group,
  }) async {
    await ready();
    final records = {
      for (final row in _childRepository.milestoneRecords(childId))
        row['code']: row,
    };
    return [
      for (final row in (_picker['items'] as List?) ?? const [])
        if (group == null || (row as Map)['group'] == group)
          MilestoneOption.fromJson({
            ...Map<String, dynamic>.from(row as Map),
            'recordedAt': records[row['code']]?['recordedAt'],
            'expectedDate': records[row['code']]?['expectedDate'],
          }),
    ];
  }

  @override
  Future<void> recordMilestone(
    String childId,
    String code, {
    DateTime? at,
  }) async {
    await ready();
    _childRepository.addMilestoneRecord({
      'childId': childId,
      'code': code,
      'recordedAt': (at ?? today).toIso8601String(),
    });
  }

  @override
  Future<List<String>> diaryPrompts(String childId) async {
    await ready();
    final name = _childRepository.child(childId)?['name'] as String? ?? '';
    return [
      for (final prompt
          in (_repository.catalog()['diaryPrompts'] as List?) ?? const [])
        (prompt as String).replaceAll('{child}', name),
    ];
  }

  @override
  Future<Memory?> refreshMemory(String id) => memory(id);

  @override
  Future<void> retryUpload(String memoryId) async {}

  @override
  Future<void> cancelUpload(String memoryId) async {
    await ready();
    _repository.removeMemory(memoryId);
  }

  @override
  Future<int?> videoDurationSec(String path) async => null;

  @override
  Future<List<String>> searchRecents() async {
    await ready();
    return _repository.searchRecents();
  }

  static String _fold(String value) {
    const from =
        'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ';
    const to =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    final lower = value.toLowerCase();
    final buffer = StringBuffer();
    for (final char in lower.split('')) {
      final index = from.indexOf(char);
      buffer.write(index < 0 ? char : to[index]);
    }
    return buffer.toString();
  }

  @override
  Future<MemorySearchResult> search(String query, {String? childId}) async {
    await ready();
    final needle = _fold(query.trim());
    if (needle.isEmpty) {
      return MemorySearchResult(query: query);
    }
    final recents = _repository.searchRecents();
    if (!recents.contains(query.trim())) {
      _repository.saveSearchRecents(
        [query.trim(), ...recents].take(5).toList(),
      );
    }
    final rows =
        [
              ..._repository.searchMemories(familyId),
              ..._repository.memories(familyId).where(_visible),
            ]
            .where((row) {
              if (childId != null &&
                  !(row['childIds'] as List).contains(childId)) {
                return false;
              }
              final text = [
                row['title'],
                row['body'],
                row['quoteContext'],
              ].whereType<String>().join(' ');
              return _fold(text).contains(needle);
            })
            .map(Memory.fromJson)
            .toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return MemorySearchResult(
      query: query,
      media: rows.where((memory) => memory.mediaAssets.isNotEmpty).toList(),
      diaries: rows.where((memory) => memory.kind == MemoryKind.diary).toList(),
    );
  }

  @override
  Future<List<OnThisDayGroup>> onThisDay({DateTime? date}) async {
    await ready();
    final day = date ?? today;
    final byYear = <int, List<Memory>>{};
    for (final row in _repository.pastMemories(familyId)) {
      final memory = Memory.fromJson(row);
      if (memory.occurredAt.month == day.month &&
          memory.occurredAt.day == day.day &&
          memory.occurredAt.year < day.year) {
        byYear.putIfAbsent(memory.occurredAt.year, () => []).add(memory);
      }
    }
    final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final year in years)
        OnThisDayGroup(
          yearsAgo: day.year - year,
          date: DateTime(year, day.month, day.day),
          childId: byYear[year]!.first.childIds.firstOrNull,
          memories: byYear[year]!,
        ),
    ];
  }

  @override
  Future<WeeklyRecap?> weeklyRecap() async {
    await ready();
    final row = _repository.weeklyRecap();
    return row.isEmpty ? null : WeeklyRecap.fromJson(row);
  }

  // ------------------------------------------------------------ batch 3

  /// Thùng rác giữ 30 ngày (mục 7.x, MEM-17).
  static const _trashDays = 30;

  @override
  Future<List<Memory>> trash() async {
    await ready();
    return _repository.trash(familyId).map(Memory.fromJson).toList()..sort(
      (a, b) =>
          (b.deletedAt ?? b.occurredAt).compareTo(a.deletedAt ?? a.occurredAt),
    );
  }

  @override
  int trashDaysLeft(Memory memory) {
    final deleted = memory.deletedAt;
    if (deleted == null) {
      return _trashDays;
    }
    final day = DateTime(deleted.year, deleted.month, deleted.day);
    return (_trashDays - today.difference(day).inDays).clamp(0, _trashDays);
  }

  @override
  Future<void> restoreMemory(String memoryId) async {
    await ready();
    _repository.restoreFromTrash(memoryId);
  }

  @override
  Future<void> deleteForever(String memoryId) async {
    await ready();
    _repository.removeFromTrash(memoryId);
  }

  @override
  int get trashDays => _trashDays;

  @override
  Future<void> moveToTrash(String memoryId) async {
    await ready();
    _repository.moveToTrash(memoryId, {
      'deletedAt': now.toIso8601String(),
      'deletedByUserId': myUserId,
    });
  }

  @override
  Future<MemoryDraftItem> saveDraft({
    required MemoryKind kind,
    String title = '',
    List<String> childIds = const [],
    List<String> mediaAssets = const [],
    int? voiceDurationSec,
  }) async {
    await ready();
    return MemoryDraftItem.fromJson(
      _repository.addDraft({
        'kind': kind.name,
        'title': title,
        'childIds': childIds,
        'updatedAt': now.toIso8601String(),
        'location': DraftLocation.device.name,
        'mediaAssets': mediaAssets.take(1).toList(),
        'extraCount': mediaAssets.length > 1 ? mediaAssets.length - 1 : 0,
        'voiceDurationSec': ?voiceDurationSec,
        'userId': myUserId,
      }),
    );
  }

  @override
  Future<List<MemoryDraftItem>> drafts() async {
    await ready();
    final all = _repository.drafts(myUserId).map(MemoryDraftItem.fromJson);
    return [
      ...all.where((draft) => draft.location == DraftLocation.device),
      ...all.where((draft) => draft.location == DraftLocation.cloud),
    ];
  }

  @override
  Future<void> deleteDraft(String draftId) async {
    await ready();
    _repository.removeDraft(draftId);
  }

  @override
  Future<List<Memory>> pendingPosts() async {
    await ready();
    return _repository.pendingPosts(familyId).map(Memory.fromJson).toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  }

  @override
  Future<void> approvePost(String postId, {List<String>? childIds}) async {
    await ready();
    _repository.approvePendingPost(postId, {
      'childIds': ?childIds,
      ChildServiceImp.localKey: true,
    });
  }

  @override
  Future<void> rejectPost(String postId, {String? reason}) async {
    await ready();
    _repository.removePendingPost(postId);
  }

  @override
  Future<List<String>> rejectReasons() async {
    await ready();
    return ((_repository.catalog()['rejectReasons'] as List?) ?? const [])
        .cast<String>();
  }

  @override
  Future<List<ReportReason>> reportReasons() async {
    await ready();
    return [
      for (final row
          in (_repository.catalog()['reportReasons'] as List?) ?? const [])
        ReportReason.fromJson(Map<String, dynamic>.from(row as Map)),
    ];
  }

  @override
  Future<ReportReceipt> submitReport({
    required String targetId,
    ReportTarget target = ReportTarget.memory,
    required String reasonCode,
    String? note,
    bool hideForMe = false,
    bool removeFromFamily = false,
  }) async {
    await ready();
    if (removeFromFamily) {
      _repository.updateMemory(targetId, {
        'visibility': MemoryVisibility.onlyMe.name,
      });
    }
    // Mock receipt: the design's sample code (RPT-01b).
    return ReportReceipt(code: 'BC-261007-0482', createdAt: now);
  }

  @override
  Future<DayStory?> dayStory({String? childId}) async {
    await ready();
    final row = _repository.dayStory();
    if (row.isEmpty || (childId != null && row['childId'] != childId)) {
      return null;
    }
    return DayStory.fromJson(row);
  }

  @override
  Future<void> saveDayStory(DayStory story) async {
    await ready();
    _repository.saveDayStory(story.toJson());
  }

  @override
  Future<MonthRecap?> monthRecap({String? childId}) async {
    await ready();
    final row = _repository.monthRecap();
    if (row.isEmpty || (childId != null && row['childId'] != childId)) {
      return null;
    }
    return MonthRecap.fromJson(row);
  }
}
