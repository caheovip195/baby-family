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
  /// [requireApproval] khác lựa chọn của lời mời hiện có → tạo lời mời mới.
  Future<InviteInfo?> partnerInvite({bool? requireApproval});

  /// ONB-07: đánh dấu đã gửi lời mời (kèm lựa chọn “xác nhận lần cuối”).
  Future<void> markPartnerInviteSent({bool? requireApproval});

  /// FAM-02 “Thu hồi lời mời”: mã/link đang chia sẻ hết hiệu lực.
  Future<void> revokePartnerInvite();

  /// ONB-WAIT (debug): “Giả lập: bạn đời đã tham gia” → activatedSetup,
  /// bắt đầu dùng thử theo trial policy (mặc định 7 ngày).
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

  /// Đăng nhập/onboarding đi qua server thật (`BABY_FAMILY_API_URL`); false →
  /// bản mock (có nút mô phỏng ở ONB-WAIT).
  bool get usesServer;

  /// ONB-WAIT: hỏi trạng thái bạn đời (poll 30 giây, tài liệu kỹ thuật 23.1).
  /// Đã tham gia → dữ liệu trên máy chuyển sang `activatedSetup`.
  Future<PartnerJoinStatus> checkPartnerStatus();

  /// Tên gọi bạn đời đang chờ xác nhận lần cuối (khi [checkPartnerStatus] trả
  /// `awaitingApproval`).
  String? get pendingPartnerCallName;

  /// 7.3 bước 6 — Bố/Mẹ xác nhận hoặc từ chối người vừa nhận lời mời.
  Future<PartnerJoinStatus> decidePartner({required bool approve});

  /// INV-04: lời mời đã nhận đang chờ người mời xác nhận.
  bool get awaitingPartnerApproval;

  /// Đăng xuất: dữ liệu mẫu trở về seed `fresh`.
  Future<void> signOut();

  /// Lưu bản chụp dữ liệu dùng khi mở app lúc mất mạng (app vào nền,
  /// BF-20261022-005). Bản mock: không làm gì.
  Future<void> persistOffline();

  /// FAM-08: mở gia đình [familyId] (id server) — bản phản chiếu trên máy làm
  /// lại theo gia đình mới. Bản mẫu chỉ có một gia đình nên không đổi gì.
  Future<AppSession> changeFamily(String familyId);

  /// Dev tools: nạp lại một seed (`fresh|active|pregnant|circle|expired`).
  Future<void> reseed(DemoSeed seed, {String? actor});
}
