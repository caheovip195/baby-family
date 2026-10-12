import 'package:baby_family/data/dto/account_settings_summary.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/family_membership.dart';
import 'package:baby_family/data/model/family/family_settings.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_details.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/service/family.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FamilyServiceImp extends MockServiceImp implements IFamilyService {
  FamilyServiceImp(super.sessionRepository, super.clock, this._repository);

  final IFamilyRepository _repository;

  @override
  Future<Family?> currentFamily() async {
    await ready();
    final row = _repository.family(familyId);
    return row == null ? null : Family.fromJson(row);
  }

  @override
  Future<List<Member>> members() async {
    await ready();
    final list = _repository
        .members(familyId)
        .map(Member.fromJson)
        .where((member) => member.status != MemberStatus.removed)
        .toList();
    list.sort((a, b) {
      final parent = (b.role.isParent ? 1 : 0) - (a.role.isParent ? 1 : 0);
      if (parent != 0) {
        return parent;
      }
      return (a.slot?.index ?? 9).compareTo(b.slot?.index ?? 9);
    });
    return list;
  }

  @override
  Future<Member?> me() async {
    await ready();
    final row = _repository.member(myMemberId);
    return row == null ? null : Member.fromJson(row);
  }

  @override
  Future<Member?> partner() async {
    final all = await members();
    return all
        .where(
          (member) =>
              member.role.isParent &&
              member.id != myMemberId &&
              member.status == MemberStatus.active,
        )
        .firstOrNull;
  }

  @override
  Future<List<PlanOffer>> planOffers() async {
    await ready();
    return _repository.planOffers().map(PlanOffer.fromJson).toList();
  }

  @override
  Future<void> purchasePlan(PlanState plan) async {
    final family = await currentFamily();
    if (family == null) {
      return;
    }
    final isFamily = plan == PlanState.family;
    _repository.updateFamily(family.id, {
      'plan': {
        ...family.plan.toJson(),
        'state': plan.name,
        'startedAt': now.toIso8601String(),
        'endsAt': DateTime(now.year + 1, now.month, now.day).toIso8601String(),
        'storageQuotaMb': isFamily ? 204800 : 51200,
        'relativeSlotsMax': isFamily ? 12 : 0,
      },
    });
  }

  @override
  Future<void> updateFamily({String? name, int? coverIndex}) async {
    await ready();
    _repository.updateFamily(familyId, {
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      'coverIndex': ?coverIndex,
    });
  }

  @override
  Future<InviteInfo> createRelativeInvite({
    required RelativeRelation relation,
    required String callName,
    List<String> childIds = const [],
    bool canComment = true,
    bool canPost = false,
  }) async {
    await ready();
    final code =
        'BN${(DateTime.now().microsecondsSinceEpoch % 1000000).toString().padLeft(6, '0')}';
    final row = _repository.addInvite({
      'code': code,
      'kind': InviteKind.relative.name,
      'familyId': familyId,
      'inviterMemberId': myMemberId,
      'role': FamilyRole.relative.name,
      'relation': relation.name,
      'callName': callName,
      'grantedChildIds': childIds,
      'canComment': canComment,
      'canPost': canPost,
      'link': 'https://babyfamily.vn/invite/$code',
      'sentAt': now.toIso8601String(),
      'expiresAt': now.add(const Duration(days: 7)).toIso8601String(),
      'status': 'open',
    });
    return InviteInfo.fromJson(row);
  }

  @override
  Future<List<InviteInfo>> pendingInvites() async {
    await ready();
    return _repository
        .invites(familyId)
        .where((row) => row['status'] == 'open')
        .map(InviteInfo.fromJson)
        .toList();
  }

  @override
  Future<void> updateMember(
    String memberId, {
    String? callName,
    List<String>? grantedChildIds,
    bool? canComment,
    bool? canPost,
  }) async {
    await ready();
    _repository.updateMember(memberId, {
      'callName': ?callName,
      'grantedChildIds': ?grantedChildIds,
      'canComment': ?canComment,
      'canPost': ?canPost,
    });
  }

  @override
  Future<void> removeRelative(String memberId) async {
    await ready();
    _repository.updateMember(memberId, {'status': MemberStatus.removed.name});
  }

  @override
  Future<AccountSettingsSummary> settingsSummary() async {
    await ready();
    final config = _repository.config();
    final quota = config['aiQuota'] as Map<String, dynamic>?;
    return AccountSettingsSummary(
      aiRemaining: quota?['remaining'] as int?,
      aiTotal: quota?['total'] as int?,
      appLockName: config['appLock'] as String?,
    );
  }

  @override
  Future<String?> appVersion() async {
    try {
      return (await PackageInfo.fromPlatform()).version;
    } catch (_) {
      return null;
    }
  }

  // ------------------------------------------------------------ batch 2

  @override
  Future<Member?> member(String memberId) async {
    await ready();
    final row = _repository.member(memberId);
    return row == null ? null : Member.fromJson(row);
  }

  @override
  Future<void> setChildPermission(
    String memberId,
    String childId,
    RelativePermission? permission,
  ) async {
    final current = await member(memberId);
    if (current == null) {
      return;
    }
    final permissions = {
      for (final entry in current.childPermissions.entries)
        entry.key: entry.value.name,
    };
    if (permission == null) {
      permissions.remove(childId);
    } else {
      permissions[childId] = permission.name;
    }
    final granted = {...current.grantedChildIds};
    permission == null || permission == RelativePermission.hidden
        ? granted.remove(childId)
        : granted.add(childId);
    _repository.updateMember(memberId, {
      'childPermissions': permissions,
      'grantedChildIds': granted.toList(),
    });
  }

  @override
  Future<void> updateRelative(
    String memberId, {
    bool? allowDownload,
    bool? notificationsMuted,
    bool? paused,
  }) async {
    await ready();
    _repository.updateMember(memberId, {
      'allowDownload': ?allowDownload,
      'notificationsMuted': ?notificationsMuted,
      'paused': ?paused,
    });
  }

  @override
  Future<FamilySettings> familySettings() async {
    await ready();
    final family = _repository.family(familyId);
    return FamilySettings.fromJson({
      ..._repository.familySettings(),
      'name': family?['name'] ?? '',
      'coverAsset': family?['coverAsset'],
    });
  }

  @override
  Future<void> saveFamilySettings(FamilySettings settings) async {
    await ready();
    _repository.updateFamily(familyId, {
      'name': settings.name,
      'coverAsset': ?settings.coverAsset,
    });
    _repository.saveFamilySettings(settings.toJson());
  }

  // ------------------------------------------------------------ batch 3

  /// FAM-05: lời mời người thân hết hạn sau 14 ngày.
  static const _relativeInviteDays = 14;

  @override
  Future<PlanDetails?> planDetails() async {
    final family = await currentFamily();
    if (family == null) {
      return null;
    }
    final details = _repository.planDetails();
    final quota = _repository.config()['aiQuota'] as Map<String, dynamic>?;
    return PlanDetails.fromJson({
      ...details,
      'plan': family.plan.toJson(),
      'aiRemaining': quota?['remaining'] ?? 0,
      'aiTotal': quota?['total'] ?? 0,
      'relativeNames': [
        for (final member in await members())
          if (member.role == FamilyRole.relative &&
              member.status == MemberStatus.active)
            member.callName,
      ],
    });
  }

  @override
  Future<List<FamilyMembership>> memberships() async {
    await ready();
    return _repository
        .memberships(myUserId)
        .map(FamilyMembership.fromJson)
        .toList();
  }

  @override
  Future<void> switchFamily(String familyId) async {
    await ready();
  }

  @override
  Future<List<InviteInfo>> relativeInvites() async {
    await ready();
    return _repository
        .invites(familyId)
        .where((row) => row['kind'] == InviteKind.relative.name)
        .map(InviteInfo.fromJson)
        .toList();
  }

  @override
  Future<void> resendInvite(String inviteId) async {
    await ready();
    _repository.updateInvite(inviteId, {'sentAt': now.toIso8601String()});
  }

  @override
  Future<void> revokeInvite(String inviteId) async {
    await ready();
    _repository.updateInvite(inviteId, {'status': 'revoked'});
  }

  @override
  Future<void> renewInvite(String inviteId) async {
    await ready();
    _repository.updateInvite(inviteId, {
      'status': 'open',
      'sentAt': now.toIso8601String(),
      'openedAt': null,
      'expiresAt': now
          .add(const Duration(days: _relativeInviteDays))
          .toIso8601String(),
    });
  }
}
