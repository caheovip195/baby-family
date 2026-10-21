import 'package:baby_family/data/dto/invite_preview_data.dart';
import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/model/session/pending_invite.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/data/service_imp/mock_service.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';

class SessionServiceImp extends MockServiceImp implements ISessionService {
  SessionServiceImp(
    super.sessionRepository,
    super.clock,
    this._familyRepository,
    this._childRepository,
  );

  final IFamilyRepository _familyRepository;
  final IChildRepository _childRepository;

  static const _newUserId = 'u-me';

  @override
  Future<AppSession> restore() async {
    await ready();
    return current;
  }

  @override
  AppSession get current {
    if (!sessionRepository.isLoaded) {
      return const AppSession();
    }
    final raw = sessionRepository.session();
    final member = _familyRepository.member(raw['memberId'] as String?);
    final role = member?['role'] ?? raw['role'];
    final pending = raw['pendingInvite'] as JsonMap?;
    return AppSession(
      state: _state(raw, member),
      userId: raw['userId'] as String?,
      familyId: raw['familyId'] as String?,
      memberId: raw['memberId'] as String?,
      role: role == null ? null : FamilyRole.values.byName(role as String),
      callName: (member?['callName'] ?? raw['callName']) as String?,
      authMethod: raw['authMethod'] == null
          ? null
          : AuthMethod.values.byName(raw['authMethod'] as String),
      phone: raw['phone'] as String?,
      stage: raw['stage'] == null
          ? null
          : FamilyStage.values.byName(raw['stage'] as String),
      pendingInvite: pending == null ? null : PendingInvite.fromJson(pending),
    );
  }

  SessionState _state(JsonMap raw, JsonMap? member) {
    if (raw['userId'] == null) {
      return SessionState.signedOut;
    }
    if (raw['profileDone'] != true) {
      return SessionState.needsProfile;
    }
    if (member == null) {
      return switch (raw['role']) {
        null => SessionState.needsRole,
        'relative' => SessionState.circleWaiting,
        _ => SessionState.needsFamily,
      };
    }
    if (member['role'] == FamilyRole.relative.name) {
      if (member['status'] != MemberStatus.active.name) {
        return SessionState.circleWaiting;
      }
      // CIR-05: the family paused sharing with this relative.
      return member['paused'] == true
          ? SessionState.circlePaused
          : SessionState.circleActive;
    }
    final familyId = member['familyId'] as String;
    final family = _familyRepository.family(familyId);
    final parents = _familyRepository
        .members(familyId)
        .where(
          (row) =>
              row['role'] != FamilyRole.relative.name &&
              row['status'] == MemberStatus.active.name,
        );
    // PARTNER_LEFT (US-00): the remaining parent keeps using the app in
    // view & download mode instead of going back to ONB-WAIT.
    final partnerLeft = family?['partnerLeftAt'] != null;
    if (family == null || (parents.length < 2 && !partnerLeft)) {
      return SessionState.waitingPartner;
    }
    if ((family['plan'] as JsonMap?)?['state'] == PlanState.expired.name) {
      return SessionState.expired;
    }
    if (family['setupCompleted'] != true) {
      return SessionState.activatedSetup;
    }
    return SessionState.active;
  }

  @override
  Future<void> signIn(AuthMethod method) async {
    await ready();
    sessionRepository.upsertUser({'id': _newUserId, 'displayName': ''});
    sessionRepository.patchSession({
      'userId': _newUserId,
      'authMethod': method.name,
    });
  }

  @override
  Future<void> requestOtp(String phone) async {
    await ready();
    sessionRepository.patchSession({'phone': phone});
  }

  @override
  Future<void> verifyOtp(String code) => signIn(AuthMethod.phone);

  @override
  String get otpHint =>
      (sessionRepository.config()['otp'] as String?) ?? '123456';

