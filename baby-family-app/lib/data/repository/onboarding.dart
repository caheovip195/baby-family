import 'package:baby_family/data/model/circle/my_circle_record.dart';
import 'package:baby_family/data/model/session/family_bootstrap.dart';
import 'package:baby_family/data/model/session/invite_decision.dart';
import 'package:baby_family/data/model/session/invite_resolution.dart';
import 'package:baby_family/data/model/session/partner_invite_issued.dart';
import 'package:baby_family/data/model/session/partner_invite_status.dart';
import 'package:baby_family/data/repository/base.dart';

/// Tạo gia đình, lời mời bạn đời và kích hoạt (tài liệu kỹ thuật 6.5, 11.3).
abstract class IOnboardingRepository extends IBaseRepository {
  /// `POST /v1/families` → bootstrap (WAITING_PARTNER).
  Future<FamilyBootstrap?> createFamily({
    required String name,
    String? kind,
    String? callName,
  });

  /// `POST /v1/families/{fid}/cancel`.
  Future<void> cancelFamily(String familyId);

  /// `GET /v1/families/{fid}/bootstrap`.
  Future<FamilyBootstrap?> bootstrap(String familyId);

  /// `POST /v1/families/{fid}/invites/partner` — vô hiệu lời mời cũ.
  Future<PartnerInviteIssued?> createPartnerInvite(
    String familyId, {
    bool requireFinalApproval = true,
    String? message,
  });

  /// `GET /v1/families/{fid}/invites/partner` — lời mời mới nhất.
  Future<PartnerInviteStatus?> partnerInviteStatus(String familyId);

  /// `POST /v1/invites/resolve`.
  Future<InviteResolution?> resolveInvite(String code);

  /// `POST /v1/invites/accept`.
  Future<InviteDecision?> acceptInvite(String code, {String? callName});

  /// `POST /v1/invites/decline`.
  Future<InviteDecision?> declineInvite(String code);

  /// `POST /v1/invites/{id}/approve|reject` — Bố/Mẹ xác nhận lần cuối.
  Future<InviteDecision?> decideInvite(
    String inviteId, {
    required bool approve,
  });

  /// Mã/link lời mời bạn đời đã tạo (server chỉ trả một lần) — lưu trên máy.
  Future<JsonMap?> cachedPartnerInvite(String familyId);

  Future<void> cachePartnerInvite(String familyId, JsonMap invite);

  /// Đã xong thiết lập ONB-ACT → ONB-09 trên máy này.
  Future<bool> isSetupDone(String familyId);

  Future<void> markSetupDone(String familyId);

  /// `GET /v1/me/circles` — các gia đình tôi là người thân (CIR-WAIT/CIR-05).
  Future<List<MyCircleRecord>> myCircles();

  /// `POST /v1/families/{familyId}/circle/leave` (SET-10).
  Future<void> leaveCircle(String familyId);
}
