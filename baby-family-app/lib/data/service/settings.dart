import 'package:baby_family/data/dto/family_deletion_info.dart';
import 'package:baby_family/data/model/settings/ai_settings.dart';
import 'package:baby_family/data/model/settings/blocked_person.dart';
import 'package:baby_family/data/model/settings/data_export_info.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/model/settings/help_info.dart';
import 'package:baby_family/data/model/settings/notification_settings.dart';
import 'package:baby_family/data/model/settings/privacy_settings.dart';
import 'package:baby_family/data/model/settings/profile_settings.dart';
import 'package:baby_family/data/model/settings/security_settings.dart';
import 'package:baby_family/data/model/settings/support_ticket.dart';
import 'package:baby_family/data/model/settings/support_ticket_detail.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Cài đặt cá nhân (SET-02/03/04/07/08/09/11). Bản mock: mọi thao tác thành
/// công ngay; dữ liệu theo `assets/data/mock/settings.json`.
abstract class ISettingsService extends IBaseService {
  /// SET-02.
  Future<ProfileSettings> profileSettings();

  Future<void> saveProfileSettings(ProfileSettings settings);

  /// SET-03.
  Future<NotificationSettings> notificationSettings();

  Future<void> saveNotificationSettings(NotificationSettings settings);

  /// SET-04.
  Future<PrivacySettings> privacySettings();

  Future<void> savePrivacySettings(PrivacySettings settings);

  /// SET-07.
  Future<SecuritySettings> securitySettings();

  Future<void> saveSecuritySettings(SecuritySettings settings);

  Future<void> signOutDevice(String deviceId);

  /// “Đăng xuất mọi thiết bị” (mock: giữ lại thiết bị này).
  Future<void> signOutOtherDevices();

  /// SET-08.
  Future<DataExportInfo> dataExport();

  Future<void> startExport(DataExportKind kind);

  /// Link tải bản xuất đã sẵn sàng (hết hạn sau vài phút); null khi chưa có
  /// (bản mock).
  Future<String?> exportDownloadUrl(DataExportKind kind);

  Future<void> clearCache();

  /// SET-09/09b/09c — `onlyParent` chọn biến thể 09b.
  Future<DeleteAccountInfo> deleteAccountInfo();

  /// SET-09c: gửi OTP xác thực lại tới số của chính tôi (mục 7.25).
  Future<void> requestReauthOtp();

  /// SET-09c: xác thực lại bằng [code]; sai mã thì ném lỗi.
  Future<void> verifyReauth(String code);

  /// SET-09c “Xoá tài khoản”: tài khoản chờ xoá 30 ngày rồi đăng xuất. Mock
  /// đăng xuất và nạp lại seed `fresh`. [keepMemories] = giữ ký ức đã đăng cho
  /// gia đình (ẩn danh).
  Future<void> deleteAccount({bool keepMemories = true});

  /// Xoá gia đình (mục 7.25): cả hai Parent đồng ý, sau đó có [graceDays]
  /// ngày để huỷ. Yêu cầu/đồng ý cần xác thực lại ([verifyReauth]) trước.
  /// Đổi số điện thoại: sau [verifyReauth], gửi OTP tới [phone] mới (E.164).
  Future<void> requestPhoneChange(String phone);

  /// Xác nhận số mới bằng mã OTP; các phiên khác bị đăng xuất.
  Future<void> confirmPhoneChange(String phone, String code);

  /// Hỗ trợ khách hàng: danh mục do server cấu hình (mã, app dịch nhãn).
  Future<List<String>> supportCategories();

  /// Gửi yêu cầu; trả yêu cầu vừa tạo (có mã tra cứu).
  Future<SupportTicket> sendSupportRequest({
    required String category,
    required String subject,
    required String body,
  });

  /// Yêu cầu tôi đã gửi, mới nhất trước.
  Future<List<SupportTicket>> supportTickets();

  /// Chi tiết + trao đổi với CSKH; null khi không còn (đã xoá / không phải
  /// của tôi).
  Future<SupportTicketDetail?> supportTicket(String ticketId);

  /// Nhắn thêm (yêu cầu đã giải quyết/đóng thì server từ chối).
  Future<void> sendSupportMessage(String ticketId, String body);

  Future<FamilyDeletionInfo> familyDeletion();

  Future<FamilyDeletionInfo> requestFamilyDeletion();

  Future<FamilyDeletionInfo> confirmFamilyDeletion();

  Future<FamilyDeletionInfo> cancelFamilyDeletion();

  /// SET-11.
  Future<HelpInfo> help();

  // --- Batch 3 (SET-05, SET-13, RPT-02) ---

  /// SET-05.
  Future<AiSettings> aiSettings();

  Future<void> saveAiSettings(AiSettings settings);

  /// SET-13.
  Future<List<BlockedPerson>> blockedPeople();

  /// RPT-02 “Chặn” (tuỳ chọn gỡ khỏi gia đình luôn).
  Future<void> blockMember(String memberId, {bool removeFromFamily = false});

  Future<void> unblock(String blockedId);
}
