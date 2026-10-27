import 'dart:async';
import 'dart:typed_data';

import 'package:baby_family/data/dto/processed_media.dart';
import 'package:baby_family/data/model/child/child_record.dart';
import 'package:baby_family/data/model/child/child_stats_record.dart';
import 'package:baby_family/data/model/memory/comment_record.dart';
import 'package:baby_family/data/model/memory/media_asset_record.dart';
import 'package:baby_family/data/model/memory/media_grid_item_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/memory/on_this_day_record.dart';
import 'package:baby_family/data/model/memory/reaction_state.dart';
import 'package:baby_family/data/model/memory/timeline_item_record.dart';
import 'package:baby_family/data/model/memory/today_story_record.dart';
import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_part_url.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/model/pregnancy/journey_record.dart';
import 'package:baby_family/data/model/pregnancy/journey_size_record.dart';
import 'package:baby_family/data/model/pregnancy/journey_week_record.dart';
import 'package:baby_family/data/model/pregnancy/pregnancy_record.dart';
import 'package:baby_family/data/model/recap/week_stats_record.dart';
import 'package:baby_family/data/model/safety/report_record.dart';
import 'package:baby_family/data/model/sync/change_item.dart';
import 'package:baby_family/data/model/sync/outbox_entry.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/remote/app_client/base_response.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/memory_feed.dart';
import 'package:baby_family/data/repository/outbox.dart';
import 'package:baby_family/data/repository/pregnancy_remote.dart';
import 'package:baby_family/data/repository/subject.dart';
import 'package:baby_family/data/service_imp/child_remote.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/memory_remote.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';
import '../helpers/fake_local_memory_db.dart';
import '../helpers/fake_outbox.dart';

/// API giả cho bé/thai kỳ (BF-20261016-002).
class _FakeSubjects implements ISubjectRepository {
  final created = <JsonMap>[];
  final patches = <String, JsonMap>{};

  @override
  Future<ChildRecord?> createChild(String familyId, JsonMap body) async {
    created.add({'familyId': familyId, ...body});
    return ChildRecord(id: 'srv-child-${created.length}', status: 'ACTIVE');
  }

  @override
  Future<ChildRecord?> updateChild(
    String familyId,
    String childId,
    JsonMap body,
  ) async {
    patches[childId] = body;
    return ChildRecord(id: childId);
  }

  @override
  Future<PregnancyRecord?> createPregnancy(
    String familyId,
    JsonMap body,
  ) async {
    created.add({'familyId': familyId, ...body});
    return const PregnancyRecord(id: 'srv-pregnancy', seqNo: 3);
  }

  @override
  Future<PregnancyRecord?> updatePregnancy(
    String familyId,
    String pregnancyId,
    JsonMap body,
  ) async {
    patches[pregnancyId] = body;
    return PregnancyRecord(id: pregnancyId);
  }

  final calls = <String>[];

  @override
  Future<void> reorderChildren(String familyId, List<String> childIds) async =>
      calls.add('order:${childIds.join(',')}');

  @override
  Future<void> archiveChild(String childId) async =>
      calls.add('archive:$childId');

  @override
  Future<void> restoreChild(String childId) async =>
      calls.add('restore:$childId');

  @override
  Future<void> deleteChild(
    String childId, {
    required String confirmName,
  }) async => calls.add('delete:$childId:$confirmName');

  @override
  Future<void> setChildAvatar(String childId, String? assetId) async =>
      calls.add('avatar:$childId:$assetId');

  @override
  Future<void> setChildCover(String childId, String? assetId) async =>
      calls.add('cover:$childId:$assetId');

  final statsCalls = <String>[];

  @override
  Future<ChildStatsRecord?> childStats(String childId) async {
    statsCalls.add(childId);
    return const ChildStatsRecord(memoryCount: 42, milestoneCount: 5);
  }

  @override
  Future<WeekStatsRecord?> weekStats(String familyId) async =>
      const WeekStatsRecord(memoryCount: 7, milestoneCount: 2);
}

/// Thai kỳ trên server giả (chỉ cần kích thước theo tuần cho bé).
class _FakePregnancies extends Fake implements IPregnancyRemoteRepository {
  @override
  Future<JourneyRecord?> journey(String pregnancyId, {int? week}) async =>
      const JourneyRecord(
        currentWeek: 24,
        week: JourneyWeekRecord(
          number: 24,
          size: JourneySizeRecord(emoji: '🌽', lengthCm: 30, label: 'bắp ngô'),
        ),
      );
}

class _FakeMedia implements IMediaRepository {
  final intents = <JsonMap>[];
  final uploaded = <int>[];
  final completed = <String>[];

  @override
  Future<Uint8List> readLocalFile(String path) async =>
      Uint8List.fromList(path.codeUnits);

  /// Lần xin upload tiếp theo trả multipart (file lớn).
  bool nextMultipart = false;

  /// Số lần xin upload tiếp theo bị lỗi mạng (MEM-06 thử lại).
  int failNext = 0;
  final completedParts = <List<JsonMap>>[];

  @override
  Future<int?> mediaDurationMs(String path) async => 95000;

  @override
  Future<ProcessedMedia> processImage(String path) async => ProcessedMedia(
    kind: 'IMAGE',
    mime: 'image/jpeg',
    bytes: Uint8List.fromList(path.codeUnits),
    width: 4032,
    height: 3024,
    variants: [
      MediaVariantFile(
        code: 'm1080',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([1, 2, 3]),
        width: 1080,
        height: 810,
      ),
      MediaVariantFile(
        code: 't320',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([4]),
        width: 320,
        height: 240,
      ),
    ],
  );

  @override
  Future<ProcessedMedia> processVideo(String path) async => ProcessedMedia(
    kind: 'VIDEO',
    mime: 'video/mp4',
    bytes: Uint8List.fromList(path.codeUnits),
    width: 1920,
    height: 1080,
    durationMs: 95000,
    variants: [
      MediaVariantFile(
        code: 'poster',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([5, 6]),
      ),
      MediaVariantFile(
        code: 't320',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([7]),
      ),
    ],
  );

  @override
  Future<UploadIntent?> createUploadIntent(
    String idempotencyKey,
    JsonMap body,
  ) async {
    if (failNext > 0) {
      failNext--;
      throw DioException(requestOptions: RequestOptions(path: '/media'));
    }
    intents.add(body);
    final multipart = nextMultipart;
    nextMultipart = false;
    return UploadIntent(
      assetId: 'asset-${intents.length}',
      status: 'PENDING_UPLOAD',
      variantUploads: [
        for (final variant in (body['variants'] as List?) ?? const [])
          VariantUpload(
            code: (variant as Map)['code'] as String,
            upload: UploadInstruction(
              mode: 'single',
              url: 'https://s3/${variant['code']}',
            ),
          ),
      ],
      upload: multipart
          ? const UploadInstruction(
              mode: 'multipart',
              partSize: 8,
              partCount: 2,
              parts: [
                UploadPartUrl(n: 1, url: 'https://s3/p1'),
                UploadPartUrl(n: 2, url: 'https://s3/p2'),
              ],
            )
          : const UploadInstruction(mode: 'single', url: 'https://s3/put'),
    );
  }

  @override
  Future<List<JsonMap>> uploadBytes(
    UploadInstruction instruction,
    Uint8List bytes,
  ) async {
    uploaded.add(bytes.length);
    return [
      for (final part in instruction.parts) {'n': part.n, 'etag': 'e${part.n}'},
    ];
  }

  @override
  Future<UploadStatus?> completeUpload(
    String assetId, {
    List<JsonMap> parts = const [],
  }) async {
    completed.add(assetId);
    completedParts.add(parts);
    return UploadStatus(assetId: assetId, status: 'UPLOADED');
  }

  /// Lần hỏi trạng thái (VOICE chờ READY): lần đầu còn PROCESSING.
  final statusChecks = <String>[];

  @override
  Future<UploadStatus?> assetStatus(String assetId) async {
    statusChecks.add(assetId);
    return UploadStatus(
      assetId: assetId,
      status: statusChecks.length == 1 ? 'PROCESSING' : 'READY',
    );
  }
}

/// Đồng hồ điều khiển được để thử nhịp đồng bộ (BF-20261017-001).
class _TestClock extends AppClock {
  _TestClock(this.current) : super.system();

  DateTime current;

  void advance(Duration duration) => current = current.add(duration);

  @override
  DateTime now() => current;
}

class _FakeFeed implements IMemoryFeedRepository {
  final subjectCalls = <String>[];
  final created = <JsonMap>[];
  final keys = <String>[];
  bool failNext = false;
  List<MemoryRecord> page = const [];
  int feedCalls = 0;

  /// Trang theo cursor (null = trang đầu); khi có thì thay cho [page].
  Map<String?, (List<MemoryRecord>, String?)>? pages;
  final cursors = <String?>[];
  String? failCursor;
  Completer<void>? gate;

  /// Mất mạng (không có response) / server từ chối một lần với mã này.
  bool offline = false;
  int? rejectWith;