  @override
  Future<OnboardingSamples> samples() async {
    await ready();
    final config = sessionRepository.config();
    final raw = (config['samples'] as JsonMap?) ?? const {};
    DateTime? date(Object? value) =>
        value is String ? DateTime.tryParse(value) : null;
    return OnboardingSamples(
      phone: raw['phone'] as String? ?? '',
      otpPrefill: raw['otpPrefill'] as String? ?? '',
      profileName: raw['profileName'] as String? ?? '',
      pregnancyName: raw['pregnancyName'] as String? ?? '',
      dueDate: date(raw['dueDate']),
      childName: raw['childName'] as String? ?? '',
      birthDate: date(raw['birthDate']),
      partnerInviteCode: config['partnerInviteCode'] as String? ?? '',
      relativeInviteCode: config['relativeInviteCode'] as String? ?? '',
    );
  }

  @override
  String get userName {
    if (!sessionRepository.isLoaded) {
      return '';
    }
    return (sessionRepository.user(myUserId)?['displayName'] as String?) ?? '';
  }

  @override
  Future<void> saveProfile({String? name, String? avatarAsset}) async {
    await ready();
    final userId = myUserId.isEmpty ? _newUserId : myUserId;
    sessionRepository.upsertUser({
      'id': userId,
      if (name != null && name.trim().isNotEmpty) 'displayName': name.trim(),
      'avatarAsset': ?avatarAsset,
    });
    sessionRepository.patchSession({'userId': userId, 'profileDone': true});
    final pending = sessionRepository.session()['pendingInvite'] as JsonMap?;
    if (pending != null) {
      await _applyInvite(pending['code'] as String);
    }
  }

  @override
  Future<void> chooseRole(FamilyRole role, {String? callName}) async {
    await ready();
    sessionRepository.patchSession({
      'role': role.name,
      'callName': callName ?? _defaultCallName(role),
    });
  }

  @override
  Future<Family> createFamily({String? name, int coverIndex = 0}) async {
    await ready();
    final raw = sessionRepository.session();
    final role = FamilyRole.values.byName((raw['role'] as String?) ?? 'mother');
    final user = sessionRepository.user(myUserId);
    final familyName = (name == null || name.trim().isEmpty)
        ? (user?['displayName'] as String? ?? '')
        : name.trim();
    final family = _familyRepository.createFamily({
      'name': familyName,
      'coverIndex': coverIndex,
      'createdAt': now.toIso8601String(),
      'setupCompleted': false,
      'plan': {
        'state': PlanState.trial.name,
        'storageQuotaMb': 10240,
        'storageUsedMb': 0,
      },
    });
    final familyId = family['id'] as String;
    final member = _familyRepository.addMember({
      'familyId': familyId,
      'userId': myUserId,
      'role': role.name,
      'slot': ParentSlot.a.name,
      'status': MemberStatus.active.name,
      'displayName': user?['displayName'] ?? '',
      'callName': raw['callName'] ?? _defaultCallName(role),
      'isAdmin': true,
      'joinedAt': now.toIso8601String(),
    });
    // ONB-07 (Pencil `tIOQ7`): lời mời đầu tiên của phiên dùng mã mẫu
    // “K7Q2 · 9MXA”; các gia đình tạo sau nhận mã sinh từ id.
    final sampleCode =
        sessionRepository.config()['partnerInviteCode'] as String?;
    final useSample = sampleCode != null && raw['sampleInviteIssued'] != true;
    if (useSample) {
      sessionRepository.patchSession({'sampleInviteIssued': true});
    }
    _familyRepository.addInvite({
      'code': useSample
          ? sampleCode
          : 'BF${(familyId.hashCode.abs() % 1000000).toString().padLeft(6, '0')}',
      'kind': InviteKind.partner.name,
      'familyId': familyId,
      'inviterMemberId': member['id'],
      'role': role.partnerRole.name,
      'callName': _defaultCallName(role.partnerRole),
      'expiresAt': now.add(const Duration(days: 7)).toIso8601String(),
      'status': 'open',
    });
    sessionRepository.patchSession({
      'familyId': familyId,
      'memberId': member['id'],
    });
    return Family.fromJson(_familyRepository.family(familyId)!);
  }

