import 'dart:typed_data';

import 'package:baby_family/data/dto/processed_media.dart';
import 'package:baby_family/data/model/account/data_export_record.dart';
import 'package:baby_family/data/model/account/deletion_preview_record.dart';
import 'package:baby_family/data/model/account/export_download_record.dart';
import 'package:baby_family/data/model/account/reauth_token_record.dart';
import 'package:baby_family/data/model/account/session_record.dart';
import 'package:baby_family/data/model/memory/upload_instruction.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/privacy/family_deletion_record.dart';
import 'package:baby_family/data/model/privacy/privacy_overview_record.dart';
import 'package:baby_family/data/model/safety/blocked_user_record.dart';
import 'package:baby_family/data/model/settings/ai_settings_record.dart';
import 'package:baby_family/data/model/settings/help_center_record.dart';
import 'package:baby_family/data/model/settings/notification_settings_record.dart';
import 'package:baby_family/data/model/settings/sign_in_method_record.dart';
import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/model/settings/support_ticket_detail.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/repository/account_remote.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/service_imp/settings_remote.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

/// API tài khoản giả (BF-20261018-013).
class _FakeAccount implements IAccountRemoteRepository {
  final calls = <String>[];
  final deletions = <Map<String, String>>[];
  String exportStatus = 'QUEUED';
  final revoked = <String>[];

  @override
  Future<void> requestReauthOtp() async => calls.add('otp');

  @override
  Future<ReauthTokenRecord?> verifyReauthOtp(String code) async {
    calls.add('verify:$code');
    return const ReauthTokenRecord(reauthToken: 'reauth-1');
  }

  @override
  Future<DeletionPreviewRecord?> deletionPreview() async =>
      const DeletionPreviewRecord(
        graceDays: 30,
        familyId: 'srv-family',
        familyChoices: ['PARTNER_CONTINUES'],
      );

  @override
  Future<void> requestDeletion({
    required String familyChoice,
    required String sharedContentChoice,
    required String reauthToken,
  }) async => deletions.add({
    'familyChoice': familyChoice,
    'sharedContentChoice': sharedContentChoice,
    'reauthToken': reauthToken,
  });

  @override
  Future<DataExportRecord?> createExport(
    String scope, {
    String? familyId,
  }) async {
    calls.add('export:$scope:$familyId');
    return DataExportRecord(id: 'exp-$scope', scope: scope, status: 'QUEUED');
  }

  @override
  Future<List<SessionRecord>> sessions() async => [
    SessionRecord(
      id: 's-1',
      platform: 'IOS',
      deviceModel: 'iPhone 15',
      lastUsedAt: DateTime.utc(2026, 10, 7, 12),
      current: true,
    ),
    const SessionRecord(id: 's-2', platform: 'ANDROID'),
  ];

  @override
  Future<void> revokeSession(String sessionId) async => revoked.add(sessionId);

  @override
  Future<void> revokeOtherSessions() async => revoked.add('others');

  final mePatches = <JsonMap>[];

  @override
  Future<void> updateMe(JsonMap patch) async => mePatches.add(patch);

  NotificationSettingsRecord notifications = const NotificationSettingsRecord(
    quietStart: '21:00',
    quietEnd: '06:00',
    hideSensitivePreview: false,
    categories: {'MEMORIES': false, 'REQUESTS': true},
    circleDigestTime: '20:00',
  );
  final notificationPatches = <JsonMap>[];
  AiSettingsRecord ai = const AiSettingsRecord(
    aiEnabled: true,
    features: {'dailyStory': false},
  );
  final aiPatches = <JsonMap>[];

  @override
  Future<NotificationSettingsRecord?> notificationSettings() async =>
      notifications;

  @override
  Future<NotificationSettingsRecord?> updateNotificationSettings(
    JsonMap patch,
  ) async {
    notificationPatches.add(patch);
    return notifications;
  }

  @override
  Future<AiSettingsRecord?> aiSettings() async => ai;

  @override
  Future<AiSettingsRecord?> updateAiSettings(JsonMap patch) async {
    aiPatches.add(patch);
    return ai;
  }

  final avatarIntents = <JsonMap>[];
  final avatarCompleted = <String>[];

  @override
  Future<UploadIntent?> createAvatarIntent(
    String idempotencyKey,
    JsonMap body,
  ) async {
    avatarIntents.add(body);
    return UploadIntent(
      assetId: 'avatar-1',
      status: 'PENDING_UPLOAD',
      upload: const UploadInstruction(mode: 'single', url: 'https://s3/avatar'),
      variantUploads: [
        for (final variant in (body['variants'] as List?) ?? const [])
          VariantUpload(
            code: (variant as Map)['code'] as String,
            upload: UploadInstruction(
              mode: 'single',
              url: 'https://s3/avatar/${variant['code']}',
            ),
          ),
      ],
    );
  }

