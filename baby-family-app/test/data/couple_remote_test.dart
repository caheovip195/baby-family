import 'dart:typed_data';

import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/memory/upload_status.dart';
import 'package:baby_family/data/model/us/appreciation_record.dart';
import 'package:baby_family/data/model/us/appreciation_wall.dart';
import 'package:baby_family/data/model/us/checkin_record.dart';
import 'package:baby_family/data/model/us/checkin_today.dart';
import 'package:baby_family/data/model/us/journal_entry_record.dart';
import 'package:baby_family/data/model/us/journal_list.dart';
import 'package:baby_family/data/model/us/request_created.dart';
import 'package:baby_family/data/model/us/request_list.dart';
import 'package:baby_family/data/model/us/request_record.dart';
import 'package:baby_family/data/model/us/us_settings_record.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/couple_remote.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/us_remote.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// Kho media giả: ghi lại mục đích của ảnh tải lên.
class _FakeMedia extends Fake implements IMediaRepository {
  final purposes = <String>[];

  @override
  Future<Uint8List> readLocalFile(String path) async =>
      Uint8List.fromList(path.codeUnits);

  @override
  Future<UploadIntent?> createUploadIntent(
    String idempotencyKey,
    JsonMap body,
  ) async {
    purposes.add(body['purpose'] as String);
    return UploadIntent(
      assetId: 'asset-${purposes.length}',
      status: 'PENDING_UPLOAD',
      upload: const UploadInstruction(mode: 'single', url: 'https://s3/put'),
    );
  }

  @override
  Future<List<JsonMap>> uploadBytes(
    UploadInstruction instruction,
    Uint8List bytes,
  ) async => const [];

  @override
  Future<UploadStatus?> completeUpload(
    String assetId, {
    List<JsonMap> parts = const [],
  }) async => const UploadStatus();
}

/// API Papa & Mama giả (BF-20261018-005).
class _FakeCouple implements ICoupleRemoteRepository {
  final checkins = <JsonMap>[];
  final requestBodies = <JsonMap>[];
  final keys = <String>[];
  final actions = <String>[];
  CheckinToday today = const CheckinToday();
  List<RequestRecord> page = const [];
  bool failNext = false;