  @override
  Future<void> cancelFamily() async {
    await ready();
    final memberId = myMemberId;
    if (memberId != null) {
      _familyRepository.updateMember(memberId, {
        'status': MemberStatus.removed.name,
      });
    }
    sessionRepository.patchSession({
      'familyId': null,
      'memberId': null,
      'role': null,
      'callName': null,
      'stage': null,
    });
  }

  @override
  Future<InviteInfo?> partnerInvite({bool? requireApproval}) async {
    await ready();
    // Bỏ qua lời mời mẫu INV-02/03/04 (`mock: true`) cùng gia đình — FAM-02
    // (seed partnerLeft) phải lấy lời mời bạn đời mới R4TB2HWN.
    final invite = _familyRepository
        .invites(familyId)
        .where(
          (row) =>
              row['kind'] == InviteKind.partner.name && row['mock'] != true,
        )
        .firstOrNull;
    return invite == null ? null : _inviteInfo(invite);
  }

  /// Bản mock: lời mời bị thu hồi qua `IFamilyService.revokeInvite`.
  @override
  Future<void> revokePartnerInvite() async {}

  @override
  Future<void> markPartnerInviteSent({bool? requireApproval}) async {
    final invite = await partnerInvite();
    if (invite != null) {
      _familyRepository.updateInvite(invite.id, {
        'sentAt': now.toIso8601String(),
        'link': invite.link ?? 'https://babyfamily.vn/invite/${invite.code}',
      });
    }
  }

  @override
  Future<void> simulatePartnerJoined() async {
    await ready();
    final me = _familyRepository.member(myMemberId);
    if (me == null) {
      return;
    }
    final partnerRole = FamilyRole.values
        .byName(me['role'] as String)
        .partnerRole;
    final partnerName =
        sessionRepository.config()['defaultPartnerName'] as String? ?? '';
    final partnerUser = sessionRepository.upsertUser({
      'id': 'u-partner-$familyId',
      'displayName': partnerName,
    });
    _familyRepository.addMember({
      'familyId': familyId,
      'userId': partnerUser['id'],
      'role': partnerRole.name,
      'slot': ParentSlot.b.name,
      'status': MemberStatus.active.name,
      'displayName': partnerName,
      'callName': _defaultCallName(partnerRole),
      'isAdmin': true,
      'joinedAt': now.toIso8601String(),
    });
    _activate(familyId);
  }

  /// BR-054: đủ Papa + Mama → cấp dùng thử theo trial policy hiện hành của
  /// catalog; expiry tính một lần (`startedAt + durationSeconds`), không làm
  /// tròn cuối ngày.
  /// Bản server: ghi đúng giai đoạn quyền lợi server trả về (dùng thử với hạn
  /// thật, hoặc hết hạn) thay cho dùng thử mô phỏng của [_activate].
  void applyServerPlan({required PlanState state, DateTime? endsAt}) {
    final family = _familyRepository.family(familyId);
    if (family == null) {
      return;
    }
    final plan = Map<String, dynamic>.from(
      (family['plan'] as Map?) ?? const <String, dynamic>{},
    );
    _familyRepository.updateFamily(familyId, {
      'plan': {
        ...plan,
        'state': state.name,
        'endsAt': endsAt?.toIso8601String() ?? plan['endsAt'],
      },
    });
  }

  /// Bản server: gia đình `PARTNER_LEFT` (US-00) — bạn đời đã rời; người còn
  /// lại xem & tải về, mời bạn đời mới (FAM-02). Bỏ bạn đời khỏi bản phản chiếu.
  void applyServerPartnerLeft({DateTime? at}) {
    final family = _familyRepository.family(familyId);
    if (family == null) {
      return;
    }
    if (family['partnerLeftAt'] == null) {
      _familyRepository.updateFamily(familyId, {
        'partnerLeftAt': (at ?? now).toIso8601String(),
      });
    }
    // Như seed `partnerLeft`: bạn đời không còn trong danh sách thành viên.
    for (final member in [..._familyRepository.members(familyId)]) {
      if (member['id'] != myMemberId &&
          member['role'] != FamilyRole.relative.name) {
        _familyRepository.removeMember(member['id'] as String);
      }
    }
  }