  @override
  Future<void> completeAvatar(String assetId) async =>
      avatarCompleted.add(assetId);

  FamilyDeletionRecord deletion = const FamilyDeletionRecord(status: 'NONE');
  final deletionCalls = <String>[];
  final familyPatches = <JsonMap>[];

  @override
  Future<FamilyDeletionRecord?> familyDeletion(String familyId) async =>
      deletion;

  @override
  Future<FamilyDeletionRecord?> requestFamilyDeletion(
    String familyId,
    String reauthToken,
  ) async {
    deletionCalls.add('request:$reauthToken');
    return deletion = const FamilyDeletionRecord(
      status: 'AWAITING_PARTNER',
      requestedBy: 'srv-me',
      graceDays: 30,
    );
  }

  @override
  Future<FamilyDeletionRecord?> confirmFamilyDeletion(
    String familyId,
    String reauthToken,
  ) async {
    deletionCalls.add('confirm:$reauthToken');
    return deletion = FamilyDeletionRecord(
      status: 'SCHEDULED',
      requestedBy: 'srv-partner',
      scheduledFor: DateTime.utc(2026, 11, 18),
    );
  }

  @override
  Future<FamilyDeletionRecord?> cancelFamilyDeletion(String familyId) async {
    deletionCalls.add('cancel');
    return deletion = const FamilyDeletionRecord(status: 'CANCELLED');
  }

  @override
  Future<PrivacyOverviewRecord?> privacyOverview(String familyId) async =>
      const PrivacyOverviewRecord(
        defaults: PrivacyDefaultsRecord(defaultVisibility: 'PARENTS'),
        blockedCount: 2,
      );

  @override
  Future<void> updateFamilySettings(String familyId, JsonMap patch) async =>
      familyPatches.add(patch);

  final phoneCalls = <String>[];

  @override
  Future<void> requestPhoneChangeOtp(String phone, String reauthToken) async =>
      phoneCalls.add('otp:$phone:$reauthToken');

  @override
  Future<void> verifyPhoneChange(String phone, String code) async =>
      phoneCalls.add('verify:$phone:$code');

  @override
  Future<List<SignInMethodRecord>> signInMethods() async => const [
    SignInMethodRecord(provider: 'PHONE', maskedHint: '***1234'),
    SignInMethodRecord(provider: 'GOOGLE', maskedHint: 'a***@example.com'),
  ];

  @override
  Future<HelpCenterRecord?> helpCenter(String locale) async =>
      const HelpCenterRecord(
        version: 1,
        faqs: [
          HelpFaqRecord(id: 'trial', question: 'Dùng thử?', answer: 'Có.'),
        ],
        contact: HelpContactRecord(email: 'help@example.test'),
        legal: HelpLegalRecord(termsUrl: 'https://example.test/terms'),
      );

  final supportBodies = <JsonMap>[];
  final supportReplies = <String>[];

  @override
  Future<SupportTicketDetail?> supportTicket(String ticketId) async =>
      SupportTicketDetail(
        id: ticketId,
        code: 'HT-1',
        status: 'WAITING_USER',
        subject: 'Gia hạn',
        body: 'Không gia hạn được',
        messages: [
          const SupportMessage(
            id: 'm-1',
            sender: 'SUPPORT',
            body: 'Bạn thử lại nhé',
          ),
          for (final reply in supportReplies)
            SupportMessage(id: 'r-$reply', sender: 'USER', body: reply),
        ],
      );

  @override
  Future<void> sendSupportMessage(String ticketId, String body) async =>
      supportReplies.add(body);

  @override
  Future<List<String>> supportCategories() async => ['ACCOUNT', 'BILLING'];

  @override
  Future<SupportTicket?> createSupportTicket(JsonMap body) async {
    supportBodies.add(body);
    return const SupportTicket(id: 't-1', code: 'HT-1', status: 'OPEN');
  }

  @override
  Future<List<SupportTicket>> supportTickets({int limit = 50}) async => [
    for (final (index, _) in supportBodies.indexed)
      SupportTicket(id: 't-$index', code: 'HT-$index', status: 'OPEN'),
  ];

  final blocked = <String>[];

  @override
  Future<void> block(String familyId, String userId) async =>
      blocked.add(userId);

