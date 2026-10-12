import 'package:baby_family/data/model/settings/ai_settings.dart';
import 'package:baby_family/data/model/settings/blocked_person.dart';
import 'package:baby_family/data/model/settings/data_export_info.dart';
import 'package:baby_family/data/model/settings/data_export_job.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/model/settings/help_info.dart';
import 'package:baby_family/data/model/settings/notification_settings.dart';
import 'package:baby_family/data/model/settings/privacy_settings.dart';
import 'package:baby_family/data/model/settings/profile_settings.dart';
import 'package:baby_family/data/model/settings/security_settings.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/settings.dart';
import 'package:baby_family/data/service/settings.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';

class SettingsServiceImp extends MockServiceImp implements ISettingsService {
  SettingsServiceImp(
    super.sessionRepository,
    super.clock,
    this._repository,
    this._familyRepository,
    this._childRepository,
  );

  final ISettingsRepository _repository;
  final IFamilyRepository _familyRepository;
  final IChildRepository _childRepository;

  /// Days an account waits before permanent deletion (SET-09c, mục 7.25).
  static const _deleteGraceDays = 30;

  @override
  Future<ProfileSettings> profileSettings() async {
    await ready();
    final me = _familyRepository.member(myMemberId);
    final user = sessionRepository.user(myUserId);
    return ProfileSettings.fromJson({
      ..._repository.section('profile'),
      if (user?['displayName'] case final String name when name.isNotEmpty)
        'name': name,
      if (me?['callName'] case final String callName when callName.isNotEmpty)
        'callName': callName,
      'avatarAsset': ?me?['avatarAsset'],
    });
  }

  @override
  Future<void> saveProfileSettings(ProfileSettings settings) async {
    await ready();
    _repository.saveSection('profile', settings.toJson());
    sessionRepository.upsertUser({
      'id': myUserId,
      'displayName': settings.name,
    });
    if (myMemberId != null) {
      _familyRepository.updateMember(myMemberId!, {
        'displayName': settings.name,
        'callName': settings.callName,
      });
    }
  }

  @override
  Future<NotificationSettings> notificationSettings() async {
    await ready();
    return NotificationSettings.fromJson(_repository.section('notifications'));
  }

  @override
  Future<void> saveNotificationSettings(NotificationSettings settings) async {
    await ready();
    _repository.saveSection('notifications', settings.toJson());
  }

  @override
  Future<PrivacySettings> privacySettings() async {
    await ready();
    return PrivacySettings.fromJson(_repository.section('privacy'));
  }

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) async {
    await ready();
    _repository.saveSection('privacy', settings.toJson());
  }

  @override
  Future<SecuritySettings> securitySettings() async {
    await ready();
    return SecuritySettings.fromJson(_repository.section('security'));
  }

  @override
  Future<void> saveSecuritySettings(SecuritySettings settings) async {
    await ready();
    _repository.saveSection('security', settings.toJson());
  }

  @override
  Future<void> signOutDevice(String deviceId) async {
    final current = await securitySettings();
    await saveSecuritySettings(
      current.copyWith(
        devices: current.devices.where((d) => d.id != deviceId).toList(),
      ),
    );
  }

  @override
  Future<void> signOutOtherDevices() async {
    final current = await securitySettings();
    await saveSecuritySettings(
      current.copyWith(
        devices: current.devices.where((d) => d.current).toList(),
      ),
    );
  }

  @override
  Future<DataExportInfo> dataExport() async {
    await ready();
    return DataExportInfo.fromJson(_repository.section('dataExport'));
  }

  @override
  Future<void> startExport(DataExportKind kind) async {
    final info = await dataExport();
    final job = DataExportJob(
      kind: kind,
      status: DataExportStatus.preparing,
      startedAt: now,
    );
    _repository.saveSection(
      'dataExport',
      info
          .copyWith(
            jobs: [job, ...info.jobs.where((item) => item.kind != kind)],
          )
          .toJson(),
    );
  }

  @override
  Future<void> clearCache() async {
    final info = await dataExport();
    _repository.saveSection('dataExport', info.copyWith(cacheMb: 0).toJson());
  }

  @override
  Future<DeleteAccountInfo> deleteAccountInfo() async {
    await ready();
    final members = _familyRepository.members(familyId);
    final parents = members.where(
      (row) =>
          row['role'] != FamilyRole.relative.name &&
          row['status'] == MemberStatus.active.name,
    );
    final partner = parents.where((row) => row['id'] != myMemberId).firstOrNull;
    final user = sessionRepository.user(myUserId);
    return DeleteAccountInfo.fromJson({
      ..._repository.section('deleteAccount'),
      'userName': user?['displayName'] ?? '',
      'partnerName': partner?['displayName'],
      'partnerCallName': partner?['callName'],
      'familyName': _familyRepository.family(familyId)?['name'] ?? '',
      'childNames': [
        for (final child in _childRepository.children(familyId))
          if (child['archived'] != true) child['name'],
      ],
      'onlyParent': partner == null,
      'purgeDate': today
          .add(const Duration(days: _deleteGraceDays))
          .toIso8601String(),
    });
  }

  @override
  Future<void> deleteAccount() => sessionRepository.reseed(DemoSeed.fresh);

  @override
  Future<HelpInfo> help() async {
    await ready();
    return HelpInfo.fromJson(_repository.section('help'));
  }

  // ------------------------------------------------------------ batch 3

  @override
  Future<AiSettings> aiSettings() async {
    await ready();
    final saved = _repository.section('ai');
    final features =
        (saved['features'] as List?) ??
        (_repository.catalog()['aiFeatures'] as List?) ??
        const [];
    return AiSettings.fromJson({...saved, 'features': features});
  }

  @override
  Future<void> saveAiSettings(AiSettings settings) async {
    await ready();
    _repository.saveSection('ai', settings.toJson());
  }

  @override
  Future<List<BlockedPerson>> blockedPeople() async {
    await ready();
    return _repository
        .sectionList('blocked')
        .map(BlockedPerson.fromJson)
        .toList();
  }

  void _setBlockedCount(int count) {
    final privacy = _repository.section('privacy');
    _repository.saveSection('privacy', {...privacy, 'blockedCount': count});
  }

  @override
  Future<void> blockMember(
    String memberId, {
    bool removeFromFamily = false,
  }) async {
    await ready();
    final member = _familyRepository.member(memberId);
    if (member == null) {
      return;
    }
    final blocked = [
      ..._repository.sectionList('blocked'),
      {
        'id': 'b-$memberId',
        'name': member['callName'] ?? member['displayName'] ?? '',
        'blockedAt': now.toIso8601String(),
      },
    ];
    _repository.saveSectionList('blocked', blocked);
    _setBlockedCount(blocked.length);
    if (removeFromFamily) {
      _familyRepository.updateMember(memberId, {
        'status': MemberStatus.removed.name,
      });
    }
  }

  @override
  Future<void> unblock(String blockedId) async {
    await ready();
    final blocked = _repository
        .sectionList('blocked')
        .where((row) => row['id'] != blockedId)
        .toList();
    _repository.saveSectionList('blocked', blocked);
    _setBlockedCount(blocked.length);
  }
}
