import 'dart:async';

import 'dart:convert';

import 'package:baby_family/data/dto/memory_grid_photo.dart';
import 'package:baby_family/data/dto/memory_search_result.dart';
import 'package:baby_family/data/model/memory/comment_record.dart';
import 'package:baby_family/data/model/memory/media_asset_record.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/memory_draft_item.dart';
import 'package:baby_family/data/model/memory/memory_record.dart';
import 'package:baby_family/data/model/memory/on_this_day_group.dart';
import 'package:baby_family/data/model/memory/on_this_day_record.dart';
import 'package:baby_family/data/model/memory/report_receipt.dart';
import 'package:baby_family/data/model/memory/story_item.dart';
import 'package:baby_family/data/model/memory/today_story_record.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/memory.dart';
import 'package:baby_family/data/repository/memory_feed.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/service/local_media.dart';
import 'package:baby_family/data/service_imp/child.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/memory.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Ký ức qua server thật (MEM-04/05, HOME-01 feed; tài liệu kỹ thuật 10.2,
/// 11.5). Đăng ký ức: tải từng ảnh lên (upload-intent → PUT presigned URL →
/// complete) rồi `POST /v1/memories`; thành công mới ghi vào kho trên máy với id
/// của server (ảnh hiển thị ngay từ file vừa chọn). Đọc danh sách: đồng bộ feed
/// của server vào kho trên máy (URL ảnh đã ký thay file khi server xử lý xong).
/// Các loại chưa có API phía server (ghi âm, thư, cột mốc, ảnh tháng…) vẫn chỉ
/// lưu trên máy (BF-20261016-002).
class MemoryRemoteServiceImp extends MemoryServiceImp {
  MemoryRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._memories,
    this._children,
    this._family,
    this._feed,
    this._media,
  ) : super(sessionRepository, clock, _memories, _children, _family);

  final IMemoryRepository _memories;
  final IChildRepository _children;
  final IFamilyRepository _family;
  final IMemoryFeedRepository _feed;
  final IMediaRepository _media;

  static const _uuid = Uuid();

  /// Loại ký ức app → server (mục 11.5); loại khác chưa có API.
  static final _day = DateFormat('yyyy-MM-dd');

  static const _serverKinds = {
    MemoryKind.photo: 'MOMENT',
    MemoryKind.diary: 'DIARY',
    MemoryKind.keepsake: 'KEEPSAKE',
    MemoryKind.quote: 'QUOTE',
    // BF-20261019-002: cột mốc (MEM-11) và thư gửi con (MEM-14).
    MemoryKind.milestone: 'MILESTONE',
    MemoryKind.letter: 'LETTER',
    // BF-20261021-001: ghi âm (asset audio, server tính thời lượng).
    MemoryKind.voice: 'VOICE',
  };

  static const _appKinds = {
    'MOMENT': MemoryKind.photo,
    'DIARY': MemoryKind.diary,
    'KEEPSAKE': MemoryKind.keepsake,
    'QUOTE': MemoryKind.quote,
    'VOICE': MemoryKind.voice,
    'LETTER': MemoryKind.letter,
    'MILESTONE': MemoryKind.milestone,
    'MONTHLY_PHOTO': MemoryKind.monthlyPhoto,
    'ULTRASOUND': MemoryKind.ultrasound,
    'BUMP': MemoryKind.bump,
    'MISSION': MemoryKind.fromMission,
  };

  /// Cảm xúc của khoảnh khắc server nhận (mục 11.5).
  static const _feelings = {
    'LOVE',
    'JOY',
    'TOUCHED',
    'SURPRISED',
    'PEACEFUL',
    'PROUD',
  };

  DateTime? _syncedAt;
  DateTime? _fullSyncedAt;
  Future<void>? _syncing;

  /// Ký ức tạo trên máy trong lúc đang đồng bộ: có thể chưa nằm trong ảnh chụp
  /// feed vừa tải nên không bị coi là đã xoá phía server.
  final _createdDuringSync = <String>{};

  /// Lúc đầu tiên thấy ký ức ở trạng thái PROCESSING (giới hạn thời gian hỏi lại).
  final _processingSince = <String, DateTime>{};

  /// Idempotency-Key theo nội dung của lần đăng đang dở: bấm Lưu lại sau lỗi
  /// (server có thể đã ghi nhưng mất response) dùng lại key → không tạo trùng.
  final _pendingKeys = <String, String>{};

  String _keyFor(String fingerprint) =>
      _pendingKeys[fingerprint] ??= _uuid.v4();

  String? get _serverFamilyId {
    final id =
        sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;
    if (id != _cachedFamilyId) {
      // FAM-08: đổi gia đình → bỏ mốc đồng bộ/bộ nhớ đệm của nhà cũ.
      _cachedFamilyId = id;
      _timelineSyncedAt.clear();
      _photoCache.clear();
      _syncedAt = null;
      _latestRecapWeek = null;
      _cloudDrafts = const {};
    }
    return id;
  }

  String? _cachedFamilyId;

  @override
  Future<List<Memory>> memories({
    String? childId,
    Set<MemoryKind>? kinds,
  }) async {
    _markStaleUploads();
    await _sync();
    if (childId != null) {
      await _syncSubject(childId);
    }
    return super.memories(childId: childId, kinds: kinds);
  }

  /// Lần đọc bảng tin theo từng bé/thai kỳ gần nhất.
  final _subjectSyncedAt = <String, DateTime>{};

  /// Lọc theo bé/thai kỳ: đọc thêm bảng tin server của riêng bé đó (đủ trang)
  /// để không thiếu ký ức cũ ngoài số trang của bảng tin cả nhà. Chỉ thêm/cập
  /// nhật, không xoá; lỗi mạng giữ dữ liệu đang có.
  Future<void> _syncSubject(String childId) async {
    final serverFamilyId = _serverFamilyId;
    final synced = _subjectSyncedAt[childId];
    if (serverFamilyId == null ||
        (synced != null &&
            now.difference(synced) < kValueRemoteFeedRefreshInterval)) {
      return;
    }
    final pregnancy =
        _children.child(childId)?['kind'] == ChildKind.pregnancy.name;
    try {
      String? cursor;
      for (var page = 0; page < kValueRemoteFeedMaxPages; page++) {
        final result = await _feed.feed(
          serverFamilyId,
          childId: pregnancy ? null : childId,
          pregnancyId: pregnancy ? childId : null,
          cursor: cursor,
          limit: kValueRemoteFeedPageSize,
        );
        if (_serverFamilyId != serverFamilyId) {
          return;
        }
        result.memories.forEach(_mirror);
        final next = result.nextCursor;
        if (next == null || next == cursor) {
          break;
        }
        cursor = next;
      }
      _subjectSyncedAt[childId] = now;
    } on DioException catch (error) {
      Logger().w('Không đọc được bảng tin của bé: ${error.message}');
    }
  }

  /// Lần đọc timeline / lưới ảnh gần nhất theo bé (null = cả nhà).
  final _timelineSyncedAt = <String?, DateTime>{};
  final _photoCache =
      <String?, ({DateTime at, List<MemoryGridPhoto> photos})>{};

  /// MEM-01: đồng bộ timeline của server (theo ngày xảy ra, đủ trang) vào kho
  /// trên máy rồi đọc kho — cùng thứ tự, gồm cả ký ức chỉ có trên máy. Tối đa
  /// mỗi [kValueRemoteFeedRefreshInterval]; lỗi mạng giữ dữ liệu đang có.
  @override
  Future<List<Memory>> timeline({String? childId}) async {
    final serverFamilyId = _serverFamilyId;
    final synced = _timelineSyncedAt[childId];
    if (serverFamilyId != null &&
        (synced == null ||
            now.difference(synced) >= kValueRemoteFeedRefreshInterval)) {
      await ready();
      final pregnancy =
          childId != null &&
          _children.child(childId)?['kind'] == ChildKind.pregnancy.name;
      final chapters = <String, JsonMap>{};
      String? recapWeek;
      try {
        String? cursor;
        for (var page = 0; page < kValueRemoteFeedMaxPages; page++) {
          final result = await _feed.timeline(
            serverFamilyId,
            childId: pregnancy ? null : childId,
            pregnancyId: pregnancy ? childId : null,
            cursor: cursor,
            limit: kValueRemoteFeedPageSize,
          );
          if (_serverFamilyId != serverFamilyId) {
            break;
          }
          // Thẻ chào đời/tròn tháng app tự dựng; thẻ chương tháng lấy số
          // liệu + ảnh bìa của server (đúng quyền xem) cho thẻ chương trên máy.
          result.items.map((item) => item.memory).nonNulls.forEach(_mirror);
          for (final item in result.items) {
            final week = item.periodStart;
            if (item.kind == _weeklyRecapKind &&
                week != null &&
                (recapWeek == null || week.compareTo(recapWeek) > 0)) {
              recapWeek = week;
            }
            if (item.kind == 'CHAPTER' &&
                item.childId != null &&
                item.monthIndex != null) {
              chapters.putIfAbsent(
                item.childId!,
                () => {},
              )['${item.monthIndex}'] = {
                'coverUrl': item.coverUrl,
                'memoryCount': item.memoryCount,
                'firstsCount': item.firstsCount,
              };
            }
          }
          final next = result.nextCursor;
          if (next == null || next == cursor) {
            break;
          }
          cursor = next;
        }
        _timelineSyncedAt[childId] = now;
        if (childId == null) {
          _latestRecapWeek = recapWeek == null
              ? null
              : DateTime.tryParse(recapWeek);
        }
        chapters.forEach((id, months) {
          if (_children.child(id) != null) {
            _children.updateChild(id, {kValueChildKeyServerChapters: months});
          }
        });
      } on DioException catch (error) {
        Logger().w('Không đọc được timeline: ${error.message}');
      }
    }
    return super.memories(childId: childId);
  }

  /// MEM-02: ô ảnh từ `media-grid` (bản thu nhỏ `t320` đã ký) + ảnh của ký
  /// ức chỉ có trên máy, mới nhất trước.
  @override
  Future<List<MemoryGridPhoto>> photos({String? childId}) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.photos(childId: childId);
    }
    final cached = _photoCache[childId];
    if (cached != null &&
        now.difference(cached.at) < kValueRemoteFeedRefreshInterval) {
      return cached.photos;
    }
    await ready();
    final local = [
      for (final photo in await super.photos(childId: childId))
        if (_memories.memory(photo.memory.id)?['remoteStatus'] == null) photo,
    ];
    final server = <MemoryGridPhoto>[];
    try {
      String? cursor;
      for (var page = 0; page < kValueRemoteFeedMaxPages; page++) {
        final result = await _feed.mediaGrid(
          serverFamilyId,
          childId: childId,
          cursor: cursor,
          limit: kValueRemoteFeedPageSize,
        );
        for (final item in result.items) {
          final url =
              item.urls['t320'] ?? item.urls['m1080'] ?? item.urls['l2048'];
          final memoryId = item.memoryId;
          final memory = memoryId == null ? null : await this.memory(memoryId);
          if (url != null && memory != null) {
            server.add(MemoryGridPhoto(asset: url, memory: memory));
          }
        }
        final next = result.nextCursor;
        if (next == null || next == cursor) {
          break;
        }
        cursor = next;
      }
    } on DioException catch (error) {
      Logger().w('Không đọc được lưới ảnh: ${error.message}');
      return super.photos(childId: childId);
    }
    final photos = [...server, ...local]
      ..sort((a, b) => b.memory.occurredAt.compareTo(a.memory.occurredAt));
    _photoCache[childId] = (at: now, photos: photos);
    return photos;
  }

  /// Nháp điền sẵn của bản mock là dữ liệu mẫu theo thiết kế (ảnh trong app,
  /// tên bé mẫu) — không dùng với dữ liệu thật.
  @override
  Future<Memory?> draft(MemoryKind kind) async {
    // Chỉ nháp trên máy của người dùng (không điền nội dung mẫu).
    await ready();
    return deviceDraft(kind);
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
    String? locationLabel,
    String? milestoneCode,
    String? milestoneTitle,
    int? monthIndex,
    int? pregnancyWeek,
    int? voiceDurationSec,
    DateTime? sealedUntil,
    String? missionId,
    bool deferUpload = false,
  }) async {
    final serverKind = _serverKinds[kind];
    final serverFamilyId = _serverFamilyId;
    if (serverKind == null || serverFamilyId == null) {
      return super.create(
        kind: kind,
        childIds: childIds,
        title: title,
        body: body,
        quoteContext: quoteContext,
        mediaAssets: mediaAssets,
        visibility: visibility,
        occurredAt: occurredAt,
        feeling: feeling,
        people: people,
        locationLabel: locationLabel,
        milestoneCode: milestoneCode,
        milestoneTitle: milestoneTitle,
        monthIndex: monthIndex,
        pregnancyWeek: pregnancyWeek,
        voiceDurationSec: voiceDurationSec,
        sealedUntil: sealedUntil,
        missionId: missionId,
      );
    }
    await ready();
    if (deferUpload && mediaAssets.isNotEmpty) {
      // MEM-06: ký ức tạm hiện ngay với tiến độ; tải + tạo ký ức chạy nền.
      return _enqueue(
        () => create(
          kind: kind,
          childIds: childIds,
          title: title,
          body: body,
          quoteContext: quoteContext,
          mediaAssets: mediaAssets,
          visibility: visibility,
          occurredAt: occurredAt,
          feeling: feeling,
          people: people,
          locationLabel: locationLabel,
          milestoneCode: milestoneCode,
          milestoneTitle: milestoneTitle,
          monthIndex: monthIndex,
          pregnancyWeek: pregnancyWeek,
          voiceDurationSec: voiceDurationSec,
          sealedUntil: sealedUntil,
          missionId: missionId,
        ),
        {
          'familyId': familyId,
          'kind': kind.name,
          'title': ?title,
          'body': ?body,
          'childIds': childIds,
          'authorId': myUserId,
          'occurredAt': (occurredAt ?? now).toIso8601String(),
          'createdAt': now.toIso8601String(),
          'mediaAssets': mediaAssets,
          'visibility': visibility.name,
          'people': people,
          'locationLabel': ?locationLabel,
          'uploadTotal': mediaAssets.length,
        },
      );
    }
    final assetIds = <String>[];
    for (final path in mediaAssets) {
      assetIds.add(await _upload(serverFamilyId, path));
      final active = _activeUpload;
      if (active != null) {
        _memories.updateMemory(active, {'uploadDone': assetIds.length});
      }
    }
    final pregnancyId = childIds
        .where((id) => _children.child(id)?['kind'] == ChildKind.pregnancy.name)
        .firstOrNull;
    final kids = childIds
        .where((id) => _children.child(id)?['kind'] != ChildKind.pregnancy.name)
        .toList();
    final at = occurredAt ?? now;
    final serverFeeling = feeling?.toUpperCase();
    final payload = <String, dynamic>{
      'familyId': serverFamilyId,
      'kind': serverKind,
      'assetIds': assetIds,
      'title': ?title,
      'body': ?body,
      'childIds': kids,
      'familyMoment': kids.isEmpty && pregnancyId == null,
      'pregnancyId': ?pregnancyId,
      'occurredAt': at.toUtc().toIso8601String(),
      'visibility': _serverVisibility(visibility),
      if (_feelings.contains(serverFeeling)) 'feeling': serverFeeling,
      if (people.isNotEmpty)
        'people': [
          for (final name in people)
            if (name.trim().isNotEmpty) {'displayName': name.trim()},
        ],
      if (locationLabel != null && locationLabel.trim().isNotEmpty)
        'locationLabel': locationLabel.trim(),
      if (kind == MemoryKind.quote) 'quoteContext': ?quoteContext,
      if (kind == MemoryKind.milestone)
        'milestone': {
          'templateCode': ?milestoneCode,
          if (milestoneCode == null) 'customTitle': milestoneTitle ?? title,
          'occurredOn': _day.format(at),
        },
      // Thư niêm phong tới ngày mở; lúc mở, ký ức hiện theo quyền đã chọn.
      if (kind == MemoryKind.letter && kids.isNotEmpty)
        'letter': {
          'childId': kids.first,
          'releaseRule': 'DATE',
          'unlockAt': ?sealedUntil?.toUtc().toIso8601String(),
          'releaseVisibility': _serverVisibility(visibility),
        },
    };
    final fingerprint = jsonEncode(payload);
    final record = await _feed.createMemory(_keyFor(fingerprint), payload);
    _pendingKeys.remove(fingerprint);
    final createdId = record?.id;
    if (createdId != null) {
      if (_syncing != null) {
        _createdDuringSync.add(createdId);
      }
      _trackProcessing(createdId, record?.status);
    }
    final row = _memories.addMemory({
      'id': ?record?.id,
      'familyId': familyId,
      'kind': kind.name,
      'title': ?title,
      'body': ?body,
      'quoteContext': ?quoteContext,
      'childIds': childIds,
      'authorId': myUserId,
      'occurredAt': at.toIso8601String(),
      'createdAt': now.toIso8601String(),
      // File vừa chọn hiển thị ngay; URL của server thay vào khi xử lý xong.
      'mediaAssets': mediaAssets,
      'visibility': visibility.name,
      'feeling': ?feeling,
      'people': people,
      'milestoneCode': ?milestoneCode,
      'milestoneTitle': ?milestoneTitle,
      'sealedUntil': ?sealedUntil?.toIso8601String(),
      'remoteStatus': ?record?.status,
      'remoteVersion': ?record?.version,
      ChildServiceImp.localKey: true,
    });
    return Memory.fromJson(row);
  }

  // ------------------------------------------------------------ MEM-06

  /// Việc tải nền theo id ký ức tạm; chạy lần lượt (một tải lên một lúc).
  final _uploadJobs = <String, Future<Memory> Function()>{};
  String? _activeUpload;
  Future<void> _uploadQueue = Future.value();

  /// Chờ hàng đợi tải nền xong (test, đăng xuất).
  @visibleForTesting
  Future<void> get uploadsSettled => _uploadQueue;

  Memory _enqueue(Future<Memory> Function() run, JsonMap placeholder) {
    final row = _memories.addMemory({
      ...placeholder,
      'uploadDone': 0,
      'uploadFailed': false,
      ChildServiceImp.localKey: true,
    });
    final id = row['id'] as String;
    _uploadJobs[id] = run;
    _scheduleUpload(id);
    return Memory.fromJson(row);
  }

  /// Ký ức tạm không còn việc tải (app vừa mở lại) → hiện “chưa xong”.
  void _markStaleUploads() {
    for (final row in _memories.memories(familyId)) {
      final id = row['id'] as String;
      if (row['uploadTotal'] != null &&
          row['uploadFailed'] != true &&
          !_uploadJobs.containsKey(id)) {
        _memories.updateMemory(id, {'uploadFailed': true});
      }
    }
  }

  void _scheduleUpload(String id) {
    _uploadQueue = _uploadQueue.then((_) => _runUpload(id));
  }

  Future<void> _runUpload(String id) async {
    final run = _uploadJobs[id];
    if (run == null || _memories.memory(id) == null) {
      return;
    }
    _activeUpload = id;
    _memories.updateMemory(id, {'uploadFailed': false, 'uploadDone': 0});
    try {
      await run();
      _uploadJobs.remove(id);
      _memories.removeMemory(id);
    } on Object catch (error) {
      Logger().w('Tải lên chưa xong: $error');
      if (_memories.memory(id) != null) {
        _memories.updateMemory(id, {'uploadFailed': true});
      }
    } finally {
      _activeUpload = null;
    }
  }

  /// Key idempotency theo nội dung được giữ, nên thử lại không tạo trùng.
  @override
  Future<void> retryUpload(String memoryId) async {
    if (!_uploadJobs.containsKey(memoryId)) {
      return _keepAsDraft(memoryId);
    }
    _scheduleUpload(memoryId);
    await _uploadQueue;
  }

  @override
  Future<void> cancelUpload(String memoryId) async {
    _uploadJobs.remove(memoryId);
    _memories.removeMemory(memoryId);
  }

  /// Ký ức tạm còn lại sau khi mở lại app (việc tải đã mất) → nháp trên máy
  /// (giữ nội dung, MEM-06 “giữ nháp”).
  Future<void> _keepAsDraft(String memoryId) async {
    final row = _memories.memory(memoryId);
    if (row == null) {
      return;
    }
    final memory = Memory.fromJson(row);
    await saveDraft(
      kind: memory.kind,
      title: memory.title ?? memory.body ?? '',
      childIds: memory.childIds,
      mediaAssets: memory.mediaAssets,
    );
    _memories.removeMemory(memoryId);
  }

  /// Tải một ảnh/video lên (lớp con dùng cho ảnh tháng); trả asset id.
  @protected
  Future<String> uploadAsset(String path) => _upload(_serverFamilyId!, path);

  /// Ảnh/video (MEM-04): upload-intent → PUT (multipart khi lớn) →
  /// complete; nội dung đã có trên server (trùng SHA-256) thì dùng lại asset.
  /// Key idempotency theo nội dung để bấm Lưu lại sau lỗi không tạo trùng.
  Future<String> _upload(String serverFamilyId, String path) async {
    final bytes = await _media.readLocalFile(path);
    final fingerprint = 'upload:$serverFamilyId:${sha256.convert(bytes)}';
    final assetId = await MediaUploader(_media).upload(
      serverFamilyId,
      path,
      purpose: 'MEMORY',
      idempotencyKey: _keyFor(fingerprint),
      bytes: bytes,
    );
    if (MediaUploader.isAudio(path)) {
      // VOICE: server cần audio READY (đã đo thời lượng) khi tạo ký ức.
      await MediaUploader(_media).waitReady(assetId);
    }
    _pendingKeys.remove(fingerprint);
    return assetId;
  }

  static String _serverVisibility(MemoryVisibility visibility) =>
      switch (visibility) {
        MemoryVisibility.family => 'FAMILY',
        MemoryVisibility.parents => 'PARENTS',
        MemoryVisibility.onlyMe => 'PRIVATE',
      };

  static MemoryVisibility _appVisibility(String? value) => switch (value) {
    'PRIVATE' => MemoryVisibility.onlyMe,
    'PARENTS' => MemoryVisibility.parents,
    _ => MemoryVisibility.family,
  };

  /// Ký ức đang ở thùng rác của server (lần đọc [trash] gần nhất).
  final _serverTrashIds = <String>{};

  bool _isServerMemory(String id) =>
      _serverFamilyId != null && _memories.memory(id)?['remoteStatus'] != null;

  /// MEM-09: ký ức của server sửa qua `PATCH` với version đang có trên máy;
  /// server báo version cũ (412) → tải lại bản mới vào kho rồi báo lỗi để người
  /// dùng xem lại. Chỉ gửi trường thay đổi (bố/mẹ khác chỉ đổi bé, phạm vi).
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
    if (!_isServerMemory(memoryId)) {
      return super.updateMemory(
        memoryId,
        title: title,
        body: body,
        childIds: childIds,
        occurredAt: occurredAt,
        visibility: visibility,
        commentsEnabled: commentsEnabled,
        mediaAssets: mediaAssets,
      );
    }
    await ready();
    final row = _memories.memory(memoryId)!;
    var version = row['remoteVersion'] as int?;
    if (version == null) {
      final current = await _feed.memory(memoryId);
      if (current != null) {
        _mirror(current);
      }
      version = current?.version;
    }
    String? blank(String? value) =>
        value == null || value.trim().isEmpty ? null : value.trim();
    final payload = <String, dynamic>{
      if (title != null && blank(title) != blank(row['title'] as String?))
        'title': blank(title),
      if (body != null && blank(body) != blank(row['body'] as String?))
        'body': blank(body),
      if (occurredAt != null)
        'occurredAt': occurredAt.toUtc().toIso8601String(),
      if (visibility != null) 'visibility': _serverVisibility(visibility),
      if (childIds != null) ..._subjectsOf(childIds),
      if (commentsEnabled != null &&
          commentsEnabled != (row['commentsEnabled'] ?? true))
        'commentsEnabled': commentsEnabled,
      if (mediaAssets != null) ...await _mediaPatch(row, mediaAssets),
    };
    if (version == null || payload.isEmpty) {
      return Memory.fromJson(row);
    }
    try {
      final record = await _feed.updateMemory(memoryId, version, payload);
      if (record != null) {
        _mirror(record);
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 412) {
        final current = await _feed.memory(memoryId);
        if (current != null) {
          _mirror(current);
        }
      }
      rethrow;
    }
    return (await memory(memoryId)) ?? Memory.fromJson(row);
  }

  /// MEM-09 đổi ảnh: URL đang có ↔ asset id (lưu khi phản chiếu); ảnh mới
  /// trên máy tải lên trước; ảnh đầu danh sách là bìa.
  Future<JsonMap> _mediaPatch(JsonMap row, List<String> next) async {
    final current = [...(row['mediaAssets'] as List? ?? const [])];
    final ids = [...(row['mediaAssetIds'] as List? ?? const [])];
    final idOf = {
      for (var i = 0; i < current.length && i < ids.length; i++)
        current[i] as String: ids[i] as String,
    };
    final serverFamilyId = _serverFamilyId!;
    final added = <String>[];
    final ordered = <String>[];
    for (final source in next) {
      final known = idOf[source];
      if (known != null) {
        ordered.add(known);
        continue;
      }
      final uploaded = await _upload(serverFamilyId, source);
      added.add(uploaded);
      ordered.add(uploaded);
    }
    final removed = [
      for (final id in idOf.values)
        if (!ordered.contains(id)) id,
    ];
    final cover = ordered.firstOrNull;
    final changed =
        added.isNotEmpty ||
        removed.isNotEmpty ||
        (cover != null && ids.isNotEmpty && cover != ids.first);
    return {
      if (added.isNotEmpty) 'addAssetIds': added,
      if (removed.isNotEmpty) 'removeAssetIds': removed,
      if (changed && cover != null) 'coverAssetId': cover,
    };
  }

  /// Bé/thai kỳ của ký ức theo dạng server (thai kỳ là `pregnancyId` riêng).
  JsonMap _subjectsOf(List<String> childIds) {
    final pregnancyId = childIds
        .where((id) => _children.child(id)?['kind'] == ChildKind.pregnancy.name)
        .firstOrNull;
    final kids = childIds
        .where((id) => _children.child(id)?['kind'] != ChildKind.pregnancy.name)
        .toList();
    return {
      'childIds': kids,
      'familyMoment': kids.isEmpty && pregnancyId == null,
      'pregnancyId': pregnancyId,
    };
  }

  /// Bình luận server đã đọc (id → ký ức) để sửa/xoá đi đúng đường.
  final _serverComments = <String, String>{};

  /// Cảm xúc của ký ức server: đổi/bỏ qua API rồi ghi số đếm server trả về.
  /// Emoji ngoài năm cảm xúc của đặc tả không gửi lên server.
  @override
  Future<void> react(String memoryId, String emoji) async {
    final type = kValueReactionTypes[emoji];
    if (!_isServerMemory(memoryId)) {
      return super.react(memoryId, emoji);
    }
    if (type == null) {
      return;
    }
    await ready();
    final previous = _memories.memory(memoryId)?['myReaction'];
    final state = previous == emoji
        ? await _feed.clearReaction(memoryId)
        : await _feed.setReaction(memoryId, type);
    if (state == null) {
      return;
    }
    _memories.updateMemory(memoryId, {
      'reactions': _emojiReactions(state.reactions),
      'myReaction': _emojiOf(state.myReaction),
    });
  }

  @override
  Future<List<MemoryComment>> comments(String memoryId) async {
    if (!_isServerMemory(memoryId)) {
      return super.comments(memoryId);
    }
    await ready();
    final records = await _feed.comments(memoryId);
    return [
      for (final record in records)
        if (record.id != null) _commentOf(record, memoryId),
    ];
  }

  @override
  Future<MemoryComment> addComment(
    String memoryId,
    String body, {
    String? parentId,
  }) async {
    if (!_isServerMemory(memoryId)) {
      return super.addComment(memoryId, body, parentId: parentId);
    }
    await ready();
    final record = await _feed.addComment(
      memoryId,
      body.trim(),
      parentCommentId: parentId,
    );
    if (record?.id == null) {
      throw StateError('Comment was not created');
    }
    final count = _memories.memory(memoryId)?['commentCount'] as int? ?? 0;
    _memories.updateMemory(memoryId, {'commentCount': count + 1});
    return _commentOf(record!, memoryId);
  }

  @override
  Future<void> editComment(String commentId, String body) async {
    if (!_serverComments.containsKey(commentId)) {
      return super.editComment(commentId, body);
    }
    await ready();
    await _feed.editComment(commentId, body.trim());
  }

  @override
  Future<void> deleteComment(String commentId) async {
    final memoryId = _serverComments[commentId];
    if (memoryId == null) {
      return super.deleteComment(commentId);
    }
    await ready();
    await _feed.deleteComment(commentId);
    _serverComments.remove(commentId);
  }

  /// Bình luận server → dạng của app (tác giả đổi về id/tên trên máy).
  MemoryComment _commentOf(CommentRecord record, String memoryId) {
    final id = record.id!;
    _serverComments[id] = memoryId;
    final authorId = _localUserId(record.authorUserId);
    final member = _family
        .members(familyId)
        .where((row) => row['userId'] == authorId)
        .firstOrNull;
    return MemoryComment.fromJson({
      'id': id,
      'memoryId': memoryId,
      'authorId': authorId,
      'authorName': member?['displayName'] ?? '',
      'authorRole': member?['role'],
      'body': record.body ?? '',
      'createdAt': (record.createdAt ?? now).toLocal().toIso8601String(),
      'parentId': record.parentCommentId,
    });
  }

  /// MEM-07 “Xoá”: ký ức của server vào thùng rác trên server (30 ngày) rồi gỡ
  /// khỏi kho trên máy; ký ức chỉ có trên máy giữ luồng cũ.
  @override
  Future<void> moveToTrash(String memoryId) async {
    if (!_isServerMemory(memoryId)) {
      return super.moveToTrash(memoryId);
    }
    await ready();
    await _feed.trashMemory(memoryId);
    _processingSince.remove(memoryId);
    _memories.removeMemory(memoryId);
  }

  /// MEM-17: thùng rác của server (mọi trang) + ký ức chỉ có trên máy đã xoá.
  @override
  Future<List<Memory>> trash() async {
    final local = await super.trash();
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return local;
    }
    final records = <MemoryRecord>[];
    String? cursor;
    for (var page = 0; page < kValueRemoteFeedMaxPages; page++) {
      final result = await _feed.trash(
        serverFamilyId,
        cursor: cursor,
        limit: kValueRemoteFeedPageSize,
      );
      records.addAll(result.memories);
      final next = result.nextCursor;
      if (next == null || next == cursor) {
        break;
      }
      cursor = next;
    }
    _serverTrashIds
      ..clear()
      ..addAll(records.map((record) => record.id).nonNulls);
    final server = [
      for (final record in records)
        if (record.id != null)
          Memory.fromJson({
            ..._fieldsOf(record),
            'id': record.id,
            'mediaAssets': _urlsOf(record),
            'deletedAt': record.trashedAt?.toLocal().toIso8601String(),
            'deletedByUserId': _localUserId(record.trashedBy),
          }),
    ];
    return [...server, ...local]..sort(
      (a, b) =>
          (b.deletedAt ?? b.occurredAt).compareTo(a.deletedAt ?? a.occurredAt),
    );
  }

  @override
  Future<void> restoreMemory(String memoryId) async {
    if (!_serverTrashIds.contains(memoryId)) {
      return super.restoreMemory(memoryId);
    }
    await ready();
    final record = await _feed.restoreMemory(memoryId);
    _serverTrashIds.remove(memoryId);
    if (record != null) {
      _mirror(record);
    }
  }

  @override
  Future<void> deleteForever(String memoryId) async {
    if (!_serverTrashIds.contains(memoryId)) {
      return super.deleteForever(memoryId);
    }
    await ready();
    await _feed.purgeMemory(memoryId);
    _serverTrashIds.remove(memoryId);
  }

  /// Ký ức đang xử lý ảnh → hỏi lại sau [kValueRemoteFeedRefreshInterval]
  /// (tối đa [kValueRemoteProcessingPollWindow]); không còn thì chờ tới lúc URL
  /// ảnh ký sớm hết hạn nhất cần làm mới; không có gì cần → null (dừng).
  @override
  Duration? refreshDelay() {
    if (_serverFamilyId == null) {
      return null;
    }
    final current = now;
    final rows = _mirroredRows().toList();
    final processing = rows.any((row) {
      final since = _processingSince[row['id']];
      return row['remoteStatus'] == 'PROCESSING' &&
          (since == null ||
              current.difference(since) < kValueRemoteProcessingPollWindow);
    });
    if (processing) {
      return kValueRemoteFeedRefreshInterval;
    }
    final soonest = _soonestUrlExpiry(rows);
    if (soonest == null) {
      return null;
    }
    final due = soonest
        .subtract(kValueSignedUrlRefreshMargin)
        .difference(current);
    return due < kValueRemoteFeedRefreshInterval
        ? kValueRemoteFeedRefreshInterval
        : due;
  }

  /// Bản sao trên máy của ký ức server (có `remoteStatus`) thuộc gia đình này.
  Iterable<JsonMap> _mirroredRows() => _memories
      .memories(familyId)
      .where((row) => row['remoteStatus'] != null && row['id'] != null);

  static DateTime? _soonestUrlExpiry(Iterable<JsonMap> rows) => rows
      .map(
        (row) => DateTime.tryParse(row['mediaUrlsExpireAt'] as String? ?? ''),
      )
      .nonNulls
      .fold<DateTime?>(
        null,
        (soonest, at) => soonest == null || at.isBefore(soonest) ? at : soonest,
      );

  void _trackProcessing(String id, String? status) {
    if (status == 'PROCESSING') {
      _processingSince.putIfAbsent(id, () => now);
    } else {
      _processingSince.remove(id);
    }
  }

  @override
  Future<int?> videoDurationSec(String path) async {
    if (!MediaUploader.isVideo(path)) {
      return null;
    }
    final ms = await _media.mediaDurationMs(path);
    return ms == null ? null : (ms / 1000).ceil();
  }

  // ------------------------------------------------ MEM-15/16, RPT-01

  /// MEM-15: server tìm (bỏ dấu, theo tiền tố từ, đúng quyền xem); kết quả
  /// ghi vào kho trên máy rồi chia nhóm Ảnh & video / Nhật ký như bản mock.
  @override
  Future<MemorySearchResult> search(String query, {String? childId}) async {
    final serverFamilyId = _serverFamilyId;
    final text = query.trim();
    if (serverFamilyId == null || text.length < kValueSearchMinLength) {
      return super.search(query, childId: childId);
    }
    await ready();
    final recents = _memories.searchRecents();
    if (!recents.contains(text)) {
      _memories.saveSearchRecents([text, ...recents].take(5).toList());
    }
    final pregnancy =
        childId != null &&
        _children.child(childId)?['kind'] == ChildKind.pregnancy.name;
    final records = await _feed.search(
      serverFamilyId,
      text,
      childId: pregnancy ? null : childId,
    );
    final found = [
      for (final record in records)
        if (_mirrored(record) case final memory?)
          if (!pregnancy || record.pregnancyId == childId) memory,
    ];
    return MemorySearchResult(
      query: query,
      media: found.where((memory) => memory.mediaAssets.isNotEmpty).toList(),
      diaries: found
          .where((memory) => memory.kind == MemoryKind.diary)
          .toList(),
    );
  }

  /// MEM-16: ngày theo múi giờ gia đình do server tính khi không truyền ngày.
  @override
  Future<List<OnThisDayGroup>> onThisDay({DateTime? date}) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.onThisDay(date: date);
    }
    await ready();
    final record = await _feed.onThisDay(
      serverFamilyId,
      date: date == null ? null : _day.format(date),
    );
    return [
      for (final group in record?.groups ?? const <OnThisDayGroupRecord>[])
        if (DateTime.tryParse(group.date ?? '') case final day?)
          OnThisDayGroup(
            yearsAgo: group.yearsAgo,
            date: day,
            memories: [for (final record in group.memories) ?_mirrored(record)],
          ),
    ].where((group) => group.memories.isNotEmpty).map((group) {
      return group.copyWith(childId: group.memories.first.childIds.firstOrNull);
    }).toList();
  }

  /// RPT-01: ký ức/bình luận/người của server báo cáo lên server (ẩn với tôi
  /// do server lưu); nội dung chỉ có trên máy giữ cách cũ.
  @override
  Future<ReportReceipt> submitReport({
    required String targetId,
    ReportTarget target = ReportTarget.memory,
    required String reasonCode,
    String? note,
    bool hideForMe = false,
    bool removeFromFamily = false,
  }) async {
    final serverFamilyId = _serverFamilyId;
    final serverTarget = switch (target) {
      ReportTarget.memory when _isServerMemory(targetId) => targetId,
      ReportTarget.comment => targetId,
      ReportTarget.member => _family.member(targetId)?['userId'] as String?,
      _ => null,
    };
    if (serverFamilyId == null || serverTarget == null) {
      return super.submitReport(
        targetId: targetId,
        target: target,
        reasonCode: reasonCode,
        note: note,
        hideForMe: hideForMe,
        removeFromFamily: removeFromFamily,
      );
    }
    final record = await _feed.report({
      'familyId': serverFamilyId,
      'targetType': switch (target) {
        ReportTarget.memory => 'MEMORY',
        ReportTarget.comment => 'COMMENT',
        ReportTarget.member => 'USER',
      },
      'targetId': serverTarget,
      'reason': reasonCode.toUpperCase(),
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      'hideForMe': hideForMe && target != ReportTarget.member,
    });
    if (hideForMe && target == ReportTarget.memory) {
      _memories.removeMemory(targetId);
    }
    return ReportReceipt(
      code: record?.code ?? '',
      createdAt: (record?.createdAt ?? now).toLocal(),
    );
  }

  /// Ghi một ký ức server vào kho rồi đọc lại dạng [Memory].
  Memory? _mirrored(MemoryRecord record) {
    final id = record.id;
    if (id == null) {
      return null;
    }
    _mirror(record);
    final row = _memories.memory(id);
    return row == null ? null : Memory.fromJson(row);
  }

  // ------------------------------------------------------------ MEM-25

  /// Đã xem trên máy này (server không theo dõi lượt xem story).
  final _seenStories = <String>{};

  /// Story hôm nay của từng bé đã chào đời (hoặc bé [childId]) từ server;
  /// mỗi ảnh/video là một trang. Lỗi mạng → không có story.
  @override
  Future<List<StoryItem>> stories({String? childId}) async {
    if (_serverFamilyId == null) {
      return super.stories(childId: childId);
    }
    await ready();
    final ids = childId != null
        ? [childId]
        : [
            for (final row in _children.children(familyId))
              if (row['kind'] == ChildKind.baby.name &&
                  row['archived'] != true &&
                  row[kValueChildKeyServerSubject] == true)
                row['id'] as String,
          ];
    final items = <StoryItem>[];
    for (final id in ids) {
      if (_children.child(id)?['kind'] == ChildKind.pregnancy.name) {
        continue;
      }
      final TodayStoryRecord? story;
      try {
        story = await _feed.todayStory(id);
      } on DioException catch (error) {
        Logger().w('Không đọc được story hôm nay: ${error.message}');
        continue;
      }
      final slides = story?.slides ?? const <TodayStorySlideRecord>[];
      for (var i = 0; i < slides.length; i++) {
        final slide = slides[i];
        final image = slide.imageUrl;
        final memoryId = slide.memoryId;
        if (image == null || memoryId == null) {
          continue;
        }
        final storyId = '$memoryId#$i';
        items.add(
          StoryItem(
            id: storyId,
            childId: id,
            asset: image,
            memoryId: memoryId,
            caption: slide.caption,
            authorId: _memories.memory(memoryId)?['authorId'] as String? ?? '',
            createdAt: (slide.occurredAt ?? now).toLocal(),
            seen: _seenStories.contains(storyId),
          ),
        );
      }
    }
    return items..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<void> markStorySeen(String storyId) async {
    if (_serverFamilyId == null || !storyId.contains('#')) {
      return super.markStorySeen(storyId);
    }
    _seenStories.add(storyId);
  }

  // ------------------------------------------------------------ MEM-07

  /// Lần đọc chi tiết gần nhất theo ký ức.
  final _detailSyncedAt = <String, DateTime>{};

  /// MEM-07: mở chi tiết đọc bản mới từ server (`GET /memories/:id`, tối đa
  /// mỗi [kValueRemoteFeedRefreshInterval] cho một ký ức) — bình luận/cảm xúc/
  /// ảnh mới không phải chờ bảng tin. Không còn xem được (404) → gỡ khỏi máy;
  /// lỗi mạng khác giữ bản đang có.
  @override
  Future<Memory?> refreshMemory(String id) async {
    final serverFamilyId = _serverFamilyId;
    final row = _memories.memory(id);
    final synced = _detailSyncedAt[id];
    if (serverFamilyId != null &&
        (row == null || row['remoteStatus'] != null) &&
        (synced == null ||
            now.difference(synced) >= kValueRemoteFeedRefreshInterval)) {
      _detailSyncedAt[id] = now;
      try {
        final record = await _feed.memory(id);
        if (record != null) {
          _mirror(record);
        }
      } on DioException catch (error) {
        if (error.response?.statusCode == 404 && row != null) {
          _memories.removeMemory(id);
        } else {
          Logger().w('Không đọc được ký ức: ${error.message}');
        }
      }
    }
    return memory(id);
  }

  // ------------------------------------------------------------ MEM-18

  /// Nháp trên máy trước, nháp đã lưu trên tài khoản (`GET /me/drafts`) sau;
  /// lỗi mạng chỉ hiện nháp trên máy.
  @override
  Future<List<MemoryDraftItem>> drafts() async {
    final local = await super.drafts();
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return local;
    }
    final List<MemoryRecord> records;
    try {
      records = await _feed.drafts(serverFamilyId);
    } on DioException catch (error) {
      Logger().w('Không đọc được nháp trên tài khoản: ${error.message}');
      return local;
    }
    _cloudDrafts = {for (final record in records) ?record.id};
    // Bản sao để trình soạn mở nháp ở chế độ sửa (ẩn khỏi danh sách ký ức).
    records.forEach(_mirror);
    return [
      ...local.where((draft) => draft.location == DraftLocation.device),
      for (final record in records)
        if (record.id != null) _draftOf(record),
    ];
  }

  /// Id nháp trên tài khoản của lần đọc gần nhất.
  Set<String> _cloudDrafts = const {};

  /// Nháp trên tài khoản: vào thùng rác rồi xoá hẳn (nháp không cần giữ).
  @override
  Future<void> deleteDraft(String draftId) async {
    if (!_cloudDrafts.contains(draftId)) {
      return super.deleteDraft(draftId);
    }
    await _feed.trashMemory(draftId);
    await _feed.purgeMemory(draftId);
    _cloudDrafts = {..._cloudDrafts}..remove(draftId);
    _memories.removeMemory(draftId);
  }

  /// Tuần của thẻ `WEEKLY_RECAP` mới nhất (dòng thời gian cả nhà).
  DateTime? _latestRecapWeek;

  static const _weeklyRecapKind = 'WEEKLY_RECAP';

  @override
  Future<DateTime?> latestRecapWeek() async =>
      _serverFamilyId == null ? super.latestRecapWeek() : _latestRecapWeek;

  @override
  Future<Memory?> publishDraft(String draftId) async {
    if (!_isServerMemory(draftId)) {
      return super.publishDraft(draftId);
    }
    final record = await _feed.publish(draftId);
    if (record == null) {
      return null;
    }
    _mirror(record);
    _cloudDrafts = {..._cloudDrafts}..remove(draftId);
    return memory(draftId);
  }

  MemoryDraftItem _draftOf(MemoryRecord record) {
    final urls = _urlsOf(record);
    return MemoryDraftItem(
      id: record.id!,
      kind: _appKinds[record.kind] ?? MemoryKind.photo,
      title: record.title ?? record.body ?? '',
      childIds: [...record.childIds, ?record.pregnancyId],
      updatedAt: (record.createdAt ?? now).toLocal(),
      location: DraftLocation.cloud,
      mediaAssets: urls.take(1).toList(),
      extraCount: urls.length > 1 ? urls.length - 1 : 0,
    );
  }

  /// Trang đầu tối đa mỗi [kValueRemoteFeedRefreshInterval]; đủ mọi trang + gỡ
  /// ký ức không còn trên server mỗi [kValueRemoteFeedFullSyncInterval] hoặc
  /// khi URL ảnh ký sắp hết hạn. Các lời gọi cùng lúc dùng chung một yêu cầu;
  /// lỗi mạng giữ dữ liệu đang có.
  Future<void> _sync() {
    final current = now;
    final fullSynced = _fullSyncedAt;
    final soonest = _soonestUrlExpiry(_mirroredRows());
    final full =
        fullSynced == null ||
        current.difference(fullSynced) >= kValueRemoteFeedFullSyncInterval ||
        (soonest != null &&
            soonest.isBefore(current.add(kValueSignedUrlRefreshMargin)));
    final synced = _syncedAt;
    if (!full &&
        synced != null &&
        current.difference(synced) < kValueRemoteFeedRefreshInterval) {
      return Future.value();
    }
    return _syncing ??= _pull(full: full).whenComplete(() {
      _syncing = null;
      _syncedAt = now;
    });
  }

  Future<void> _pull({required bool full}) async {
    _createdDuringSync.clear();
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return;
    }
    await ready();
    try {
      final localFamilyId = familyId;
      final records = <MemoryRecord>[];
      String? cursor;
      var complete = false;
      for (var page = 0; page < (full ? kValueRemoteFeedMaxPages : 1); page++) {
        final result = await _feed.feed(
          serverFamilyId,
          cursor: cursor,
          limit: kValueRemoteFeedPageSize,
        );
        // Đăng xuất / đổi gia đình trong lúc chờ: bỏ kết quả cũ.
        if (_serverFamilyId != serverFamilyId || familyId != localFamilyId) {
          return;
        }
        records.addAll(result.memories);
        final next = result.nextCursor;
        if (next == null || next == cursor) {
          complete = next == null;
          break;
        }
        cursor = next;
      }
      records.forEach(_mirror);
      if (full && complete) {
        _reconcile({...records.map((record) => record.id).nonNulls});
        _fullSyncedAt = now;
      }
    } on DioException catch (error) {
      Logger().w('Không đồng bộ được ký ức: ${error.message}');
    }
  }

  /// Sau khi tải đủ mọi trang: ký ức server không còn trong feed (đã xoá, bị
  /// ẩn, chuyển riêng tư) được gỡ khỏi kho trên máy. Ký ức chỉ có trên máy
  /// (không có `remoteStatus`) và ký ức vừa tạo trong lúc đồng bộ được giữ.
  void _reconcile(Set<String> serverIds) {
    final gone = _mirroredRows()
        .map((row) => row['id'] as String)
        .where(
          (id) => !serverIds.contains(id) && !_createdDuringSync.contains(id),
        )
        .toList();
    for (final id in gone) {
      _memories.removeMemory(id);
      _processingSince.remove(id);
    }
  }

  /// Ghi một ký ức của server vào kho trên máy; chỉ ghi khi có thay đổi (mỗi
  /// lần ghi làm mới giao diện) — URL đã ký chỉ thay khi chưa có hoặc sắp hết hạn.
  /// Ghi một ký ức server vào kho trên máy (lớp con dùng cho danh sách riêng
  /// như ảnh chờ duyệt).
  @protected
  void mirrorRecord(MemoryRecord record) => _mirror(record);

  /// Ưu tiên ảnh/video còn trong thư viện máy (BF-20261021-008); null = tắt.
  ILocalMediaService? localMedia;

  /// assetId → file trong thư viện máy đã khớp (cùng nội dung gốc).
  final _localPaths = <String, String>{};
  final _localTried = <String>{};
  final _localPending = <String, MemoryRecord>{};
  bool _resolvingLocal = false;

  /// Gom các asset có dấu vết file gốc để khớp với thư viện máy (chạy nền).
  void _queueLocal(MemoryRecord record) {
    final id = record.id;
    if (localMedia == null || id == null) {
      return;
    }
    final fresh = record.assets.any(
      (asset) =>
          asset.source?.sha256 != null &&
          asset.assetId != null &&
          !_localTried.contains(asset.assetId),
    );
    if (!fresh) {
      return;
    }
    _localPending[id] = record;
    if (!_resolvingLocal) {
      _resolvingLocal = true;
      unawaited(_resolveLocal());
    }
  }

  Future<void> _resolveLocal() async {
    try {
      while (_localPending.isNotEmpty) {
        final records = [..._localPending.values];
        _localPending.clear();
        final refs = [
          for (final record in records)
            for (final asset in record.assets)
              if ((asset.assetId, asset.source?.sha256, asset.source?.key)
                  case (final String id, final String sha, final String key)
                  when _localTried.add(id))
                RemoteMediaRef(
                  assetId: id,
                  sha256: sha,
                  key: key,
                  capturedAt: asset.source?.capturedAt,
                ),
        ];
        final found = await localMedia!.resolve(refs);
        if (found.isEmpty) {
          continue;
        }
        _localPaths.addAll(found);
        for (final record in records) {
          if (record.assets.any((a) => found.containsKey(a.assetId))) {
            _writeMedia(record);
          }
        }
      }
    } on Object catch (error) {
      Logger().w('Không khớp được ảnh trong máy: $error');
    } finally {
      _resolvingLocal = false;
    }
  }

  /// Ghi lại ảnh/video của một ký ức (sau khi tìm thấy bản trong máy).
  void _writeMedia(MemoryRecord record) {
    final id = record.id;
    if (id == null || _memories.memory(id) == null) {
      return;
    }
    _memories.updateMemory(id, {
      'mediaAssets': _urlsOf(record),
      'mediaVideos': _videoUrlsOf(record),
    });
  }

  void _mirror(MemoryRecord record) {
    final id = record.id;
    if (id == null) {
      return;
    }
    _queueLocal(record);
    _trackProcessing(id, record.status);
    final urls = _urlsOf(record);
    final ready = urls.isNotEmpty && urls.length == record.assets.length;
    final expiresAt = ready
        ? record.assets
              .map((asset) => asset.urlsExpireAt)
              .nonNulls
              .fold<DateTime?>(
                null,
                (soonest, at) =>
                    soonest == null || at.isBefore(soonest) ? at : soonest,
              )
        : null;
    final fields = _fieldsOf(record);
    final media = <String, dynamic>{
      'mediaAssets': urls,
      'mediaAssetIds': _assetIdsOf(record),
      'mediaVideos': _videoUrlsOf(record),
      'mediaUrlsExpireAt': expiresAt?.toIso8601String(),
    };
    final existing = _memories.memory(id);
    if (existing == null) {
      _memories.addMemory({
        'id': id,
        ...fields,
        ...media,
        ChildServiceImp.localKey: true,
      });
      return;
    }
    final current = DateTime.tryParse(
      existing['mediaUrlsExpireAt'] as String? ?? '',
    );
    // Bộ ảnh đổi (MEM-09) hoặc URL sắp hết hạn → ghi lại ảnh.
    final refreshMedia =
        ready &&
        (current == null ||
            current.isBefore(now.add(kValueSignedUrlRefreshMargin)) ||
            !_same(existing['mediaAssetIds'], media['mediaAssetIds']) ||
            existing['mediaVideos'] == null);
    final changed = fields.entries.any(
      (entry) => !_same(existing[entry.key], entry.value),
    );
    if (changed || refreshMedia) {
      _memories.updateMemory(id, {...fields, if (refreshMedia) ...media});
    }
  }

  /// Ảnh hiển thị của một asset: bản trong thư viện máy nếu có, không thì
  /// biến thể ảnh lớn nhất đã ký; video dùng ảnh poster của server (MEM-08
  /// phát bản local hoặc `v1080` từ [_videoUrlsOf]).
  String? _displayUrl(MediaAssetRecord asset) => asset.kind == 'VIDEO'
      ? asset.urls['poster'] ?? asset.urls['t320']
      : _localPaths[asset.assetId] ??
            asset.urls['m1080'] ??
            asset.urls['l2048'] ??
            asset.urls['t320'];

  /// Asset id cùng thứ tự với [_urlsOf] (MEM-09 đổi ảnh).
  List<String> _assetIdsOf(MemoryRecord record) => [
    for (final asset in record.assets)
      if (_displayUrl(asset) != null) ?asset.assetId,
  ];

  /// Ảnh hiển thị của một ký ức server (cùng thứ tự với [_videoUrlsOf]).
  List<String> _urlsOf(MemoryRecord record) =>
      [for (final asset in record.assets) _displayUrl(asset)].nonNulls.toList();

  /// URL phát video theo từng ảnh của [_urlsOf]; ảnh tĩnh → null.
  List<String?> _videoUrlsOf(MemoryRecord record) => [
    for (final asset in record.assets)
      if (_displayUrl(asset) != null)
        asset.kind == 'VIDEO'
            ? _localPaths[asset.assetId] ?? asset.urls['v1080']
            : null,
  ];

  /// Trường của ký ức server theo dạng kho trên máy (id người dùng của máy).
  JsonMap _fieldsOf(MemoryRecord record) => {
    'familyId': familyId,
    'kind': (_appKinds[record.kind] ?? MemoryKind.photo).name,
    'title': record.title,
    'body': record.body,
    'quoteContext': record.quoteContext,
    'childIds': [...record.childIds, ?record.pregnancyId],
    'authorId': _localUserId(record.authorUserId),
    'occurredAt': record.occurredAt?.toLocal().toIso8601String(),
    'createdAt': record.createdAt?.toLocal().toIso8601String(),
    'visibility': _appVisibility(record.visibility).name,
    'remoteStatus': record.status,
    'remoteVersion': record.version,
    'commentCount': record.commentCount,
    'commentsEnabled': record.commentsEnabled,
    'reactions': _emojiReactions(record.reactions),
    'myReaction': _emojiOf(record.myReaction),
    'pregnancyWeek': ?_pregnancyWeekOf(record),
    'feeling': record.feeling?.toLowerCase(),
    'people': [for (final person in record.people) person.displayName],
    'locationLabel': record.locationLabel,
    // VOICE: thời lượng server đo + URL nghe của asset audio.
    'voiceDurationSec': ?record.durationSec?.round(),
    'voiceUrl': ?_audioUrlOf(record),
  };

  static String? _audioUrlOf(MemoryRecord record) => record.assets
      .where((asset) => asset.kind == 'AUDIO')
      .map((asset) => asset.urls['a'])
      .nonNulls
      .firstOrNull;

  /// PREG-02/03: tuần thai lúc chụp, theo ngày dự sinh của thai kỳ trên máy.
  int? _pregnancyWeekOf(MemoryRecord record) {
    final pregnancyId = record.pregnancyId;
    final occurredAt = record.occurredAt;
    if (pregnancyId == null || occurredAt == null) {
      return null;
    }
    final due = DateTime.tryParse(
      _children.child(pregnancyId)?['dueDate'] as String? ?? '',
    );
    return due == null ? null : pregnancyWeek(due, occurredAt.toLocal()).week;
  }

  /// Loại cảm xúc server → emoji hiển thị ([kValueReactionTypes]).
  static String? _emojiOf(String? type) => type == null
      ? null
      : kValueReactionTypes.entries
            .where((entry) => entry.value == type)
            .firstOrNull
            ?.key;

  static Map<String, int> _emojiReactions(Map<String, int> byType) => {
    for (final entry in byType.entries) ?_emojiOf(entry.key): entry.value,
  };

  /// Id người dùng server → id trên máy: tôi, hoặc bạn đời (Parent còn lại).
  String? _localUserId(String? serverUserId) {
    if (serverUserId == null) {
      return null;
    }
    if (serverUserId ==
        sessionRepository.session()[kValueSessionKeyServerUserId]) {
      return myUserId;
    }
    final partner = _family
        .members(familyId)
        .where(
          (member) =>
              member['userId'] != myUserId &&
              member['role'] != FamilyRole.relative.name,
        )
        .firstOrNull?['userId'];
    return partner as String? ?? serverUserId;
  }

  static bool _same(Object? a, Object? b) => jsonEncode(a) == jsonEncode(b);
}
