import 'package:baby_family/data/dto/family_deletion_info.dart';
import 'package:baby_family/data/model/account/data_export_record.dart';
import 'package:baby_family/data/model/privacy/family_deletion_record.dart';
import 'package:baby_family/data/model/settings/ai_settings.dart';
import 'package:baby_family/data/model/settings/blocked_person.dart';
import 'package:baby_family/data/model/settings/data_export_info.dart';
import 'package:baby_family/data/model/settings/data_export_job.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/model/settings/login_device.dart';
import 'package:baby_family/data/model/settings/notification_settings.dart';
import 'package:baby_family/data/model/settings/notification_settings_record.dart';
import 'package:baby_family/data/model/settings/privacy_settings.dart';
import 'package:baby_family/data/model/settings/profile_settings.dart';
import 'package:baby_family/data/model/settings/security_settings.dart';
import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/repository/account_remote.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/media.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository/settings.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/settings.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

/// SET-08/09 qua server thật (BF-20261018-013, mục 7.25):
/// - Xuất dữ liệu: tạo job trên server, nhớ id job trong mục `dataExport` để
///   hỏi lại trạng thái; link tải lấy mới mỗi lần bấm (hết hạn ~15 phút).
/// - Xoá tài khoản: xác thực lại bằng OTP tới số của chính tôi, giữ mã xác thực
///   lại trong bộ nhớ (≤ 5 phút), gửi yêu cầu xoá có 30 ngày chờ rồi đăng xuất.
/// Các mục cài đặt khác vẫn dùng bản trên máy.
class SettingsRemoteServiceImp extends SettingsServiceImp {
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

  Future<String> _uploadAvatar(String path) async {
    final bytes = await _media.readLocalFile(path);
    final intent = await _remote.createAvatarIntent(const Uuid().v4(), {
      'purpose': 'AVATAR',
      'mime': MediaUploader.mimeOf(path),
      'size': bytes.length,
      'sha256': sha256.convert(bytes).toString(),
    });
    final assetId = intent?.assetId;
    if (assetId == null) {
      throw StateError('Avatar upload intent without asset');
    }
    final upload = intent?.upload;
    if (intent?.status == 'PENDING_UPLOAD' && upload != null) {
      await _media.uploadBytes(upload, bytes);
      await _remote.completeAvatar(assetId);
    }
    return assetId;
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
    final local = await super.notificationSettings();
    if (!_remoteOn) {
      return local;
    }
    final record = await _remote.notificationSettings();
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
    final local = await super.aiSettings();
    if (!_remoteOn) {
      return local;
    }
    final record = await _remote.aiSettings();
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
    final local = await super.privacySettings();
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return local;
    }
    final overview = await _remote.privacyOverview(serverFamilyId);
    if (overview == null) {
      return local;
    }
    final visibility = _visibilityCodes.entries
        .where((entry) => entry.value == overview.defaults?.defaultVisibility)
        .firstOrNull
        ?.key;
    return local.copyWith(
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
    final local = await super.securitySettings();
    if (!_remoteOn) {
      return local;
    }
    final sessions = await _remote.sessions();
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

  @override
  Future<DataExportInfo> dataExport() async {
    final info = await super.dataExport();
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
    final info = await super.dataExport();
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
    final info = await super.dataExport();
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
    return info.copyWith(
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
