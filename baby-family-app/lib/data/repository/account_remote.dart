import 'package:baby_family/data/model/account/data_export_record.dart';
import 'package:baby_family/data/model/account/deletion_preview_record.dart';
import 'package:baby_family/data/model/account/reauth_token_record.dart';
import 'package:baby_family/data/model/account/session_record.dart';
import 'package:baby_family/data/model/memory/upload_intent.dart';
import 'package:baby_family/data/model/privacy/family_deletion_record.dart';
import 'package:baby_family/data/model/privacy/privacy_overview_record.dart';
import 'package:baby_family/data/model/safety/blocked_user_record.dart';
import 'package:baby_family/data/model/settings/ai_settings_record.dart';
import 'package:baby_family/data/model/settings/help_center_record.dart';
import 'package:baby_family/data/model/settings/notification_settings_record.dart';
import 'package:baby_family/data/model/settings/sign_in_method_record.dart';
import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/model/settings/support_ticket_detail.dart';
import 'package:baby_family/data/repository/base.dart';

/// Tài khoản trên server (mục 7.25): xác thực lại bằng OTP, xoá tài khoản có
/// thời gian chờ, xuất dữ liệu.
abstract class IAccountRemoteRepository extends IBaseRepository {
  /// OTP gửi tới số đã xác minh của chính tôi — không truyền số điện thoại.
  Future<void> requestReauthOtp();

  Future<ReauthTokenRecord?> verifyReauthOtp(String code);

  Future<DeletionPreviewRecord?> deletionPreview();

  /// [familyChoice] = `NONE` | `DELETE_FAMILY` | `PARTNER_CONTINUES`;
  /// [sharedContentChoice] = `KEEP_ANONYMIZED` | `DELETE`.
  Future<void> requestDeletion({
    required String familyChoice,
    required String sharedContentChoice,
    required String reauthToken,
  });

  /// [scope] = `PERSONAL` | `FAMILY`.
  Future<DataExportRecord?> createExport(String scope, {String? familyId});

  Future<DataExportRecord?> export(String exportId);

  /// SET-07: phiên đăng nhập của chính tôi.
  Future<List<SessionRecord>> sessions();

  Future<void> revokeSession(String sessionId);

  Future<void> revokeOtherSessions();

  /// SET-02: `PATCH /v1/me` (tên hiển thị).
  Future<void> updateMe(JsonMap patch);

  /// SET-03: `GET/PATCH /v1/me/notification-settings`.
  Future<NotificationSettingsRecord?> notificationSettings();

  Future<NotificationSettingsRecord?> updateNotificationSettings(JsonMap patch);

  /// SET-05: `GET/PATCH /v1/me/ai-settings`.
  Future<AiSettingsRecord?> aiSettings();

  Future<AiSettingsRecord?> updateAiSettings(JsonMap patch);

  /// RPT-02: chặn / bỏ chặn / danh sách đã chặn trong gia đình.
  Future<void> block(String familyId, String userId);

  Future<void> unblock(String familyId, String userId);

  Future<List<BlockedUserRecord>> blocks(String familyId);

  /// AUTH-04: upload-intent / complete của ảnh đại diện tài khoản.
  Future<UploadIntent?> createAvatarIntent(String idempotencyKey, JsonMap body);

  Future<void> completeAvatar(String assetId);

  /// Xoá gia đình (cả hai Parent đồng ý, có thời gian chờ).
  Future<FamilyDeletionRecord?> familyDeletion(String familyId);

  Future<FamilyDeletionRecord?> requestFamilyDeletion(
    String familyId,
    String reauthToken,
  );

  Future<FamilyDeletionRecord?> confirmFamilyDeletion(
    String familyId,
    String reauthToken,
  );

  Future<FamilyDeletionRecord?> cancelFamilyDeletion(String familyId);

  /// Đổi số điện thoại (`/v1/me/phone/otp|verify`).
  Future<void> requestPhoneChangeOtp(String phone, String reauthToken);

  Future<void> verifyPhoneChange(String phone, String code);

  /// `GET /v1/me/sign-in-methods`.
  Future<List<SignInMethodRecord>> signInMethods();

  /// SET-11/12 `GET /v1/support/help-center`.
  Future<HelpCenterRecord?> helpCenter(String locale);

  /// Hỗ trợ khách hàng (`/v1/support/*`).
  Future<List<String>> supportCategories();

  Future<SupportTicket?> createSupportTicket(JsonMap body);

  Future<List<SupportTicket>> supportTickets({int limit = 50});

  Future<SupportTicketDetail?> supportTicket(String ticketId);

  Future<void> sendSupportMessage(String ticketId, String body);

  /// SET-04 `GET /v1/families/{fid}/privacy-overview`.
  Future<PrivacyOverviewRecord?> privacyOverview(String familyId);

  /// `PATCH /v1/families/{fid}/settings` (mặc định ai xem).
  Future<void> updateFamilySettings(String familyId, JsonMap patch);
}
