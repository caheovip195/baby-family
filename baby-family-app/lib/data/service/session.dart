import 'package:baby_family/data/dto/invite_preview_data.dart';
import 'package:baby_family/data/dto/onboarding_samples.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/data/model/session/app_session.dart';
import 'package:baby_family/data/service/base.dart';
import 'package:baby_family/utils/constants/enum.dart';

/// Phiên + luồng đăng nhập/onboarding/lời mời (mục 9.1–9.2, BR-050…056).
///
/// Bản mock “đi xuyên qua”: mọi bước luôn thành công (OTP, mã mời nhận mọi giá
/// trị) và đẩy [SessionState] sang bước kế tiếp theo thứ tự của kế hoạch.
abstract class ISessionService extends IBaseService {
  /// Tải dữ liệu mẫu (Splash gọi trước khi điều hướng).
  Future<AppSession> restore();

  /// Phiên hiện tại (đồng bộ — dùng sau [restore]).
  AppSession get current;

  /// AUTH-01: Apple/Google → needsProfile (hoặc áp dụng lời mời đang chờ).
  Future<void> signIn(AuthMethod method);

  /// AUTH-02: lưu số điện thoại, “gửi” OTP.
  Future<void> requestOtp(String phone);

  /// AUTH-03: mọi mã đều hợp lệ trong bản mock (mã gợi ý: `otpHint`).
  Future<void> verifyOtp(String code);

  /// Mã OTP mẫu để hiển thị gợi ý (`123456`).
  String get otpHint;

  /// Giá trị mẫu điền sẵn cho các form đăng nhập/onboarding (bản UI-first).
  Future<OnboardingSamples> samples();

  /// Tên hiển thị của người đang đăng nhập (đã lưu ở AUTH-04), rỗng nếu chưa có.
  String get userName;

  /// AUTH-04: lưu hồ sơ → needsRole, hoặc áp dụng lời mời đang chờ.
  Future<void> saveProfile({String? name, String? avatarAsset});

  /// ONB-03: Papa/Mama → needsFamily; Người thân → circleWaiting.
  Future<void> chooseRole(FamilyRole role, {String? callName});

  /// ONB-06: tạo gia đình → waitingPartner, sinh lời mời bạn đời.
  Future<Family> createFamily({String? name, int coverIndex = 0});

  /// ONB-WAIT “Huỷ gia đình này”: rời gia đình đang chờ → chọn lại vai trò.
  Future<void> cancelFamily();

  /// ONB-07/ONB-WAIT: lời mời bạn đời của gia đình hiện tại.
  Future<InviteInfo?> partnerInvite();

  /// ONB-07: đánh dấu đã gửi lời mời.
  Future<void> markPartnerInviteSent();

  /// ONB-WAIT (debug): “Giả lập: bạn đời đã tham gia” → activatedSetup,
  /// bắt đầu dùng thử 90 ngày.
  Future<void> simulatePartnerJoined();

  /// ONB-04.
  Future<void> setStage(FamilyStage stage);

  /// Kết thúc onboarding (sau ONB-09) → active.
  Future<void> completeSetup();

  /// INV-05 → INV-01: mọi mã đều mở được lời mời (mã người thân mẫu
  /// `B4N0I123` → biến thể Bà nội, còn lại → lời mời bạn đời). Ném
  /// `StateError` khi dữ liệu không có lời mời nào (INV-02).
  Future<InvitePreviewData> previewInvite(String code);

  /// INV-01 “Tham gia”: chưa đăng nhập → lưu lời mời chờ (áp dụng sau
  /// AUTH-03/04); đã đăng nhập → áp dụng ngay (bạn đời → activatedSetup,
  /// người thân → circleActive).
  Future<void> acceptInvite(String code, {String? callName});

  Future<void> declineInvite();

  /// Đăng xuất: dữ liệu mẫu trở về seed `fresh`.
  Future<void> signOut();

  /// Dev tools: nạp lại một seed (`fresh|active|pregnant|circle|expired`).
  Future<void> reseed(DemoSeed seed, {String? actor});
}
