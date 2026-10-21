import 'dart:typed_data';

import 'package:baby_family/data/dto/processed_media.dart';
import 'package:baby_family/data/model/memory/album_record.dart';
import 'package:baby_family/data/model/memory/download_url_record.dart';
import 'package:baby_family/data/model/memory/letter_record.dart';
import 'package:baby_family/data/model/memory/media_asset_record.dart';
import 'package:baby_family/data/model/memory/memory_prompt_record.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/memory/milestone_achieved_record.dart';
import 'package:baby_family/data/model/memory/milestone_category_record.dart';
import 'package:baby_family/data/model/memory/milestone_template_record.dart';
import 'package:baby_family/data/model/memory/monthly_photo_record.dart';
import 'package:baby_family/data/model/memory/perspective_record.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/recap/week_stats_record.dart';
import 'package:baby_family/data/model/recap/weekly_recap_record.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/memory_feed.dart';
import 'package:baby_family/data/repository/memory_library_remote.dart';
import 'package:baby_family/data/service/local_media.dart';
import 'package:baby_family/data/service_imp/memory_library_remote.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Thư viện ký ức trên server giả (BF-20261019-002).
class _FakeLibrary implements IMemoryLibraryRemoteRepository {
  final calls = <String>[];
  List<MemoryRecord> pending = const [];

  @override
  Future<List<MemoryRecord>> pendingReview(String familyId) async => pending;

  @override
  Future<void> review(String memoryId, String action, JsonMap body) async =>
      calls.add('$action:$memoryId:$body');

  WeeklyRecapRecord? recap;
  final monthlySet = <String>[];

  @override
  Future<List<MonthlyPhotoRecord>> monthlyPhotos(String childId) async => [
    MonthlyPhotoRecord(
      monthIndex: 2,
      memoryId: 'srv-m2',
      url: 'https://cdn/m2.jpg',
      occurredAt: DateTime.utc(2026, 3, 21),
    ),
  ];

  @override
  Future<MonthlyPhotoRecord?> setMonthlyPhoto(
    String childId,
    int monthIndex, {
    required String memoryId,
    required String assetId,
  }) async {
    monthlySet.add('$childId:$monthIndex:$memoryId:$assetId');
    return null;
  }

  @override
  Future<WeeklyRecapRecord?> latestWeeklyRecap(String familyId) async => recap;
  final favoriteIds = <String>{};

  static MemoryRecord photo(String id, String url) => MemoryRecord(
    id: id,
    kind: 'MOMENT',
    assets: [
      MediaAssetRecord(assetId: 'a-$id', kind: 'IMAGE', urls: {'m1080': url}),
    ],
  );

  @override
  Future<List<AlbumRecord>> albums(String familyId) async => [
    AlbumRecord(
      id: 'al-1',
      name: 'Đi biển',
      memoryCount: 2,
      cover: photo('m-1', 'https://img/1.jpg'),
    ),
  ];

  @override
  Future<AlbumRecord?> createAlbum(String familyId, String name) async {
    calls.add('create:$name');
    return AlbumRecord(id: 'al-2', name: name);
  }

  @override
  Future<void> updateAlbum(String albumId, JsonMap patch) async =>
      calls.add('update:$albumId:${patch.entries.single}');

  @override
  Future<void> deleteAlbum(String albumId) async =>
      calls.add('delete:$albumId');

  @override
  Future<List<MemoryRecord>> albumMemories(String albumId) async => [
    photo('m-1', 'https://img/1.jpg'),
    photo('m-2', 'https://img/2.jpg'),
  ];

  @override
  Future<void> addToAlbum(String albumId, List<String> memoryIds) async {}

  @override
  Future<void> setFavorite(String memoryId, {required bool favorite}) async =>
      calls.add('favorite:$memoryId:$favorite');

  @override
  Future<List<MemoryRecord>> favorites(String familyId) async => [
    for (final id in favoriteIds) MemoryRecord(id: id),
  ];

  @override
  Future<List<DownloadUrlRecord>> downloadUrls(String memoryId) async => [
    const DownloadUrlRecord(url: 'https://orig/1.jpg'),
  ];

  @override
  Future<List<PerspectiveRecord>> perspectives(String memoryId) async => [
    PerspectiveRecord(
      id: 'p-1',
      memoryId: memoryId,
      authorUserId: 'srv-me',
      body: 'Hôm đó con cười suốt',
      createdAt: DateTime.utc(2026, 10, 1),
    ),
  ];