  /// Bản server (BF-20261019-005): phản chiếu tư cách người thân từ
  /// `GET /v1/me/circles`. [familyName] null → chưa vào gia đình nào hoặc
  /// đang chờ Bố/Mẹ duyệt (CIR-WAIT); [paused] → CIR-05. Trả id gia đình trên
  /// máy (để thêm bé được cấp quyền).
  String? applyServerCircle({
    String? familyName,
    bool paused = false,
    List<String>? grantedChildIds,
    Map<String, RelativePermission>? childPermissions,
    bool allowDownload = false,
  }) {
    final memberId = myMemberId;
    final mine = _familyRepository.member(memberId);
    if (familyName == null) {
      if (mine != null && mine['role'] == FamilyRole.relative.name) {
        _familyRepository.removeMember(memberId!);
      }
      sessionRepository.patchSession({
        'familyId': null,
        'memberId': null,
        'role': FamilyRole.relative.name,
      });
      return null;
    }
    var localFamilyId = sessionRepository.session()['familyId'] as String?;
    if (localFamilyId == null ||
        _familyRepository.family(localFamilyId) == null) {
      localFamilyId =
          _familyRepository.createFamily({
                'name': familyName,
                'coverIndex': 0,
                'createdAt': now.toIso8601String(),
                'setupCompleted': true,
              })['id']
              as String;
    } else {
      _familyRepository.updateFamily(localFamilyId, {'name': familyName});
    }
    final permissions = childPermissions ?? const {};
    final fields = <String, dynamic>{
      'paused': paused,
      'allowDownload': allowDownload,
      // CIR-05: gói tạm dừng thì server không trả danh sách bé — giữ bản cũ.
      'grantedChildIds': ?grantedChildIds,
      if (childPermissions != null)
        'childPermissions': {
          for (final entry in permissions.entries) entry.key: entry.value.name,
        },
      if (childPermissions != null)
        'canComment': permissions.values.any(
          (value) => value != RelativePermission.view,
        ),
      if (childPermissions != null)
        'canPost': permissions.values.contains(RelativePermission.contribute),
    };
    String id;
    if (mine != null &&
        mine['role'] == FamilyRole.relative.name &&
        mine['familyId'] == localFamilyId) {
      id = memberId!;
      _familyRepository.updateMember(id, fields);
    } else {
      final user = sessionRepository.user(myUserId);
      id =
          _familyRepository.addMember({
                'familyId': localFamilyId,
                'userId': myUserId,
                'role': FamilyRole.relative.name,
                'status': MemberStatus.active.name,
                'displayName': user?['displayName'] ?? '',
                'callName':
                    sessionRepository.session()['callName'] ??
                    user?['displayName'] ??
                    '',
                'joinedAt': now.toIso8601String(),
                'grantedChildIds': const <String>[],
                ...fields,
              })['id']
              as String;
    }
    sessionRepository.patchSession({
      'familyId': localFamilyId,
      'memberId': id,
      'role': FamilyRole.relative.name,
    });
    return localFamilyId;
  }

  /// AUTH-04 bản server: ảnh đại diện của tôi (URL ký) cho thành viên trên máy.
  void applyServerAvatar(String? url) {
    final memberId = myMemberId;
    if (url == null || memberId == null) {
      return;
    }
    _familyRepository.updateMember(memberId, {'avatarAsset': url});
  }

  void _activate(String familyId) {
    final policy = _familyRepository.trialPolicy();
    final seconds = policy['durationSeconds'] as int?;
    final duration = seconds == null
        ? kValueDefaultTrialDuration
        : Duration(seconds: seconds);
    final startedAt = now;
    _familyRepository.updateFamily(familyId, {
      'activatedAt': startedAt.toIso8601String(),
      'plan': {
        'state': PlanState.trial.name,
        'startedAt': startedAt.toIso8601String(),
        'endsAt': startedAt.add(duration).toIso8601String(),
        'storageUsedMb': 0,
        'storageQuotaMb': policy['storageQuotaMb'] as int? ?? 10240,
        'relativeSlotsUsed': 0,
        'relativeSlotsMax': policy['relativeSlotsMax'] as int? ?? 0,
      },
    });
    for (final invite in _familyRepository.invites(familyId)) {
      if (invite['kind'] == InviteKind.partner.name) {
        _familyRepository.updateInvite(invite['id'] as String, {
          'status': 'accepted',
        });
      }
    }
  }