  @override
  Future<void> unblock(String familyId, String userId) async =>
      blocked.remove(userId);

  @override
  Future<List<BlockedUserRecord>> blocks(String familyId) async => [
    for (final id in blocked)
      BlockedUserRecord(userId: id, displayName: 'Bà Ngoại'),
  ];

  @override
  Future<DataExportRecord?> export(String exportId) async {
    calls.add('get:$exportId');
    return DataExportRecord(
      id: exportId,
      status: exportStatus,
      download: exportStatus == 'COMPLETED'
          ? const ExportDownloadRecord(url: 'https://files.test/export.json')
          : null,
    );
  }
}

class _FakeMedia extends Fake implements IMediaRepository {
  final uploaded = <int>[];

  @override
  Future<Uint8List> readLocalFile(String path) async =>
      Uint8List.fromList(path.codeUnits);

  @override
  Future<List<JsonMap>> uploadBytes(
    UploadInstruction instruction,
    Uint8List bytes,
  ) async {
    uploaded.add(bytes.length);
    return const [];
  }

  /// Client nén avatar (BF-20261021-008): bản JPEG + 2 biến thể.
  @override
  Future<ProcessedMedia> processImage(String path) async => ProcessedMedia(
    kind: 'IMAGE',
    mime: 'image/jpeg',
    bytes: Uint8List.fromList(path.codeUnits),
    width: 2048,
    height: 2048,
    variants: [
      MediaVariantFile(
        code: 'm1080',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([1, 2]),
      ),
      MediaVariantFile(
        code: 't320',
        mime: 'image/jpeg',
        bytes: Uint8List.fromList([3]),
      ),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late _FakeAccount remote;
  late _FakeMedia media;

  setUp(() async {
    container = ProviderContainer(overrides: mockOverrides());
    addTearDown(container.dispose);
    remote = _FakeAccount();
    media = _FakeMedia();
    final session = container.read(sessionRepositoryProvider);
    await session.ensureLoaded();
    session.patchSession({
      kValueSessionKeyServerFamilyId: 'srv-family',
      kValueSessionKeyServerUserId: 'srv-me',
      'phone': '+84901234456',
    });
  });

  SettingsRemoteServiceImp service() => SettingsRemoteServiceImp(
    container.read(sessionRepositoryProvider),
    container.read(appClockProvider),
    container.read(settingsRepositoryProvider),
    container.read(familyRepositoryProvider),
    container.read(childRepositoryProvider),
    remote,
    container.read(sessionServiceProvider),
    media,
  );

  test('SET-03: notification settings merge and patch the server', () async {
    final settings = service();
    final merged = await settings.notificationSettings();
    bool on(String code) =>
        merged.channels.firstWhere((c) => c.code == code).enabled;
    expect(on('memories'), isFalse);
    expect(on('requests'), isTrue);
    expect(merged.quietHours, isTrue);
    expect(merged.quietFrom, '21:00');
    expect(merged.hideOnLockScreen, isFalse);
    expect(merged.relativesDigestTime, '20:00');

    await settings.saveNotificationSettings(
      merged.copyWith(
        quietHours: false,
        channels: [
          for (final c in merged.channels)
            c.code == 'thanks' || c.code == 'missions'
                ? c.copyWith(enabled: !c.enabled)
                : c,
        ],
      ),
    );
    // Nhiệm vụ chưa có nhóm trên server: chỉ lưu trên máy.
    expect(remote.notificationPatches.single, {
      'categories': {'APPRECIATION': false},
      'quietStart': '21:00',
      'quietEnd': '21:00',
    });
  });

  test(
    'AUTH-04: a new avatar is uploaded, then attached with PATCH /me',
    () async {
      final settings = service();
      final before = await settings.profileSettings();
      await settings.saveProfileSettings(
        before.copyWith(avatarAsset: '/tmp/me.png'),
      );
      final intent = remote.avatarIntents.single;
      expect(intent, containsPair('mime', 'image/jpeg'));
      expect(intent, containsPair('purpose', 'AVATAR'));
      expect(intent.containsKey('familyId'), isFalse);
      expect((intent['variants'] as List).map((v) => (v as Map)['code']), [
        'm1080',
        't320',
      ]);
      // File chính + 2 biến thể đi thẳng lên S3.
      expect(media.uploaded, hasLength(3));
      expect(remote.avatarCompleted, ['avatar-1']);
      expect(remote.mePatches.single, {'avatarAssetId': 'avatar-1'});
      expect((await settings.profileSettings()).avatarAsset, '/tmp/me.png');

      await settings.saveProfileSettings(
        (await settings.profileSettings()).copyWith(avatarAsset: null),
      );
      expect(remote.mePatches.last, {'avatarAssetId': null});
    },
  );

  test('SET-04: privacy dashboard merges the server overview', () async {
    final settings = service();
    final privacy = await settings.privacySettings();
    expect(privacy.blockedCount, 2);
    expect(privacy.defaultVisibility, MemoryVisibility.parents);
    await settings.savePrivacySettings(
      privacy.copyWith(defaultVisibility: MemoryVisibility.family),
    );
    expect(remote.familyPatches.single, {'defaultVisibility': 'FAMILY'});
  });

  test('Phone change: reauth first, code to the new number', () async {
    final settings = service();
    await expectLater(
      settings.requestPhoneChange('+84987654321'),
      throwsStateError,
    );
    await settings.requestReauthOtp();
    await settings.verifyReauth('123456');
    await settings.requestPhoneChange('+84987654321');
    await settings.confirmPhoneChange('+84987654321', '654321');
    expect(remote.phoneCalls, [
      'otp:+84987654321:reauth-1',
      'verify:+84987654321:654321',
    ]);
    expect(
      container.read(sessionRepositoryProvider).session()['phone'],
      '+84987654321',
    );
  });

  test(
    'Support: catalog from the server, ticket carries only typed text',
    () async {
      final settings = service();
      expect(await settings.supportCategories(), ['ACCOUNT', 'BILLING']);
      final ticket = await settings.sendSupportRequest(
        category: 'BILLING',
        subject: 'Gia hạn',
        body: 'Không gia hạn được',
      );
      expect(ticket.code, 'HT-1');
      expect(remote.supportBodies.single, {
        'category': 'BILLING',
        'subject': 'Gia hạn',
        'body': 'Không gia hạn được',
        'familyId': 'srv-family',
      });
      expect((await settings.supportTickets()).single.code, 'HT-0');
    },
  );

  test('Support: a ticket thread loads and a reply is sent', () async {
    final settings = service();
    final ticket = await settings.supportTicket('t-1');
    expect(ticket?.messages.single.sender, 'SUPPORT');
    await settings.sendSupportMessage('t-1', 'Đã được rồi, cảm ơn');
    expect(remote.supportReplies, ['Đã được rồi, cảm ơn']);
    final updated = await settings.supportTicket('t-1');
    expect(updated?.messages.last.body, 'Đã được rồi, cảm ơn');
  });

  test(
    'SET-11/12: FAQ answers, contact and legal links come from the server',
    () async {
      final help = await service().help();
      expect(help.faqs, ['Dùng thử?']);
      expect(help.faqAnswers, ['Có.']);
      expect(help.email, 'help@example.test');
      // Chưa cấu hình → không hiện số mẫu.
      expect(help.hotline, isEmpty);
      expect(help.openReports, 0);
      expect(help.termsUrl, 'https://example.test/terms');
      expect(help.privacyUrl, isNull);
    },
  );

  test('Sign-in methods mirror the server list', () async {
    final methods = (await service().profileSettings()).signInMethods;
    final byMethod = {for (final item in methods) item.method: item};
    expect(byMethod[AuthMethod.phone]?.linked, isTrue);
    expect(byMethod[AuthMethod.phone]?.maskedAccount, '***1234');
    expect(byMethod[AuthMethod.google]?.linked, isTrue);
    expect(byMethod[AuthMethod.apple]?.linked, isFalse);
  });

  test('§7.25: family deletion needs reauth and both parents', () async {
    final settings = service();
    expect((await settings.familyDeletion()).status, FamilyDeletionStatus.none);
    // Không xác thực lại → không gửi yêu cầu.
    await expectLater(settings.requestFamilyDeletion(), throwsStateError);
    await settings.requestReauthOtp();
    await settings.verifyReauth('123456');
    final asked = await settings.requestFamilyDeletion();
    expect(asked.status, FamilyDeletionStatus.awaitingPartner);
    expect(asked.requestedByMe, isTrue);
    // Mã xác thực lại chỉ dùng một lần.
    await expectLater(settings.confirmFamilyDeletion(), throwsStateError);
    await settings.verifyReauth('654321');
    final scheduled = await settings.confirmFamilyDeletion();
    expect(scheduled.status, FamilyDeletionStatus.scheduled);
    expect(scheduled.scheduledFor?.toUtc(), DateTime.utc(2026, 11, 18));
    expect(
      (await settings.cancelFamilyDeletion()).status,
      FamilyDeletionStatus.none,
    );
    expect(remote.deletionCalls, [
      'request:reauth-1',
      'confirm:reauth-1',
      'cancel',
    ]);
  });

  test('RPT-02: blocks go to the server by account id', () async {
    final settings = service();
    final family = container.read(familyRepositoryProvider);
    final member = family.addMember({
      'familyId': 'local-family',
      'userId': 'srv-grandma',
      'role': FamilyRole.relative.name,
      'callName': 'Bà Ngoại',
    });
    await settings.blockMember(member['id'] as String);
    expect(remote.blocked, ['srv-grandma']);
    final people = await settings.blockedPeople();
    expect(people.single.id, 'srv-grandma');
    expect(people.single.name, 'Bà Ngoại');
    await settings.unblock('srv-grandma');
    expect(await settings.blockedPeople(), isEmpty);
  });

  test('SET-05: AI switches map to the server feature catalog', () async {
    final settings = service();
    final merged = await settings.aiSettings();
    expect(
      merged.features.firstWhere((f) => f.code == 'day_story').enabled,
      isFalse,
    );
    await settings.saveAiSettings(
      merged.copyWith(
        enabled: false,
        features: [
          for (final f in merged.features)
            f.code == 'caption' ? f.copyWith(enabled: false) : f,
        ],
      ),
    );
    expect(remote.aiPatches.single, {
      'aiEnabled': false,
      'features': {'caption': false},
    });
  });

  test(
    'SET-02: the display name goes to PATCH /me only when changed',
    () async {
      final settings = service();
      final before = await settings.profileSettings();
      await settings.saveProfileSettings(before.copyWith(callName: 'Mẹ Lan'));
      expect(remote.mePatches, isEmpty);
      await settings.saveProfileSettings(before.copyWith(name: ' Lan Anh '));
      expect(remote.mePatches, [
        {'displayName': 'Lan Anh'},
      ]);
      expect((await settings.profileSettings()).name, ' Lan Anh ');
    },
  );

  test(
    'SET-08: export runs on the server and the download link is fetched fresh',
    () async {
      final settings = service();
      await settings.startExport(DataExportKind.family);
      expect(remote.calls, ['export:FAMILY:srv-family']);
      var job = (await settings.dataExport()).jobs.firstWhere(
        (item) => item.kind == DataExportKind.family,
      );
      expect(job.status, DataExportStatus.preparing);
      expect(job.exportId, 'exp-FAMILY');

      remote.exportStatus = 'COMPLETED';
      job = (await settings.dataExport()).jobs.firstWhere(
        (item) => item.kind == DataExportKind.family,
      );
      expect(job.status, DataExportStatus.ready);
      expect(
        await settings.exportDownloadUrl(DataExportKind.family),
        'https://files.test/export.json',
      );

      // A failed/expired export disappears so it can be started again.
      remote.exportStatus = 'EXPIRED';
      final info = await settings.dataExport();
      expect(
        info.jobs.where((item) => item.kind == DataExportKind.family),
        isEmpty,
      );
    },
  );

  test(
    'SET-09c: deletion needs a fresh OTP reauth, then signs out locally',
    () async {
      final settings = service();
      final info = await settings.deleteAccountInfo();
      expect(info.maskedPhone, '••• 456');
      expect(info.maskedAppleAccount, isNull);
      expect(info.onlyParent, isFalse);

      await expectLater(settings.deleteAccount(), throwsStateError);
      expect(remote.deletions, isEmpty);

      await settings.requestReauthOtp();
      await settings.verifyReauth('123456');
      await settings.deleteAccount(keepMemories: false);
      expect(remote.calls, ['otp', 'verify:123456']);
      expect(remote.deletions.single, {
        'familyChoice': 'PARTNER_CONTINUES',
        'sharedContentChoice': 'DELETE',
        'reauthToken': 'reauth-1',
      });
      // Signed out locally: nothing else reaches the server.
      await settings.deleteAccount();
      expect(remote.deletions, hasLength(1));
    },
  );

  test(
    'SET-07: devices are my server sessions; sign-out goes to the server',
    () async {
      final settings = service();
      final security = await settings.securitySettings();
      expect(security.devices.map((device) => device.name), [
        'iPhone 15',
        'Android',
      ]);
      expect(security.devices.first.current, isTrue);
      await settings.signOutDevice('s-2');
      await settings.signOutOtherDevices();
      expect(remote.revoked, ['s-2', 'others']);
    },
  );
}