  @override
  Future<MemoryRecord?> createMemory(
    String idempotencyKey,
    JsonMap body,
  ) async {
    keys.add(idempotencyKey);
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: '/memories'));
    }
    final status = rejectWith;
    if (status != null) {
      rejectWith = null;
      final options = RequestOptions(path: '/memories');
      throw DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: status),
      );
    }
    if (failNext) {
      failNext = false;
      throw StateError('response lost');
    }
    created.add(body);
    return const MemoryRecord(id: 'srv-memory', status: 'PROCESSING');
  }

  @override
  Future<({List<MemoryRecord> memories, String? nextCursor})> feed(
    String familyId, {
    String? childId,
    String? pregnancyId,
    String? cursor,
    int? limit,
  }) async {
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: '/feed'));
    }
    if (childId != null || pregnancyId != null) {
      subjectCalls.add(childId ?? 'preg:$pregnancyId');
      return (memories: const <MemoryRecord>[], nextCursor: null);
    }
    feedCalls++;
    cursors.add(cursor);
    await gate?.future;
    if (cursor != null && cursor == failCursor) {
      throw DioException(requestOptions: RequestOptions(path: '/feed'));
    }
    final paged = pages?[cursor];
    if (pages != null) {
      return (
        memories: paged?.$1 ?? const <MemoryRecord>[],
        nextCursor: paged?.$2,
      );
    }
    return (memories: page, nextCursor: null);
  }

  @override
  Future<MemoryRecord?> memory(String memoryId) async {
    memoryReads.add(memoryId);
    return byId[memoryId] ?? latest;
  }

  final memoryReads = <String>[];
  final byId = <String, MemoryRecord>{};

  /// Trang changes theo cursor gửi lên; null = chưa cấu hình (trang rỗng).
  Map<String?, ChangesPage> changePages = const {};
  final changeCursors = <String?>[];
  String? changesError;

  @override
  Future<ChangesPage> changes(
    String familyId, {
    String? cursor,
    int? limit,
  }) async {
    changeCursors.add(cursor);
    final code = changesError;
    if (code != null) {
      changesError = null;
      final options = RequestOptions(path: '/changes');
      throw DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 409,
          data: {
            'error': {'code': code},
          },
        ),
      );
    }
    return changePages[cursor] ?? ChangesPage(nextCursor: cursor ?? 'c0');
  }

  final updates = <(String, int, JsonMap)>[];
  int conflictsLeft = 0;
  MemoryRecord? latest;

  @override
  Future<MemoryRecord?> updateMemory(
    String memoryId,
    int version,
    JsonMap body,
  ) async {
    updates.add((memoryId, version, body));
    if (conflictsLeft > 0) {
      conflictsLeft--;
      throw DioException(
        requestOptions: RequestOptions(path: '/memories/$memoryId'),
        response: Response(
          requestOptions: RequestOptions(path: '/memories/$memoryId'),
          statusCode: 412,
          data: {
            'error': {'code': 'VERSION_CONFLICT'},
          },
        ),
      );
    }
    return MemoryRecord(
      id: memoryId,
      kind: 'MOMENT',
      status: 'PUBLISHED',
      version: version + 1,
      authorUserId: 'srv-me',
      body: body['body'] as String? ?? 'srv-1',
      visibility: body['visibility'] as String? ?? 'PARENTS',
      occurredAt: DateTime.utc(2026, 10, 7),
      createdAt: DateTime.utc(2026, 10, 7),
    );
  }

  List<TimelineItemRecord> timelineItems = const [];
  List<MediaGridItemRecord> gridItems = const [];
  final timelineCalls = <String>[];

  @override
  Future<({List<TimelineItemRecord> items, String? nextCursor})> timeline(
    String familyId, {
    String? childId,
    String? pregnancyId,
    String? cursor,
    int? limit,
  }) async {
    timelineCalls.add(
      'child:${childId ?? '-'} pregnancy:${pregnancyId ?? '-'}',
    );
    return (items: timelineItems, nextCursor: null);
  }

  @override
  Future<({List<MediaGridItemRecord> items, String? nextCursor})> mediaGrid(
    String familyId, {
    String? childId,
    String? cursor,
    int? limit,
  }) async => (items: gridItems, nextCursor: null);

  final reactionCalls = <String>[];
  final commentCalls = <String>[];
  final reactionKeys = <String?>[];
  final commentKeys = <String?>[];
  List<CommentRecord> commentPage = const [];

  @override
  Future<ReactionState?> setReaction(
    String memoryId,
    String type, {
    String? idempotencyKey,
  }) async {
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: '/reaction'));
    }
    reactionKeys.add(idempotencyKey);
    reactionCalls.add('put:$type');
    return ReactionState(
      memoryId: memoryId,
      reactions: {type: 1, 'LOVE': 2},
      myReaction: type,
      reactionCount: 3,
    );
  }

  @override
  Future<ReactionState?> clearReaction(
    String memoryId, {
    String? idempotencyKey,
  }) async {
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: '/reaction'));
    }
    reactionKeys.add(idempotencyKey);
    reactionCalls.add('delete');
    return ReactionState(
      memoryId: memoryId,
      reactions: const {'LOVE': 2},
      reactionCount: 2,
    );
  }

  @override
  Future<List<CommentRecord>> comments(String memoryId) async {
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: '/comments'));
    }
    return commentPage;
  }

  @override
  Future<CommentRecord?> addComment(
    String memoryId,
    String body, {
    String? parentCommentId,
    String? idempotencyKey,
  }) async {
    if (offline) {
      throw DioException(requestOptions: RequestOptions(path: '/comments'));
    }
    commentKeys.add(idempotencyKey);
    commentCalls.add('add:$body:${parentCommentId ?? '-'}');
    return CommentRecord(
      id: 'srv-c-new',
      memoryId: memoryId,
      authorUserId: 'srv-me',
      parentCommentId: parentCommentId,
      body: body,
      createdAt: DateTime.utc(2026, 10, 10),
    );
  }

  @override
  Future<CommentRecord?> editComment(String commentId, String body) async {
    commentCalls.add('edit:$commentId:$body');
    return null;
  }

  @override
  Future<void> deleteComment(String commentId) async =>
      commentCalls.add('delete:$commentId');

  final trashed = <String>[];
  final restored = <String>[];
  final purged = <String>[];
  List<MemoryRecord> trashPage = const [];

  @override
  Future<void> trashMemory(String memoryId) async => trashed.add(memoryId);

  @override
  Future<({List<MemoryRecord> memories, String? nextCursor})> trash(
    String familyId, {
    String? cursor,
    int? limit,
  }) async => (memories: trashPage, nextCursor: null);

  @override
  Future<MemoryRecord?> restoreMemory(String memoryId) async {
    restored.add(memoryId);
    return MemoryRecord(
      id: memoryId,
      kind: 'MOMENT',
      status: 'PUBLISHED',
      authorUserId: 'srv-me',
      body: 'Khôi phục',
      visibility: 'PARENTS',
      occurredAt: DateTime.utc(2026, 10, 7),
      createdAt: DateTime.utc(2026, 10, 7),
    );
  }

  @override
  Future<void> purgeMemory(String memoryId) async => purged.add(memoryId);

  List<MemoryRecord> draftRecords = const [];

  @override
  Future<List<MemoryRecord>> drafts(String familyId) async => draftRecords;

  final published = <String>[];

  @override
  Future<MemoryRecord?> publish(String memoryId) async {
    published.add(memoryId);
    return MemoryRecord(
      id: memoryId,
      kind: 'DIARY',
      status: 'PUBLISHED',
      version: 2,
      authorUserId: 'srv-me',
      title: 'Nháp trên tài khoản',
      visibility: 'PARENTS',
      occurredAt: DateTime.utc(2026, 10, 18),
      createdAt: DateTime.utc(2026, 10, 18),
    );
  }

  List<MemoryRecord> searchRecords = const [];
  final searches = <String>[];
  OnThisDayRecord? onThisDayRecord;
  final reports = <JsonMap>[];
  TodayStoryRecord? story;

  @override
  Future<TodayStoryRecord?> todayStory(String childId) async => story;

  @override
  Future<List<MemoryRecord>> search(
    String familyId,
    String query, {
    String? childId,
  }) async {
    searches.add('$query|$childId');
    return searchRecords;
  }

  @override
  Future<OnThisDayRecord?> onThisDay(String familyId, {String? date}) async =>
      onThisDayRecord;

  @override
  Future<ReportRecord?> report(JsonMap body) async {
    reports.add(body);
    return ReportRecord(
      id: 'r-1',
      code: 'BC-261019-0001',
      status: 'NEW',
      createdAt: DateTime.utc(2026, 10, 19),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeSubjects subjects;
  late _FakeMedia media;
  late _FakeFeed feed;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    subjects = _FakeSubjects();
    media = _FakeMedia();
    feed = _FakeFeed();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({
      kValueSessionKeyServerFamilyId: 'srv-family',
      kValueSessionKeyServerUserId: 'srv-me',
    });
  });

  ChildRemoteServiceImp children() => ChildRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(childRepositoryProvider),
    container.read(memoryRepositoryProvider),
    subjects,
    _FakePregnancies(),
    MediaUploader(media),
  );

  MemoryRemoteServiceImp memories({AppClock? clock}) => MemoryRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    clock ?? container.read(appClockProvider),
    container.read(memoryRepositoryProvider),
    container.read(childRepositoryProvider),
    container.read(familyRepositoryProvider),
    feed,
    media,
  );

  test(
    'BF-20261023-001: collection counts and covers exclude fixtures',
    () async {
      container.read(sessionRepositoryProvider).patchSession({
        'familyId': 'real-family',
      });
      final collections = await memories().collections();
      expect(collections, isNotEmpty);
      expect(collections.every((item) => item.count == 0), isTrue);
      expect(collections.every((item) => item.coverAsset == null), isTrue);
    },
  );

  test(
    'BF-20261023-001: child lookup excludes another family fixture',
    () async {
      container.read(sessionRepositoryProvider).patchSession({
        'familyId': 'real-family',
      });
      expect(await children().child('haru'), isNull);
      expect(await children().chapters('haru'), isEmpty);
    },
  );

  test('BF-20261023-001: child stats exclude another family fixture', () async {
    container.read(sessionRepositoryProvider).patchSession({
      'familyId': 'real-family',
    });
    final stats = await children().stats('haru');
    expect(stats.memories, 0);
    expect(stats.firsts, 0);
    expect(stats.voices, 0);
  });

  test(
    'BF-20261023-001: child profile excludes another family fixture',
    () async {
      container.read(sessionRepositoryProvider).patchSession({
        'familyId': 'real-family',
      });
      expect(await children().profile('haru'), isNull);
    },
  );

  test(
    'BF-20261023-001: child archive info excludes another family fixture',
    () async {
      container.read(sessionRepositoryProvider).patchSession({
        'familyId': 'real-family',
      });
      final info = await children().archiveInfo('haru');
      expect(info.addedByUserId, isNull);
      expect(info.privateMemoryCount, 0);
      expect(info.sharedMemoryCount, 0);
      expect(info.canDeleteAt(DateTime(2100)), isFalse);
    },
  );

  test('BF-20261023-001: day story does not read fixture metadata', () async {
    expect(await memories().dayStory(), isNull);
    container.read(sessionRepositoryProvider).patchSession({
      kValueSessionKeyServerFamilyId: null,
    });
    expect(await memories().dayStory(), isNotNull);
  });

  test('BF-20261023-001: month recap does not read fixture metadata', () async {
    expect(await memories().monthRecap(), isNull);
    container.read(sessionRepositoryProvider).patchSession({
      kValueSessionKeyServerFamilyId: null,
    });
    expect(await memories().monthRecap(), isNotNull);
  });

  test(
    'BF-20261023-001: base weekly recap does not read fixture metadata',
    () async {
      expect(await memories().weeklyRecap(), isNull);
      container.read(sessionRepositoryProvider).patchSession({
        kValueSessionKeyServerFamilyId: null,
      });
      expect(await memories().weeklyRecap(), isNotNull);
    },
  );

  test(
    'BF-20261023-001: memory lookup rejects a fixture from another family',
    () async {
      final store = container.read(memoryRepositoryProvider);
      final demoFamily =
          container.read(sessionRepositoryProvider).session()['familyId']
              as String;
      final fixtureId = store.memories(demoFamily).first['id'] as String;
      container.read(sessionRepositoryProvider).patchSession({
        'familyId': 'real-family',
      });
      expect(await memories().memory(fixtureId), isNull);
    },
  );

  test('BF-20261023-001: short search never queries sample memories', () async {
    final result = await memories().search('a');
    expect(result.media, isEmpty);
    expect(result.diaries, isEmpty);
  });

  test('BF-20261023-001: server drafts exclude fixture drafts', () async {
    final service = memories();
    final saved = await service.saveDraft(
      kind: MemoryKind.diary,
      title: 'User draft',
    );
    final drafts = await service.drafts();
    expect(drafts.any((draft) => draft.id == saved.id), isTrue);
    expect(
      drafts
          .where((draft) => draft.location == DraftLocation.device)
          .map((draft) => draft.id),
      [saved.id],
    );
  });

  test('BF-20261023-001: comments exclude foreign fixture memory', () async {
    container.read(sessionRepositoryProvider).patchSession({
      'familyId': 'real-family',
    });
    final store = container.read(mockStoreProvider);
    final fixture = store.table('comments').first;
    expect(await memories().comments(fixture['memoryId'] as String), isEmpty);
  });

  test('BF-20261023-001: unsent report never returns a mock receipt', () async {
    expect(
      memories().submitReport(targetId: 'not-on-server', reasonCode: 'spam'),
      throwsStateError,
    );
  });

  test(
    'MEM-25: today\'s story comes from the server; seen stays on device',
    () async {
      container.read(childRepositoryProvider).addChild({
        'id': 'srv-kid',
        'familyId': container
            .read(sessionRepositoryProvider)
            .session()['familyId'],
        'name': 'Hana',
        'kind': ChildKind.baby.name,
        kValueChildKeyServerSubject: true,
      });
      feed.story = TodayStoryRecord(
        childId: 'srv-kid',
        memoryCount: 1,
        slides: [
          TodayStorySlideRecord(
            memoryId: 'srv-today',
            kind: 'IMAGE',
            imageUrl: 'https://cdn/today.jpg',
            caption: 'Đi công viên',
            occurredAt: DateTime.utc(2026, 10, 19, 2),
          ),
        ],
      );
      final service = memories();
      final stories = await service.stories(childId: 'srv-kid');
      expect(stories.single.asset, 'https://cdn/today.jpg');
      expect(stories.single.seen, isFalse);
      await service.markStorySeen(stories.single.id);
      expect((await service.stories(childId: 'srv-kid')).single.seen, isTrue);
    },
  );

  test('MEM-01: month chapters use the server timeline cards', () async {
    final kids = container.read(childRepositoryProvider);
    final familyId =
        container.read(sessionRepositoryProvider).session()['familyId']
            as String;
    final birth = DateTime.now().subtract(const Duration(days: 100));
    kids.addChild({
      'id': 'srv-kid',
      'familyId': familyId,
      'name': 'Hana',
      'kind': ChildKind.baby.name,
      'birthDate': DateTime(
        birth.year,
        birth.month,
        birth.day,
      ).toIso8601String(),
    });
    feed.timelineItems = const [
      TimelineItemRecord(
        type: 'SYSTEM',
        kind: 'CHAPTER',
        childId: 'srv-kid',
        monthIndex: 2,
        coverUrl: 'https://cdn/month-2.jpg',
        memoryCount: 7,
        firstsCount: 2,
      ),
    ];
    await memories().timeline(childId: 'srv-kid');
    final chapters = await children().chapters('srv-kid');
    final second = chapters.firstWhere((chapter) => chapter.monthIndex == 2);
    expect(second.coverAsset, 'https://cdn/month-2.jpg');
    expect(second.hasMonthlyPhoto, isTrue);
    expect(second.memoryCount, 7);
    expect(second.firstsCount, 2);
  });

  test('the newest weekly recap card of the family timeline is kept', () async {
    final service = memories();
    expect(await service.latestRecapWeek(), isNull);
    feed.timelineItems = const [
      TimelineItemRecord(
        type: 'RECAP',
        kind: 'WEEKLY_RECAP',
        periodStart: '2026-10-05',
      ),
      TimelineItemRecord(
        type: 'RECAP',
        kind: 'WEEKLY_RECAP',
        periodStart: '2026-10-12',
      ),
    ];
    await service.timeline();
    expect(await service.latestRecapWeek(), DateTime(2026, 10, 12));
  });

  test(
    'MEM-04: the client compresses and uploads every variant to S3',
    () async {
      final service = memories();
      await service.create(
        kind: MemoryKind.photo,
        childIds: const [],
        mediaAssets: const ['/tmp/a.jpg'],
        deferUpload: true,
      );
      await service.uploadsSettled;
      final intent = media.intents.single;
      expect(intent['kind'], 'IMAGE');
      expect(intent['width'], 4032);
      expect((intent['variants'] as List).map((v) => (v as Map)['code']), [
        'm1080',
        't320',
      ]);
      // File chính + 2 biến thể (PUT riêng), rồi complete.
      expect(media.uploaded, hasLength(3));
      expect(media.completed, ['asset-1']);
    },
  );

  test(
    'MEM-08: a video is compressed on the device with poster and thumb',
    () async {
      final service = memories();
      await service.create(
        kind: MemoryKind.photo,
        childIds: const [],
        mediaAssets: const ['/tmp/clip.mp4'],
        deferUpload: true,
      );
      await service.uploadsSettled;
      final intent = media.intents.single;
      expect(intent['kind'], 'VIDEO');
      expect(intent['mime'], 'video/mp4');
      expect(intent['durationMs'], 95000);
      expect((intent['variants'] as List).map((v) => (v as Map)['code']), [
        'poster',
        't320',
      ]);
      expect(media.uploaded, hasLength(3));
    },
  );

  test(
    'VOICE: audio is uploaded, awaited READY, then created',
    () async {
      final service = memories();
      await service.create(
        kind: MemoryKind.voice,
        childIds: const [],
        mediaAssets: const ['/tmp/voice_1.m4a'],
        voiceDurationSec: 12,
        deferUpload: true,
      );
      await service.uploadsSettled;
      expect(media.intents.single['kind'], 'AUDIO');
      expect(media.intents.single['mime'], 'audio/mp4');
      expect(media.statusChecks, ['asset-1', 'asset-1']);
      expect(feed.created.single['kind'], 'VOICE');
      expect(feed.created.single['assetIds'], ['asset-1']);
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );

  test('MEM-05: who was there, feeling and place go to the server', () async {
    final service = memories();
    await service.create(
      kind: MemoryKind.photo,
      childIds: const [],
      body: 'Đi biển',
      people: const ['Bà nội', ' '],
      feeling: 'joy',
      locationLabel: ' Vũng Tàu ',
    );
    final body = feed.created.single;
    expect(body['people'], [
      {'displayName': 'Bà nội'},
    ]);
    expect(body['feeling'], 'JOY');
    expect(body['locationLabel'], 'Vũng Tàu');

    feed.latest = MemoryRecord(
      id: 'srv-beach',
      kind: 'MOMENT',
      status: 'PUBLISHED',
      authorUserId: 'srv-me',
      visibility: 'FAMILY',
      feeling: 'JOY',
      locationLabel: 'Vũng Tàu',
      people: const [MemoryPersonRecord(displayName: 'Bà nội')],
      occurredAt: DateTime.utc(2026, 10, 1),
      createdAt: DateTime.utc(2026, 10, 1),
    );
    final mirrored = (await service.refreshMemory('srv-beach'))!;
    expect(mirrored.people, ['Bà nội']);
    expect(mirrored.feeling, 'joy');
    expect(mirrored.locationLabel, 'Vũng Tàu');
  });

  test('VOICE: duration and the signed listen URL are mirrored', () async {
    final service = memories();
    feed.latest = MemoryRecord(
      id: 'srv-voice',
      kind: 'VOICE',
      status: 'PUBLISHED',
      authorUserId: 'srv-me',
      visibility: 'FAMILY',
      occurredAt: DateTime.utc(2026, 10, 1),
      createdAt: DateTime.utc(2026, 10, 1),
      durationSec: 12.4,
      assets: [
        const MediaAssetRecord(
          assetId: 'a-1',
          kind: 'AUDIO',
          status: 'READY',
          urls: {'a': 'https://cdn/voice.m4a'},
        ),
      ],
    );
    final voice = (await service.refreshMemory('srv-voice'))!;
    expect(voice.kind, MemoryKind.voice);
    expect(voice.voiceDurationSec, 12);
    expect(voice.voiceUrl, 'https://cdn/voice.m4a');
    expect(voice.mediaAssets, isEmpty);
  });

  test('MEM-08: videos show their poster and keep a playable URL', () async {
    final service = memories();
    feed.latest = MemoryRecord(
      id: 'srv-video',
      kind: 'MOMENT',
      status: 'PUBLISHED',
      authorUserId: 'srv-me',
      visibility: 'FAMILY',
      occurredAt: DateTime.utc(2026, 10, 1),
      createdAt: DateTime.utc(2026, 10, 1),
      assets: [
        MediaAssetRecord(
          assetId: 'img',
          kind: 'IMAGE',
          urls: const {'m1080': 'https://cdn/img.jpg'},
          urlsExpireAt: DateTime.now().add(const Duration(hours: 1)),
        ),
        MediaAssetRecord(
          assetId: 'vid',
          kind: 'VIDEO',
          urls: const {
            'poster': 'https://cdn/vid-poster.jpg',
            'v1080': 'https://cdn/vid.mp4',
          },
          urlsExpireAt: DateTime.now().add(const Duration(hours: 1)),
        ),
      ],
    );
    final memory = await service.refreshMemory('srv-video');
    expect(memory?.mediaAssets, [
      'https://cdn/img.jpg',
      'https://cdn/vid-poster.jpg',
    ]);
    expect(memory?.mediaVideos, [null, 'https://cdn/vid.mp4']);
  });

  test(
    'MEM-07/09: detail reloads; edits add, remove, re-cover photos',
    () async {
      final service = memories();
      MediaAssetRecord asset(String id) => MediaAssetRecord(
        assetId: id,
        kind: 'IMAGE',
        status: 'READY',
        urls: {'m1080': 'https://cdn/$id.jpg'},
        urlsExpireAt: DateTime.now().add(const Duration(hours: 1)),
      );
      feed.latest = MemoryRecord(
        id: 'srv-photos',
        kind: 'MOMENT',
        status: 'PUBLISHED',
        authorUserId: 'srv-me',
        visibility: 'FAMILY',
        version: 3,
        occurredAt: DateTime.utc(2026, 10, 1),
        createdAt: DateTime.utc(2026, 10, 1),
        assets: [asset('a1'), asset('a2')],
      );
      final detail = await service.refreshMemory('srv-photos');
      expect(detail?.mediaAssets, ['https://cdn/a1.jpg', 'https://cdn/a2.jpg']);

      await service.updateMemory(
        'srv-photos',
        mediaAssets: const ['https://cdn/a2.jpg', '/tmp/new.jpg'],
      );
      final (id, version, body) = feed.updates.single;
      expect((id, version), ('srv-photos', 3));
      expect(body, {
        'addAssetIds': ['asset-1'],
        'removeAssetIds': ['a1'],
        'coverAssetId': 'a2',
      });
    },
  );

  test(
    'MEM-06: photos upload in the background; failure keeps a retry',
    () async {
      final service = memories();
      media.failNext = 1;
      final placeholder = await service.create(
        kind: MemoryKind.photo,
        childIds: const [],
        body: 'Đi biển',
        mediaAssets: const ['/tmp/a.jpg', '/tmp/b.jpg'],
        deferUpload: true,
      );
      expect(placeholder.uploadTotal, 2);
      await service.uploadsSettled;
      final store = container.read(memoryRepositoryProvider);
      // Mất mạng: chờ có mạng để tự gửi lại (không phải lỗi).
      expect(store.memory(placeholder.id)?['uploadWaiting'], isTrue);
      expect(store.memory(placeholder.id)?['uploadFailed'], isFalse);
      expect(feed.created, isEmpty);
      expect(service.pendingSyncCount, 1);

      await service.syncPending();
      await service.uploadsSettled;
      expect(store.memory(placeholder.id), isNull);
      expect(feed.created.single['assetIds'], hasLength(2));
      expect(store.memory('srv-memory'), isNotNull);
    },
  );

  test(
    'offline-first: a memory made offline survives a restart and posts once',
    () async {
      final outbox = FakeOutbox();
      final store = container.read(memoryRepositoryProvider);
      feed.offline = true;
      final first = memories()..outbox = outbox;
      final placeholder = await first.create(
        kind: MemoryKind.diary,
        childIds: const [],
        body: 'Ngủ trưa ngoan',
        deferUpload: true,
      );
      expect(placeholder.uploadTotal, 0);
      await first.uploadsSettled;
      expect(store.memory(placeholder.id)?['uploadWaiting'], isTrue);
      expect(outbox.entries.single.args['body'], 'Ngủ trưa ngoan');
      final key = feed.keys.single;

      // Tắt app: ký ức tạm trong RAM mất, outbox trên máy còn.
      store.removeMemory(placeholder.id);
      feed.offline = false;
      final second = memories()..outbox = outbox;
      // Mở app: outbox được đọc lại và gửi ngay khi có mạng.
      await second.memories();
      await second.uploadsSettled;

      expect(feed.created.single['body'], 'Ngủ trưa ngoan');
      // Cùng Idempotency-Key với lần gửi trước khi tắt app → không tạo trùng.
      expect(feed.keys.last, key);
      expect(outbox.entries, isEmpty);
      expect(store.memory(placeholder.id), isNull);
      expect(store.memory('srv-memory'), isNotNull);
      expect(second.pendingSyncCount, 0);
    },
  );

  test('offline-first: a server refusal waits for the user', () async {
    final outbox = FakeOutbox();
    final store = container.read(memoryRepositoryProvider);
    feed.rejectWith = 422;
    final service = memories()..outbox = outbox;
    final placeholder = await service.create(
      kind: MemoryKind.diary,
      childIds: const [],
      body: 'Hết dung lượng',
      deferUpload: true,
    );
    await service.uploadsSettled;
    expect(store.memory(placeholder.id)?['uploadFailed'], isTrue);
    expect(outbox.entries.single.failed, isTrue);

    // Có mạng lại không tự gửi thao tác bị từ chối.
    await service.syncPending();
    await service.uploadsSettled;
    expect(feed.created, isEmpty);

    await service.retryUpload(placeholder.id);
    expect(feed.created.single['body'], 'Hết dung lượng');
    expect(outbox.entries, isEmpty);

    final cancelled = await service.create(
      kind: MemoryKind.diary,
      childIds: const [],
      body: 'Bỏ',
      deferUpload: true,
    );
    feed.offline = true;
    await service.cancelUpload(cancelled.id);
    expect(outbox.discarded, [cancelled.id]);
    expect(store.memory(cancelled.id), isNull);
  });

  test(
    'MEM-04: a video goes up with its duration, multipart when large',
    () async {
      final service = memories();
      media.nextMultipart = true;
      await service.create(
        kind: MemoryKind.photo,
        childIds: const [],
        mediaAssets: const ['/tmp/first-steps.MOV'],
      );
      expect(media.intents.single, containsPair('kind', 'VIDEO'));
      // Video .mov được nén trên máy thành mp4 trước khi upload.
      expect(media.intents.single, containsPair('mime', 'video/mp4'));
      expect(media.intents.single, containsPair('durationMs', 95000));
      expect(media.completedParts.single, [
        {'n': 1, 'etag': 'e1'},
        {'n': 2, 'etag': 'e2'},
      ]);
      expect(await service.videoDurationSec('/tmp/first-steps.MOV'), 95);
      expect(await service.videoDurationSec('/tmp/photo.jpg'), isNull);
    },
  );

  test('MEM-15/16: search and on-this-day come from the server', () async {
    final service = memories();
    // BF-20261022-006: không có mục “tìm gần đây” mẫu của fixture.
    expect(await service.searchRecents(), isEmpty);
    feed.searchRecords = [
      MemoryRecord(
        id: 'srv-found',
        authorUserId: 'srv-partner',
        kind: 'DIARY',
        status: 'PUBLISHED',
        body: 'Bé tập đi',
        visibility: 'FAMILY',
        occurredAt: DateTime.utc(2026, 10, 1),
        createdAt: DateTime.utc(2026, 10, 1),
      ),
    ];
    final result = await service.search(' tap di ');
    expect(feed.searches, ['tap di|null']);
    expect(result.diaries.map((memory) => memory.id), ['srv-found']);
    expect(await service.searchRecents(), contains('tap di'));
    // Một ký tự: tìm trên máy, không gọi server.
    await service.search('t');
    expect(feed.searches, hasLength(1));

    feed.onThisDayRecord = OnThisDayRecord(
      date: '2026-10-19',
      groups: [
        OnThisDayGroupRecord(
          yearsAgo: 1,
          date: '2025-10-19',
          memories: [
            MemoryRecord(
              id: 'srv-last-year',
              authorUserId: 'srv-partner',
              kind: 'MOMENT',
              status: 'PUBLISHED',
              visibility: 'FAMILY',
              occurredAt: DateTime.utc(2025, 10, 19),
              createdAt: DateTime.utc(2025, 10, 19),
            ),
          ],
        ),
      ],
    );
    final groups = await service.onThisDay();
    expect(groups.single.yearsAgo, 1);
    expect(groups.single.date, DateTime(2025, 10, 19));
    expect(groups.single.memories.single.id, 'srv-last-year');
  });

  test('RPT-01: server memories are reported to the server', () async {
    final service = memories();
    feed.searchRecords = [
      MemoryRecord(
        id: 'srv-bad',
        authorUserId: 'srv-partner',
        kind: 'MOMENT',
        status: 'PUBLISHED',
        visibility: 'FAMILY',
        occurredAt: DateTime.utc(2026, 10, 1),
        createdAt: DateTime.utc(2026, 10, 1),
      ),
    ];
    await service.search('xau');
    final receipt = await service.submitReport(
      targetId: 'srv-bad',
      reasonCode: 'child_safety',
      note: ' Ảnh không phù hợp ',
      hideForMe: true,
    );
    expect(feed.reports.single, {
      'familyId': 'srv-family',
      'targetType': 'MEMORY',
      'targetId': 'srv-bad',
      'reason': 'CHILD_SAFETY',
      'note': 'Ảnh không phù hợp',
      'hideForMe': true,
    });
    expect(receipt.code, 'BC-261019-0001');
    // Ẩn với tôi: không còn trong kho trên máy.
    expect(container.read(memoryRepositoryProvider).memory('srv-bad'), isNull);
  });

  test(
    'MEM-18: account drafts come after device drafts; delete purges',
    () async {
      final service = memories();
      await service.saveDraft(kind: MemoryKind.photo, title: 'Trên máy');
      feed.draftRecords = [
        MemoryRecord(
          id: 'srv-draft',
          kind: 'DIARY',
          status: 'DRAFT',
          title: 'Nháp trên tài khoản',
          createdAt: DateTime.utc(2026, 10, 18),
        ),
      ];
      final drafts = await service.drafts();
      final cloud = drafts.last;
      expect(drafts.first.location, DraftLocation.device);
      expect(cloud.id, 'srv-draft');
      expect(cloud.location, DraftLocation.cloud);
      expect(cloud.kind, MemoryKind.diary);
      expect(cloud.title, 'Nháp trên tài khoản');

      await service.deleteDraft('srv-draft');
      expect(feed.trashed, contains('srv-draft'));
      expect(feed.purged, contains('srv-draft'));
      // Nháp trên máy vẫn xoá trên máy, không gọi server.
      await service.deleteDraft(drafts.first.id);
      expect(feed.purged, isNot(contains(drafts.first.id)));
    },
  );

  test('MEM-18: an account draft opens for editing, then publishes', () async {
    final service = memories();
    feed.draftRecords = [
      MemoryRecord(
        id: 'srv-draft',
        kind: 'DIARY',
        status: 'DRAFT',
        version: 1,
        authorUserId: 'srv-me',
        title: 'Nháp trên tài khoản',
        visibility: 'PRIVATE',
        occurredAt: DateTime.utc(2026, 10, 18),
        createdAt: DateTime.utc(2026, 10, 18),
      ),
    ];
    await service.drafts();
    // Mở được trong trình soạn nhưng không hiện trong dòng thời gian.
    expect((await service.memory('srv-draft'))?.title, 'Nháp trên tài khoản');
    expect(
      (await service.memories()).map((memory) => memory.id),
      isNot(contains('srv-draft')),
    );
    final published = await service.publishDraft('srv-draft');
    expect(feed.published, ['srv-draft']);
    expect(published?.id, 'srv-draft');
    expect(
      container
          .read(memoryRepositoryProvider)
          .memory('srv-draft')?['remoteStatus'],
      'PUBLISHED',
    );
  });

  test('HOME-01: this week\'s counts come from the server', () async {
    final week = await children().weekSummary();
    expect(week.moments, 7);
    expect(week.firsts, 2);
  });

  // BF-20261026-001: server chỉ có `profile-stats` cho bé; gọi với thai kỳ bị
  // 404 làm màn hành trình thai kỳ báo lỗi.
  test('PREG: pregnancy stats never call the child profile-stats', () async {
    container.read(childRepositoryProvider).addChild({
      'id': 'srv-preg',
      'familyId': container
          .read(sessionRepositoryProvider)
          .session()['familyId'],
      'name': 'Bi',
      'kind': ChildKind.pregnancy.name,
      kValueChildKeyServerSubject: true,
    });
    final stats = await children().stats('srv-preg');
    expect(stats.childId, 'srv-preg');
    expect(subjects.statsCalls, isEmpty);
  });

  // BF-20261022-006: gia đình thật không cộng số/ảnh mẫu của fixture
  // (`children.json` → `stats.week`: 1 câu nói + 4 ảnh stock).
  test('HOME-01: a new family has no sample quotes or photos', () async {
    final session = container.read(sessionRepositoryProvider);
    session.patchSession({'familyId': 'f-server-new'});
    final empty = await children().weekSummary();
    expect(empty.quotes, 0);
    expect(empty.thumbnails, isEmpty);

    // Ký ức đã đồng bộ trong tuần: câu nói và ảnh lấy từ chính chúng.
    final repository = container.read(memoryRepositoryProvider);
    final now = container.read(appClockProvider).now();
    for (final (id, kind, media, at) in [
      ('srv-photo-1', MemoryKind.photo, ['https://cdn/a.jpg'], now),
      (
        'srv-photo-2',
        MemoryKind.photo,
        ['https://cdn/b.jpg'],
        now.subtract(const Duration(hours: 1)),
      ),
      ('srv-quote', MemoryKind.quote, <String>[], now),
    ]) {
      repository.addMemory({
        'id': id,
        'familyId': 'f-server-new',
        'kind': kind.name,
        'authorId': 'srv-me',
        'occurredAt': at.toIso8601String(),
        'mediaAssets': media,
        'childIds': <String>[],
      });
    }
    final week = await children().weekSummary();
    expect(week.quotes, 1);
    expect(week.thumbnails, ['https://cdn/a.jpg', 'https://cdn/b.jpg']);
  });

  test('ONB-05b: a child is created on the server, then mirrored', () async {
    final service = children();
    final before = (await service.children(includeArchived: true)).length;
    final child = await service.addChild(
      name: ' Mây ',
      birthDate: DateTime(2026, 9, 1),
      gender: ChildGender.girl,
    );
    expect(subjects.created.single, {
      'familyId': 'srv-family',
      'name': 'Mây',
      'birthDate': '2026-09-01',
      'gender': 'FEMALE',
      'colorIndex': before % 8 + 1,
    });
    expect(child.id, 'srv-child-1');
    expect((await service.child('srv-child-1'))?.name, 'Mây');

    await service.updateChild(child.copyWith(name: 'Mây Mây'));
    expect(subjects.patches['srv-child-1'], {'name': 'Mây Mây'});
    expect((await service.child('srv-child-1'))?.name, 'Mây Mây');
  });

  test('ONB-05a: a pregnancy keeps the server id and sequence', () async {
    final pregnancy = await children().addPregnancy(
      name: 'Bơ',
      dueDate: DateTime(2027, 2, 14),
      babyCount: 2,
    );
    expect(subjects.created.single, {
      'familyId': 'srv-family',
      'nickname': 'Bơ',
      'dueDate': '2027-02-14',
      'expectedCount': 2,
    });
    expect(pregnancy.id, 'srv-pregnancy');
    expect(pregnancy.pregnancyOrder, 3);
  });

  test('MEM-05: photos are uploaded before the memory is created', () async {
    final kids = await container.read(childServiceProvider).children();
    final baby = kids.firstWhere((child) => !child.isPregnancy);
    final memory = await memories().create(
      kind: MemoryKind.photo,
      childIds: [baby.id],
      body: 'Lần đầu cười',
      mediaAssets: const ['/tmp/a.jpg', '/tmp/b.png'],
      visibility: MemoryVisibility.parents,
      occurredAt: DateTime.utc(2026, 10, 5, 2),
    );
    // Ảnh được nén trên máy thành JPEG (kể cả PNG).
    expect(media.intents.map((intent) => intent['mime']), [
      'image/jpeg',
      'image/jpeg',
    ]);
    expect(media.intents.first['purpose'], 'MEMORY');
    expect(media.completed, ['asset-1', 'asset-2']);
    expect(feed.created.single, {
      'familyId': 'srv-family',
      'kind': 'MOMENT',
      'assetIds': ['asset-1', 'asset-2'],
      'body': 'Lần đầu cười',
      'childIds': [baby.id],
      'familyMoment': false,
      'occurredAt': '2026-10-05T02:00:00.000Z',
      'visibility': 'PARENTS',
    });
    expect(memory.id, 'srv-memory');
    // The picked files show at once, before the server finishes processing.
    expect(memory.mediaAssets, ['/tmp/a.jpg', '/tmp/b.png']);
  });

  test('a retried save reuses the Idempotency-Key', () async {
    final service = memories();
    feed.failNext = true;
    Future<void> save() => service.create(
      kind: MemoryKind.diary,
      childIds: const [],
      body: 'Một ngày',
      occurredAt: DateTime.utc(2026, 10, 5),
    );
    await expectLater(save(), throwsStateError);
    await save();
    expect(feed.keys, hasLength(2));
    expect(feed.keys.first, feed.keys.last);
    // A new memory afterwards gets a new key.
    await save();
    expect(feed.keys.last, isNot(feed.keys.first));
  });

  test('no sample draft is prefilled with real data', () async {
    expect(await memories().draft(MemoryKind.photo), isNull);
  });

  test('feed: server memories are mirrored with signed URLs', () async {
    final service = memories();
    final expires = DateTime.now().add(const Duration(hours: 1));
    feed.page = [
      MemoryRecord(
        id: 'srv-feed-1',
        kind: 'MOMENT',
        status: 'PUBLISHED',
        authorUserId: 'srv-me',
        body: 'Ảnh từ server',
        visibility: 'PARENTS',
        occurredAt: DateTime.utc(2026, 10, 7, 1),
        createdAt: DateTime.utc(2026, 10, 7, 1),
        assets: [
          MediaAssetRecord(
            assetId: 'a1',
            status: 'READY',
            urls: const {
              't320': 'https://s3/t320?sig=1',
              'm1080': 'https://s3/m1080?sig=1',
            },
            urlsExpireAt: expires,
          ),
        ],
      ),
    ];
    final list = await service.memories();
    final mirrored = list.firstWhere((memory) => memory.id == 'srv-feed-1');
    expect(mirrored.mediaAssets, ['https://s3/m1080?sig=1']);
    expect(mirrored.visibility, MemoryVisibility.parents);
    expect(mirrored.authorId, isNot('srv-me'));

    // Within the refresh interval the server is not asked again.
    final revision = container.read(mockStoreProvider).revision;
    await service.memories();
    expect(feed.feedCalls, 1);
    expect(container.read(mockStoreProvider).revision, revision);
  });

  MemoryRecord record(
    String id, {
    String status = 'PUBLISHED',
    int version = 1,
    DateTime? createdAt,
    DateTime? urlsExpireAt,
  }) => MemoryRecord(
    id: id,
    kind: 'MOMENT',
    status: status,
    version: version,
    authorUserId: 'srv-me',
    body: id,
    visibility: 'PARENTS',
    occurredAt: createdAt ?? DateTime.utc(2026, 10, 7),
    createdAt: createdAt ?? DateTime.utc(2026, 10, 7),
    assets: [
      if (urlsExpireAt != null)
        MediaAssetRecord(
          assetId: 'asset-$id',
          status: 'READY',
          urls: {'m1080': 'https://s3/$id?sig=1'},
          urlsExpireAt: urlsExpireAt,
        ),
    ],
  );

  Set<String> ids(Iterable<dynamic> memories) => {
    for (final memory in memories) memory.id as String,
  };

  test('feed: every page is synced by following nextCursor', () async {
    final clock = _TestClock(DateTime(2026, 10, 10, 9));
    feed.pages = {
      null: ([record('srv-1')], 'c1'),
      'c1': ([record('srv-2')], 'c2'),
      'c2': ([record('srv-3')], null),
    };
    final list = await memories(clock: clock).memories();
    expect(feed.cursors, [null, 'c1', 'c2']);
    expect(ids(list), containsAll(['srv-1', 'srv-2', 'srv-3']));
  });

  test(
    'feed: memories gone from the server are removed after a full sync',
    () async {
      final clock = _TestClock(DateTime(2026, 10, 10, 9));
      final service = memories(clock: clock);
      feed.pages = {
        null: ([record('srv-1')], 'c1'),
        'c1': ([record('srv-2')], null),
      };
      final first = await service.memories();
      final localOnly = ids(
        first,
      ).where((id) => !id.startsWith('srv-')).toSet();
      expect(ids(first), containsAll(['srv-1', 'srv-2']));
      expect(localOnly, isNotEmpty);

      // Between full syncs only the first page is read: nothing is removed.
      feed.pages = {
        null: ([record('srv-1')], null),
      };
      clock.advance(kValueRemoteFeedRefreshInterval);
      expect(ids(await service.memories()), contains('srv-2'));

      // An interrupted pagination keeps everything.
      feed.pages = {null: (<MemoryRecord>[], 'c1')};
      feed.failCursor = 'c1';
      clock.advance(kValueRemoteFeedFullSyncInterval);
      expect(ids(await service.memories()), containsAll(['srv-1', 'srv-2']));

      // A complete full sync drops the deleted/hidden memory, keeps local-only ones.
      feed.failCursor = null;
      feed.pages = {
        null: ([record('srv-1')], null),
      };
      clock.advance(kValueRemoteFeedFullSyncInterval);
      final after = ids(await service.memories());
      expect(after, contains('srv-1'));
      expect(after, isNot(contains('srv-2')));
      expect(after, containsAll(localOnly));
    },
  );

  test(
    'feed: a memory created while syncing is not removed by that sync',
    () async {
      final clock = _TestClock(DateTime(2026, 10, 10, 9));
      final service = memories(clock: clock);
      feed.pages = {
        null: ([record('srv-1')], null),
      };
      feed.gate = Completer<void>();
      final syncing = service.memories();
      await service.create(
        kind: MemoryKind.diary,
        childIds: const [],
        body: 'Vừa viết',
        occurredAt: DateTime.utc(2026, 10, 10),
      );
      feed.gate!.complete();
      await syncing;
      expect(
        container.read(memoryRepositoryProvider).memory('srv-memory'),
        isNotNull,
      );
    },
  );

  test(
    'refreshDelay polls processing memories, then waits for URL expiry',
    () async {
      final clock = _TestClock(DateTime(2026, 10, 10, 9));
      final service = memories(clock: clock);
      feed.pages = {
        null: (
          [record('srv-1', status: 'PROCESSING', createdAt: clock.now())],
          null,
        ),
      };
      await service.memories();
      expect(service.refreshDelay(), kValueRemoteFeedRefreshInterval);

      // Stuck in processing: polling stops after the window.
      clock.advance(kValueRemoteProcessingPollWindow);
      expect(service.refreshDelay(), isNull);

      clock.advance(kValueRemoteFeedFullSyncInterval);
      feed.pages = {
        null: (
          [
            record(
              'srv-1',
              urlsExpireAt: clock.now().add(const Duration(hours: 1)),
            ),
          ],
          null,
        ),
      };
      await service.memories();
      expect(
        service.refreshDelay(),
        const Duration(hours: 1) - kValueSignedUrlRefreshMargin,
      );
    },
  );

  testWidgets(
    'memoriesProvider re-reads while a memory is processing, then stops',
    (tester) async {
      final clock = _TestClock(DateTime(2026, 10, 10, 9));
      final scoped = ProviderContainer(
        overrides: [
          ...mockOverrides(),
          memoryServiceProvider.overrideWith(
            (ref) => MemoryRemoteServiceImp(
              ref.watch(sessionRepositoryProvider),
              clock,
              ref.watch(memoryRepositoryProvider),
              ref.watch(childRepositoryProvider),
              ref.watch(familyRepositoryProvider),
              feed,
              media,
            ),
          ),
        ],
      );
      addTearDown(scoped.dispose);
      final session = scoped.read(sessionRepositoryProvider);
      await session.ensureLoaded();
      session.patchSession({
        kValueSessionKeyServerFamilyId: 'srv-family',
        kValueSessionKeyServerUserId: 'srv-me',
      });
      feed.pages = {
        null: (
          [record('srv-1', status: 'PROCESSING', createdAt: clock.now())],
          null,
        ),
      };
      final subscription = scoped.listen(memoriesProvider(null), (_, _) {});
      addTearDown(subscription.close);
      await tester.pump();
      expect(feed.feedCalls, 1);

      feed.pages = {
        null: ([record('srv-1')], null),
      };
      clock.advance(kValueRemoteFeedRefreshInterval);
      await tester.pump(kValueRemoteFeedRefreshInterval);
      await tester.pump();
      expect(feed.feedCalls, 2);
      expect(
        scoped.read(memoryRepositoryProvider).memory('srv-1')?['remoteStatus'],
        'PUBLISHED',
      );

      // Nothing processing and no signed URL: no further polling.
      clock.advance(kValueRemoteFeedRefreshInterval * 3);
      await tester.pump(kValueRemoteFeedRefreshInterval * 3);
      expect(feed.feedCalls, 2);
    },
  );

  test(
    'MEM-07/17: server memories go to the server trash and come back',
    () async {
      final clock = _TestClock(DateTime(2026, 10, 10, 9));
      final service = memories(clock: clock);
      feed.pages = {
        null: ([record('srv-1'), record('srv-2')], null),
      };
      final before = await service.memories();
      final localOnly = before.firstWhere(
        (memory) => !memory.id.startsWith('srv-'),
      );
      final repository = container.read(memoryRepositoryProvider);

      await service.moveToTrash('srv-1');
      expect(feed.trashed, ['srv-1']);
      expect(repository.memory('srv-1'), isNull);
      // A memory that only exists on this device keeps the local trash.
      await service.moveToTrash(localOnly.id);
      expect(feed.trashed, ['srv-1']);

      feed.trashPage = [
        record('srv-1').copyWith(
          trashedAt: DateTime.utc(2026, 10, 10, 1),
          trashedBy: 'srv-me',
        ),
        record('srv-2').copyWith(
          trashedAt: DateTime.utc(2026, 10, 9),
          trashedBy: 'srv-partner',
        ),
      ];
      final trash = await service.trash();
      expect(ids(trash), containsAll(['srv-1', 'srv-2', localOnly.id]));
      final mine = trash.firstWhere((memory) => memory.id == 'srv-1');
      expect(mine.deletedByUserId, isNot('srv-me'));
      expect(mine.deletedAt, DateTime.utc(2026, 10, 10, 1).toLocal());
      expect(service.trashDaysLeft(mine), service.trashDays);

      await service.restoreMemory('srv-1');
      expect(feed.restored, ['srv-1']);
      expect(repository.memory('srv-1')?['remoteStatus'], 'PUBLISHED');
      await service.deleteForever('srv-2');
      expect(feed.purged, ['srv-2']);
      // Local-only trash rows still use the device store.
      await service.restoreMemory(localOnly.id);
      expect(feed.restored, ['srv-1']);
      expect(repository.memory(localOnly.id), isNotNull);
    },
  );

  test(
    'MEM-09: a server memory is patched with its version, changed fields only',
    () async {
      final clock = _TestClock(DateTime(2026, 10, 10, 9));
      final service = memories(clock: clock);
      feed.pages = {
        null: ([record('srv-1', version: 3)], null),
      };
      final kids = await container.read(childServiceProvider).children();
      final baby = kids.firstWhere((child) => !child.isPregnancy);
      await service.memories();

      final edited = await service.updateMemory(
        'srv-1',
        title: '',
        body: '  Mới  ',
        childIds: [baby.id],
        visibility: MemoryVisibility.family,
      );
      // Title was already empty: only the changed fields are sent (§13.3).
      final (id, version, body) = feed.updates.single;
      expect((id, version), ('srv-1', 3));
      expect(body, {
        'body': 'Mới',
        'visibility': 'FAMILY',
        'childIds': [baby.id],
        'familyMoment': false,
        'pregnancyId': null,
      });
      expect(edited.body, 'Mới');
      expect(
        container
            .read(memoryRepositoryProvider)
            .memory('srv-1')?['remoteVersion'],
        4,
      );

      // A stale version: the newer server copy is mirrored, then the error surfaces.
      feed.conflictsLeft = 1;
      feed.latest = record('srv-1', version: 9);
      await expectLater(
        service.updateMemory('srv-1', body: 'Lần hai'),
        throwsA(isA<DioException>()),
      );
      expect(
        container
            .read(memoryRepositoryProvider)
            .memory('srv-1')?['remoteVersion'],
        9,
      );
      await service.updateMemory('srv-1', body: 'Lần hai');
      expect(feed.updates.last.$2, 9);
    },
  );

  test('offline-first: comments and reactions made offline show at once and '
      'are sent once when back online', () async {
    final outbox = FakeOutbox();
    final service = memories()..outbox = outbox;
    feed.pages = {
      null: (
        [
          record(
            'srv-1',
          ).copyWith(reactions: const {'LOVE': 2}, commentCount: 1),
        ],
        null,
      ),
    };
    feed.commentPage = [
      CommentRecord(
        id: 'srv-c-1',
        memoryId: 'srv-1',
        authorUserId: 'srv-partner',
        body: 'Đáng yêu',
        createdAt: DateTime.utc(2026, 10, 9),
      ),
    ];
    await service.memories();
    await service.comments('srv-1');

    feed.offline = true;
    // Đổi cảm xúc liên tiếp khi mất mạng: chỉ lần cuối được gửi.
    await service.react('srv-1', '👏');
    await service.react('srv-1', '😂');
    var memory = await service.memory('srv-1');
    expect(memory?.myReaction, '😂');
    expect(memory?.reactions, {'❤️': 2, '😂': 1});

    final comment = await service.addComment('srv-1', 'Nhớ con quá');
    expect((await service.memory('srv-1'))?.commentCount, 2);
    // Mất mạng: đọc lại bình luận vẫn có bản đã lưu + bình luận tạm.
    final offlineList = await service.comments('srv-1');
    expect(offlineList.map((c) => c.body), ['Đáng yêu', 'Nhớ con quá']);
    await service.uploadsSettled;
    expect(feed.commentCalls, isEmpty);
    expect(
      outbox.entries.map((e) => e.kind),
      containsAll(['memory.reaction', 'memory.comment']),
    );
    expect(feed.reactionCalls, isEmpty);
    feed.offline = false;
    await service.syncPending();
    await service.uploadsSettled;
    expect(feed.reactionCalls, ['put:HAHA']);
    expect(feed.commentCalls, ['add:Nhớ con quá:-']);
    expect(outbox.entries, isEmpty);
    memory = await service.memory('srv-1');
    expect(memory?.myReaction, '😂');

    // Bình luận chưa gửi bị xoá: chỉ bỏ khỏi hàng đợi.
    feed.offline = true;
    final draft = await service.addComment('srv-1', 'Thôi');
    await service.deleteComment(draft.id);
    expect(outbox.entries, isEmpty);
    expect(comment.authorId, isNotNull);
  });

  test('offline-first: changes remove deleted memories, re-read edited ones '
      'and update saved comments', () async {
    final outbox = FakeOutbox();
    final clock = _TestClock(DateTime(2026, 10, 10, 9));
    final service = memories(clock: clock)..outbox = outbox;
    feed.pages = {
      null: ([record('srv-1'), record('srv-2')], null),
    };
    feed.commentPage = [
      CommentRecord(
        id: 'srv-c-1',
        memoryId: 'srv-1',
        authorUserId: 'srv-partner',
        body: 'Đáng yêu',
        createdAt: DateTime.utc(2026, 10, 9),
      ),
    ];
    feed.changePages = {
      // Lần đầu: chỉ lấy mốc (feed vừa tải đủ), không đọc lại ký ức.
      null: const ChangesPage(
        items: [
          ChangeItem(entity: 'memory', id: 'srv-1', op: 'upsert', version: 1),
        ],
        nextCursor: 'c1',
      ),
      'c1': ChangesPage(
        items: [
          const ChangeItem(entity: 'memory', id: 'srv-2', op: 'delete'),
          const ChangeItem(
            entity: 'memory',
            id: 'srv-1',
            op: 'upsert',
            version: 2,
          ),
          ChangeItem(
            entity: 'memoryComment',
            id: 'srv-c-2',
            memoryId: 'srv-1',
            op: 'upsert',
            updatedAt: DateTime.utc(2026, 10, 10),
            data: const {
              'id': 'srv-c-2',
              'memoryId': 'srv-1',
              'body': 'Con giỏi quá',
              'authorUserId': 'srv-partner',
            },
          ),
          const ChangeItem(
            entity: 'memoryComment',
            id: 'srv-c-1',
            memoryId: 'srv-1',
            op: 'delete',
          ),
        ],
        nextCursor: 'c2',
      ),
    };
    await service.memories();
    expect(outbox.cursors['srv-family'], 'c1');
    expect(feed.memoryReads, isEmpty);
    await service.comments('srv-1');

    feed.byId['srv-1'] = record('srv-1', version: 2);
    clock.advance(const Duration(hours: 1));
    await service.memories();
    expect(feed.changeCursors.last, 'c1');
    expect(outbox.cursors['srv-family'], 'c2');
    final store = container.read(memoryRepositoryProvider);
    expect(store.memory('srv-2'), isNull);
    expect(feed.memoryReads, ['srv-1']);
    expect(store.memory('srv-1')?['remoteVersion'], 2);

    // Mất mạng: bình luận đã lưu đã có thêm/xoá theo changes.
    feed.offline = true;
    expect((await service.comments('srv-1')).map((c) => c.body), [
      'Con giỏi quá',
    ]);

    // Cursor quá hạn: bỏ mốc, lần sau bắt đầu lại.
    feed.offline = false;
    feed.changesError = 'SYNC_CURSOR_EXPIRED';
    clock.advance(const Duration(hours: 1));
    await service.memories();
    expect(outbox.cursors.containsKey('srv-family'), isFalse);
  });

  test(
    'local DB: memories and comments survive a restart and open offline',
    () async {
      final db = FakeLocalMemoryDb();
      final store = container.read(memoryRepositoryProvider);
      final first = memories()..localDb = db;
      feed.pages = {
        null: ([record('srv-1'), record('srv-2')], null),
      };
      feed.commentPage = [
        CommentRecord(
          id: 'srv-c-1',
          memoryId: 'srv-1',
          authorUserId: 'srv-partner',
          body: 'Đáng yêu',
          createdAt: DateTime.utc(2026, 10, 9),
        ),
      ];
      await first.memories();
      await first.comments('srv-1');
      await first.flushLocalDb();
      expect(db.rows['srv-family']?.keys, unorderedEquals(['srv-1', 'srv-2']));
      expect(db.commentRows['srv-family']?['srv-1'], hasLength(1));
      // Lần ghi sau chỉ ghi dòng đổi.
      final writes = db.writes;
      await first.flushLocalDb();
      expect(db.writes, writes);

      // Tắt app: kho trong RAM mất; mở lại khi mất mạng.
      store
        ..removeMemory('srv-1')
        ..removeMemory('srv-2');
      feed.offline = true;
      final second = memories()..localDb = db;
      final list = await second.memories();
      expect(list.map((m) => m.id), containsAll(['srv-1', 'srv-2']));
      expect((await second.comments('srv-1')).map((c) => c.body), ['Đáng yêu']);

      // Ký ức bị xoá trên server (changes) → xoá khỏi DB ở lần ghi sau.
      feed.offline = false;
      store.removeMemory('srv-2');
      await second.flushLocalDb();
      expect(db.rows['srv-family']?.keys, ['srv-1']);
    },
  );

  test(
    'local DB: broken saved rows and an older format never crash the app',
    () async {
      final db = FakeLocalMemoryDb()
        ..schema = kValueLocalDbSchemaVersion
        ..rows['srv-family'] = {
          'ok': {
            'id': 'ok',
            'familyId': 'any',
            'kind': 'photo',
            'authorId': 'u-1',
            'occurredAt': '2026-10-01T08:00:00.000',
            'remoteStatus': 'PUBLISHED',
            // Field app chưa biết (bản lưu từ phiên bản mới hơn) bị bỏ qua.
            'futureField': {'x': 1},
          },
          // Kiểu sai (vd app cũ đọc dòng của app mới): bỏ, không crash.
          'bad': {'id': 'bad', 'kind': 42, 'occurredAt': 'not a date'},
        }
        ..commentRows['srv-family'] = {
          'ok': [
            {'id': 'c1', 'memoryId': 'ok', 'body': 'Hi', 'createdAt': 'x'},
          ],
        };
      feed.offline = true;
      final service = memories()..localDb = db;
      final list = await service.memories();
      expect(list.map((m) => m.id), contains('ok'));
      expect(list.map((m) => m.id), isNot(contains('bad')));
      expect(db.rows['srv-family']?.containsKey('bad'), isFalse);

      // Định dạng cũ (khác schema) → xoá sạch, tải lại từ server.
      final old = FakeLocalMemoryDb()
        ..schema = kValueLocalDbSchemaVersion - 1
        ..rows['srv-family'] = {
          'old': {'id': 'old'},
        };
      await (memories()..localDb = old).memories();
      expect(old.rows['srv-family'], isNull);
    },
  );

  test('server: one record with a changed field type does not break the '
      'whole feed page or the changes page', () {
    final feedPage = MemoryFeedRespond.fromJson({
      'data': [
        {'id': 'good', 'kind': 'MOMENT', 'version': 1, 'newField': true},
        {'id': 'bad', 'version': 'one'},
      ],
      'nextCursor': 'n1',
    });
    expect(feedPage.memories.map((m) => m.id), ['good']);
    expect(feedPage.nextCursor, 'n1');

    final changes = ChangesPage.fromJson({
      'items': [
        {'entity': 'memory', 'id': 'm1', 'op': 'upsert', 'version': 2},
        {'entity': 'memory', 'id': 'm2', 'op': 'upsert', 'version': 'x'},
        {'entity': 'memoryAlbum', 'id': 'a1', 'op': 'upsert'},
      ],
      'nextCursor': 'c9',
      'hasMore': false,
      'extra': 1,
    });
    expect(changes.items.map((c) => c.id), ['m1', 'a1']);
    expect(changes.nextCursor, 'c9');
  });

  test(
    'MEM-07/10: reactions and comments of server memories go through the API',
    () async {
      final clock = _TestClock(DateTime(2026, 10, 10, 9));
      final service = memories(clock: clock);
      feed.pages = {
        null: (
          [
            record(
              'srv-1',
            ).copyWith(reactions: const {'LOVE': 2}, commentCount: 1),
          ],
          null,
        ),
      };
      await service.memories();
      expect((await service.memory('srv-1'))?.reactions, {'❤️': 2});

      await service.react('srv-1', '👏');
      await service.uploadsSettled;
      expect(feed.reactionCalls, ['put:CLAP']);
      expect(feed.reactionKeys.single, isNotNull);
      var memory = await service.memory('srv-1');
      expect(memory?.myReaction, '👏');
      expect(memory?.reactions, {'👏': 1, '❤️': 2});
      // Tapping the current reaction removes it (one per person, spec 7.12).
      await service.react('srv-1', '👏');
      await service.uploadsSettled;
      expect(feed.reactionCalls.last, 'delete');
      memory = await service.memory('srv-1');
      expect(memory?.myReaction, isNull);
      // Emoji outside the five server reactions are not sent.
      await service.react('srv-1', '🥰');
      expect(feed.reactionCalls, hasLength(2));

      feed.commentPage = [
        CommentRecord(
          id: 'srv-c-1',
          memoryId: 'srv-1',
          authorUserId: 'srv-partner',
          body: 'Đáng yêu',
          createdAt: DateTime.utc(2026, 10, 9),
        ),
      ];
      final list = await service.comments('srv-1');
      expect(list.single.body, 'Đáng yêu');
      expect(list.single.authorId, isNot('srv-partner'));
      final reply = await service.addComment(
        'srv-1',
        ' Cảm ơn ',
        parentId: 'srv-c-1',
      );
      await service.uploadsSettled;
      expect(feed.commentCalls, ['add:Cảm ơn:srv-c-1']);
      expect(feed.commentKeys.single, isNotNull);
      expect(reply.parentId, 'srv-c-1');
      expect((await service.memory('srv-1'))?.commentCount, 2);
      await service.editComment('srv-c-new', 'Cảm ơn nhé');
      await service.deleteComment('srv-c-1');
      expect(feed.commentCalls.skip(1), [
        'edit:srv-c-new:Cảm ơn nhé',
        'delete:srv-c-1',
      ]);
    },
  );

  test('mock: one reaction per person, changeable and removable', () async {
    final service = container.read(memoryServiceProvider);
    final before = (await service.memories()).firstWhere(
      (memory) => memory.reactions.isNotEmpty,
    );
    final love = before.reactions['❤️'] ?? 0;
    await service.react(before.id, '❤️');
    await service.react(before.id, '❤️');
    expect((await service.memory(before.id))?.reactions['❤️'] ?? 0, love);
    await service.react(before.id, '😂');
    await service.react(before.id, '👏');
    final after = await service.memory(before.id);
    expect(after?.myReaction, '👏');
    expect(after?.reactions['😂'] ?? 0, before.reactions['😂'] ?? 0);
  });

  test('MEM-01/02: timeline and photo grid come from the server APIs', () async {
    final clock = _TestClock(DateTime(2026, 10, 10, 9));
    final service = memories(clock: clock);
    final kids = await container.read(childServiceProvider).children();
    final baby = kids.firstWhere((child) => !child.isPregnancy);
    // A back-dated memory (created last, happened first) sorts by occurredAt.
    feed.timelineItems = [
      TimelineItemRecord(
        type: 'MEMORY',
        memory: record(
          'srv-new',
          createdAt: DateTime.utc(2026, 10, 9),
        ).copyWith(childIds: [baby.id]),
      ),
      const TimelineItemRecord(
        type: 'SYSTEM',
        id: 'sys:birth:x',
        kind: 'BIRTH',
      ),
      TimelineItemRecord(
        type: 'MEMORY',
        memory: record(
          'srv-old',
          createdAt: DateTime.utc(2026, 10, 10),
        ).copyWith(occurredAt: DateTime.utc(2026, 9, 1), childIds: [baby.id]),
      ),
    ];
    // The feed (full sync + reconcile) sees the same memories as the timeline.
    feed.pages = {
      null: (
        [
          for (final item in feed.timelineItems)
            if (item.memory != null) item.memory!,
        ],
        null,
      ),
    };
    final timeline = await service.timeline(childId: baby.id);
    expect(feed.timelineCalls, ['child:${baby.id} pregnancy:-']);
    final ids = timeline.map((memory) => memory.id).toList();
    expect(ids, containsAll(['srv-new', 'srv-old']));
    expect(ids.indexOf('srv-new'), lessThan(ids.indexOf('srv-old')));
    expect(ids, isNot(contains('sys:birth:x')));
    // Within the refresh interval the server is not asked again.
    await service.timeline(childId: baby.id);
    expect(feed.timelineCalls, hasLength(1));

    feed.gridItems = [
      MediaGridItemRecord(
        assetId: 'a1',
        memoryId: 'srv-new',
        kind: 'IMAGE',
        occurredAt: DateTime.utc(2026, 10, 9),
        urls: const {
          't320': 'https://s3/t320?sig=1',
          'm1080': 'https://s3/m1080?sig=1',
        },
      ),
      const MediaGridItemRecord(assetId: 'a2', memoryId: 'srv-unknown'),
    ];
    final photos = await service.photos(childId: baby.id);
    final server = photos.where((photo) => photo.memory.id.startsWith('srv-'));
    expect(server.single.asset, 'https://s3/t320?sig=1');
    expect(server.single.memory.id, 'srv-new');
  });

  test(
    'CHD-01/03/05: profile counts, order, archive and delete go to the server',
    () async {
      final service = children();
      final child = await service.addChild(
        name: 'Na',
        birthDate: DateTime(2025, 3),
      );
      final stats = await service.stats(child.id);
      expect((stats.memories, stats.firsts), (42, 5));

      await service.archiveChild(child.id);
      await service.restoreChild(child.id);
      await service.deleteChild(child.id);
      expect(subjects.calls, [
        'archive:${child.id}',
        'restore:${child.id}',
        'delete:${child.id}:Na',
      ]);
    },
  );

  test(
    'a new avatar photo is uploaded as AVATAR and set on the child',
    () async {
      final service = children();
      final child = await service.addChild(
        name: 'Na',
        birthDate: DateTime(2025, 3),
      );
      await service.updateChild(child.copyWith(avatarAsset: '/tmp/na.png'));
      expect(media.intents.single['purpose'], 'AVATAR');
      expect(subjects.calls.single, 'avatar:${child.id}:asset-1');
      // Bundled sample images are never uploaded.
      await service.updateChild(
        (await service.child(child.id))!.copyWith(coverAsset: 'assets/x.png'),
      );
      expect(media.intents, hasLength(1));
    },
  );

  test('PREG-01: the fetal size of this week comes from the server', () async {
    final size = await children().fetalSize('srv-pregnancy');
    expect(
      (size?.week, size?.emoji, size?.fruit, size?.lengthCm),
      (24, '🌽', 'bắp ngô', 30),
    );
  });

  test(
    'filtering the feed by a child also reads that child\'s server feed',
    () async {
      final service = memories();
      final child = await children().addChild(
        name: 'Na',
        birthDate: DateTime(2025, 3),
      );
      await service.memories(childId: child.id);
      await service.memories(childId: child.id);
      // Throttled: one subject read per refresh interval.
      expect(feed.subjectCalls, [child.id]);
    },
  );

  test('MEM-07: the author can turn comments off for one memory', () async {
    final service = memories();
    feed.pages = {
      null: ([record('srv-1', version: 3)], null),
    };
    await service.memories();
    expect((await service.memory('srv-1'))?.commentsEnabled, isTrue);
    await service.updateMemory('srv-1', commentsEnabled: false);
    expect(feed.updates.single.$3, {'commentsEnabled': false});
    // The server copy (fake) says comments are on: the same value is not sent.
    feed.updates.clear();
    await service.updateMemory('srv-1', commentsEnabled: true);
    expect(feed.updates, isEmpty);
  });
}
