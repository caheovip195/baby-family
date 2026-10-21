import 'dart:convert';

import 'package:baby_family/data/dto/couple_today.dart';
import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:baby_family/data/model/us/checkin_record.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/data/model/us/couple_settings.dart';
import 'package:baby_family/data/model/us/journal_entry.dart';
import 'package:baby_family/data/model/us/journal_entry_record.dart';
import 'package:baby_family/data/model/us/mood_checkin.dart';
import 'package:baby_family/data/model/us/request_record.dart';
import 'package:baby_family/data/model/us/thanks.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/care.dart';
import 'package:baby_family/data/repository/couple_remote.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository/us.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/us.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Papa & Mama qua server thật (US-01 hôm nay, US-02 check-in, US-03/04 lời
/// nhờ — BF-20261018-005). Kết quả server được phản chiếu vào kho trên máy
/// (id của server) để các màn đang đọc kho vẫn chạy; bạn đời chỉ có các trường
/// đã chia sẻ. Cảm ơn, câu hỏi, nhật ký riêng, Cầu nối… chưa có API nên vẫn
/// chỉ lưu trên máy.
class UsRemoteServiceImp extends UsServiceImp {
  UsRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._store,
    this._family,
    ICareRepository careRepository,
    this._remote, {
    this.uploader,
  }) : super(sessionRepository, clock, _store, _family, careRepository);

  final IUsRepository _store;
  final IFamilyRepository _family;
  final ICoupleRemoteRepository _remote;

  /// Tải ảnh nhật ký riêng (US-07, mục đích JOURNAL — chỉ người viết xem).
  final MediaUploader? uploader;

  static const _uuid = Uuid();

  /// Mood của app ↔ mã server (catalog `couple-policy.ts`).
  static const _moods = {
    MoodCode.ok: 'GOOD',
    MoodCode.normal: 'OKAY',
    MoodCode.tired: 'TIRED',
    MoodCode.exhausted: 'EXHAUSTED',
    MoodCode.stressed: 'STRESSED',
    MoodCode.sad: 'SAD',
    MoodCode.annoyed: 'UPSET',
    MoodCode.overwhelmed: 'OVERWHELMED',
    MoodCode.lonely: 'LONELY',
    MoodCode.missYou: 'NEED_AFFECTION',
  };

  static const _needs = {
    CoupleNeed.rest: 'BREAK',
    CoupleNeed.childcare: 'HELP_CHILD',
    CoupleNeed.quiet: 'QUIET',
    CoupleNeed.hug: 'HUG',
    CoupleNeed.talk: 'TALK',
    CoupleNeed.encouragement: 'REASSURANCE',
  };

  /// Cảm xúc của trang nhật ký (app) ↔ mood server.
  static const _journalMoods = {
    JournalMood.tired: 'TIRED',
    JournalMood.grateful: 'GOOD',
    JournalMood.worried: 'STRESSED',
    JournalMood.calm: 'OKAY',
  };

  /// Lời nhờ có thời lượng chỉ nhận 15/30/60 phút (tài liệu kỹ thuật 15.8).
  static const _durations = {15, 30, 60};

  /// Phần chia sẻ mặc định khi chọn “Chia sẻ với bạn đời”: ghi chú không chia
  /// sẻ trừ khi người dùng chọn (đặc tả 7.16.1 mục 6).
  static const _sharedFields = ['mood', 'energy', 'needs'];

  DateTime? _syncedAt;
  DateTime? _thanksSyncedAt;
  DateTime? _journalSyncedAt;
  Future<void>? _syncing;

  /// Idempotency-Key theo nội dung lời nhờ đang gửi dở (giữ khi bấm gửi lại).
  final _pendingKeys = <String, String>{};

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  String? get _partnerLocalId => _family
      .members(familyId)
      .where(
        (row) =>
            row['role'] != FamilyRole.relative.name &&
            row['userId'] != myUserId &&
            row['status'] == MemberStatus.active.name,
      )
      .map((row) => row['userId'] as String?)
      .firstOrNull;

  /// Id người dùng server → id trên máy (tôi hoặc bạn đời).
  String _localUserId(String? serverUserId) =>
      serverUserId != null &&
          serverUserId ==
              sessionRepository.session()[kValueSessionKeyServerUserId]
      ? myUserId
      : _partnerLocalId ?? serverUserId ?? '';

  @override
  Future<CoupleToday> coupleToday() async {
    await _sync();
    final today = await super.coupleToday();
    // Câu hỏi kết nối hằng ngày là bản 1.1 (chưa có API): bản server không
    // hiện câu hỏi mẫu cho gia đình thật.
    if (_serverFamilyId == null) {
      return today;
    }
    return CoupleToday(
      myCheckin: today.myCheckin,
      partnerCheckin: today.partnerCheckin,
      openRequests: today.openRequests,
      recentThanks: today.recentThanks,
    );
  }

  @override
  Future<List<CoupleRequest>> requests({bool openOnly = false}) async {
    await _sync();
    return super.requests(openOnly: openOnly);
  }

  @override
  Future<MoodCheckin> checkIn({
    required MoodCode mood,
    int energy = 3,
    List<CoupleNeed> needs = const [],
    String? note,
    bool shared = true,
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.checkIn(
        mood: mood,
        energy: energy,
        needs: needs,
        note: note,
        shared: shared,
      );
    }
    await ready();
    final record = await _remote.createCheckin(serverFamilyId, {
      'mood': _moods[mood],
      'energy': energy,
      'needs': [for (final need in needs) ?_needs[need]],
      'note': ?note,
      'share': {
        'enabled': shared,
        'fields': shared ? _sharedFields : const <String>[],
      },
    });
    if (record?.id == null) {
      throw StateError('Check-in was not created');
    }
    return MoodCheckin.fromJson(_mirrorCheckin(record!, myUserId)!);
  }

  @override
  Future<CoupleRequest> sendRequest({
    RequestKind kind = RequestKind.task,
    String? templateCode,
    CoupleNeed? needCode,
    String title = '',
    String? message,
    List<String> childIds = const [],
    String? dueLabel,
    DateTime? dueAt,
    int? durationMin,
    RequestUrgency urgency = RequestUrgency.normal,
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.sendRequest(
        kind: kind,
        templateCode: templateCode,
        needCode: needCode,
        title: title,
        message: message,
        childIds: childIds,
        dueLabel: dueLabel,
        dueAt: dueAt,
        durationMin: durationMin,
        urgency: urgency,
      );
    }
    await ready();
    final task = kind == RequestKind.task;
    final due = task ? _due(dueLabel, dueAt) : null;
    final body = <String, dynamic>{
      'kind': task ? 'TASK' : 'NEED',
      if (title.trim().isNotEmpty) 'title': title.trim(),
      if (!task) 'needCode': ?_needs[needCode],
      if (task && _durations.contains(durationMin)) 'durationMin': durationMin,
      if (task && childIds.isNotEmpty) 'childIds': childIds,
      if (due != null) 'dueKind': due.kind,
      if (due?.at != null) 'dueAt': due!.at!.toUtc().toIso8601String(),
      'urgency': urgency == RequestUrgency.soon ? 'SOON' : 'NORMAL',
      'message': ?message,
    };
    final fingerprint = jsonEncode(body);
    final created = await _remote.createRequest(
      serverFamilyId,
      _pendingKeys[fingerprint] ??= _uuid.v4(),
      body,
    );
    _pendingKeys.remove(fingerprint);
    final record = created?.request;
    if (record?.id == null) {
      throw StateError('Request was not created');
    }
    return CoupleRequest.fromJson(_mirrorRequest(record!));
  }

  /// Hạn của app (`now` | `tonight` | `at` + giờ chọn) → `dueKind` server.
  ({String kind, DateTime? at}) _due(String? label, DateTime? at) {
    if (label == 'tonight') {
      return (kind: 'TONIGHT', at: null);
    }
    if (label != 'at' || at == null || !at.isAfter(now)) {
      return (kind: 'NOW', at: null);
    }
    final sameDay =
        at.year == now.year && at.month == now.month && at.day == now.day;
    return (kind: sameDay ? 'TODAY_AT' : 'TOMORROW', at: at);
  }

  @override
  Future<void> markSeen(String id) async {
    final current = _store.request(id);
    // Chỉ người nhận đánh dấu đã xem, một lần (SENT → SEEN).
    if (current?['receiverId'] != myUserId ||
        current?['status'] != RequestStatus.sent.name) {
      return;
    }
    await _act(id, 'seen', () => super.markSeen(id));
  }

  @override
  Future<void> accept(String id) => _act(id, 'accept', () => super.accept(id));

  @override
  Future<void> decline(String id, {String? reason}) => _act(
    id,
    'decline',
    () => super.decline(id, reason: reason),
    {'reasonCode': ?reason},
  );

  /// Server ghi +5 Hearts cho người làm (BR-068) — app không cộng thêm.
  @override
  Future<void> markDone(String id) =>
      _act(id, 'done', () => super.markDone(id));

  @override
  Future<void> acknowledge(String id) =>
      _act(id, 'acknowledge', () => super.acknowledge(id), {'type': 'SEEN'});

  @override
  Future<void> cancel(String id) => _act(id, 'cancel', () => super.cancel(id));

  @override
  Future<void> setReminder(String id, DateTime at) => _act(
    id,
    'remind-me',
    () => super.setReminder(id, at),
    {'at': at.toUtc().toIso8601String()},
  );

  /// Lời nhờ của server → chuyển trạng thái qua API rồi phản chiếu kết quả;
  /// lời nhờ chỉ có trên máy (bản mẫu) giữ luồng cũ.
  Future<void> _act(
    String id,
    String action,
    Future<void> Function() local, [
    JsonMap body = const {},
  ]) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null || _store.request(id)?['remote'] != true) {
      return local();
    }
    await ready();
    final record = await _remote.requestAction(
      serverFamilyId,
      id,
      action,
      body,
    );
    if (record != null) {
      _mirrorRequest(record);
    }
  }

  // ------------------------------------------------ US-05/06 cảm ơn

  @override
  Future<Thanks> sendThanks({
    required String body,
    String? sticker,
    String? missionId,
    String? memoryId,
    bool proposeFamilyMoment = false,
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.sendThanks(
        body: body,
        sticker: sticker,
        missionId: missionId,
        memoryId: memoryId,
        proposeFamilyMoment: proposeFamilyMoment,
      );
    }
    await ready();
    final record = await _remote.createAppreciation(serverFamilyId, {
      'body': body.trim(),
      'sticker': ?sticker,
      if (missionId != null) ...{
        'linkedType': 'MISSION',
        'linkedId': missionId,
      },
      if (missionId == null && memoryId != null) ...{
        'linkedType': 'MEMORY',
        'linkedId': memoryId,
      },
    });
    if (record?.id == null) {
      throw StateError('Thanks was not sent');
    }
    if (proposeFamilyMoment) {
      await _remote.requestAppreciationShare(serverFamilyId, record!.id!);
    }
    return Thanks.fromJson(_mirrorThanks(record!));
  }

  @override
  Future<List<Thanks>> thanks() async {
    await _syncThanks();
    return super.thanks();
  }

  @override
  Future<List<Thanks>> thanksWall({DateTime? month}) async {
    await _syncThanks();
    return super.thanksWall(month: month);
  }

  /// Chỉ người nhận thả 💛 lên lời cảm ơn (server lưu một cảm xúc); bỏ tim
  /// chưa có API nên lời cảm ơn của server giữ nguyên khi chạm lại.
  /// Duyệt tạo ký ức PARENTS/MOMENT trên server; lời cảm ơn cập nhật ngay.
  @override
  Future<void> respondThanksShare(
    String thanksId, {
    required bool approve,
  }) async {
    final serverFamilyId = _serverFamilyId;
    final remote = _store
        .thanks(familyId)
        .any((row) => row['id'] == thanksId && row['remote'] == true);
    if (serverFamilyId == null || !remote) {
      return super.respondThanksShare(thanksId, approve: approve);
    }
    await _remote.respondAppreciationShare(
      serverFamilyId,
      thanksId,
      approve: approve,
    );
    _store.updateThanks(thanksId, {
      'shareRequested': false,
      'postedToFamily': approve,
    });
  }

  @override
  Future<void> toggleThanksHeart(String thanksId) async {
    final serverFamilyId = _serverFamilyId;
    final row = _store
        .thanks(familyId)
        .where((item) => item['id'] == thanksId)
        .firstOrNull;
    if (serverFamilyId == null || row?['remote'] != true) {
      return super.toggleThanksHeart(thanksId);
    }
    final reacted = (row!['reactedByUserIds'] as List?) ?? const [];
    if (row['toUserId'] != myUserId || reacted.contains(myUserId)) {
      return;
    }
    final record = await _remote.reactAppreciation(
      serverFamilyId,
      thanksId,
      kValueHeartReaction,
    );
    if (record != null) {
      _mirrorThanks(record);
    }
  }

  /// Bức tường hai chiều của server (đủ trang) tối đa mỗi
  /// [kValueRemoteFeedRefreshInterval].
  Future<void> _syncThanks() async {
    final serverFamilyId = _serverFamilyId;
    final synced = _thanksSyncedAt;
    if (serverFamilyId == null ||
        (synced != null &&
            now.difference(synced) < kValueRemoteFeedRefreshInterval)) {
      return;
    }
    await ready();
    try {
      String? cursor;
      for (var page = 0; page < kValueRemoteFeedMaxPages; page++) {
        final wall = await _remote.appreciations(
          serverFamilyId,
          cursor: cursor,
          limit: kValueRemoteFeedPageSize,
        );
        wall?.items.forEach(_mirrorThanks);
        final next = wall?.nextCursor;
        if (next == null || next == cursor) {
          break;
        }
        cursor = next;
      }
      _thanksSyncedAt = now;
    } on DioException catch (error) {
      Logger().w('Không đồng bộ được lời cảm ơn: ${error.message}');
    }
  }

  JsonMap _mirrorThanks(AppreciationRecord record) {
    final id = record.id!;
    final to = _localUserId(record.toUserId);
    final row = <String, dynamic>{
      'familyId': familyId,
      'fromUserId': _localUserId(record.fromUserId),
      'toUserId': to,
      'body': record.body ?? '',
      'sticker': record.sticker,
      'missionId': record.linkedType == 'MISSION' ? record.linkedId : null,
      'memoryId': record.linkedType == 'MEMORY' ? record.linkedId : null,
      'createdAt': (record.createdAt ?? now).toLocal().toIso8601String(),
      'postedToFamily': record.familyShareStatus == 'APPROVED',
      'shareRequested': record.familyShareStatus == 'REQUESTED',
      // Server giữ một cảm xúc của người nhận.
      'reactedByUserIds': [if (record.reaction != null) to],
      'remote': true,
    };
    final existing = _store
        .thanks(familyId)
        .where((item) => item['id'] == id)
        .firstOrNull;
    if (existing == null) {
      return _store.addThanks({'id': id, ...row});
    }
    if (row.entries.any(
      (entry) => jsonEncode(existing[entry.key]) != jsonEncode(entry.value),
    )) {
      _store.updateThanks(id, row);
    }
    return {...existing, ...row};
  }

  // ------------------------------------------------ US-07 nhật ký riêng

  @override
  Future<List<JournalEntry>> journal() async {
    final serverFamilyId = _serverFamilyId;
    final synced = _journalSyncedAt;
    if (serverFamilyId != null &&
        (synced == null ||
            now.difference(synced) >= kValueRemoteFeedRefreshInterval)) {
      await ready();
      try {
        String? cursor;
        for (var page = 0; page < kValueRemoteFeedMaxPages; page++) {
          final list = await _remote.journal(
            serverFamilyId,
            cursor: cursor,
            limit: kValueRemoteFeedPageSize,
          );
          list?.items.forEach(_mirrorJournal);
          final next = list?.nextCursor;
          if (next == null || next == cursor) {
            break;
          }
          cursor = next;
        }
        _journalSyncedAt = now;
      } on DioException catch (error) {
        Logger().w('Không đồng bộ được nhật ký riêng: ${error.message}');
      }
    }
    return super.journal();
  }

  /// Ảnh của trang nhật ký chưa tải lên server (cần upload `JOURNAL` riêng tư)
  /// — chỉ giữ trên máy này.
  @override
  Future<JournalEntry> addJournalEntry({
    required JournalMood mood,
    required String title,
    String body = '',
    String? photoAsset,
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.addJournalEntry(
        mood: mood,
        title: title,
        body: body,
        photoAsset: photoAsset,
      );
    }
    await ready();
    final text = body.trim().isEmpty ? title.trim() : body.trim();
    final uploader = this.uploader;
    final assetIds = [
      if (photoAsset != null &&
          !photoAsset.startsWith('assets/') &&
          uploader != null)
        await uploader.uploadImage(
          serverFamilyId,
          photoAsset,
          purpose: 'JOURNAL',
        ),
    ];
    final record = await _remote.createJournalEntry(serverFamilyId, {
      if (title.trim().isNotEmpty) 'title': title.trim(),
      'body': text,
      'mood': _journalMoods[mood],
      if (assetIds.isNotEmpty) 'assetIds': assetIds,
    });
    if (record?.id == null) {
      throw StateError('Journal entry was not saved');
    }
    return JournalEntry.fromJson(
      _mirrorJournal(record!, photoAsset: photoAsset),
    );
  }

  /// Gửi đúng nội dung trang (bản xem trước ở US-07) làm đoạn chia sẻ.
  @override
  Future<void> shareJournalExcerpt(String entryId) async {
    final serverFamilyId = _serverFamilyId;
    final row = _store
        .journal(myUserId)
        .where((item) => item['id'] == entryId)
        .firstOrNull;
    if (serverFamilyId == null || row?['remote'] != true) {
      return super.shareJournalExcerpt(entryId);
    }
    await ready();
    final body = (row!['body'] as String?)?.trim() ?? '';
    await _remote.shareJournalExcerpt(
      serverFamilyId,
      entryId,
      body.isEmpty ? (row['title'] as String? ?? '') : body,
    );
    _store.updateJournal(entryId, {'sharedExcerpt': true});
  }

  JsonMap _mirrorJournal(JournalEntryRecord record, {String? photoAsset}) {
    final id = record.id!;
    final row = <String, dynamic>{
      'familyId': familyId,
      'userId': myUserId,
      'createdAt': (record.createdAt ?? now).toLocal().toIso8601String(),
      'showTime': true,
      'mood':
          _journalMoods.entries
              .where((entry) => entry.value == record.mood)
              .firstOrNull
              ?.key
              .name ??
          JournalMood.calm.name,
      'title': record.title ?? '',
      'body': record.body ?? '',
      'photoAsset': ?photoAsset,
      'remote': true,
    };
    final existing = _store
        .journal(myUserId)
        .where((item) => item['id'] == id)
        .firstOrNull;
    if (existing == null) {
      return _store.addJournal({'id': id, ...row});
    }
    final changed = {
      for (final entry in row.entries)
        if (jsonEncode(existing[entry.key]) != jsonEncode(entry.value))
          entry.key: entry.value,
    };
    if (changed.isNotEmpty) {
      _store.updateJournal(id, changed);
    }
    return {...existing, ...row};
  }

  /// Đọc lại check-in hôm nay và lời nhờ tối đa mỗi
  /// [kValueRemoteFeedRefreshInterval]; lời gọi cùng lúc dùng chung yêu cầu,
  /// lỗi mạng giữ dữ liệu đang có.
  Future<void> _sync() {
    final serverFamilyId = _serverFamilyId;
    final synced = _syncedAt;
    if (serverFamilyId == null ||
        (synced != null &&
            now.difference(synced) < kValueRemoteFeedRefreshInterval)) {
      return Future.value();
    }
    return _syncing ??= _pull(serverFamilyId).whenComplete(() {
      _syncing = null;
      _syncedAt = now;
    });
  }

  Future<void> _pull(String serverFamilyId) async {
    await ready();
    try {
      final localFamilyId = familyId;
      final (today, page) = await (
        _remote.checkinsToday(serverFamilyId),
        _remote.requests(serverFamilyId, limit: kValueRemoteFeedPageSize),
      ).wait;
      if (_serverFamilyId != serverFamilyId || familyId != localFamilyId) {
        return;
      }
      final partner = _partnerLocalId;
      final mine = today?.mine;
      if (mine != null) {
        _mirrorCheckin(mine, myUserId);
      }
      // Bạn đời đã thôi chia sẻ / hết hiệu lực / xoá lịch sử → gỡ bản sao.
      final partnerId = today?.partner?.id;
      for (final row in _store.checkins(familyId)) {
        if (row['remote'] == true &&
            row['userId'] == partner &&
            row['id'] != partnerId) {
          _store.removeCheckin(row['id'] as String);
        }
      }
      final shared = today?.partner;
      if (shared != null && partner != null) {
        _mirrorCheckin(shared, partner);
      }
      page?.items.forEach(_mirrorRequest);
    } on DioException catch (error) {
      Logger().w('Không đồng bộ được Papa & Mama: ${error.message}');
    }
  }

  /// Check-in server → hàng trong kho; bản của bạn đời không có mood (không
  /// chia sẻ) thì không hiện (thẻ US-01 cần cảm xúc).
  JsonMap? _mirrorCheckin(CheckinRecord record, String userId) {
    final id = record.id;
    final mood = _moods.entries
        .where((entry) => entry.value == record.mood)
        .firstOrNull
        ?.key;
    if (id == null || mood == null) {
      return null;
    }
    final row = <String, dynamic>{
      'id': id,
      'familyId': familyId,
      'userId': userId,
      'mood': mood.name,
      'energy': record.energy ?? 3,
      'needs': [
        for (final code in record.needs)
          ?_needs.entries
              .where((entry) => entry.value == code)
              .firstOrNull
              ?.key
              .name,
      ],
      'note': ?record.note,
      'shared': record.shared ?? userId != myUserId,
      'createdAt': (record.createdAt ?? now).toLocal().toIso8601String(),
      'expiresAt': record.expiresAt?.toLocal().toIso8601String(),
      'remote': true,
    };
    final existing = _store
        .checkins(familyId)
        .where((candidate) => candidate['id'] == id)
        .firstOrNull;
    return existing ?? _store.addCheckin(row);
  }

  /// Lời nhờ server → hàng trong kho (thêm mới hoặc cập nhật khi đổi).
  JsonMap _mirrorRequest(RequestRecord record) {
    final status =
        RequestStatus.values
            .where((value) => value.name == record.status?.toLowerCase())
            .firstOrNull ??
        RequestStatus.sent;
    final respondedAt = record.respondedAt?.toLocal().toIso8601String();
    final row = <String, dynamic>{
      'familyId': familyId,
      'kind': record.kind == 'NEED'
          ? RequestKind.need.name
          : RequestKind.task.name,
      'needCode': _needs.entries
          .where((entry) => entry.value == record.needCode)
          .firstOrNull
          ?.key
          .name,
      'title': record.title ?? '',
      'message': record.message,
      'childIds': record.childIds,
      'dueAt': (record.dueAt ?? record.createdAt ?? now)
          .toLocal()
          .toIso8601String(),
      'durationMin': record.durationMin,
      'urgency': record.urgency == 'SOON'
          ? RequestUrgency.soon.name
          : RequestUrgency.normal.name,
      'status': status.name,
      'senderId': _localUserId(record.senderUserId),
      'receiverId': _localUserId(record.receiverUserId),
      'volunteered': record.volunteered,
      'declineReason': record.declineReason,
      'sentAt': (record.createdAt ?? now).toLocal().toIso8601String(),
      'seenAt': record.seenAt?.toLocal().toIso8601String(),
      'acceptedAt':
          status == RequestStatus.accepted || status == RequestStatus.done
          ? respondedAt
          : null,
      'declinedAt': status == RequestStatus.declined ? respondedAt : null,
      'doneAt': record.doneAt?.toLocal().toIso8601String(),
      'remindAt': record.reminderAt?.toLocal().toIso8601String(),
      'remote': true,
    };
    final id = record.id!;
    final existing = _store.request(id);
    if (existing == null) {
      return _store.addRequest({'id': id, ...row});
    }
    if (row.entries.any(
      (entry) => jsonEncode(existing[entry.key]) != jsonEncode(entry.value),
    )) {
      _store.updateRequest(id, row);
    }
    return {...existing, ...row};
  }

  // ------------------------------------------------------------ US-15

  /// US-15 qua server: chia sẻ cảm xúc mặc định, ẩn nội dung trên màn khoá,
  /// khoá Face ID, lời nhờ gấp vượt giờ yên tĩnh — chỉ của chính tôi. Giờ yên
  /// tĩnh, lưu Cầu nối, khoá nhật ký vẫn trên máy.
  @override
  Future<CoupleSettings> coupleSettings() async {
    final local = await super.coupleSettings();
    if (_serverFamilyId == null) {
      return local;
    }
    final record = await _remote.usSettings();
    if (record == null) {
      return local;
    }
    return local.copyWith(
      checkinShareMode: switch (record.moodShareDefault) {
        'ALWAYS' => CheckinShareMode.alwaysShare,
        'NEVER' => CheckinShareMode.alwaysPrivate,
        'ASK' => CheckinShareMode.askEachTime,
        _ => local.checkinShareMode,
      },
      hideOnLockScreen: record.hideSensitivePreview ?? local.hideOnLockScreen,
      faceIdLock: record.usLockEnabled ?? local.faceIdLock,
      urgentBypassQuiet:
          record.requestSoonBypassQuiet ?? local.urgentBypassQuiet,
    );
  }

  @override
  Future<void> saveCoupleSettings(CoupleSettings settings) async {
    if (_serverFamilyId != null) {
      final before = await coupleSettings();
      final patch = <String, dynamic>{
        if (settings.checkinShareMode != before.checkinShareMode)
          'moodShareDefault': switch (settings.checkinShareMode) {
            CheckinShareMode.alwaysShare => 'ALWAYS',
            CheckinShareMode.alwaysPrivate => 'NEVER',
            CheckinShareMode.askEachTime => 'ASK',
          },
        if (settings.hideOnLockScreen != before.hideOnLockScreen)
          'hideSensitivePreview': settings.hideOnLockScreen,
        if (settings.faceIdLock != before.faceIdLock)
          'usLockEnabled': settings.faceIdLock,
        if (settings.urgentBypassQuiet != before.urgentBypassQuiet)
          'requestSoonBypassQuiet': settings.urgentBypassQuiet,
      };
      if (patch.isNotEmpty) {
        await _remote.updateUsSettings(patch);
      }
    }
    await super.saveCoupleSettings(settings);
  }
}
