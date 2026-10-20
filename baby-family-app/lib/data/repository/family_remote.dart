import 'package:baby_family/data/model/billing/billing_plan_record.dart';
import 'package:baby_family/data/model/billing/family_billing_record.dart';
import 'package:baby_family/data/model/circle/circle_invite_issued.dart';
import 'package:baby_family/data/model/circle/circle_invite_record.dart';
import 'package:baby_family/data/model/circle/circle_member_record.dart';
import 'package:baby_family/data/model/family/family_record.dart';
import 'package:baby_family/data/model/family/family_settings_record.dart';
import 'package:baby_family/data/repository/base.dart';

/// Gia đình trên server: tên (`PATCH /families/:fid`) và cài đặt quyền riêng
/// tư mặc định (`/families/:fid/settings`, ONB-08 / FAM-07).
abstract class IFamilyRemoteRepository extends IBaseRepository {
  Future<void> updateFamily(String familyId, {String? name});

  /// FAM-07 `GET /v1/families/{fid}`.
  Future<FamilyRecord?> family(String familyId);

  /// FAM-07 `PATCH /v1/families/{fid}` (contentLocale, coverAssetId…).
  Future<void> patchFamily(String familyId, JsonMap patch);

  Future<FamilySettingsRecord?> settings(String familyId);

  /// Chỉ gửi các khoá đã đổi.
  Future<FamilySettingsRecord?> updateSettings(String familyId, JsonMap patch);

  /// FAM-03: `{relation, displayName, grants, message?, allowDownload?}`.
  Future<CircleInviteIssued?> createCircleInvite(String familyId, JsonMap body);

  Future<List<CircleInviteRecord>> circleInvites(String familyId);

  /// [action] = `revoke` | `renew`.
  Future<CircleInviteIssued?> circleInviteAction(
    String inviteId,
    String action,
  );

  Future<List<CircleMemberRecord>> circle(String familyId);

  Future<void> updateCircleMember(String memberId, JsonMap patch);

  /// [action] = `pause` | `resume`.
  Future<void> circleMemberAction(String memberId, String action);

  Future<void> removeCircleMember(String memberId);

  /// `GET /v1/billing/plans`.
  Future<List<BillingPlanRecord>> billingPlans();

  /// `GET /v1/families/{familyId}/billing`.
  Future<FamilyBillingRecord?> familyBilling(String familyId);
}
