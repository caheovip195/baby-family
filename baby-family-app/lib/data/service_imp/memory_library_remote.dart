import 'package:baby_family/data/model/memory/album.dart';
import 'package:baby_family/data/model/memory/album_item.dart';
import 'package:baby_family/data/model/memory/album_record.dart';
import 'package:baby_family/data/model/memory/collection_summary.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_perspective.dart';
import 'package:baby_family/data/model/memory/memory_prompt.dart';
import 'package:baby_family/data/model/memory/memory_prompt_record.dart';
import 'package:baby_family/data/model/memory/milestone_item.dart';
import 'package:baby_family/data/model/memory/milestone_option.dart';
import 'package:baby_family/data/model/memory/milestone_template_record.dart';
import 'package:baby_family/data/model/memory/monthly_photo.dart';
import 'package:baby_family/data/model/memory/monthly_photo_record.dart';
import 'package:baby_family/data/model/memory/perspective_record.dart';
import 'package:baby_family/data/model/memory/weekly_recap.dart';
import 'package:baby_family/data/model/recap/weekly_recap_record.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/memory_feed.dart';
import 'package:baby_family/data/repository/memory_library_remote.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/service_imp/memory_remote.dart';
import 'package:baby_family/data/service_imp/offline_read.dart';
import 'package:baby_family/data/service_imp/outbox_runner.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:dio/dio.dart';

/// Thư viện ký ức qua server (BF-20261019-002): album (MEM-03), yêu thích
/// (MEM-22), tải bản gốc (MEM-08), góc nhìn thứ hai (MEM-24), gợi ý ghi lại,
/// cột mốc & những lần đầu (MEM-11/12), số thư niêm phong (MEM-14).
/// Album tự động, nhóm/tên cột mốc vẫn theo catalog của app.
class MemoryLibraryRemoteServiceImp extends MemoryRemoteServiceImp {
  /// Bản đọc gần nhất cho màn phụ khi mất mạng (BF-20261026-007).
  final _reads = OfflineReads();

  MemoryLibraryRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._store,
    this._kids,
    this._members,
    IMemoryFeedRepository feed,
    IMediaRepository media,
    this._library,
  ) : super(sessionRepository, clock, _store, _kids, _members, feed, media);

  final IMemoryRepository _store;
  final IChildRepository _kids;
  final IFamilyRepository _members;
  final IMemoryLibraryRemoteRepository _library;

  /// Ảnh của album server đã mở gần nhất → id ký ức (đổi ảnh bìa theo ký ức).
  final _albumAssets = <String, Map<String, String>>{};

  /// Gợi ý đang hiện (để “Bỏ qua” gửi đúng mã + bé).
  MemoryPromptRecord? _prompt;

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  // ------------------------------------------------------------ album

  @override
  Future<List<Album>> albums() async {
    final local = await super.albums();
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return local;
    }
    // Mất mạng: album server đọc gần nhất.
    final records =
        await whenOnline(
          () => _library.albums(serverFamilyId),
          what: 'album',
        ) ??
        _albums;
    _albums = records;
    return [
      ...local.where((album) => album.isAuto),
      for (final record in records) ?_toAlbum(record),
    ];
  }

  List<AlbumRecord> _albums = const [];

  /// BF-20261023-001: chỉ mở album trong gia đình hiện tại hoặc từ server.
  @override
  Future<Album?> album(String id) async {
    final row = _store.album(id);
    final local = _serverFamilyId == null || row?['familyId'] == familyId
        ? await super.album(id)
        : null;
    final serverFamilyId = _serverFamilyId;
    if (local != null || serverFamilyId == null) {
      return local;
    }
    final record = (await _reads.read(
      ['albums', serverFamilyId],
      () => _library.albums(serverFamilyId),
    )).where((album) => album.id == id).firstOrNull;
    if (record == null) {
      return null;
    }
    final memories = await _reads.read([
      'albumMemories',
      id,
    ], () => _library.albumMemories(id));
    final assets = <String, String>{};
    final items = <AlbumItem>[];
    for (final memory in memories) {
      final memoryId = memory.id;
      for (final asset in memory.assets) {
        final url =
            asset.urls['m1080'] ?? asset.urls['l2048'] ?? asset.urls['t320'];
        if (url == null || memoryId == null) {
          continue;
        }
        assets[url] = memoryId;
        items.add(
          AlbumItem(
            asset: url,
            isVideo: asset.kind == 'VIDEO',
            memoryId: memoryId,
          ),
        );
      }
    }
    _albumAssets[id] = assets;
    return _toAlbum(record)?.copyWith(items: items);
  }

  @override
  Future<Album> createAlbum({
    required String title,
    List<String> childIds = const [],
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.createAlbum(title: title, childIds: childIds);
    }
    final record = await _library.createAlbum(serverFamilyId, title.trim());
    final album = record == null ? null : _toAlbum(record);
    if (album == null) {
      throw StateError('Album was not created');
    }
    _store.touch();
    return album;
  }

  @override
  Future<void> renameAlbum(String id, String title) async {
    if (await _isLocalAlbum(id)) {
      return super.renameAlbum(id, title);
    }
    await _library.updateAlbum(id, {'name': title.trim()});
    _store.touch();
  }

  /// Ảnh bìa của album server là một ký ức trong album.
  @override
  Future<void> changeAlbumCover(String id, String asset) async {
    if (await _isLocalAlbum(id)) {
      return super.changeAlbumCover(id, asset);
    }
    final memoryId = _albumAssets[id]?[asset];
    if (memoryId == null) {
      return;
    }
    await _library.updateAlbum(id, {'coverMemoryId': memoryId});
    _store.touch();
  }

  @override
  Future<void> deleteAlbum(String id) async {
    if (await _isLocalAlbum(id)) {
      return super.deleteAlbum(id);
    }
    await _library.deleteAlbum(id);
    _store.touch();
  }

  Future<bool> _isLocalAlbum(String id) async =>
      _serverFamilyId == null || await super.album(id) != null;

  Album? _toAlbum(AlbumRecord record) {
    final id = record.id;
    if (id == null) {
      return null;
    }
    final cover = record.cover?.assets.firstOrNull;
    return Album(
      id: id,
      title: record.name ?? '',
      coverAsset:
          cover?.urls['m1080'] ?? cover?.urls['l2048'] ?? cover?.urls['t320'],
      memoryCount: record.memoryCount,
      createdByUserId: _localUserId(record.ownerUserId),
      startDate: record.createdAt?.toLocal(),
    );
  }

  // ------------------------------------------------------------ yêu thích

  @override
  Future<void> toggleFavorite(String memoryId) async {
    if (_serverFamilyId != null && _isServerMemory(memoryId)) {
      final current = await memory(memoryId);
      await _library.setFavorite(
        memoryId,
        favorite: !(current?.isFavorite ?? false),
      );
    }
    await super.toggleFavorite(memoryId);
  }

  /// Bộ sưu tập: đánh dấu yêu thích lấy từ server (yêu thích trên máy khác).
  @override
  Future<List<CollectionSummary>> collections() async {
    final serverFamilyId = _serverFamilyId;
    final records = serverFamilyId == null
        ? null
        : await whenOnline(
            () => _library.favorites(serverFamilyId),
            what: 'yêu thích',
          );
    if (records != null) {
      final favorites = {for (final record in records) ?record.id};
      for (final row in _store.memories(familyId)) {
        final id = row['id'] as String;
        final favorite = favorites.contains(id);
        if (_isServerMemory(id) && (row['isFavorite'] == true) != favorite) {
          _store.updateMemory(id, {'isFavorite': favorite});
        }
      }
    }
    return super.collections();
  }

  @override
  Future<List<String>> downloadUrls(String memoryId) async {
    if (_serverFamilyId == null || !_isServerMemory(memoryId)) {
      return super.downloadUrls(memoryId);
    }
    return [
      for (final item in await _library.downloadUrls(memoryId)) ?item.url,
    ];
  }

  // ------------------------------------------------------------ góc nhìn

  /// BF-20261023-001: không đọc góc nhìn mẫu bằng id ngoài gia đình.
  @override
  Future<List<MemoryPerspective>> perspectives(String memoryId) async {
    if (_serverFamilyId != null && await memory(memoryId) == null) {
      return const [];
    }
    if (_serverFamilyId == null || !_isServerMemory(memoryId)) {
      return super.perspectives(memoryId);
    }
    return [
      for (final record in await _reads.read([
        'perspectives',
        memoryId,
      ], () => _library.perspectives(memoryId)))
        ?_toPerspective(record),
    ];
  }

  /// Chỉ Parent còn lại (không phải tác giả) viết góc nhìn; mỗi người một bài.
  @override
  Future<MemoryPerspective> savePerspective(
    String memoryId, {
    required String body,
    List<String> mediaAssets = const [],
  }) async {
    if (_serverFamilyId == null || !_isServerMemory(memoryId)) {
      return super.savePerspective(
        memoryId,
        body: body,
        mediaAssets: mediaAssets,
      );
    }
    final record = await _library.putPerspective(memoryId, body.trim());
    final perspective = record == null ? null : _toPerspective(record);
    if (perspective == null) {
      throw StateError('Perspective was not saved');
    }
    _store.touch();
    return perspective;
  }

  MemoryPerspective? _toPerspective(PerspectiveRecord record) {
    final id = record.id;
    final memoryId = record.memoryId;
    if (id == null || memoryId == null) {
      return null;
    }
    return MemoryPerspective(
      id: id,
      memoryId: memoryId,
      authorId: _localUserId(record.authorUserId) ?? '',
      body: record.body ?? '',
      createdAt: (record.createdAt ?? now).toLocal(),
      hiddenFromRelatives: record.hiddenFromCircle,
    );
  }

  // ------------------------------------------------------------ gợi ý

  /// BF-20261023-001: offline chỉ giữ gợi ý server, không lấy fixture.
  @override
  Future<MemoryPrompt?> todayPrompt({String? childId}) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.todayPrompt(childId: childId);
    }
    final MemoryPromptRecord? record;
    try {
      record = (await _library.prompts(
        serverFamilyId,
        childId: childId,
      )).firstOrNull;
    } on DioException catch (error) {
      // BF-20261023-001: chỉ giữ gợi ý server, không dùng catalog mẫu.
      if (!OutboxRunner.isTransient(error)) {
        rethrow;
      }
      if (_prompt == null) {
        return null;
      }
      return _promptOf(_prompt!, childId);
    }
    _prompt = record;
    if (record == null) {
      return null;
    }
    return _promptOf(record, childId);
  }

  MemoryPrompt? _promptOf(MemoryPromptRecord record, String? childId) {
    final code = record.code;
    if (code == null) {
      return null;
    }
    final language = currentAppLanguage().code;
    final text =
        (record.textI18n[language] ?? record.textI18n['vi']) as String? ?? '';
    final name =
        _kids.child(record.childId ?? childId ?? '')?['name'] as String? ?? '';
    return MemoryPrompt(
      id: code,
      childId: record.childId,
      kind: _promptKinds[record.targetKind] ?? MemoryKind.photo,
      text: text.replaceAll('{child}', name),
    );
  }

  @override
  Future<void> dismissPrompt() async {
    final code = _prompt?.code;
    if (_serverFamilyId == null || code == null) {
      return super.dismissPrompt();
    }
    await _library.dismissPrompt(code, childId: _prompt?.childId);
    _prompt = null;
  }

  // ------------------------------------------------------------ cột mốc

  @override
  Future<List<MilestoneOption>> milestoneOptions(
    String childId, {
    String? group,
  }) async {
    final local = await super.milestoneOptions(childId, group: group);
    final recorded = await _recorded(childId);
    if (recorded == null) {
      return local;
    }
    return [
      for (final option in local)
        option.copyWith(
          recordedAt:
              recorded[option.code]?.achieved?.occurredOn ?? option.recordedAt,
          expectedDate:
              recorded[option.code]?.suggestedDate ?? option.expectedDate,
        ),
    ];
  }

  @override
  Future<List<MilestoneItem>> milestones(String childId) async {
    final local = await super.milestones(childId);
    final recorded = await _recorded(childId);
    if (recorded == null) {
      return local;
    }
    return [
      for (final item in local)
        if (recorded[item.code]?.achieved case final achieved?)
          item.copyWith(
            memoryId: achieved.memoryId ?? item.memoryId,
            achievedAt: achieved.occurredOn ?? item.achievedAt,
          )
        else
          item,
    ];
  }

  /// Ghi cột mốc = một ký ức MILESTONE trên server (mỗi mẫu một lần mỗi bé;
  /// đã ghi rồi thì coi như xong).
  @override
  Future<void> recordMilestone(
    String childId,
    String code, {
    DateTime? at,
  }) async {
    if (_serverFamilyId != null && !_isPregnancy(childId)) {
      final title = (await super.milestoneOptions(
        childId,
      )).where((option) => option.code == code).firstOrNull?.title;
      try {
        await create(
          kind: MemoryKind.milestone,
          childIds: [childId],
          title: title,
          milestoneCode: code,
          milestoneTitle: title,
          occurredAt: at,
        );
      } on Object catch (error) {
        if (serverErrorCode(error) != 'MILESTONE_ALREADY_RECORDED') {
          rethrow;
        }
      }
    }
    await super.recordMilestone(childId, code, at: at);
  }

  Future<Map<String, MilestoneTemplateRecord>?> _recorded(
    String childId,
  ) async {
    if (_serverFamilyId == null || _isPregnancy(childId)) {
      return null;
    }
    final categories = await _library.milestoneTemplates(childId: childId);
    return {
      for (final category in categories)
        for (final template in category.templates)
          if (template.code != null) template.code!: template,
    };
  }

  // ------------------------------------------------------------ thư

  /// MEM-14: số thư còn niêm phong của các bé (người khác chỉ thấy phong bì).
  @override
  Future<int> sealedLetters() async {
    if (_serverFamilyId == null) {
      return super.sealedLetters();
    }
    var count = 0;
    for (final row in _kids.children(familyId)) {
      if (row['kind'] == ChildKind.pregnancy.name) {
        continue;
      }
      final letters = await whenOnline(
        () => _library.letters(row['id'] as String),
        what: 'thư',
      );
      if (letters == null) {
        // Mất mạng: số đọc gần nhất.
        return _sealedLetters;
      }
      count += letters.where((letter) => letter.sealed).length;
    }
    return _sealedLetters = count;
  }

  int _sealedLetters = 0;

  // ------------------------------------------------------------ chung

  /// Ký ức đã có trên server (id do server cấp, phản chiếu với `remoteStatus`).
  bool _isServerMemory(String memoryId) =>
      _store.memory(memoryId)?['remoteStatus'] != null;

  bool _isPregnancy(String childId) =>
      _kids.child(childId)?['kind'] == ChildKind.pregnancy.name;

  /// Id người dùng server → id trên máy: tôi, hoặc bạn đời (Parent còn lại).
  String? _localUserId(String? serverUserId) {
    if (serverUserId == null) {
      return null;
    }
    if (serverUserId ==
        sessionRepository.session()[kValueSessionKeyServerUserId]) {
      return myUserId;
    }
    return _members
            .members(familyId)
            .where(
              (member) =>
                  member['userId'] != myUserId &&
                  member['role'] != FamilyRole.relative.name,
            )
            .firstOrNull?['userId']
        as String?;
  }

  static const _promptKinds = {
    'MOMENT': MemoryKind.photo,
    'DIARY': MemoryKind.diary,
    'QUOTE': MemoryKind.quote,
    'VOICE': MemoryKind.voice,
    'KEEPSAKE': MemoryKind.keepsake,
    'MILESTONE': MemoryKind.milestone,
  };

  // ------------------------------------------------------------ duyệt ảnh

  /// MEM-19: ảnh người thân đăng đang chờ Papa & Mama duyệt (server).
  @override
  Future<List<Memory>> pendingPosts() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.pendingPosts();
    }
    final records = await _reads.read([
      'pendingReview',
      serverFamilyId,
    ], () => _library.pendingReview(serverFamilyId));
    final posts = <Memory>[];
    for (final record in records) {
      final id = record.id;
      if (id == null) {
        continue;
      }
      mirrorRecord(record);
      final post = await memory(id);
      if (post != null) {
        posts.add(post);
      }
    }
    return posts..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  }

  @override
  Future<void> approvePost(String postId, {List<String>? childIds}) async {
    if (_serverFamilyId == null || !_isServerMemory(postId)) {
      return super.approvePost(postId, childIds: childIds);
    }
    await _library.review(postId, 'approve', {'childIds': ?childIds});
    _store.updateMemory(postId, {'remoteStatus': 'PUBLISHED'});
    _store.touch();
  }

  @override
  Future<void> rejectPost(String postId, {String? reason}) async {
    if (_serverFamilyId == null || !_isServerMemory(postId)) {
      return super.rejectPost(postId, reason: reason);
    }
    await _library.review(postId, 'reject', {'reason': ?reason});
    _store.updateMemory(postId, {'remoteStatus': 'REJECTED'});
    _store.touch();
  }

  // ------------------------------------------------------------ REC-02

  /// Recap tuần mới nhất của server: số liệu + ký ức nổi bật (id → ký ức đọc
  /// từ server khi máy chưa có). Câu nói đếm từ ký ức đã đồng bộ trong tuần.
  @override
  Future<WeeklyRecap?> weeklyRecap() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.weeklyRecap();
    }
    final record = await _reads.read([
      'latestWeeklyRecap',
      serverFamilyId,
    ], () => _library.latestWeeklyRecap(serverFamilyId));
    final start = DateTime.tryParse(record?.periodStart ?? '');
    final end = DateTime.tryParse(record?.periodEnd ?? '');
    if (record == null || start == null || end == null) {
      return null;
    }
    final highlights = <Memory>[];
    for (final ref in record.content?.topMemories ?? const <RecapMemoryRef>[]) {
      final id = ref.id;
      if (id == null || highlights.length >= kValueRecapHighlightMax) {
        continue;
      }
      final memory = await refreshMemory(id);
      if (memory != null) {
        highlights.add(memory);
      }
    }
    final stats = record.content?.stats;
    final lastDay = end.add(const Duration(days: 1));
    final quotes = (await memories())
        .where(
          (memory) =>
              memory.kind == MemoryKind.quote &&
              !memory.occurredAt.isBefore(start) &&
              memory.occurredAt.isBefore(lastDay),
        )
        .length;
    final moments = stats?.memoryCount ?? 0;
    final firsts = stats?.milestoneCount ?? 0;
    return WeeklyRecap(
      start: start,
      end: end,
      headline: currentL10n().recapWeekHeadline(moments, firsts),
      moments: moments,
      firsts: firsts,
      quotes: quotes,
      heroAssets: [
        for (final memory in highlights) ...memory.mediaAssets.take(1),
      ].take(kValueRecapHeroMax).toList(),
      highlights: highlights,
    );
  }

  // ------------------------------------------------------------ MEM-20/21

  @override
  Future<List<MonthlyPhoto>> monthlyPhotos(String childId) async {
    if (_serverFamilyId == null || !_isServerChild(childId)) {
      return super.monthlyPhotos(childId);
    }
    final List<MonthlyPhotoRecord> records;
    try {
      records = await _library.monthlyPhotos(childId);
    } on DioException catch (error) {
      // Mất mạng: ảnh tháng theo các ký ức đã lưu trên máy.
      if (!OutboxRunner.isTransient(error)) {
        rethrow;
      }
      return super.monthlyPhotos(childId);
    }
    // Thẻ chương tháng (tính trên máy) cần biết ký ức nào là ảnh tháng nào.
    for (final record in records) {
      final memoryId = record.memoryId;
      final row = memoryId == null ? null : _store.memory(memoryId);
      if (row != null && row['monthIndex'] != record.monthIndex) {
        _store.updateMemory(memoryId!, {
          'monthIndex': record.monthIndex,
          'kind': MemoryKind.monthlyPhoto.name,
        });
      }
    }
    return [
      for (final record in records)
        if (record.memoryId case final memoryId?)
          MonthlyPhoto(
            id: memoryId,
            childId: childId,
            monthIndex: record.monthIndex ?? 0,
            memoryId: memoryId,
            asset: record.url,
            takenAt: record.occurredAt?.toLocal(),
          ),
    ]..sort((a, b) => a.monthIndex.compareTo(b.monthIndex));
  }

  /// MEM-21: ảnh tải lên thành khoảnh khắc của bé vào đúng ngày tròn tháng
  /// (server kiểm tháng theo ngày ký ức), rồi đặt làm ảnh tháng — ảnh cũ
  /// của tháng đó thành ký ức thường (BR-072, server xử lý).
  @override
  Future<Memory> saveMonthlyPhoto(
    String childId, {
    required String asset,
    int? monthIndex,
  }) async {
    final birthText = _kids.child(childId)?['birthDate'] as String?;
    if (_serverFamilyId == null ||
        !_isServerChild(childId) ||
        birthText == null) {
      return super.saveMonthlyPhoto(
        childId,
        asset: asset,
        monthIndex: monthIndex,
      );
    }
    final birth = DateTime.parse(birthText);
    final index = monthIndex ?? childAgeInMonths(birth, today).clamp(0, 240);
    final anniversary = monthAnniversary(birth, index);
    final occurredAt = anniversary.isAfter(now) ? now : anniversary;
    final assetId = await uploadAsset(asset);
    final memory = await create(
      kind: MemoryKind.photo,
      childIds: [childId],
      mediaAssets: [asset],
      occurredAt: occurredAt,
    );
    await _library.setMonthlyPhoto(
      childId,
      index,
      memoryId: memory.id,
      assetId: assetId,
    );
    return (await refreshMemory(memory.id)) ?? memory;
  }

  bool _isServerChild(String childId) =>
      _kids.child(childId)?[kValueChildKeyServerSubject] == true;
}