  @override
  Future<CheckinRecord?> createCheckin(String familyId, JsonMap body) async {
    checkins.add(body);
    return CheckinRecord(
      id: 'srv-checkin-${checkins.length}',
      mood: body['mood'] as String?,
      energy: body['energy'] as int?,
      needs: [...(body['needs'] as List).cast<String>()],
      shared: (body['share'] as Map)['enabled'] as bool,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 6)),
    );
  }

  @override
  Future<CheckinToday?> checkinsToday(String familyId) async => today;

  @override
  Future<RequestCreated?> createRequest(
    String familyId,
    String idempotencyKey,
    JsonMap body,
  ) async {
    keys.add(idempotencyKey);
    if (failNext) {
      failNext = false;
      throw DioException(requestOptions: RequestOptions(path: '/requests'));
    }
    requestBodies.add(body);
    return RequestCreated(
      request: RequestRecord(
        id: 'srv-request',
        senderUserId: 'srv-me',
        receiverUserId: 'srv-partner',
        kind: body['kind'] as String?,
        title: body['title'] as String?,
        status: 'SENT',
        urgency: body['urgency'] as String?,
        createdAt: DateTime.now(),
      ),
      openCount: 1,
      openLimit: 5,
    );
  }

  @override
  Future<RequestList?> requests(
    String familyId, {
    String? box,
    String? cursor,
    int? limit,
  }) async => RequestList(items: page);

  final appreciationBodies = <JsonMap>[];
  final reactions = <String>[];
  final journalBodies = <JsonMap>[];
  final shares = <String>[];
  List<AppreciationRecord> wall = const [];
  List<JournalEntryRecord> entries = const [];

  @override
  Future<AppreciationRecord?> createAppreciation(
    String familyId,
    JsonMap body,
  ) async {
    appreciationBodies.add(body);
    return AppreciationRecord(
      id: 'srv-thanks-${appreciationBodies.length}',
      fromUserId: 'srv-me',
      toUserId: 'srv-partner',
      body: body['body'] as String? ?? 'Cảm ơn bạn đời nhiều lắm! 💛',
      linkedType: body['linkedType'] as String?,
      linkedId: body['linkedId'] as String?,
      familyShareStatus: 'PRIVATE',
      createdAt: DateTime.now(),
      isMine: true,
    );
  }

  @override
  Future<AppreciationWall?> appreciations(
    String familyId, {
    String? cursor,
    int? limit,
    String? month,
  }) async => AppreciationWall(items: wall);

  @override
  Future<AppreciationRecord?> reactAppreciation(
    String familyId,
    String appreciationId,
    String reaction,
  ) async {
    reactions.add('$appreciationId:$reaction');
    return wall
        .firstWhere((item) => item.id == appreciationId)
        .copyWith(reaction: reaction);
  }

  @override
  Future<JournalList?> journal(
    String familyId, {
    String? cursor,
    int? limit,
  }) async => JournalList(items: entries);

  final shareRequests = <String>[];
  final usPatches = <JsonMap>[];
  UsSettingsRecord usRecord = const UsSettingsRecord(
    usLockEnabled: true,
    moodShareDefault: 'NEVER',
    requestSoonBypassQuiet: false,
    hideSensitivePreview: true,
  );

  @override
  Future<UsSettingsRecord?> usSettings() async => usRecord;

  @override
  Future<UsSettingsRecord?> updateUsSettings(JsonMap patch) async {
    usPatches.add(patch);
    return usRecord;
  }

  @override
  Future<void> requestAppreciationShare(
    String familyId,
    String appreciationId,
  ) async => shareRequests.add(appreciationId);

  final shareResponses = <String>[];

  @override
  Future<void> respondAppreciationShare(
    String familyId,
    String appreciationId, {
    required bool approve,
  }) async => shareResponses.add('$appreciationId:$approve');

  @override
  Future<JournalEntryRecord?> createJournalEntry(
    String familyId,
    JsonMap body,
  ) async {
    journalBodies.add(body);
    return JournalEntryRecord(
      id: 'srv-journal-${journalBodies.length}',
      title: body['title'] as String?,
      body: body['body'] as String?,
      mood: body['mood'] as String?,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> shareJournalExcerpt(
    String familyId,
    String entryId,
    String excerpt,
  ) async => shares.add('$entryId:$excerpt');

  @override
  Future<RequestRecord?> requestAction(
    String familyId,
    String requestId,
    String action, [
    JsonMap body = const {},
  ]) async {
    actions.add('$action:${body.keys.join(',')}');
    return RequestRecord(
      id: requestId,
      senderUserId: 'srv-partner',
      receiverUserId: 'srv-me',
      kind: 'TASK',
      title: 'Tắm cho bé',
      status: switch (action) {
        'accept' => 'ACCEPTED',
        'done' => 'DONE',
        _ => 'SEEN',
      },
      createdAt: DateTime.utc(2026, 10, 10),
      respondedAt: DateTime.utc(2026, 10, 10, 1),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeCouple remote;
  late _FakeMedia media;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeCouple();
    media = _FakeMedia();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({
      kValueSessionKeyServerFamilyId: 'srv-family',
      kValueSessionKeyServerUserId: 'srv-me',
    });
  });

  UsRemoteServiceImp service() => UsRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(usRepositoryProvider),
    container.read(familyRepositoryProvider),
    container.read(careRepositoryProvider),
    remote,
    uploader: MediaUploader(media),
  );

  test(
    'US-02: a check-in is sent with server codes, note never shared by default',
    () async {
      final us = service();
      final checkin = await us.checkIn(
        mood: MoodCode.annoyed,
        energy: 2,
        needs: const [CoupleNeed.rest, CoupleNeed.hug],
        note: 'Riêng tư',
      );
      expect(remote.checkins.single, {
        'mood': 'UPSET',
        'energy': 2,
        'needs': ['BREAK', 'HUG'],
        'note': 'Riêng tư',
        'share': {
          'enabled': true,
          'fields': ['mood', 'energy', 'needs'],
        },
      });
      expect(checkin.id, 'srv-checkin-1');
      expect(checkin.mood, MoodCode.annoyed);
      await us.checkIn(mood: MoodCode.ok, shared: false);
      expect(remote.checkins.last['share'], {'enabled': false, 'fields': []});
    },
  );

  test(
    "US-01: only the partner's shared check-in is shown, and it goes away when unshared",
    () async {
      final us = service();
      final clock = container.read(appClockProvider);
      remote.today = CheckinToday(
        partner: CheckinRecord(
          id: 'srv-partner-checkin',
          mood: 'TIRED',
          energy: 1,
          needs: const ['HELP_CHILD'],
          createdAt: clock.now(),
          expiresAt: clock.now().add(const Duration(hours: 3)),
        ),
      );
      final today = await us.coupleToday();
      expect(today.partnerCheckin?.mood, MoodCode.tired);
      expect(today.partnerCheckin?.needs, [CoupleNeed.childcare]);

      // A fresh service syncs again: the partner stopped sharing.
      remote.today = const CheckinToday();
      final later = await service().coupleToday();
      expect(later.partnerCheckin?.id, isNot('srv-partner-checkin'));
    },
  );

  test(
    'US-03: a request maps due/urgency and keeps its Idempotency-Key on retry',
    () async {
      final us = service();
      final clock = container.read(appClockProvider);
      final at = clock.now().add(const Duration(hours: 1));
      Future<void> send() => us.sendRequest(
        title: 'Tắm cho bé',
        message: 'Tối nay nhé',
        dueLabel: 'at',
        dueAt: at,
        durationMin: 30,
        urgency: RequestUrgency.soon,
      );
      remote.failNext = true;
      await expectLater(send(), throwsA(isA<DioException>()));
      await send();
      expect(remote.keys, hasLength(2));
      expect(remote.keys.first, remote.keys.last);
      final body = remote.requestBodies.single;
      expect(body['kind'], 'TASK');
      expect(body['urgency'], 'SOON');
      expect(body['durationMin'], 30);
      expect(body['dueKind'], isIn(['TODAY_AT', 'TOMORROW']));
      expect(body['dueAt'], at.toUtc().toIso8601String());
      final mirrored = container
          .read(usRepositoryProvider)
          .request('srv-request');
      expect(mirrored?['senderId'], isNot('srv-me'));
      expect(mirrored?['status'], RequestStatus.sent.name);
    },
  );

  test(
    'US-04: server requests change state through the API, local ones locally',
    () async {
      final us = service();
      remote.page = [
        RequestRecord(
          id: 'srv-incoming',
          senderUserId: 'srv-partner',
          receiverUserId: 'srv-me',
          kind: 'TASK',
          title: 'Tắm cho bé',
          status: 'SENT',
          createdAt: DateTime.utc(2026, 10, 10),
        ),
      ];
      final list = await us.requests();
      final incoming = list.firstWhere(
        (request) => request.id == 'srv-incoming',
      );
      expect(incoming.status, RequestStatus.sent);

      await us.markSeen('srv-incoming');
      await us.accept('srv-incoming');
      await us.markDone('srv-incoming');
      expect(remote.actions, ['seen:', 'accept:', 'done:']);
      final store = container.read(usRepositoryProvider);
      expect(store.request('srv-incoming')?['status'], RequestStatus.done.name);

      final local = list.firstWhere(
        (request) => !request.id.startsWith('srv-'),
      );
      await us.cancel(local.id);
      expect(remote.actions, hasLength(3));
      expect(store.request(local.id)?['status'], RequestStatus.cancelled.name);
    },
  );

  test(
    'US-05/06: thanks are sent and the two-way wall comes from the server',
    () async {
      final us = service();
      final sent = await us.sendThanks(
        body: ' Cảm ơn anh tối qua ',
        sticker: '💛',
        missionId: 'srv-mission',
      );
      expect(remote.appreciationBodies.single, {
        'body': 'Cảm ơn anh tối qua',
        'sticker': '💛',
        'linkedType': 'MISSION',
        'linkedId': 'srv-mission',
      });
      expect(sent.missionId, 'srv-mission');
      expect(sent.toUserId, isNot('srv-partner'));

      remote.wall = [
        AppreciationRecord(
          id: 'srv-thanks-in',
          fromUserId: 'srv-partner',
          toUserId: 'srv-me',
          body: 'Cảm ơn em',
          createdAt: DateTime.now(),
        ),
      ];
      final wall = await service().thanksWall();
      final incoming = wall.firstWhere((item) => item.id == 'srv-thanks-in');
      expect(incoming.toUserId, isNot('srv-me'));
      final us2 = service();
      await us2.toggleThanksHeart('srv-thanks-in');
      expect(remote.reactions, ['srv-thanks-in:❤️']);
      // Already reacted: no second call.
      await us2.toggleThanksHeart('srv-thanks-in');
      expect(remote.reactions, hasLength(1));
    },
  );

  test(
    'US-07: journal entries are only mine and share the exact text',
    () async {
      final us = service();
      final entry = await us.addJournalEntry(
        mood: JournalMood.worried,
        title: 'Tối nay',
        body: ' Mình hơi lo ',
      );
      expect(remote.journalBodies.single, {
        'title': 'Tối nay',
        'body': 'Mình hơi lo',
        'mood': 'STRESSED',
      });
      expect(entry.mood, JournalMood.worried);
      await us.shareJournalExcerpt(entry.id);
      expect(remote.shares, ['${entry.id}:Mình hơi lo']);
      final store = container.read(usRepositoryProvider);
      expect(
        store
            .journal(
              container.read(sessionRepositoryProvider).session()['userId']
                  as String,
            )
            .firstWhere((row) => row['id'] == entry.id)['sharedExcerpt'],
        isTrue,
      );

      remote.entries = [
        JournalEntryRecord(
          id: 'srv-journal-old',
          body: 'Trang cũ',
          mood: 'GOOD',
          createdAt: DateTime.utc(2026, 10, 1),
        ),
      ];
      final list = await service().journal();
      expect(
        list.firstWhere((item) => item.id == 'srv-journal-old').mood,
        JournalMood.grateful,
      );
    },
  );

  test(
    'US-05/07: a family-moment proposal and a journal photo go to the server',
    () async {
      final us = service();
      await us.sendThanks(body: 'Cảm ơn anh', proposeFamilyMoment: true);
      await us.sendThanks(body: 'Cảm ơn lần nữa');
      expect(remote.shareRequests, ['srv-thanks-1']);

      await us.addJournalEntry(
        mood: JournalMood.calm,
        title: 'Tối nay',
        body: 'Con ngủ sớm',
        photoAsset: '/tmp/night.jpg',
      );
      expect(media.purposes, ['JOURNAL']);
      expect(remote.journalBodies.last['assetIds'], ['asset-1']);
      // Bundled sample images are never uploaded.
      await us.addJournalEntry(
        mood: JournalMood.calm,
        title: 'Mẫu',
        photoAsset: 'assets/images/sample.jpg',
      );
      expect(media.purposes, hasLength(1));
    },
  );

  test('US-05: the partner approves a family-moment proposal', () async {
    remote.wall = [
      AppreciationRecord(
        id: 'srv-thanks-ask',
        fromUserId: 'srv-partner',
        toUserId: 'srv-me',
        body: 'Cảm ơn em',
        familyShareStatus: 'REQUESTED',
        createdAt: DateTime.now(),
      ),
    ];
    final us = service();
    final asked = (await us.thanksWall()).firstWhere(
      (item) => item.id == 'srv-thanks-ask',
    );
    expect(asked.shareRequested, isTrue);
    expect(asked.postedToFamily, isFalse);

    await us.respondThanksShare(asked.id, approve: true);
    expect(remote.shareResponses, ['srv-thanks-ask:true']);
    final after = (await us.thanks()).firstWhere((item) => item.id == asked.id);
    expect(after.shareRequested, isFalse);
    expect(after.postedToFamily, isTrue);
  });

  test('US-15: my Papa & Mama settings come from the server', () async {
    final us = service();
    final settings = await us.coupleSettings();
    expect(settings.checkinShareMode, CheckinShareMode.alwaysPrivate);
    expect(settings.faceIdLock, isTrue);
    await us.saveCoupleSettings(
      settings.copyWith(
        checkinShareMode: CheckinShareMode.askEachTime,
        quietFrom: '23:00',
      ),
    );
    // Quiet hours stay on this device; only the changed server field is sent.
    expect(remote.usPatches, [
      {'moodShareDefault': 'ASK'},
    ]);
  });
}