  @override
  Future<PerspectiveRecord?> putPerspective(
    String memoryId,
    String body,
  ) async {
    calls.add('perspective:$memoryId:$body');
    return PerspectiveRecord(
      id: 'p-2',
      memoryId: memoryId,
      authorUserId: 'srv-me',
      body: body,
    );
  }

  @override
  Future<List<MemoryPromptRecord>> prompts(
    String familyId, {
    String? childId,
  }) async => [
    MemoryPromptRecord(
      code: 'first_word',
      targetKind: 'QUOTE',
      textI18n: const {
        'vi': '{child} vừa nói gì đáng yêu?',
        'en': 'What lovely thing did {child} say?',
      },
      childId: childId,
    ),
  ];

  @override
  Future<void> dismissPrompt(String code, {String? childId}) async =>
      calls.add('dismiss:$code:$childId');

  @override
  Future<List<MilestoneCategoryRecord>> milestoneTemplates({
    String? childId,
  }) async => [
    MilestoneCategoryRecord(
      category: 'TRADITIONAL',
      templates: [
        MilestoneTemplateRecord(
          code: 'full_month',
          achieved: MilestoneAchievedRecord(
            memoryId: 'm-ms',
            occurredOn: DateTime(2025, 4, 1),
          ),
        ),
      ],
    ),
  ];

  @override
  Future<List<LetterRecord>> letters(String childId) async => const [
    LetterRecord(id: 'l-1', sealed: true),
    LetterRecord(id: 'l-2'),
  ];
}

class _FakeFeed extends Fake implements IMemoryFeedRepository {
  final created = <JsonMap>[];
  List<MemoryRecord> records = const [];

  @override
  Future<({List<MemoryRecord> memories, String? nextCursor})> feed(
    String familyId, {
    String? childId,
    String? pregnancyId,
    String? cursor,
    int? limit,
  }) async => (memories: records, nextCursor: null);

  @override
  Future<MemoryRecord?> createMemory(
    String idempotencyKey,
    JsonMap body,
  ) async {
    created.add(body);
    return MemoryRecord(id: 'srv-ms-${created.length}', status: 'PUBLISHED');
  }

  @override
  Future<MemoryRecord?> memory(String memoryId) async =>
      records.where((record) => record.id == memoryId).firstOrNull;
}

class _FakeLocalMedia implements ILocalMediaService {
  final asked = <List<String>>[];

  @override
  Future<void> enable() async {}

  @override
  Future<Map<String, String>> resolve(List<RemoteMediaRef> refs) async {
    asked.add([for (final ref in refs) ref.assetId]);
    return {for (final ref in refs) ref.assetId: '/gallery/${ref.sha256}.jpg'};
  }
}

class _FakeMedia extends Fake implements IMediaRepository {
  /// Client nén ảnh (BF-20261021-008): bản JPEG + biến thể giả.
  @override
  Future<ProcessedMedia> processImage(String path) async => ProcessedMedia(
    kind: 'IMAGE',
    mime: 'image/jpeg',
    bytes: Uint8List.fromList(path.codeUnits),
    variants: [
      MediaVariantFile(
        code: 'm1080',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([1]),
      ),
      MediaVariantFile(
        code: 't320',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([2]),
      ),
    ],
  );

  @override
  Future<Uint8List> readLocalFile(String path) async =>
      Uint8List.fromList(path.codeUnits);

