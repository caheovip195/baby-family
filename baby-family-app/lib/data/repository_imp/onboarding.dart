import 'package:baby_family/data/model/circle/my_circle_record.dart';
import 'package:baby_family/data/model/session/family_bootstrap.dart';
import 'package:baby_family/data/model/session/invite_decision.dart';
import 'package:baby_family/data/model/session/invite_resolution.dart';
import 'package:baby_family/data/model/session/partner_invite_issued.dart';
import 'package:baby_family/data/model/session/partner_invite_status.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/onboarding.dart';
import 'package:baby_family/data/repository_imp/base.dart';
import 'package:baby_family/utils/helper/local_store.dart';

class OnboardingRepositoryImp extends BaseRepositoryImp
    implements IOnboardingRepository {
  @override
  Future<FamilyBootstrap?> createFamily({
    required String name,
    String? kind,
    String? callName,
  }) async {
    final rs = await client!.createFamily({
      'name': name,
      'parent': {'kind': ?kind, 'callName': ?callName},
    });
    return rs.bootstrap;
  }

  @override
  Future<void> cancelFamily(String familyId) => client!.cancelFamily(familyId);

  @override
  Future<FamilyBootstrap?> bootstrap(String familyId) async {
    final rs = await client!.getFamilyBootstrap(familyId);
    return rs.bootstrap;
  }

  @override
  Future<PartnerInviteIssued?> createPartnerInvite(
    String familyId, {
    bool requireFinalApproval = true,
    String? message,
  }) async {
    final rs = await client!.createPartnerInvite(familyId, {
      'requireFinalApproval': requireFinalApproval,
      'message': ?message,
    });
    return rs.invite;
  }

  @override
  Future<PartnerInviteStatus?> partnerInviteStatus(String familyId) async {
    final rs = await client!.getPartnerInvite(familyId);
    return rs.invite;
  }

  @override
  Future<InviteResolution?> resolveInvite(String code) async {
    final rs = await client!.resolveInvite({'code': code});
    return rs.invite;
  }

  @override
  Future<InviteDecision?> acceptInvite(String code, {String? callName}) async {
    final rs = await client!.acceptInvite({
      'code': code,
      'callName': ?callName,
    });
    return rs.decision;
  }

  @override
  Future<List<MyCircleRecord>> myCircles() async {
    final rs = await client!.getMyCircles();
    return rs.list?.items ?? const [];
  }

  @override
  Future<void> leaveCircle(String familyId) => client!.leaveCircle(familyId);

  @override
  Future<InviteDecision?> declineInvite(String code) async {
    final rs = await client!.declineInvite({'code': code});
    return rs.decision;
  }

  @override
  Future<InviteDecision?> decideInvite(
    String inviteId, {
    required bool approve,
  }) async {
    final rs = approve
        ? await client!.approveInvite(inviteId)
        : await client!.rejectInvite(inviteId);
    return rs.decision;
  }

  @override
  Future<JsonMap?> cachedPartnerInvite(String familyId) =>
      LocalStore().getPartnerInvite(familyId);

  @override
  Future<void> cachePartnerInvite(String familyId, JsonMap invite) async {
    await LocalStore().savePartnerInvite(familyId, invite);
  }

  @override
  Future<bool> isSetupDone(String familyId) =>
      LocalStore().isFamilySetupDone(familyId);

  @override
  Future<void> markSetupDone(String familyId) async {
    await LocalStore().saveFamilySetupDone(familyId);
  }
}
