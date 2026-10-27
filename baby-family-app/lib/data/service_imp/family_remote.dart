import 'dart:convert';

import 'package:baby_family/data/dto/account_settings_summary.dart';
import 'package:baby_family/data/model/billing/billing_plan_record.dart';
import 'package:baby_family/data/model/billing/family_billing_record.dart';
import 'package:baby_family/data/model/circle/circle_invite_record.dart';
import 'package:baby_family/data/model/circle/circle_member_record.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/family_membership.dart';
import 'package:baby_family/data/model/family/family_settings.dart';
import 'package:baby_family/data/model/family/family_settings_record.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/family/plan_details.dart';
import 'package:baby_family/data/model/family/plan_offer.dart';
import 'package:baby_family/data/model/family/timezone_catalog.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/child.dart';
import 'package:baby_family/data/repository/family.dart';
import 'package:baby_family/data/repository/family_remote.dart';
import 'package:baby_family/data/repository/session.dart';
import 'package:baby_family/data/repository/store_purchase.dart';
import 'package:baby_family/data/service_imp/family.dart';
import 'package:baby_family/data/service_imp/media_uploader.dart';
import 'package:baby_family/data/service_imp/offline_read.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// ONB-08 / FAM-07 qua server (BF-20261018-015): quyền riêng tư mặc định của
/// gia đình (`/families/:fid/settings`) và tên gia đình (`PATCH /families/:fid`).
/// Ảnh bìa, múi giờ, ngôn ngữ nội dung vẫn ở trên máy. Family Circle
/// (BF-20261019-004): người thân, lời mời, quyền theo từng bé qua server.
class FamilyRemoteServiceImp extends FamilyServiceImp {
  /// Bản đọc gần nhất cho màn phụ khi mất mạng (BF-20261026-007).
  final _reads = OfflineReads();

  FamilyRemoteServiceImp(
    ISessionRepository sessionRepository,
    AppClock clock,
    this._repository,
    this._remote,
    this._children, [
    this._uploader,
    this._storePurchase,
  ]) : super(sessionRepository, clock, _repository);

  final IFamilyRepository _repository;
  final IFamilyRemoteRepository _remote;
  final IChildRepository _children;

  /// FAM-07 tải ảnh bìa (null → ảnh bìa chỉ trên máy).
  final MediaUploader? _uploader;

  /// Store của máy (SUB-01/02/04); null trong test không cần mua.
  final IStorePurchaseRepository? _storePurchase;

  /// Mã gói server theo gói của app (từ catalog `/billing/plans`).
  final _serverPlanCodes = <PlanState, String>{};

  String? get _serverFamilyId =>
      sessionRepository.session()[kValueSessionKeyServerFamilyId] as String?;

  /// BF-20261023-001: id từ liên kết cũ không đọc thành viên fixture/nhà khác.
  @override
  Future<Member?> member(String memberId) async {
    final current = await super.member(memberId);
    if (_serverFamilyId != null &&
        _repository.member(memberId)?['familyId'] != familyId) {
      return null;
    }
    return current;
  }

  /// BF-20261023-001: chưa có quota AI/khoá app thật thì không hiện meta mẫu.
  @override
  Future<AccountSettingsSummary> settingsSummary() => _serverFamilyId == null
      ? super.settingsSummary()
      : Future.value(const AccountSettingsSummary());