  @override
  Future<UploadIntent?> createUploadIntent(
    String idempotencyKey,
    JsonMap body,
  ) async => const UploadIntent(assetId: 'asset-month', status: 'READY');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeLibrary library;
  late _FakeFeed feed;
  late String childId;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    library = _FakeLibrary();
    feed = _FakeFeed();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({
      kValueSessionKeyServerFamilyId: 'srv-family',
      kValueSessionKeyServerUserId: 'srv-me',
    });
    final familyId = session.session()['familyId'] as String;
    childId =
        container
                .read(childRepositoryProvider)
                .children(familyId)
                .firstWhere((row) => row['kind'] == ChildKind.baby.name)['id']
            as String;
  });

  MemoryLibraryRemoteServiceImp service() => MemoryLibraryRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(memoryRepositoryProvider),
    container.read(childRepositoryProvider),
    container.read(familyRepositoryProvider),
    feed,
    _FakeMedia(),
    library,
  );

  test('MEM-03: albums come from the server; cover by memory', () async {
    final memories = service();
    final albums = await memories.albums();
    final album = albums.firstWhere((item) => item.id == 'al-1');
    expect(album.title, 'Đi biển');
    expect(album.coverAsset, 'https://img/1.jpg');

    final opened = await memories.album('al-1');
    expect(opened?.items.map((item) => item.memoryId), ['m-1', 'm-2']);
    await memories.changeAlbumCover('al-1', 'https://img/2.jpg');
    await memories.renameAlbum('al-1', 'Biển Nha Trang');
    await memories.createAlbum(title: 'Sinh nhật');
    await memories.deleteAlbum('al-1');
    expect(library.calls, [
      'update:al-1:MapEntry(coverMemoryId: m-2)',
      'update:al-1:MapEntry(name: Biển Nha Trang)',
      'create:Sinh nhật',
      'delete:al-1',
    ]);
  });

  test('MEM-22/24/08: favorites, perspectives and downloads', () async {
    final memories = service();
    final store = container.read(memoryRepositoryProvider);
    final row = store.addMemory({
      'id': 'srv-m',
      'familyId': container
          .read(sessionRepositoryProvider)
          .session()['familyId'],
      'kind': MemoryKind.photo.name,
      'childIds': [childId],
      'authorId': 'u-x',
      'occurredAt': DateTime(2026, 9).toIso8601String(),
      'remoteStatus': 'PUBLISHED',
    });
    final id = row['id'] as String;
    feed.records = [
      MemoryRecord(
        id: id,
        kind: 'MOMENT',
        status: 'PUBLISHED',
        authorUserId: 'srv-me',
        childIds: [childId],
        occurredAt: DateTime.utc(2026, 9),
      ),
    ];
    await memories.toggleFavorite(id);
    expect(library.calls.single, 'favorite:$id:true');

    // A favorite made on another device is mirrored by the collection.
    library.favoriteIds.add(id);
    store.updateMemory(id, {'isFavorite': false});
    await memories.collections();
    expect(store.memory(id)?['isFavorite'], isTrue);

    final perspectives = await memories.perspectives(id);
    expect(perspectives.single.body, 'Hôm đó con cười suốt');
    await memories.savePerspective(id, body: ' Mẹ nhớ mãi ');
    expect(library.calls.last, 'perspective:$id:Mẹ nhớ mãi');

    expect(await memories.downloadUrls(id), ['https://orig/1.jpg']);
  });

  test('prompts, milestones and sealed letters use the server', () async {
    final memories = service();
    final prompt = await memories.todayPrompt(childId: childId);
    expect(prompt?.kind, MemoryKind.quote);
    expect(prompt?.text, anyOf(endsWith('đáng yêu?'), endsWith('say?')));
    expect(prompt?.text, isNot(contains('{child}')));
    await memories.dismissPrompt();
    expect(library.calls.single, 'dismiss:first_word:$childId');

    final options = await memories.milestoneOptions(childId);
    expect(
      options.firstWhere((option) => option.code == 'full_month').recordedAt,
      DateTime(2025, 4, 1),
    );
    await memories.recordMilestone(childId, 'first_tet');
    expect(feed.created.single['kind'], 'MILESTONE');
    expect(
      (feed.created.single['milestone'] as Map)['templateCode'],
      'first_tet',
    );

    final babies = container
        .read(childRepositoryProvider)
        .children(
          container.read(sessionRepositoryProvider).session()['familyId']
              as String,
        )
        .where((row) => row['kind'] == ChildKind.baby.name)
        .length;
    expect(await memories.sealedLetters(), babies);
  });

  test(
    'MEM-14: a letter is sealed on the server until its unlock date',
    () async {
      await service().create(
        kind: MemoryKind.letter,
        childIds: [childId],
        title: 'Gửi con năm 18 tuổi',
        body: 'Mẹ thương con',
        visibility: MemoryVisibility.parents,
        sealedUntil: DateTime.utc(2044, 3),
      );
      final body = feed.created.single;
      expect(body['kind'], 'LETTER');
      expect(body['letter'], {
        'childId': childId,
        'releaseRule': 'DATE',
        'unlockAt': '2044-03-01T00:00:00.000Z',
        'releaseVisibility': 'PARENTS',
      });
    },
  );

  test('MEM-20/21: monthly photos come from and go to the server', () async {
    final memories = service();
    final children = container.read(childRepositoryProvider);
    children.addChild({
      'id': 'srv-kid',
      'familyId': container
          .read(sessionRepositoryProvider)
          .session()['familyId'],
      'name': 'Hana',
      'kind': ChildKind.baby.name,
      'birthDate': DateTime(2026, 1, 19).toIso8601String(),
      kValueChildKeyServerSubject: true,
    });
    final photos = await memories.monthlyPhotos('srv-kid');
    expect(photos.single.monthIndex, 2);
    expect(photos.single.asset, 'https://cdn/m2.jpg');

    await memories.saveMonthlyPhoto(
      'srv-kid',
      asset: '/tmp/month-3.jpg',
      monthIndex: 3,
    );
    // Ký ức ảnh của bé vào đúng ngày tròn 3 tháng, rồi đặt làm ảnh tháng.
    expect(feed.created.single['kind'], 'MOMENT');
    expect(feed.created.single['childIds'], ['srv-kid']);
    expect(
      DateTime.parse(feed.created.single['occurredAt'] as String).toLocal(),
      DateTime(2026, 4, 19),
    );
    expect(library.monthlySet, ['srv-kid:3:srv-ms-1:asset-month']);
  });

  test('REC-02: the weekly recap comes from the server', () async {
    final memories = service();
    expect(await memories.weeklyRecap(), isNull);
    feed.records = [
      MemoryRecord(
        id: 'srv-top',
        kind: 'MOMENT',
        status: 'PUBLISHED',
        authorUserId: 'srv-me',
        visibility: 'FAMILY',
        occurredAt: DateTime.utc(2026, 10, 14),
        createdAt: DateTime.utc(2026, 10, 14),
        assets: const [
          MediaAssetRecord(
            assetId: 'a-top',
            kind: 'IMAGE',
            urls: {'m1080': 'https://cdn/top.jpg'},
          ),
        ],
      ),
    ];
    library.recap = const WeeklyRecapRecord(
      id: 'r-1',
      periodStart: '2026-10-12',
      periodEnd: '2026-10-18',
      content: WeeklyRecapContent(
        version: 1,
        stats: WeekStatsRecord(memoryCount: 5, milestoneCount: 1),
        topMemories: [
          RecapMemoryRef(id: 'srv-top'),
          RecapMemoryRef(id: 'gone'),
        ],
      ),
    );
    final recap = await memories.weeklyRecap();
    expect(recap?.start, DateTime(2026, 10, 12));
    expect(recap?.moments, 5);
    expect(recap?.firsts, 1);
    expect(recap?.headline, isNotEmpty);
    expect(recap?.highlights.map((memory) => memory.id), ['srv-top']);
    expect(recap?.heroAssets, ['https://cdn/top.jpg']);
  });

  test(
    'BF-20261021-008: a gallery copy is shown before the server image',
    () async {
      final local = _FakeLocalMedia();
      final memories = service()..localMedia = local;
      feed.records = [
        MemoryRecord(
          id: 'srv-local',
          kind: 'MOMENT',
          status: 'PUBLISHED',
          authorUserId: 'srv-me',
          childIds: [childId],
          occurredAt: DateTime.utc(2026, 10, 14),
          assets: [
            MediaAssetRecord(
              assetId: 'a-local',
              kind: 'IMAGE',
              urls: const {'m1080': 'https://cdn/local.jpg'},
              source: MediaSourceRecord(
                sha256: 'sha-1',
                key: 'IMAGE|3024x4032|0',
                capturedAt: DateTime.utc(2026, 10, 14, 8),
              ),
            ),
            const MediaAssetRecord(
              assetId: 'a-remote',
              kind: 'IMAGE',
              urls: {'m1080': 'https://cdn/remote.jpg'},
            ),
          ],
        ),
      ];
      await memories.memories(childId: childId);
      await pumpEventQueue();
      expect(local.asked, [
        ['a-local'],
      ]);
      final memory = await memories.memory('srv-local');
      expect(memory?.mediaAssets, [
        '/gallery/sha-1.jpg',
        'https://cdn/remote.jpg',
      ]);
    },
  );

  test('MEM-19: relatives\' posts are reviewed on the server', () async {
    library.pending = [
      MemoryRecord(
        id: 'srv-post',
        kind: 'MOMENT',
        status: 'PENDING_REVIEW',
        authorUserId: 'srv-grandma',
        body: 'Ảnh bà chụp',
        childIds: [childId],
        occurredAt: DateTime.utc(2026, 10, 18),
      ),
    ];
    final memories = service();
    final posts = await memories.pendingPosts();
    expect(posts.single.id, 'srv-post');
    await memories.approvePost('srv-post', childIds: [childId]);
    expect(library.calls.last, 'approve:srv-post:{childIds: [$childId]}');
    await memories.rejectPost('srv-post', reason: 'blurry');
    expect(library.calls.last, 'reject:srv-post:{reason: blurry}');
  });
}