  @override
  Future<void> setStage(FamilyStage stage) async {
    await ready();
    sessionRepository.patchSession({'stage': stage.name});
  }

  @override
  Future<void> completeSetup() async {
    await ready();
    if (familyId.isEmpty) {
      return;
    }
    final family = _familyRepository.family(familyId);
    if (family?['activatedAt'] == null) {
      _activate(familyId);
    }
    _familyRepository.updateFamily(familyId, {'setupCompleted': true});
  }

  @override
  Future<InvitePreviewData> previewInvite(String code) async {
    await ready();
    final invite = _resolveInvite(code);
    final info = _inviteInfo(invite);
    final children = <Child>[
      for (final id in info.grantedChildIds)
        if (_childRepository.child(id) case final row?) Child.fromJson(row),
    ];
    final hidden = <Child>[
      for (final row in _childRepository.children(info.familyId))
        if (row['kind'] == ChildKind.baby.name &&
            row['archived'] != true &&
            !info.grantedChildIds.contains(row['id']))
          Child.fromJson(row),
    ];
    _familyRepository.updateInvite(info.id, {
      'openedAt': now.toIso8601String(),
    });
    // Batch 3: INV-02/03/04 states from the invite status (mock codes
    // HETHAN01, KHOA2026, CHOXN001).
    final me = _familyRepository.member(myMemberId);
    final parentElsewhere =
        info.kind == InviteKind.partner &&
        me != null &&
        me['role'] != FamilyRole.relative.name &&
        me['familyId'] != info.familyId;
    final state = switch (info.status) {
      'expired' || 'revoked' => InvitePreviewState.invalid,
      'pendingApproval' => InvitePreviewState.waitingConfirm,
      _ when parentElsewhere => InvitePreviewState.alreadyParent,
      _ => InvitePreviewState.valid,
    };
    return InvitePreviewData(
      invite: info,
      children: children,
      hiddenChildren: info.kind == InviteKind.relative ? hidden : const [],
      state: state,
      currentFamilyName: parentElsewhere
          ? (_familyRepository.family(me['familyId'] as String?)?['name']
                as String?)
          : null,
      currentCallName: parentElsewhere ? me['callName'] as String? : null,
    );
  }

  /// Any code opens an invite: exact match, else the relative sample code for
  /// codes starting with its prefix, else the partner sample invite.
  JsonMap _resolveInvite(String code) {
    final exact = _familyRepository.inviteByCode(code);
    if (exact != null) {
      return exact;
    }
    final config = sessionRepository.config();
    final relativeCode = config['relativeInviteCode'] as String;
    final partnerCode = config['partnerInviteCode'] as String;
    final normalized = code.trim().toUpperCase();
    final fallback = normalized.startsWith(relativeCode.substring(0, 2))
        ? relativeCode
        : partnerCode;
    final invite =
        _familyRepository.inviteByCode(fallback) ??
        _familyRepository.inviteByCode(relativeCode);
    if (invite == null) {
      // INV-02: lời mời không còn hiệu lực (seed không có lời mời mẫu).
      throw StateError('invite-not-found');
    }
    return invite;
  }

  InviteInfo _inviteInfo(JsonMap invite) {
    final family = _familyRepository.family(invite['familyId'] as String);
    final inviter = _familyRepository.member(
      invite['inviterMemberId'] as String?,
    );
    return InviteInfo.fromJson({
      ...invite,
      'familyName': family?['name'],
      'inviterName': inviter?['displayName'],
      'inviterCallName': inviter?['callName'],
      'inviterAvatarAsset': inviter?['avatarAsset'],
    });
  }