  @override
  Future<FamilySettings> familySettings() async {
    final local = await super.familySettings();
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return local;
    }
    final (record, family) = await (
      _remote.settings(serverFamilyId),
      _remote.family(serverFamilyId),
    ).wait;
    final merged = record == null ? local : _merge(local, record);
    final timezone = family?.timezone;
    return merged.copyWith(
      coverAsset: family?.coverUrl ?? merged.coverAsset,
      contentLanguage: family?.contentLocale ?? merged.contentLanguage,
      timezoneId: timezone ?? merged.timezoneId,

      /// BF-20261023-001: không dùng nhãn múi giờ của fixture khi server thiếu.
      timezoneLabel: timezone == null
          ? ''
          : _timezoneLabels[timezone] ?? timezone,
    );
  }

  /// Nhãn đã dịch của lần đọc danh mục gần nhất (id IANA → nhãn).
  var _timezoneLabels = <String, String>{};

  @override
  Future<List<TimezoneOption>> timezones() async {
    if (_serverFamilyId == null) {
      return super.timezones();
    }
    final language = currentL10n().localeName == 'en' ? 'en' : 'vi';
    final catalog = await _reads.read([
      'timezones',
      language,
    ], () => _remote.timezones(language));
    final items = catalog?.items ?? const <TimezoneOption>[];
    _timezoneLabels = {for (final item in items) item.id: item.label};
    return items;
  }

  /// FAM-08: danh sách gia đình của tôi từ server; gia đình đang mở đánh dấu
  /// [FamilyMembership.current].
  @override
  Future<List<FamilyMembership>> memberships() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.memberships();
    }
    final myRole = FamilyRole.values
        .asNameMap()[sessionRepository.session()['role']];
    final parentRole = myRole == FamilyRole.relative || myRole == null
        ? FamilyRole.mother
        : myRole;
    return [
      for (final record in await _reads.read([
        'myFamilies',
      ], () => _remote.myFamilies()))
        if (record.familyId != null)
          FamilyMembership(
            familyId: record.familyId!,
            familyName: record.name ?? '',
            role: record.role == 'CIRCLE' ? FamilyRole.relative : parentRole,
            current: record.familyId == serverFamilyId,
          ),
    ];
  }

  /// FAM-08: ghi nhớ gia đình mở mặc định trên server; phiên đồng bộ lại theo
  /// gia đình mới ở [ISessionService.changeFamily].
  @override
  Future<void> switchFamily(String familyId) async {
    if (_serverFamilyId == null) {
      return super.switchFamily(familyId);
    }
    await _remote.setDefaultFamily(familyId);
  }

  @override
  Future<void> saveFamilySettings(FamilySettings settings) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.saveFamilySettings(settings);
    }
    final before = await familySettings();
    final patch = <String, dynamic>{
      if (settings.showLunar != before.showLunar)
        'showLunar': settings.showLunar,
      if (settings.relativesSeeTree != before.relativesSeeTree)
        'circleCanSeeTree': settings.relativesSeeTree,
      if (settings.defaultVisibility != before.defaultVisibility)
        'defaultVisibility': _visibilityCodes[settings.defaultVisibility],
      if (settings.approveRelativePhotos != before.approveRelativePhotos)
        'requireCircleReview': settings.approveRelativePhotos,
      if (settings.milestonesByLunar != before.milestonesByLunar)
        'traditionalUseLunar': settings.milestonesByLunar,
      if (settings.milestoneSuggestions != before.milestoneSuggestions)
        'milestoneSuggestions': settings.milestoneSuggestions,
    };
    if (patch.isNotEmpty) {
      await _remote.updateSettings(serverFamilyId, patch);
    }
    final cover = settings.coverAsset;
    final family = <String, dynamic>{
      if (settings.timezoneId != null &&
          settings.timezoneId != before.timezoneId)
        'timezone': settings.timezoneId,
      if (settings.name.trim().isNotEmpty && settings.name != before.name)
        'name': settings.name.trim(),
      if (settings.contentLanguage != before.contentLanguage)
        'contentLocale': settings.contentLanguage,
      // FAM-07: ảnh bìa mới chọn trên máy → tải lên (COVER) rồi gắn.
      if (cover != before.coverAsset && _uploader != null)
        'coverAssetId': cover == null
            ? null
            : cover.startsWith('/')
            ? await _uploader.uploadImage(
                serverFamilyId,
                cover,
                purpose: 'COVER',
              )
            : null,
    };
    if (family['coverAssetId'] == null &&
        cover != null &&
        !cover.startsWith('/')) {
      family.remove('coverAssetId');
    }
    if (family.isNotEmpty) {
      await _remote.patchFamily(serverFamilyId, family);
    }
    // Bản phản chiếu trên máy (tên, ảnh bìa, các mục chỉ có trên máy).
    await super.saveFamilySettings(settings);
  }

  static FamilySettings _merge(
    FamilySettings local,
    FamilySettingsRecord record,
  ) => local.copyWith(
    showLunar: record.showLunar ?? local.showLunar,
    relativesSeeTree: record.circleCanSeeTree ?? local.relativesSeeTree,
    defaultVisibility:
        _visibilityCodes.entries
            .where((entry) => entry.value == record.defaultVisibility)
            .firstOrNull
            ?.key ??
        local.defaultVisibility,
    approveRelativePhotos:
        record.requireCircleReview ?? local.approveRelativePhotos,
    milestonesByLunar: record.traditionalUseLunar ?? local.milestonesByLunar,
    milestoneSuggestions:
        record.milestoneSuggestions ?? local.milestoneSuggestions,
  );

  static const _visibilityCodes = {
    MemoryVisibility.family: 'FAMILY',
    MemoryVisibility.parents: 'PARENTS',
    MemoryVisibility.onlyMe: 'PRIVATE',
  };

  // ------------------------------------------------------------ Family Circle

  /// FAM-01/04: người thân lấy từ server rồi phản chiếu vào kho trên máy (id
  /// của server); Papa & Mama vẫn theo phiên. Lỗi mạng giữ bản đang có.
  @override
  Future<List<Member>> members() async {
    final serverFamilyId = _serverFamilyId;
    // Người thân không đọc được danh sách Circle (chỉ Papa & Mama).
    final relative =
        sessionRepository.session()['role'] == FamilyRole.relative.name;
    if (serverFamilyId != null && !relative) {
      await ready();
      await _syncCircle(serverFamilyId);
    }
    return super.members();
  }

  Future<void> _syncCircle(String serverFamilyId) async {
    final List<CircleMemberRecord> records;
    try {
      records = await _remote.circle(serverFamilyId);
    } on DioException catch (error) {
      Logger().w('Không đọc được người thân: ${error.message}');
      return;
    }
    final server = <String>{};
    for (final record in records) {
      final id = record.id;
      if (id == null || record.status == 'REMOVED' || record.status == 'LEFT') {
        continue;
      }
      server.add(id);
      final fields = <String, dynamic>{
        'familyId': familyId,
        'userId': record.userId,
        'role': FamilyRole.relative.name,
        'status': MemberStatus.active.name,
        'displayName': record.displayName ?? '',
        'callName': record.displayName ?? '',
        'relation': appRelation(record.relation).name,
        'grantedChildIds': [
          for (final grant in record.grants)
            ?grant.childId ?? grant.pregnancyId,
        ],
        'childPermissions': {
          for (final grant in record.grants)
            ?(grant.childId ?? grant.pregnancyId): appPermission(
              grant.permission,
            ).name,
        },
        'canComment': record.grants.any(
          (grant) => grant.permission != 'VIEW' && grant.permission != null,
        ),
        'canPost': record.grants.any(
          (grant) => grant.permission == 'CONTRIBUTE',
        ),
        'allowDownload': record.allowDownload,
        'paused': record.status == 'PAUSED',
        'joinedAt': record.joinedAt?.toLocal().toIso8601String(),
        _remoteKey: true,
      };
      if (_repository.member(id) == null) {
        _repository.addMember({'id': id, ...fields});
      } else {
        _repository.updateMember(id, fields);
      }
    }
    for (final row in _repository.members(familyId)) {
      if (row[_remoteKey] == true && !server.contains(row['id'])) {
        _repository.updateMember(row['id'] as String, {
          'status': MemberStatus.removed.name,
        });
      }
    }
  }

  /// FAM-03: lời mời trên server (mỗi bé đã chọn một quyền theo bình luận /
  /// đăng ảnh); mã + link lưu trên máy để chia sẻ lại.
  @override
  Future<InviteInfo> createRelativeInvite({
    required RelativeRelation relation,
    required String callName,
    List<String> childIds = const [],
    bool canComment = true,
    bool canPost = false,
  }) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return super.createRelativeInvite(
        relation: relation,
        callName: callName,
        childIds: childIds,
        canComment: canComment,
        canPost: canPost,
      );
    }
    await ready();
    final permission = canPost
        ? 'CONTRIBUTE'
        : canComment
        ? 'COMMENT'
        : 'VIEW';
    final issued = await _remote.createCircleInvite(serverFamilyId, {
      'relation': _serverRelations[relation],
      'displayName': callName.trim(),
      'grants': [
        for (final id in childIds)
          {..._subjectOf(id), 'allowDownload': false, 'permission': permission},
      ],
    });
    final id = issued?.inviteId;
    final code = issued?.code;
    if (id == null || code == null) {
      throw StateError('Invite was not created');
    }
    final row = _repository.addInvite({
      'id': id,
      'code': code,
      'kind': InviteKind.relative.name,
      'familyId': familyId,
      'inviterMemberId': myMemberId,
      'role': FamilyRole.relative.name,
      'relation': relation.name,
      'callName': callName.trim(),
      'grantedChildIds': childIds,
      'canComment': canComment,
      'canPost': canPost,
      'link': issued?.url,
      'sentAt': now.toIso8601String(),
      'expiresAt': issued?.expiresAt?.toLocal().toIso8601String(),
      'status': 'open',
      _remoteKey: true,
    });
    return InviteInfo.fromJson(row);
  }

  /// FAM-05: trạng thái lời mời từ server (mã cũ chỉ có trên máy đã tạo).
  @override
  Future<List<InviteInfo>> relativeInvites() async {
    await _syncInvites();
    return super.relativeInvites();
  }

  @override
  Future<List<InviteInfo>> pendingInvites() async {
    await _syncInvites();
    return super.pendingInvites();
  }

  Future<void> _syncInvites() async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null) {
      return;
    }
    await ready();
    final List<CircleInviteRecord> records;
    try {
      records = await _remote.circleInvites(serverFamilyId);
    } on DioException catch (error) {
      Logger().w('Không đọc được lời mời: ${error.message}');
      return;
    }
    final server = <String>{};
    for (final record in records) {
      final id = record.inviteId;
      if (id == null) {
        continue;
      }
      server.add(id);
      final fields = <String, dynamic>{
        'status': record.status == 'EXPIRED' ? 'expired' : 'open',
        'expiresAt': record.expiresAt?.toLocal().toIso8601String(),
        'callName': record.displayName,
        'relation': appRelation(record.relation).name,
        'grantedChildIds': [
          for (final grant in record.grants)
            ?grant.childId ?? grant.pregnancyId,
        ],
      };
      final local = _repository
          .invites(familyId)
          .where((row) => row['id'] == id)
          .firstOrNull;
      if (local == null) {
        _repository.addInvite({
          'id': id,
          // Server chỉ giữ mã đã băm: máy khác thấy lời mời nhưng không có mã.
          'code': '',
          'kind': InviteKind.relative.name,
          'familyId': familyId,
          'role': FamilyRole.relative.name,
          'requiresApproval': record.status == 'AWAITING_APPROVAL',
          ...fields,
          _remoteKey: true,
        });
      } else {
        _repository.updateInvite(id, fields);
      }
    }
    for (final row in _repository.invites(familyId)) {
      if (row[_remoteKey] == true &&
          !server.contains(row['id']) &&
          row['status'] == 'open') {
        // Đã được nhận, thu hồi hoặc xoá trên server.
        _repository.updateInvite(row['id'] as String, {'status': 'used'});
      }
    }
  }

  @override
  Future<void> revokeInvite(String inviteId) async {
    if (_serverFamilyId != null && _isRemoteInvite(inviteId)) {
      await _remote.circleInviteAction(inviteId, 'revoke');
    }
    await super.revokeInvite(inviteId);
  }

  /// Gia hạn = mã/link mới (mã cũ hết hiệu lực).
  @override
  Future<void> renewInvite(String inviteId) async {
    if (_serverFamilyId == null || !_isRemoteInvite(inviteId)) {
      return super.renewInvite(inviteId);
    }
    final issued = await _remote.circleInviteAction(inviteId, 'renew');
    _repository.updateInvite(inviteId, {
      'status': 'open',
      'code': ?issued?.code,
      'link': ?issued?.url,
      'sentAt': now.toIso8601String(),
      'openedAt': null,
      'expiresAt': ?issued?.expiresAt?.toLocal().toIso8601String(),
    });
  }

  @override
  Future<void> setChildPermission(
    String memberId,
    String childId,
    RelativePermission? permission,
  ) async {
    final current = await member(memberId);
    if (_serverFamilyId == null ||
        current == null ||
        !_isRemoteMember(memberId)) {
      return super.setChildPermission(memberId, childId, permission);
    }
    final permissions = {
      for (final entry in current.childPermissions.entries)
        entry.key: entry.value,
    };
    if (permission == null || permission == RelativePermission.hidden) {
      permissions.remove(childId);
    } else {
      permissions[childId] = permission;
    }
    for (final id in current.grantedChildIds) {
      permissions.putIfAbsent(id, () => RelativePermission.view);
    }
    if (permission == null || permission == RelativePermission.hidden) {
      permissions.remove(childId);
    }
    await _remote.updateCircleMember(memberId, {
      'grants': [
        for (final entry in permissions.entries)
          {
            ..._subjectOf(entry.key),
            'allowDownload': current.allowDownload,
            'permission': _serverPermissions[entry.value],
          },
      ],
    });
    await super.setChildPermission(memberId, childId, permission);
  }

  @override
  Future<void> updateMember(
    String memberId, {
    String? callName,
    List<String>? grantedChildIds,
    bool? canComment,
    bool? canPost,
  }) async {
    if (_serverFamilyId != null && _isRemoteMember(memberId)) {
      final current = await member(memberId);
      final permission = (canPost ?? current?.canPost ?? false)
          ? 'CONTRIBUTE'
          : (canComment ?? current?.canComment ?? false)
          ? 'COMMENT'
          : 'VIEW';
      await _remote.updateCircleMember(memberId, {
        if (callName != null && callName.trim().isNotEmpty)
          'displayName': callName.trim(),
        if (grantedChildIds != null || canComment != null || canPost != null)
          'grants': [
            for (final id
                in grantedChildIds ??
                    current?.grantedChildIds ??
                    const <String>[])
              {
                ..._subjectOf(id),
                'allowDownload': current?.allowDownload ?? false,
                'permission': permission,
              },
          ],
      });
    }
    await super.updateMember(
      memberId,
      callName: callName,
      grantedChildIds: grantedChildIds,
      canComment: canComment,
      canPost: canPost,
    );
  }

  /// FAM-04: tải về / tạm dừng qua server; tắt thông báo vẫn trên máy.
  @override
  Future<void> updateRelative(
    String memberId, {
    bool? allowDownload,
    bool? notificationsMuted,
    bool? paused,
  }) async {
    if (_serverFamilyId != null && _isRemoteMember(memberId)) {
      if (allowDownload != null) {
        await _remote.updateCircleMember(memberId, {
          'allowDownload': allowDownload,
        });
      }
      if (paused != null) {
        await _remote.circleMemberAction(memberId, paused ? 'pause' : 'resume');
      }
    }
    await super.updateRelative(
      memberId,
      allowDownload: allowDownload,
      notificationsMuted: notificationsMuted,
      paused: paused,
    );
  }

  @override
  Future<void> removeRelative(String memberId) async {
    if (_serverFamilyId != null && _isRemoteMember(memberId)) {
      await _remote.removeCircleMember(memberId);
    }
    await super.removeRelative(memberId);
  }

  bool _isRemoteMember(String id) =>
      _repository.member(id)?[_remoteKey] == true;

  bool _isRemoteInvite(String id) => _repository
      .invites(familyId)
      .any((row) => row['id'] == id && row[_remoteKey] == true);

  /// Bé hay thai kỳ — server tách `childId` / `pregnancyId`.
  JsonMap _subjectOf(String id) =>
      _children.child(id)?['kind'] == ChildKind.pregnancy.name
      ? {'pregnancyId': id}
      : {'childId': id};

  // ------------------------------------------- SUB-01/03/04/06/07 gói

  DateTime? _billingSyncedAt;

  bool get _isRelative =>
      sessionRepository.session()['role'] == FamilyRole.relative.name;

  /// Banner gói (SUB-06/07), hạn dùng thử/gói, dung lượng: gói của gia đình
  /// trên máy được cập nhật từ `/billing` (tối đa mỗi
  /// [kValueRemoteFeedRefreshInterval]).
  @override
  Future<Family?> currentFamily() async {
    await _syncBilling();
    return super.currentFamily();
  }

  @override
  Future<PlanDetails?> planDetails() async {
    await _syncBilling(force: true);
    if (_serverFamilyId == null) {
      return super.planDetails();
    }

    /// BF-20261023-001: chỉ gói và thành viên đã đồng bộ, không lấy meta mẫu.
    final family = await currentFamily();
    if (family == null) {
      return null;
    }
    return PlanDetails(
      plan: family.plan,
      relativeNames: [
        for (final member in await members())
          if (member.role == FamilyRole.relative &&
              member.status == MemberStatus.active)
            member.callName,
      ],
    );
  }

  /// BF-20261023-001: quota/feature theo server; không dùng gói của fixture khi
  /// API lỗi hoặc trả danh sách rỗng. Giá hiển thị vẫn lấy từ catalog giá của
  /// app (chưa có giá Store/server) — để trống làm câu “House () …” hỏng.
  @override
  Future<List<PlanOffer>> planOffers() async {
    if (_serverFamilyId == null) {
      return super.planOffers();
    }
    final List<BillingPlanRecord> plans;
    try {
      plans = await _remote.billingPlans();
    } on DioException catch (error) {
      Logger().w('Không đọc được catalog gói: ${error.message}');
      return const [];
    }
    for (final plan in plans) {
      if (_planOf(plan.code) case final code?) {
        _serverPlanCodes[code] = plan.code!;
      }
    }
    final prices = {
      for (final offer in await super.planOffers()) offer.code: offer,
    };
    final sorted = [...plans]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    final offers = [
      for (final plan in sorted)
        if (_planOf(plan.code) case final code?
            when code != PlanState.trial && code != PlanState.expired)
          _offerOf(code, plan, prices[code]),
    ];
    return offers;
  }

  /// SUB-01/02/04: server tạo lần mua (mã sản phẩm + token gắn tài khoản) →
  /// mua trên Store → server xác minh giao dịch rồi mới đổi quyền lợi. Người
  /// dùng huỷ ở Store → [StorePurchaseCancelled] (không đổi gì).
  @override
  Future<void> purchasePlan(PlanState plan) async {
    final serverFamilyId = _serverFamilyId;
    final storePurchase = _storePurchase;
    if (serverFamilyId == null || storePurchase == null) {
      return super.purchasePlan(plan);
    }
    final store = storePurchase.store;
    if (store == null) {
      throw UnsupportedError('Store purchases are not available here');
    }
    if (_serverPlanCodes.isEmpty) {
      await planOffers();
    }
    final planCode = _serverPlanCodes[plan] ?? plan.name.toUpperCase();
    final intent = await _remote.purchaseIntent(
      serverFamilyId,
      const Uuid().v4(),
      planCode: planCode,
      store: store,
    );
    final intentId = intent?.intentId;
    final productId = intent?.productId;
    final token = intent?.appAccountToken ?? intent?.obfuscatedAccountId;
    if (intentId == null || productId == null || token == null) {
      throw StateError('Purchase intent is incomplete');
    }
    final purchase = await storePurchase.buy(
      productId: productId,
      accountToken: token,
    );
    await _remote.verifyPurchase(serverFamilyId, {
      'store': purchase.store,
      'intentId': intentId,
      if (purchase.store == 'APP_STORE')
        'signedTransaction': purchase.credential
      else
        'purchaseToken': purchase.credential,
    });
    // Chỉ hoàn tất với Store sau khi server đã ghi nhận giao dịch.
    await storePurchase.complete(purchase);
    await _syncBilling(force: true);
  }

  Future<void> _syncBilling({bool force = false}) async {
    final serverFamilyId = _serverFamilyId;
    if (serverFamilyId == null || _isRelative) {
      return;
    }
    final synced = _billingSyncedAt;
    if (!force &&
        synced != null &&
        now.difference(synced) < kValueRemoteFeedRefreshInterval) {
      return;
    }
    _billingSyncedAt = now;
    final FamilyBillingRecord? billing;
    try {
      billing = await _remote.familyBilling(serverFamilyId);
    } on DioException catch (error) {
      Logger().w('Không đọc được gói của gia đình: ${error.message}');
      return;
    }
    await ready();
    final row = _repository.family(familyId);
    if (billing == null || row == null) {
      return;
    }
    final plan = Map<String, dynamic>.from(
      (row['plan'] as Map?) ?? const <String, dynamic>{},
    );
    final state = switch (billing.accessPhase) {
      'TRIAL' => PlanState.trial,
      'EXPIRED' || 'BLOCKED' => PlanState.expired,
      'PAID' => _planOf(billing.plan?.code),
      _ => null,
    };
    final quotas = billing.plan?.quotas ?? const <String, num>{};
    final storageQuota = quotas[_quotaStorage];
    final circleMax = quotas[_quotaCircle];
    final used = int.tryParse(billing.usage?.storageBytes ?? '');
    final next = <String, dynamic>{
      ...plan,
      'state': ?state?.name,
      'endsAt': ?(billing.validUntil ?? billing.trialEndsAt)
          ?.toLocal()
          .toIso8601String(),
      if (used != null) 'storageUsedMb': (used / _mib).round(),
      if (storageQuota != null) 'storageQuotaMb': (storageQuota / _mib).round(),
      if (circleMax != null) 'relativeSlotsMax': circleMax.toInt(),
      'paymentIssue': billing.inGrace,
    };
    if (jsonEncode(next) != jsonEncode(plan)) {
      _repository.updateFamily(familyId, {'plan': next});
    }
  }

  static PlanState? _planOf(String? code) =>
      code == null ? null : PlanState.values.asNameMap()[code.toLowerCase()];

  static PlanOffer _offerOf(
    PlanState code,
    BillingPlanRecord plan,
    PlanOffer? catalog,
  ) {
    final quotas = plan.quotas;
    int? minutes(String key) =>
        quotas[key] == null ? null : (quotas[key]! / 60).floor();
    return PlanOffer(
      code: code,
      storageGb: ((quotas[_quotaStorage] ?? 0) / (_mib * 1024)).round(),
      relativeSlots: (quotas[_quotaCircle] ?? 0).toInt(),
      priceText: catalog?.priceText ?? '',
      monthlyText: catalog?.monthlyText ?? '',
      photosPerMemory: quotas['photosPerMemory']?.toInt(),
      videoMinutes: minutes('videoMaxSec'),
      voiceMinutes: minutes('audioMaxSec'),
      originalQuality: plan.features['media.keepOriginal'] ?? false,
      aiPerMonth: quotas['aiPerMonth']?.toInt(),
      digestAndReview: plan.features['circle.enabled'] ?? false,
    );
  }

  static const _mib = 1024 * 1024;
  static const _quotaStorage = 'storageBytes';
  static const _quotaCircle = 'circleMax';

  static const _remoteKey = 'remote';

  static const _serverRelations = {
    RelativeRelation.grandmaPaternal: 'GRANDMOTHER_PATERNAL',
    RelativeRelation.grandpaPaternal: 'GRANDFATHER_PATERNAL',
    RelativeRelation.grandmaMaternal: 'GRANDMOTHER_MATERNAL',
    RelativeRelation.grandpaMaternal: 'GRANDFATHER_MATERNAL',
    RelativeRelation.auntUncle: 'AUNT_PATERNAL',
    RelativeRelation.nanny: 'CAREGIVER',
    RelativeRelation.other: 'OTHER',
  };

  /// Quan hệ server → app (dùng chung với phiên của người thân).
  static RelativeRelation appRelation(String? value) => switch (value) {
    'GRANDMOTHER_PATERNAL' => RelativeRelation.grandmaPaternal,
    'GRANDFATHER_PATERNAL' => RelativeRelation.grandpaPaternal,
    'GRANDMOTHER_MATERNAL' => RelativeRelation.grandmaMaternal,
    'GRANDFATHER_MATERNAL' => RelativeRelation.grandpaMaternal,
    'AUNT_PATERNAL' ||
    'AUNT_MATERNAL' ||
    'UNCLE_PATERNAL' ||
    'UNCLE_MATERNAL' => RelativeRelation.auntUncle,
    'CAREGIVER' => RelativeRelation.nanny,
    _ => RelativeRelation.other,
  };

  static const _serverPermissions = {
    RelativePermission.view: 'VIEW',
    RelativePermission.comment: 'COMMENT',
    RelativePermission.contribute: 'CONTRIBUTE',
  };

  /// Quyền server → app (VIEW mặc định).
  static RelativePermission appPermission(String? value) => switch (value) {
    'COMMENT' => RelativePermission.comment,
    'CONTRIBUTE' => RelativePermission.contribute,
    _ => RelativePermission.view,
  };
}
