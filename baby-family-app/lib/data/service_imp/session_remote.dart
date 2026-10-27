import 'dart:io';

import 'package:baby_family/data/dto/invite_preview_data.dart';
import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/model/auth_certificate.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/circle/my_circle_record.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/model/session/bootstrap_subject.dart';
import 'package:baby_family/data/model/session/family_bootstrap.dart';
import 'package:baby_family/data/model/session/invite_resolution.dart';
import 'package:baby_family/data/model/session/me_profile.dart';
import 'package:baby_family/data/repository/auth.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/offline_snapshot.dart';
import 'package:baby_family/data/repository/onboarding.dart';
import 'package:baby_family/data/repository/social_credential.dart';
import 'package:baby_family/data/service/auth.dart';
import 'package:baby_family/data/service/session.dart';
import 'package:baby_family/data/service_imp/base.dart';
import 'package:baby_family/data/service_imp/family_remote.dart';
import 'package:baby_family/data/service_imp/session.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Đăng nhập/onboarding qua server thật (tài liệu kỹ thuật 5, 6.5, 11.3, 23.1).
///
/// Server là nguồn sự thật cho phiên, hồ sơ, vai trò, gia đình, lời mời và
/// kích hoạt/dùng thử. Sau mỗi bước thành công, trạng thái được phản chiếu vào
/// [SessionServiceImp] (kho dữ liệu trên máy) để các màn chưa có API vẫn chạy
/// theo đúng giai đoạn của phiên. Các màn đó vẫn là dữ liệu cục bộ cho tới khi
/// có API riêng (BF-20261015-012).
class SessionRemoteServiceImp extends BaseServiceImp
    implements ISessionService {
  SessionRemoteServiceImp(
    this._local,
    this._authService,
    this._authRepository,
    this._onboardingRepository,
    this._childRepository, [
    this._snapshots,
    this._social,
  ]);

  final SessionServiceImp _local;
  final IAuthService _authService;
  final IAuthRepository _authRepository;
  final IOnboardingRepository _onboardingRepository;
  final IChildRepository _childRepository;

  /// Bản chụp để mở app lúc mất mạng (null = không lưu).
  final IOfflineSnapshotRepository? _snapshots;

  /// Đăng nhập Apple/Google trên máy (null = không hỗ trợ ở bản này).
  final ISocialCredentialRepository? _social;

  MeProfile? _me;
  String? _pendingPartnerCallName;

  // Khoá phụ trong bản ghi phiên trên máy (không lộ ra [AppSession]).
  static const _keyFamilyId = kValueSessionKeyServerFamilyId;

  /// FAM-08: gia đình người dùng chọn mở (id server).
  static const _keyPreferredFamilyId = 'remotePreferredFamilyId';
  static const _keyPendingCode = 'remotePendingCode';
  static const _keyPendingCallName = 'remotePendingCallName';
  static const _keyAwaiting = 'remoteAwaiting';
  static const _keyServerSubject = kValueChildKeyServerSubject;

  JsonMap get _raw => _local.sessionRepository.session();

  void _patch(JsonMap patch) => _local.sessionRepository.patchSession(patch);

  String? get _familyId => _raw[_keyFamilyId] as String?;

  @override
  bool get usesServer => true;

  @override
  AppSession get current => _local.current;

  @override
  String get userName => _local.userName;

  @override
  String get otpHint => '';

  @override
  Future<OnboardingSamples> samples() async => const OnboardingSamples();

  @override
  Future<AppSession> restore() async {
    await _local.restore();
    final certificate = await _authService.currentSession();
    if (certificate?.accessToken == null) {
      if (_local.current.state != SessionState.signedOut) {
        await _local.signOut();
      }
      return _local.current;
    }
    try {
      await _syncFromServer();
    } on DioException catch (error) {
      Logger().e('Không đồng bộ được phiên: ${error.message}');
      if (error.response?.statusCode == 401) {
        await _local.signOut();
      } else {
        await _restoreSnapshot();
      }
    }
    return _local.current;
  }

  /// AUTH-01 Apple/Google: lấy JWT của nhà cung cấp trên máy → server xác
  /// minh và phát hành phiên (không gộp tài khoản theo email). Đóng hộp thoại
  /// → [SocialSignInCancelled].
  @override
  Future<void> signIn(AuthMethod method) async {
    final social = _social;
    if (social == null || method == AuthMethod.phone) {
      throw UnsupportedError(currentL10n().authProviderUnavailable);
    }
    final AuthCertificate certificate;
    if (method == AuthMethod.apple) {
      final apple = await social.apple();
      certificate = await _authRepository.signInWithApple(
        identityToken: apple.identityToken,
        nonce: apple.rawNonce,
        fullName: apple.fullName,
      );
    } else {
      certificate = await _authRepository.signInWithGoogle(
        await social.google(),
      );
    }
    await _authService.saveSession(certificate);
    await _local.signIn(method);
    await _afterSignIn();
  }

  @override
  Future<void> requestOtp(String phone) async {
    await _authRepository.requestPhoneOtp(phone);
    await _local.requestOtp(phone);
  }

  @override
  Future<void> verifyOtp(String code) async {
    final phone = _local.current.phone ?? '';
    final certificate = await _authRepository.verifyPhoneOtp(
      phone: phone,
      code: code,
      device: _device,
    );
    await _authService.saveSession(certificate);
    await _local.verifyOtp(code);
    await _afterSignIn();
  }

  /// Sau khi có phiên (OTP, Apple, Google): đăng ký thiết bị, đồng bộ hồ sơ
  /// và áp dụng lời mời đang chờ.
  Future<void> _afterSignIn() async {
    try {
      await _authRepository.registerDevice(_device);
    } on DioException catch (error) {
      Logger().w('Đăng ký thiết bị thất bại: ${error.message}');
    }
    await _syncFromServer();
    // Tài khoản đã có hồ sơ bỏ qua AUTH-04: áp dụng lời mời đang chờ ngay.
    final pending = _raw[_keyPendingCode] as String?;
    if (pending != null && (_me?.profileCompleted ?? false)) {
      await _acceptRemote(pending, _raw[_keyPendingCallName] as String?);
    }
  }

  @override
  Future<void> saveProfile({String? name, String? avatarAsset}) async {
    final displayName = name?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      await _authRepository.updateProfile({'displayName': displayName});
    }
    await _authRepository.recordConsents([
      for (final document in const ['TERMS', 'PRIVACY'])
        {
          'document': document,
          'version': kValueLegalDocumentVersion,
          'granted': true,
        },
    ], platform: _platform);
    await _local.saveProfile(name: name, avatarAsset: avatarAsset);
    final pending = _raw[_keyPendingCode] as String?;
    if (pending != null) {
      await _acceptRemote(pending, _raw[_keyPendingCallName] as String?);
    }
  }

  @override
  Future<void> chooseRole(FamilyRole role, {String? callName}) async {
    _me = await _authRepository.setOnboardingRole(_onboardingRole(role));
    await _local.chooseRole(role, callName: callName);
  }

  @override
  Future<Family> createFamily({String? name, int coverIndex = 0}) async {
    final familyName = (name == null || name.trim().isEmpty)
        ? _local.userName
        : name.trim();
    final callName = _local.current.callName;
    final bootstrap = await _onboardingRepository.createFamily(
      name: familyName,
      callName: callName == null || callName.isEmpty ? null : callName,
    );
    _patch({_keyFamilyId: bootstrap?.family?.id});
    return _local.createFamily(name: familyName, coverIndex: coverIndex);
  }

  @override
  Future<void> cancelFamily() async {
    final familyId = _familyId;
    if (familyId != null) {
      await _onboardingRepository.cancelFamily(familyId);
    }
    _patch({_keyFamilyId: null});
    await _local.cancelFamily();
  }

  /// BF-20261023-001: server không cấp được mã thì không trả lời mời mẫu.
  @override
  Future<InviteInfo?> partnerInvite({bool? requireApproval}) async {
    final base = await _local.partnerInvite();
    final familyId = _familyId;
    if (familyId == null) {
      return base;
    }
    var cached = await _onboardingRepository.cachedPartnerInvite(familyId);
    final expiresAt = DateTime.tryParse(cached?['expiresAt'] as String? ?? '');
    final stale =
        cached == null ||
        expiresAt == null ||
        !expiresAt.isAfter(DateTime.now()) ||
        (requireApproval != null &&
            cached['requiresApproval'] != requireApproval);
    if (stale) {
      final issued = await _onboardingRepository.createPartnerInvite(
        familyId,
        requireFinalApproval: requireApproval ?? true,
      );
      if (issued?.code == null) {
        return null;
      }
      cached = {
        'inviteId': issued!.inviteId,
        'code': issued.code,
        'url': issued.url,
        'expiresAt': issued.expiresAt?.toIso8601String(),
        'requiresApproval': requireApproval ?? true,
      };
      await _onboardingRepository.cachePartnerInvite(familyId, cached);
    }
    final code = cached['code'] as String;
    final link = cached['url'] as String?;
    final expires = DateTime.tryParse(cached['expiresAt'] as String? ?? '');
    final requires = cached['requiresApproval'] as bool? ?? true;
    final role = _local.current.role ?? FamilyRole.mother;
    return (base ??
            InviteInfo(
              id: cached['inviteId'] as String? ?? code,
              code: code,
              kind: InviteKind.partner,
              familyId: familyId,
              role: role.partnerRole,
            ))
        .copyWith(
          code: code,
          link: link,
          expiresAt: expires,
          requiresApproval: requires,
        );
  }

  /// FAM-02 “Thu hồi lời mời”: server không có route thu hồi riêng — cấp lời
  /// mời mới thì server tự thu hồi lời mời cũ (link/mã cũ hết hiệu lực).
  @override
  Future<void> revokePartnerInvite() async {
    final familyId = _familyId;
    if (familyId == null) {
      return _local.revokePartnerInvite();
    }
    final cached = await _onboardingRepository.cachedPartnerInvite(familyId);
    final issued = await _onboardingRepository.createPartnerInvite(
      familyId,
      requireFinalApproval: cached?['requiresApproval'] as bool? ?? true,
    );
    if (issued?.code == null) {
      return;
    }
    await _onboardingRepository.cachePartnerInvite(familyId, {
      'inviteId': issued!.inviteId,
      'code': issued.code,
      'url': issued.url,
      'expiresAt': issued.expiresAt?.toIso8601String(),
      'requiresApproval': cached?['requiresApproval'] as bool? ?? true,
    });
  }

  @override
  Future<void> markPartnerInviteSent({bool? requireApproval}) async {
    // Đổi lựa chọn “xác nhận lần cuối” trước khi gửi → tạo lời mời mới.
    await partnerInvite(requireApproval: requireApproval);
    await _local.markPartnerInviteSent();
  }

  @override
  Future<void> simulatePartnerJoined() async {
    await checkPartnerStatus();
  }

  @override
  Future<PartnerJoinStatus> checkPartnerStatus() async {
    final familyId = _familyId;
    if (familyId == null) {
      return PartnerJoinStatus.waiting;
    }
    final bootstrap = await _onboardingRepository.bootstrap(familyId);
    if (bootstrap?.family?.status == 'ACTIVE') {
      _pendingPartnerCallName = null;
      await _mirrorActivated(familyId, bootstrap);
      // Gia đình vừa kích hoạt: lưu ngay để mở app lúc mất mạng không quay về
      // màn chờ bạn đời (BF-20261022-005).
      await _saveSnapshot();
      return PartnerJoinStatus.joined;
    }
    try {
      final invite = await _onboardingRepository.partnerInviteStatus(familyId);
      if (invite?.status == 'AWAITING_APPROVAL') {
        _pendingPartnerCallName = invite?.acceptedCallName;
        return PartnerJoinStatus.awaitingApproval;
      }
    } on DioException catch (error) {
      if (error.response?.statusCode != 404) {
        rethrow;
      }
    }
    _pendingPartnerCallName = null;
    return PartnerJoinStatus.waiting;
  }

  @override
  String? get pendingPartnerCallName => _pendingPartnerCallName;

  @override
  Future<PartnerJoinStatus> decidePartner({required bool approve}) async {
    final familyId = _familyId;
    if (familyId == null) {
      return PartnerJoinStatus.waiting;
    }
    final invite = await _onboardingRepository.partnerInviteStatus(familyId);
    final inviteId = invite?.inviteId;
    if (inviteId != null && invite?.status == 'AWAITING_APPROVAL') {
      await _onboardingRepository.decideInvite(inviteId, approve: approve);
    }
    return checkPartnerStatus();
  }

  @override
  bool get awaitingPartnerApproval => _raw[_keyAwaiting] == true;

  @override
  Future<void> setStage(FamilyStage stage) => _local.setStage(stage);

  @override
  Future<void> completeSetup() async {
    final familyId = _familyId;
    if (familyId != null) {
      await _onboardingRepository.markSetupDone(familyId);
    }
    await _local.completeSetup();
    await _saveSnapshot();
  }

  @override
  Future<InvitePreviewData> previewInvite(String code) async {
    final normalized = code.trim();
    final resolved = await () async {
      try {
        return await _onboardingRepository.resolveInvite(normalized);
      } on DioException catch (error) {
        final status = error.response?.statusCode;
        if (status == 404 || status == 400) {
          throw StateError('invite-not-found');
        }
        rethrow;
      }
    }();
    if (resolved != null && resolved.type == 'CIRCLE') {
      return _circlePreview(normalized, resolved);
    }
    if (resolved == null || resolved.type != 'PARTNER') {
      throw StateError('invite-not-found');
    }
    final role = _parentRole(resolved.proposedKind) ?? FamilyRole.father;
    final invite = InviteInfo(
      id: resolved.inviteId ?? normalized,
      code: normalized,
      kind: InviteKind.partner,
      familyId: '',
      familyName: resolved.familyName,
      inviterCallName: resolved.inviterCallName,
      message: resolved.message,
      role: role,
      callName: role == FamilyRole.mother
          ? kValueDefaultCallNameMother
          : kValueDefaultCallNameFather,
      expiresAt: resolved.expiresAt,
      status: resolved.state == 'VALID' ? 'open' : 'expired',
      requiresApproval: true,
    );
    final elsewhere = _me?.families.where(
      (family) => family.status != 'WAITING_PARTNER',
    );
    final current = elsewhere == null || elsewhere.isEmpty
        ? null
        : elsewhere.first;
    return InvitePreviewData(
      invite: invite,
      // §7.3: gia đình PARTNER_LEFT mời bạn đời mới → hiện tên các bé.
      children: [
        for (final subject in resolved.children)
          if (subject.id != null)
            Child(id: subject.id!, familyId: '', name: subject.name ?? ''),
      ],
      state: resolved.state != 'VALID'
          ? InvitePreviewState.invalid
          : awaitingPartnerApproval
          ? InvitePreviewState.waitingConfirm
          : current != null
          ? InvitePreviewState.alreadyParent
          : InvitePreviewState.valid,
      currentFamilyName: current?.name,
      currentCallName: current?.callName,
    );
  }

  /// INV-01 lời mời người thân: chỉ bé/thai kỳ được cấp quyền (server lọc).
  InvitePreviewData _circlePreview(String code, InviteResolution resolved) {
    final invite = InviteInfo(
      id: resolved.inviteId ?? code,
      code: code,
      kind: InviteKind.relative,
      familyId: '',
      familyName: resolved.familyName,
      inviterCallName: resolved.inviterCallName,
      message: resolved.message,
      relation: FamilyRemoteServiceImp.appRelation(resolved.relation),
      // Tên gọi Bố/Mẹ đặt cho người được mời (“Bà Nội”…), trống → nhãn quan hệ.
      callName: switch (resolved.displayName?.trim()) {
        final String name when name.isNotEmpty => name,
        _ => null,
      },
      grantedChildIds: [for (final subject in resolved.children) ?subject.id],
      // Quyền theo từng bé của server (trước đây luôn hiện “Chỉ xem” —
      // BF-20261026-004).
      canComment: resolved.children.any(
        (subject) => subject.permission != null && subject.permission != 'VIEW',
      ),
      canPost: resolved.children.any(
        (subject) => subject.permission == 'CONTRIBUTE',
      ),
      expiresAt: resolved.expiresAt,
      status: resolved.state == 'VALID' ? 'open' : 'expired',
    );
    return InvitePreviewData(
      invite: invite,
      children: [
        for (final subject in resolved.children)
          if (subject.id != null)
            Child(
              id: subject.id!,
              familyId: '',
              name: subject.name ?? '',
              kind: subject.kind == 'PREGNANCY'
                  ? ChildKind.pregnancy
                  : ChildKind.baby,
            ),
      ],
      childAccess: {
        for (final subject in resolved.children)
          if (subject.id != null)
            subject.id!: (
              permission: FamilyRemoteServiceImp.appPermission(
                subject.permission,
              ),
              allowDownload: subject.allowDownload ?? false,
            ),
      },
      state: resolved.state != 'VALID'
          ? InvitePreviewState.invalid
          : awaitingPartnerApproval
          ? InvitePreviewState.waitingConfirm
          : InvitePreviewState.valid,
    );
  }

  @override
  Future<void> acceptInvite(String code, {String? callName}) async {
    // Kho trên máy phải tải xong trước khi ghi khoá phụ (không bị seed ghi đè).
    await _local.restore();
    final certificate = await _authService.currentSession();
    final signedIn =
        certificate?.accessToken != null &&
        _local.current.state != SessionState.signedOut &&
        _local.current.state != SessionState.needsProfile;
    if (!signedIn) {
      // Áp dụng sau AUTH-03/04 (INV-01 khi chưa đăng nhập).
      _patch({_keyPendingCode: code.trim(), _keyPendingCallName: callName});
      return;
    }
    await _acceptRemote(code.trim(), callName);
  }

  @override
  Future<void> declineInvite() async {
    await _local.restore();
    final code = _raw[_keyPendingCode] as String?;
    if (code != null && (await _authService.currentSession()) != null) {
      try {
        await _onboardingRepository.declineInvite(code);
      } on DioException catch (error) {
        Logger().w('Từ chối lời mời thất bại: ${error.message}');
      }
    }
    _patch({_keyPendingCode: null, _keyPendingCallName: null});
    await _local.declineInvite();
  }

  @override
  Future<void> signOut() async {
    await _authService.logout();
    _me = null;
    _pendingPartnerCallName = null;
    await _local.signOut();
  }

  /// FAM-08: xoá bản phản chiếu của gia đình đang mở (dữ liệu mẫu `fresh`),
  /// ghi nhớ gia đình được chọn rồi đồng bộ lại từ server.
  @override
  Future<AppSession> changeFamily(String familyId) async {
    if (_local.sessionRepository.session()[_keyFamilyId] == familyId) {
      return current;
    }
    await _local.reseed(DemoSeed.fresh);
    _patch({_keyPreferredFamilyId: familyId});
    await _syncFromServer();
    return current;
  }

  @override
  Future<void> reseed(DemoSeed seed, {String? actor}) =>
      _local.reseed(seed, actor: actor);

  Future<void> _acceptRemote(String code, String? callName) async {
    final decision = await _onboardingRepository.acceptInvite(
      code,
      callName: callName,
    );
    _patch({_keyPendingCode: null, _keyPendingCallName: null});
    if (decision?.status == 'AWAITING_APPROVAL') {
      _patch({_keyAwaiting: true});
    }
    await _syncFromServer();
  }

  @override
  Future<void> persistOffline() => _saveSnapshot();

  Future<void> _saveSnapshot() async {
    final snapshots = _snapshots;
    if (snapshots == null || _local.current.state == SessionState.signedOut) {
      return;
    }
    try {
      await snapshots.save(_local.sessionRepository.exportOfflineSnapshot());
    } on Object catch (error) {
      Logger().w('Không lưu được dữ liệu dùng khi mất mạng: $error');
    }
  }

  /// Mở app lúc mất mạng (kho trên máy vừa dựng lại, chưa có dữ liệu server):
  /// dùng bản chụp lần đồng bộ trước để giữ phiên và dữ liệu đã có.
  Future<void> _restoreSnapshot() async {
    final snapshots = _snapshots;
    final state = _local.current.state;
    if (snapshots == null ||
        (state != SessionState.signedOut &&
            state != SessionState.needsProfile &&
            state != SessionState.needsRole)) {
      return;
    }
    final snapshot = await snapshots.load();
    if (snapshot != null) {
      _local.sessionRepository.importOfflineSnapshot(snapshot);
    }
  }

  /// Phản chiếu `GET /me` (+ bootstrap) vào phiên trên máy.
  /// Mỗi lần phiên đổi theo server (đăng nhập, nhận lời mời, duyệt, đổi
  /// gia đình…) lưu luôn bản chụp dùng khi mở app lúc mất mạng — trước đây
  /// chỉ lưu lúc mở app nên mở offline có thể quay về trạng thái cũ.
  Future<void> _syncFromServer() async {
    await _pullSession();
    await _saveSnapshot();
  }

  Future<void> _pullSession() async {
    final me = await _authRepository.getMeProfile();
    if (me == null) {
      return;
    }
    _me = me;
    await _local.restore();
    _patch({kValueSessionKeyServerUserId: me.id});
    if (_local.current.state == SessionState.signedOut) {
      await _local.signIn(AuthMethod.phone);
    }
    if (me.profileCompleted &&
        _local.current.state == SessionState.needsProfile) {
      await _local.saveProfile(name: me.displayName);
    }
    _patch({_keyAwaiting: me.awaitingApproval.isNotEmpty ? true : null});
    // FAM-08: gia đình đã chọn; không phải nhà mình làm Bố/Mẹ → nhà là người
    // thân.
    final preferred =
        _local.sessionRepository.session()[_keyPreferredFamilyId] as String?;
    final family =
        me.families.where((item) => item.familyId == preferred).firstOrNull ??
        me.families.firstOrNull;
    final preferCircle =
        preferred != null &&
        !me.families.any((item) => item.familyId == preferred);
    if ((family == null || preferCircle) && await _syncCircle(preferred)) {
      _local.applyServerAvatar(me.avatarUrl);
      return;
    }
    if (family == null) {
      if (_local.current.familyId != null) {
        await _local.cancelFamily();
      }
      _patch({_keyFamilyId: null});
      final role = _onboardingRoleOf(me.onboardingRole);
      if (role != null && _local.current.role != role) {
        await _local.chooseRole(role);
      }
      return;
    }
    if (_local.current.familyId == null) {
      await _local.chooseRole(
        _parentRole(family.kind) ?? FamilyRole.mother,
        callName: family.callName,
      );
      await _local.createFamily(name: family.name);
    }
    _patch({_keyFamilyId: family.familyId});
    if (family.status == 'PARTNER_LEFT' && family.familyId != null) {
      // US-00: bạn đời đã rời — người còn lại vẫn dùng app (xem & tải về) và
      // mời bạn đời mới từ FAM-02.
      _local.applyServerPartnerLeft();
      await _mirrorActivated(family.familyId!);
    } else if (family.status == 'ACTIVE' && family.familyId != null) {
      await _mirrorActivated(family.familyId!);
    }
    _local.applyServerAvatar(me.avatarUrl);
  }

  /// CIR-WAIT / CIR-01 / CIR-05 (BF-20261019-005): tư cách người thân từ
  /// `GET /v1/me/circles`. Trả `false` khi tài khoản không phải người thân
  /// (để luồng Papa/Mama chạy tiếp).
  Future<bool> _syncCircle([String? preferredFamilyId]) async {
    final List<MyCircleRecord> circles;
    try {
      circles = await _onboardingRepository.myCircles();
    } on DioException catch (error) {
      Logger().w('Không đọc được gia đình người thân: ${error.message}');
      return _local.current.role == FamilyRole.relative &&
          _local.current.memberId != null;
    }
    if (circles.isEmpty) {
      if (_local.current.role != FamilyRole.relative) {
        return false;
      }
      _local.applyServerCircle();
      _patch({_keyFamilyId: null});
      return true;
    }
    final joined = circles.where((item) => item.status != 'AWAITING_APPROVAL');
    final circle =
        joined
            .where((item) => item.familyId == preferredFamilyId)
            .firstOrNull ??
        joined.firstOrNull;
    if (circle == null || circle.familyId == null) {
      // Đã nhận lời mời, chờ Bố/Mẹ xác nhận lần cuối (INV-04 → CIR-WAIT).
      _local.applyServerCircle();
      _patch({_keyFamilyId: null, _keyAwaiting: true});
      return true;
    }
    final paused = circle.status != 'ACTIVE';
    final subjects = [
      for (final subject in circle.children)
        if (subject.id != null) subject,
    ];
    _local.applyServerCircle(
      familyName: circle.familyName ?? '',
      paused: paused,
      // CIR-05: server không trả bé khi tạm dừng — giữ quyền đang có.
      grantedChildIds: paused ? null : [for (final s in subjects) s.id!],
      childPermissions: paused
          ? null
          : {
              for (final s in subjects)
                s.id!: FamilyRemoteServiceImp.appPermission(s.permission),
            },
      allowDownload: circle.allowDownload,
    );
    _patch({_keyFamilyId: circle.familyId, _keyAwaiting: null});
    if (!paused) {
      _mirrorSubjects([
        for (final s in subjects)
          BootstrapSubject(
            id: s.id,
            type: s.kind == 'PREGNANCY' ? 'PREGNANCY' : 'CHILD',
            displayName: s.name,
          ),
      ]);
    }
    return true;
  }

  /// Phản chiếu gia đình đã đủ Bố + Mẹ; quyền lợi (dùng thử/hết hạn) lấy từ
  /// bootstrap của server, không tự cấp dùng thử trên máy.
  Future<void> _mirrorActivated(
    String familyId, [
    FamilyBootstrap? bootstrap,
  ]) async {
    if (_local.current.state == SessionState.waitingPartner) {
      await _local.simulatePartnerJoined();
    }
    final data = bootstrap ?? await _onboardingRepository.bootstrap(familyId);
    _mirrorSubjects(data?.subjects ?? const []);
    final serverMe = _raw[kValueSessionKeyServerUserId] as String?;
    final partner = data?.parents
        .where((parent) => parent.userId != null && parent.userId != serverMe)
        .firstOrNull;
    _patch({kValueSessionKeyServerPartnerUserId: partner?.userId});
    // Tên bạn đời của server, không giữ tên mẫu của bản phản chiếu.
    if (data != null) {
      _local.applyServerPartner(
        displayName: partner?.displayName ?? '',
        callName: partner?.callName,
      );
    }
    final entitlement = data?.entitlement;
    switch (entitlement?.accessPhase) {
      case 'TRIAL':
        _local.applyServerPlan(
          state: PlanState.trial,
          endsAt: entitlement?.trialEndsAt,
        );
      case 'EXPIRED' || 'BLOCKED':
        _local.applyServerPlan(state: PlanState.expired);
    }
    if (_local.current.state == SessionState.activatedSetup &&
        await _onboardingRepository.isSetupDone(familyId)) {
      await _local.completeSetup();
    }
  }

  /// `bootstrap.subjects` là nguồn sự thật của danh sách bé/thai kỳ: thêm bản
  /// còn thiếu (id của server) và cập nhật bản đã đổi; trường chỉ có trên máy
  /// (ảnh đại diện, thứ tự CHD-03) được giữ nguyên.
  void _mirrorSubjects(List<BootstrapSubject> subjects) {
    final localFamilyId = _local.current.familyId;
    if (localFamilyId == null) {
      return;
    }
    final existing = {
      for (final row in _childRepository.children(localFamilyId))
        row['id']: row,
    };
    var count = existing.length;
    for (final subject in subjects) {
      final id = subject.id;
      if (id == null) {
        continue;
      }
      final pregnancy = subject.type == 'PREGNANCY';
      final fields = <String, dynamic>{
        'name': subject.displayName ?? '',
        'kind': (pregnancy ? ChildKind.pregnancy : ChildKind.baby).name,
        if (!pregnancy) 'birthDate': ?subject.birthDate?.toIso8601String(),
        if (!pregnancy) 'gender': _childGender(subject.gender).name,
        if (pregnancy) 'dueDate': ?subject.dueDate?.toIso8601String(),
        if (pregnancy) 'babyCount': subject.expectedCount ?? 1,
        if (pregnancy) 'pregnancyOrder': ?subject.seqNo,
        // Ảnh đại diện/bìa đặt trên máy khác (URL ký, cache theo đường dẫn).
        'avatarAsset': ?subject.avatarUrl,
        'coverAsset': ?subject.coverUrl,
        // SW-01: bé có trong bootstrap là bé đang dùng của server.
        _keyServerSubject: true,
        'archived': false,
      };
      final row = existing[id];
      if (row == null) {
        final color = subject.colorIndex;
        _childRepository.addChild({
          'id': id,
          'familyId': localFamilyId,
          ...fields,
          // Server 1…8 → chỉ số 0… của `kChildPalette`.
          'colorIndex': color == null ? count : color - 1,
        });
        count++;
      } else if (fields.entries.any((entry) => row[entry.key] != entry.value)) {
        _childRepository.updateChild(id, fields);
      }
    }
    // SW-01: bé/thai kỳ của server không còn trong bootstrap (lưu trữ, xoá
    // hoặc thai kỳ đã chào đời trên máy khác; người thân bị thu hồi quyền)
    // → “Đã lưu trữ”, không còn trong bộ chuyển bé.
    final active = {for (final subject in subjects) ?subject.id};
    for (final row in existing.values) {
      if (row[_keyServerSubject] == true &&
          row['archived'] != true &&
          !active.contains(row['id'])) {
        _childRepository.updateChild(row['id'] as String, {'archived': true});
      }
    }
  }

  static ChildGender _childGender(String? value) => switch (value) {
    'MALE' => ChildGender.boy,
    'FEMALE' => ChildGender.girl,
    _ => ChildGender.unknown,
  };

  JsonMap get _device => {
    'platform': _platform,
    'locale': currentAppLanguage().code,
  };

  String get _platform => Platform.isIOS ? 'IOS' : 'ANDROID';

  static String _onboardingRole(FamilyRole role) => switch (role) {
    FamilyRole.father => 'PARENT_FATHER',
    FamilyRole.mother => 'PARENT_MOTHER',
    FamilyRole.relative => 'CIRCLE',
  };

  static FamilyRole? _onboardingRoleOf(String? value) => switch (value) {
    'PARENT_FATHER' => FamilyRole.father,
    'PARENT_MOTHER' => FamilyRole.mother,
    'CIRCLE' => FamilyRole.relative,
    _ => null,
  };

  static FamilyRole? _parentRole(String? kind) => switch (kind) {
    'FATHER' => FamilyRole.father,
    'MOTHER' => FamilyRole.mother,
    _ => null,
  };
}