  @override
  Future<void> acceptInvite(String code, {String? callName}) async {
    await ready();
    final invite = _resolveInvite(code);
    if (sessionRepository.session()['profileDone'] != true) {
      sessionRepository.patchSession({
        'pendingInvite': {
          'code': invite['code'],
          'kind': invite['kind'],
          'familyId': invite['familyId'],
        },
        'callName': ?callName,
      });
      return;
    }
    if (callName != null) {
      sessionRepository.patchSession({'callName': callName});
    }
    await _applyInvite(invite['code'] as String);
  }

  Future<void> _applyInvite(String code) async {
    final invite = _resolveInvite(code);
    final targetFamily = invite['familyId'] as String;
    final user = sessionRepository.user(myUserId);
    final raw = sessionRepository.session();
    String memberId;
    if (invite['kind'] == InviteKind.relative.name) {
      final existing = _familyRepository.member(invite['memberId'] as String?);
      if (existing != null) {
        memberId = existing['id'] as String;
        _familyRepository.updateMember(memberId, {
          'userId': myUserId,
          'status': MemberStatus.active.name,
          'joinedAt': now.toIso8601String(),
        });
      } else {
        memberId =
            _familyRepository.addMember({
                  'familyId': targetFamily,
                  'userId': myUserId,
                  'role': FamilyRole.relative.name,
                  'status': MemberStatus.active.name,
                  'displayName': user?['displayName'] ?? '',
                  'callName': invite['callName'] ?? '',
                  'relation': invite['relation'],
                  'grantedChildIds': invite['grantedChildIds'] ?? [],
                  'canComment': invite['canComment'] ?? true,
                  'canPost': invite['canPost'] ?? false,
                  'joinedAt': now.toIso8601String(),
                })['id']
                as String;
      }
    } else {
      final role = FamilyRole.values.byName(
        (invite['role'] as String?) ?? FamilyRole.father.name,
      );
      memberId =
          _familyRepository.addMember({
                'familyId': targetFamily,
                'userId': myUserId,
                'role': role.name,
                'slot': ParentSlot.b.name,
                'status': MemberStatus.active.name,
                'displayName': user?['displayName'] ?? '',
                'callName':
                    raw['callName'] ??
                    invite['callName'] ??
                    _defaultCallName(role),
                'isAdmin': true,
                'joinedAt': now.toIso8601String(),
              })['id']
              as String;
      _activate(targetFamily);
    }
    _familyRepository.updateInvite(invite['id'] as String, {
      'status': 'accepted',
    });
    sessionRepository.patchSession({
      'familyId': targetFamily,
      'memberId': memberId,
      'role': invite['kind'] == InviteKind.relative.name
          ? FamilyRole.relative.name
          : invite['role'],
      'pendingInvite': null,
    });
  }

  @override
  Future<void> declineInvite() async {
    await ready();
    sessionRepository.patchSession({'pendingInvite': null});
  }

  @override
  bool get usesServer => false;

  @override
  Future<PartnerJoinStatus> checkPartnerStatus() async {
    await ready();
    return current.state == SessionState.waitingPartner
        ? PartnerJoinStatus.waiting
        : PartnerJoinStatus.joined;
  }

  @override
  String? get pendingPartnerCallName => null;

  @override
  Future<PartnerJoinStatus> decidePartner({required bool approve}) =>
      checkPartnerStatus();

  @override
  bool get awaitingPartnerApproval => false;

  @override
  Future<void> signOut() => reseed(DemoSeed.fresh);

  @override
  Future<AppSession> changeFamily(String familyId) async => current;

  @override
  Future<void> reseed(DemoSeed seed, {String? actor}) =>
      sessionRepository.reseed(seed, actor: actor);

  static String _defaultCallName(FamilyRole role) => switch (role) {
    FamilyRole.father => kValueDefaultCallNameFather,
    FamilyRole.mother => kValueDefaultCallNameMother,
    FamilyRole.relative => '',
  };
}
