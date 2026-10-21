import 'package:baby_family/data/model/billing/billing_plan_record.dart';
import 'package:baby_family/data/model/billing/family_billing_record.dart';
import 'package:baby_family/data/model/circle/circle_invite_issued.dart';
import 'package:baby_family/data/model/circle/circle_invite_record.dart';
import 'package:baby_family/data/model/circle/circle_member_record.dart';
import 'package:baby_family/data/model/family/family_record.dart';
import 'package:baby_family/data/model/family/family_settings_record.dart';
import 'package:baby_family/data/model/family/my_family_record.dart';
import 'package:baby_family/data/model/family/purchase_intent_record.dart';
import 'package:baby_family/data/model/family/timezone_catalog.dart';
import 'package:baby_family/data/repository/base.dart';
import 'package:baby_family/data/repository/family_remote.dart';
import 'package:baby_family/data/repository_imp/base.dart';

class FamilyRemoteRepositoryImp extends BaseRepositoryImp
    implements IFamilyRemoteRepository {
  @override
  Future<void> updateFamily(String familyId, {String? name}) =>
      client!.updateFamily(familyId, {'name': ?name});

  @override
  Future<FamilyRecord?> family(String familyId) async =>
      (await client!.getFamily(familyId)).family;

  @override
  Future<void> patchFamily(String familyId, JsonMap patch) =>
      client!.updateFamily(familyId, patch);

  @override
  Future<FamilySettingsRecord?> settings(String familyId) async {
    final rs = await client!.getFamilySettings(familyId);
    return rs.settings;
  }

  @override
  Future<FamilySettingsRecord?> updateSettings(
    String familyId,
    JsonMap patch,
  ) async {
    final rs = await client!.updateFamilySettings(familyId, patch);
    return rs.settings;
  }

  @override
  Future<CircleInviteIssued?> createCircleInvite(
    String familyId,
    JsonMap body,
  ) async {
    final rs = await client!.createCircleInvite(familyId, body);
    return rs.invite;
  }

  @override
  Future<List<CircleInviteRecord>> circleInvites(String familyId) async {
    final rs = await client!.getCircleInvites(familyId);
    return rs.list?.items ?? const [];
  }

  @override
  Future<CircleInviteIssued?> circleInviteAction(
    String inviteId,
    String action,
  ) async {
    final rs = await client!.circleInviteAction(inviteId, action);
    return rs.invite;
  }

  @override
  Future<List<CircleMemberRecord>> circle(String familyId) async {
    final rs = await client!.getCircle(familyId);
    return rs.list?.members ?? const [];
  }

  @override
  Future<void> updateCircleMember(String memberId, JsonMap patch) =>
      client!.updateCircleMember(memberId, patch);

  @override
  Future<void> circleMemberAction(String memberId, String action) =>
      client!.circleMemberAction(memberId, action);

  @override
  Future<void> removeCircleMember(String memberId) =>
      client!.removeCircleMember(memberId);

  @override
  Future<List<BillingPlanRecord>> billingPlans() async {
    final rs = await client!.getBillingPlans();
    return rs.catalog?.plans ?? const [];
  }

  @override
  Future<FamilyBillingRecord?> familyBilling(String familyId) async {
    final rs = await client!.getFamilyBilling(familyId);
    return rs.billing;
  }

  @override
  Future<List<MyFamilyRecord>> myFamilies() async =>
      (await client!.getMyFamilies()).list?.items ?? const [];

  @override
  Future<void> setDefaultFamily(String familyId) =>
      client!.setDefaultFamily({'familyId': familyId});

  @override
  Future<TimezoneCatalog?> timezones(String locale) async =>
      (await client!.getTimezones(locale)).catalog;

  @override
  Future<PurchaseIntentRecord?> purchaseIntent(
    String familyId,
    String idempotencyKey, {
    required String planCode,
    required String store,
  }) async => (await client!.createPurchaseIntent(familyId, idempotencyKey, {
    'planCode': planCode,
    'store': store,
  })).intent;

  @override
  Future<FamilyBillingRecord?> verifyPurchase(
    String familyId,
    JsonMap body,
  ) async => (await client!.verifyPurchase(familyId, body)).billing;
}
