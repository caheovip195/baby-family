import 'package:baby_family/data/dto/family_deletion_info.dart';
import 'package:baby_family/data/model/account/data_export_record.dart';
import 'package:baby_family/data/model/privacy/family_deletion_record.dart';
import 'package:baby_family/data/model/settings/ai_settings.dart';
import 'package:baby_family/data/model/settings/blocked_person.dart';
import 'package:baby_family/data/model/settings/data_export_info.dart';
import 'package:baby_family/data/model/settings/data_export_job.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/model/settings/help_center_record.dart';
import 'package:baby_family/data/model/settings/help_info.dart';
import 'package:baby_family/data/model/settings/login_device.dart';
import 'package:baby_family/data/model/settings/notification_settings.dart';
import 'package:baby_family/data/model/settings/notification_settings_record.dart';
import 'package:baby_family/data/model/settings/privacy_settings.dart';
import 'package:baby_family/data/model/settings/profile_settings.dart';
import 'package:baby_family/data/model/settings/security_settings.dart';
import 'package:baby_family/data/model/settings/sign_in_method.dart';
import 'package:baby_family/data/model/settings/sign_in_method_record.dart';
import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/model/settings/support_ticket_detail.dart';
import 'package:baby_family/data/repository/account_remote.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository/settings.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/offline_read.dart';
import 'package:baby_family/data/service_imp/settings.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// SET-08/09 qua server thật (BF-20261018-013, mục 7.25):
/// - Xuất dữ liệu: tạo job trên server, nhớ id job trong mục `dataExport` để
///   hỏi lại trạng thái; link tải lấy mới mỗi lần bấm (hết hạn ~15 phút).
/// - Xoá tài khoản: xác thực lại bằng OTP tới số của chính tôi, giữ mã xác thực
///   lại trong bộ nhớ (≤ 5 phút), gửi yêu cầu xoá có 30 ngày chờ rồi đăng xuất.
/// Các mục cài đặt khác vẫn dùng bản trên máy.
class SettingsRemoteServiceImp extends SettingsServiceImp {
  /// Bản đọc gần nhất cho màn phụ khi mất mạng (BF-20261026-007).
  final _reads = OfflineReads();

  SettingsRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._store,
    this._family,
    IChildRepository childRepository,
    this._remote,
    this._session,
    this._media,
  ) : super(sessionRepository, clock, _store, _family, childRepository);

  final ISettingsRepository _store;
  final IFamilyRepository _family;
  final IAccountRemoteRepository _remote;
  final ISessionService _session;
  final IMediaRepository _media;

  /// Mã xác thực lại, chỉ trong bộ nhớ; hết hạn thì server trả `REAUTH_REQUIRED`.
  String? _reauthToken;

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  bool get _remoteOn => _serverFamilyId != null;

  // ------------------------------------------------------------ hồ sơ

  /// SET-02: tên hiển thị lưu trên server (`PATCH /me`, chỉ gửi khi đổi);
  /// tên gọi trong gia đình, ảnh đại diện, múi giờ vẫn trên máy.
  /// AUTH-04: ảnh mới chọn trên máy tải lên kho ảnh tài khoản rồi gắn bằng
  /// `PATCH /me {avatarAssetId}`; bỏ ảnh gửi null.
  /// Phương thức đăng nhập theo server (`/me/sign-in-methods`); lỗi mạng giữ
  /// bản trên máy.
  @override
  Future<ProfileSettings> profileSettings() async {
    var local = await super.profileSettings();
    if (_remoteOn) {
      /// BF-20261023-001: thiếu hồ sơ/phương thức đăng nhập không dùng Lan/OTP mẫu.
      final me = _family.member(myMemberId);
      final user = sessionRepository.user(myUserId);
      local = local.copyWith(
        name: user?['displayName'] as String? ?? '',
        callName: me?['callName'] as String? ?? '',
        avatarAsset: me?['avatarAsset'] as String?,
        signInMethods: const [],
        timezoneLabel: '',
      );
    }
    if (!_remoteOn) {
      return local;
    }
    final List<SignInMethodRecord> records;
    try {
      records = await _remote.signInMethods();
    } on DioException {
      return local;
    }
    final byMethod = {
      for (final record in records)
        ?AuthMethod.values.asNameMap()[record.provider?.toLowerCase()]: record,
    };
    return local.copyWith(
      signInMethods: [
        for (final method in AuthMethod.values)
          SignInMethod(
            method: method,
            linked: byMethod.containsKey(method),
            maskedAccount: byMethod[method]?.maskedHint,
          ),
      ],
    );
  }

  @override
  Future<void> saveProfileSettings(ProfileSettings settings) async {
    if (_remoteOn) {
      final before = await profileSettings();
      final name = settings.name.trim();
      final avatar = settings.avatarAsset;
      final patch = <String, dynamic>{
        if (name.isNotEmpty && name != before.name) 'displayName': name,
        if (avatar != before.avatarAsset)
          'avatarAssetId': avatar == null ? null : await _uploadAvatar(avatar),
      };
      if (patch.isNotEmpty) {
        await _remote.updateMe(patch);
      }
      if (avatar != before.avatarAsset && myMemberId != null) {
        _family.updateMember(myMemberId!, {'avatarAsset': avatar});
      }
    }
    await super.saveProfileSettings(settings);
  }

  /// Client nén + tạo biến thể, upload thẳng S3 (BF-20261021-008).
  Future<String> _uploadAvatar(String path) {
    final key = const Uuid().v4();
    return MediaUploader(_media).uploadAvatar(
      path,
      create: (body) => _remote.createAvatarIntent(key, body),
      complete: _remote.completeAvatar,
    );
  }

  // ------------------------------------------------ SET-03 thông báo

  /// Nhóm thông báo app → nhóm của server; nhóm khác (nhiệm vụ, cầu nối,
  /// cột mốc, recap, người thân, gói) vẫn chỉ lưu trên máy.
  static const _serverCategories = {
    'memories': 'MEMORIES',
    'requests': 'REQUESTS',
    'couple': 'US',
    'thanks': 'APPRECIATION',
    'promotions': 'PROMOTIONS',
  };

  @override
  Future<NotificationSettings> notificationSettings() async {
    final saved = await super.notificationSettings();

    /// BF-20261023-001: số người tắt thông báo trong fixture không thuộc phiên thật.
    final local = _remoteOn ? saved.copyWith(mutedPeople: 0) : saved;
    if (!_remoteOn) {
      return local;
    }
    final record = await _reads.read([
      'notificationSettings',
      sessionRepository.session()[kValueSessionKeyServerUserId],
    ], () => _remote.notificationSettings());
    return record == null ? local : _mergeNotifications(local, record);
  }

  @override
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    if (_remoteOn) {
      final before = await notificationSettings();
      final patch = _notificationPatch(before, settings);
      if (patch.isNotEmpty) {
        await _remote.updateNotificationSettings(patch);
      }
    }
    await super.saveNotificationSettings(settings);
  }

  NotificationSettings _mergeNotifications(
    NotificationSettings local,
    NotificationSettingsRecord record,
  ) {
    final start = record.quietStart;
    final end = record.quietEnd;
    // Server tắt giờ yên tĩnh bằng giờ bắt đầu = giờ kết thúc.
    final quiet = start != null && end != null && start != end;
    return local.copyWith(
      channels: [
        for (final channel in local.channels)
          switch (record.categories[_serverCategories[channel.code]]) {
            final bool enabled => channel.copyWith(enabled: enabled),
            null => channel,
          },
      ],
      quietHours: start == null ? local.quietHours : quiet,
      quietFrom: quiet ? start : local.quietFrom,
      quietTo: quiet ? end : local.quietTo,
      hideOnLockScreen: record.hideSensitivePreview ?? local.hideOnLockScreen,
      relativesDigestTime: record.circleDigestTime ?? local.relativesDigestTime,
    );
  }

  static JsonMap _notificationPatch(
    NotificationSettings before,
    NotificationSettings after,
  ) {
    final was = {for (final c in before.channels) c.code: c.enabled};
    final categories = <String, bool>{
      for (final channel in after.channels)
        if (_serverCategories[channel.code] case final category?
            when was[channel.code] != channel.enabled)
          category: channel.enabled,
    };
    final quietChanged =
        before.quietHours != after.quietHours ||
        (after.quietHours &&
            (before.quietFrom != after.quietFrom ||
                before.quietTo != after.quietTo));
    return {
      if (categories.isNotEmpty) 'categories': categories,
      if (quietChanged) 'quietStart': after.quietFrom,
      if (quietChanged)
        'quietEnd': after.quietHours ? after.quietTo : after.quietFrom,
      if (before.hideOnLockScreen != after.hideOnLockScreen)
        'hideSensitivePreview': after.hideOnLockScreen,
      if (before.relativesDigestTime != after.relativesDigestTime)
        'circleDigestTime': after.relativesDigestTime,
    };
  }

  // ------------------------------------------------------------ SET-05 AI

  /// Mã tính năng AI app → khoá trong catalog server (“recap” còn trên máy).
  static const _serverAiFeatures = {
    'caption': 'caption',
    'day_story': 'dailyStory',
    'mission_suggest': 'missionSuggest',
    'rewrite': 'gentleRewrite',
    'bridge_summary': 'bridgeSummary',
  };

  @override
  Future<AiSettings> aiSettings() async {
    final saved = await super.aiSettings();

    /// BF-20261023-001: API AI chưa có quota/lịch gia hạn, không hiện số mẫu.
    final local = _remoteOn
        ? saved.copyWith(remaining: 0, total: 0, renewsAt: null)
        : saved;
    if (!_remoteOn) {
      return local;
    }
    final record = await _reads.read([
      'aiSettings',
      sessionRepository.session()[kValueSessionKeyServerUserId],
    ], () => _remote.aiSettings());
    if (record == null) {
      return local;
    }
    return local.copyWith(
      enabled: record.aiEnabled ?? local.enabled,
      features: [
        for (final feature in local.features)
          switch (record.features[_serverAiFeatures[feature.code]]) {
            final bool enabled => feature.copyWith(enabled: enabled),
            null => feature,
          },
      ],
    );
  }

  @override
  Future<void> saveAiSettings(AiSettings settings) async {
    if (_remoteOn) {
      final before = await aiSettings();
      final was = {for (final f in before.features) f.code: f.enabled};
      final features = <String, bool>{
        for (final feature in settings.features)
          if (_serverAiFeatures[feature.code] case final key?
              when was[feature.code] != feature.enabled)
            key: feature.enabled,
      };
      final patch = <String, dynamic>{
        if (before.enabled != settings.enabled) 'aiEnabled': settings.enabled,
        if (features.isNotEmpty) 'features': features,
      };
      if (patch.isNotEmpty) {
        await _remote.updateAiSettings(patch);
      }
    }
    await super.saveAiSettings(settings);
  }

  // ------------------------------------------------ SET-04 quyền riêng tư

  static const _visibilityCodes = {
    MemoryVisibility.family: 'FAMILY',
    MemoryVisibility.parents: 'PARENTS',
    MemoryVisibility.onlyMe: 'PRIVATE',
  };

  /// Số người tôi đã chặn và mặc định ai xem lấy từ server; ai thấy bé nào
  /// màn tự tính từ danh sách người thân (đã đồng bộ `/circle`).
  @override
  Future<PrivacySettings> privacySettings() async {
    final saved = await super.privacySettings();

    /// BF-20261023-001: audience, quyền và số đếm fixture không thuộc gia đình thật.
    final local = _remoteOn
        ? saved.copyWith(
            audiences: const [],
            downloadAllowed: const [],
            postAllowed: const [],
            familyVisibleMemories: 0,
            deviceCount: 0,
            aiFeatures: 0,
            blockedCount: 0,
          )
        : saved;
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return local;
    }
    // BF-20261026-002: số thiết bị theo phiên đăng nhập thật (SET-07 cùng
    // nguồn), không để 0 khi máy này đang đăng nhập.
    final (overview, sessions) = await (
      _remote.privacyOverview(serverFamilyId),
      _remote.sessions(),
    ).wait;
    final withDevices = local.copyWith(deviceCount: sessions.length);
    if (overview == null) {
      return withDevices;
    }
    final visibility = _visibilityCodes.entries
        .where((entry) => entry.value == overview.defaults?.defaultVisibility)
        .firstOrNull
        ?.key;
    return withDevices.copyWith(
      blockedCount: overview.blockedCount,
      defaultVisibility: visibility ?? local.defaultVisibility,
    );
  }

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId != null) {
      final before = await privacySettings();
      if (before.defaultVisibility != settings.defaultVisibility) {
        await _remote.updateFamilySettings(serverFamilyId, {
          'defaultVisibility': _visibilityCodes[settings.defaultVisibility],
        });
      }
    }
    await super.savePrivacySettings(settings);
  }

  // ------------------------------------------------ đổi số điện thoại

  @override
  Future<void> requestPhoneChange(String phone) async {
    if (!_remoteOn) {
      return super.requestPhoneChange(phone);
    }
    // Mã xác thực lại dùng lại được trong lúc gửi lại OTP (hết hạn ~5 phút).
    await _remote.requestPhoneChangeOtp(phone, _reauthOrThrow);
  }

  @override
  Future<void> confirmPhoneChange(String phone, String code) async {
    if (!_remoteOn) {
      return super.confirmPhoneChange(phone, code);
    }
    await _remote.verifyPhoneChange(phone, code);
    _reauthToken = null;
    sessionRepository.patchSession({'phone': phone});
  }

  // ------------------------------------------------ hỗ trợ khách hàng

  /// SET-11/12 từ server (nội dung có version). Số báo cáo đang mở chưa có
  /// API nên không hiện số mẫu; lỗi mạng giữ bản trên máy.
  @override
  Future<HelpInfo> help() async {
    if (!_remoteOn) {
      return super.help();
    }
    final HelpCenterRecord? record;
    try {
      final language = currentL10n().localeName == 'en' ? 'en' : 'vi';
      record = await _reads.read([
        'helpCenter',
        language,
      ], () => _remote.helpCenter(language));
    } on DioException {
      /// BF-20261023-001: lỗi API không hiển thị hotline/FAQ/số báo cáo mẫu.
      return const HelpInfo();
    }
    if (record == null) {
      return const HelpInfo();
    }
    return HelpInfo(
      faqs: [for (final faq in record.faqs) faq.question],
      faqAnswers: [for (final faq in record.faqs) faq.answer],
      email: record.contact?.email ?? '',
      hotline: record.contact?.hotline ?? '',
      termsUrl: record.legal?.termsUrl,
      privacyUrl: record.legal?.privacyUrl,
    );
  }

  @override
  Future<List<String>> supportCategories() async {
    if (!_remoteOn) {
      return super.supportCategories();
    }
    return _remote.supportCategories();
  }

  /// Không gửi kèm dữ liệu của bé; chỉ nội dung người dùng tự nhập và gia đình
  /// đang mở (để CSKH biết ngữ cảnh).
  @override
  Future<SupportTicket> sendSupportRequest({
    required String category,
    required String subject,
    required String body,
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.sendSupportRequest(
        category: category,
        subject: subject,
        body: body,
      );
    }
    final ticket = await _remote.createSupportTicket({
      'category': category,
      'subject': subject,
      'body': body,
      'familyId': serverFamilyId,
    });
    return ticket ?? const SupportTicket();
  }

  @override
  Future<SupportTicketDetail?> supportTicket(String ticketId) async {
    if (!_remoteOn) {
      return super.supportTicket(ticketId);
    }
    return _remote.supportTicket(ticketId);
  }

  @override
  Future<void> sendSupportMessage(String ticketId, String body) async {
    if (!_remoteOn) {
      return super.sendSupportMessage(ticketId, body);
    }
    await _remote.sendSupportMessage(ticketId, body);
  }

  @override
  Future<List<SupportTicket>> supportTickets() async {
    if (!_remoteOn) {
      return super.supportTickets();
    }
    return _remote.supportTickets();
  }

  // ------------------------------------------------ xoá gia đình (§7.25)

  FamilyDeletionInfo _deletionOf(FamilyDeletionRecord? record) {
    final status = switch (record?.status) {
      'AWAITING_PARTNER' => FamilyDeletionStatus.awaitingPartner,
      'SCHEDULED' => FamilyDeletionStatus.scheduled,
      _ => FamilyDeletionStatus.none,
    };
    final serverMe =
        sessionRepository.session()[kValueSessionKeyServerUserId] as String?;
    return FamilyDeletionInfo(
      status: status,
      requestedByMe:
          record?.requestedBy != null && record?.requestedBy == serverMe,
      scheduledFor: record?.scheduledFor?.toLocal(),
      graceDays: record?.graceDays ?? 30,
    );
  }

  String get _reauthOrThrow {
    final token = _reauthToken;
    if (token == null) {
      throw StateError('REAUTH_REQUIRED');
    }
    return token;
  }

  @override
  Future<FamilyDeletionInfo> familyDeletion() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.familyDeletion();
    }
    return _deletionOf(await _remote.familyDeletion(serverFamilyId));
  }

  @override
  Future<FamilyDeletionInfo> requestFamilyDeletion() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.requestFamilyDeletion();
    }
    final record = await _remote.requestFamilyDeletion(
      serverFamilyId,
      _reauthOrThrow,
    );
    _reauthToken = null;
    return _deletionOf(record);
  }

  @override
  Future<FamilyDeletionInfo> confirmFamilyDeletion() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.confirmFamilyDeletion();
    }
    final record = await _remote.confirmFamilyDeletion(
      serverFamilyId,
      _reauthOrThrow,
    );
    _reauthToken = null;
    return _deletionOf(record);
  }

  @override
  Future<FamilyDeletionInfo> cancelFamilyDeletion() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.cancelFamilyDeletion();
    }
    return _deletionOf(await _remote.cancelFamilyDeletion(serverFamilyId));
  }

  // ------------------------------------------------------------ RPT-02 chặn

  /// Danh sách đã chặn trong gia đình đang mở, từ server.
  @override
  Future<List<BlockedPerson>> blockedPeople() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.blockedPeople();
    }
    final rows = await _remote.blocks(serverFamilyId);
    return [
      for (final row in rows)
        if (row.userId != null)
          BlockedPerson(
            id: row.userId!,
            name: row.displayName ?? '',
            blockedAt: row.blockedAt?.toLocal(),
          ),
    ];
  }

  /// Chặn theo tài khoản (userId của thành viên); gỡ khỏi gia đình là việc
  /// của Family service (màn gọi riêng).
  @override
  Future<void> blockMember(
    String memberId, {
    bool removeFromFamily = false,
  }) async {
    final serverFamilyId = _serverFamilyId;
    final userId = _family.member(memberId)?['userId'] as String?;
    if (serverFamilyId == null || userId == null) {
      return super.blockMember(memberId, removeFromFamily: removeFromFamily);
    }
    await _remote.block(serverFamilyId, userId);
  }

  /// [blockedId] là userId của người bị chặn (bản server).
  @override
  Future<void> unblock(String blockedId) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.unblock(blockedId);
    }
    await _remote.unblock(serverFamilyId, blockedId);
  }

  // ------------------------------------------------------------ thiết bị

  /// SET-07: thiết bị = phiên đăng nhập trên server; khoá Face ID/PIN vẫn là
  /// cài đặt trên máy.
  @override
  Future<SecuritySettings> securitySettings() async {
    final saved = await super.securitySettings();
    if (!_remoteOn) {
      return saved;
    }

    /// BF-20261023-001: khoá Face ID/PIN mẫu không phải thiết lập trên máy thật.
    final local =
        _store.section('security')['_serverFamilyId'] == _serverFamilyId
        ? saved
        : const SecuritySettings(faceIdLock: false, pinSet: false);
    final sessions = await _reads.read([
      'sessions',
      sessionRepository.session()[kValueSessionKeyServerUserId],
    ], () => _remote.sessions());
    return local.copyWith(
      devices: [
        for (final session in sessions)
          if (session.id != null)
            LoginDevice(
              id: session.id!,
              name: session.deviceModel ?? _platformName(session.platform),
              lastActiveAt: session.lastUsedAt?.toLocal(),
              current: session.current,
            ),
      ],
    );
  }

  /// BF-20261023-001: đánh dấu tuỳ chọn bảo mật thực sự được người dùng lưu.
  @override
  Future<void> saveSecuritySettings(SecuritySettings settings) async {
    await super.saveSecuritySettings(settings);
    if (_remoteOn) {
      _store.saveSection('security', {
        ...settings.toJson(),
        '_serverFamilyId': _serverFamilyId,
      });
    }
  }

  @override
  Future<void> signOutDevice(String deviceId) async {
    if (!_remoteOn) {
      return super.signOutDevice(deviceId);
    }
    await _remote.revokeSession(deviceId);
  }

  @override
  Future<void> signOutOtherDevices() async {
    if (!_remoteOn) {
      return super.signOutOtherDevices();
    }
    await _remote.revokeOtherSessions();
  }

  /// Tên nền tảng (danh từ riêng, không dịch) khi server không có tên máy.
  static String _platformName(String? platform) => switch (platform) {
    'IOS' => 'iOS',
    'ANDROID' => 'Android',
    'WEB' => 'Web',
    _ => '—',
  };

  // ------------------------------------------------------------ xuất dữ liệu

  /// BF-20261023-001: chỉ job có id server; chưa đo cache thì không hiện 486 MB.
  Future<DataExportInfo> _exportInfo() async {
    final local = await super.dataExport();
    return !_remoteOn
        ? local
        : local.copyWith(
            cacheMb: 0,
            jobs: local.jobs.where((job) => job.exportId != null).toList(),
          );
  }

  @override
  Future<DataExportInfo> dataExport() async {
    final info = await _exportInfo();
    if (!_remoteOn) {
      return info;
    }
    final jobs = <DataExportJob>[];
    var changed = false;
    for (final job in info.jobs) {
      final id = job.exportId;
      if (id == null || job.status == DataExportStatus.idle) {
        jobs.add(job);
        continue;
      }
      final record = await _remote.export(id);
      final next = record == null ? null : _toJob(job.kind, record);
      changed = changed || next != job;
      if (next != null) {
        jobs.add(next);
      }
    }
    if (!changed) {
      return info;
    }
    final updated = info.copyWith(jobs: jobs);
    _store.saveSection('dataExport', updated.toJson());
    return updated;
  }

  @override
  Future<void> startExport(DataExportKind kind) async {
    if (!_remoteOn) {
      return super.startExport(kind);
    }
    final record = await _remote.createExport(
      kind == DataExportKind.family ? 'FAMILY' : 'PERSONAL',
      familyId: kind == DataExportKind.family ? _serverFamilyId : null,
    );
    final info = await _exportInfo();
    final job =
        (record == null ? null : _toJob(kind, record)) ??
        DataExportJob(kind: kind, status: DataExportStatus.preparing);
    _store.saveSection(
      'dataExport',
      info
          .copyWith(
            jobs: [job, ...info.jobs.where((item) => item.kind != kind)],
          )
          .toJson(),
    );
  }

  @override
  Future<String?> exportDownloadUrl(DataExportKind kind) async {
    if (!_remoteOn) {
      return super.exportDownloadUrl(kind);
    }
    final info = await _exportInfo();
    final id = info.jobs.where((job) => job.kind == kind).firstOrNull?.exportId;
    if (id == null) {
      return null;
    }
    final record = await _remote.export(id);
    return record?.download?.url;
  }

  /// QUEUED/PROCESSING → đang chuẩn bị; COMPLETED có link → sẵn sàng; còn lại
  /// (FAILED, EXPIRED) → bỏ khỏi danh sách để người dùng xuất lại.
  DataExportJob? _toJob(DataExportKind kind, DataExportRecord record) {
    final status = switch (record.status) {
      'QUEUED' || 'PROCESSING' => DataExportStatus.preparing,
      'COMPLETED' when record.download != null => DataExportStatus.ready,
      _ => null,
    };
    if (status == null) {
      return null;
    }
    return DataExportJob(
      kind: kind,
      status: status,
      startedAt: record.createdAt?.toLocal(),
      expiresAt: record.expiresAt?.toLocal(),
      exportId: record.id,
    );
  }

  // ------------------------------------------------------------ xoá tài khoản

  @override
  Future<DeleteAccountInfo> deleteAccountInfo() async {
    final info = await super.deleteAccountInfo();
    if (!_remoteOn) {
      return info;
    }
    final preview = await _remote.deletionPreview();
    final phone = sessionRepository.session()['phone'] as String?;

    /// BF-20261023-001: API preview chưa có số ký ức đã đăng.
    return info.copyWith(
      postedMemories: 0,
      onlyParent:
          preview?.familyChoices.contains('DELETE_FAMILY') ?? info.onlyParent,
      purgeDate: today.add(Duration(days: preview?.graceDays ?? 30)),
      // Server chưa có xác thực lại qua Apple — chỉ dùng OTP.
      maskedAppleAccount: null,
      maskedPhone: _maskPhone(phone),
    );
  }

  @override
  Future<void> requestReauthOtp() async {
    if (!_remoteOn) {
      return super.requestReauthOtp();
    }
    _reauthToken = null;
    await _remote.requestReauthOtp();
  }

  @override
  Future<void> verifyReauth(String code) async {
    if (!_remoteOn) {
      return super.verifyReauth(code);
    }
    final token = await _remote.verifyReauthOtp(code);
    final value = token?.reauthToken;
    if (value == null || value.isEmpty) {
      throw StateError('Missing reauth token');
    }
    _reauthToken = value;
  }

  @override
  Future<void> deleteAccount({bool keepMemories = true}) async {
    if (!_remoteOn) {
      return super.deleteAccount(keepMemories: keepMemories);
    }
    final token = _reauthToken;
    if (token == null) {
      throw StateError('Reauthentication required');
    }
    final preview = await _remote.deletionPreview();
    await _remote.requestDeletion(
      familyChoice: preview?.familyChoices.firstOrNull ?? 'NONE',
      sharedContentChoice: keepMemories ? 'KEEP_ANONYMIZED' : 'DELETE',
      reauthToken: token,
    );
    _reauthToken = null;
    // Server đã thu hồi mọi phiên; dọn phiên trên máy.
    await _session.signOut();
  }

  /// `+84901234456` → `••• 456`.
  static String? _maskPhone(String? phone) {
    final digits = phone?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.length < 3) {
      return null;
    }
    return '••• ${digits.substring(digits.length - 3)}';
  }
}
