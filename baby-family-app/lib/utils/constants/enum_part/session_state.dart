part of '../enum.dart';

/// Trạng thái phiên quyết định điều hướng (tài liệu nghiệp vụ 9.2 “Logic điều
/// hướng”, BR-050…058). Splash và các `AutoRouteGuard` đọc giá trị này.
enum SessionState {
  /// Chưa đăng nhập → ONB-01 Welcome.
  signedOut,

  /// Đã xác thực, chưa có hồ sơ → AUTH-04.
  needsProfile,

  /// Chưa chọn vai trò → ONB-03 (BR-050).
  needsRole,

  /// Parent đã chọn vai trò, chưa tạo gia đình → ONB-06.
  needsFamily,

  /// Gia đình mới có 1 Parent → ONB-WAIT (BR-051/052).
  waitingPartner,

  /// Bạn đời đã tham gia, chưa thiết lập xong bé → ONB-ACT.
  activatedSetup,

  /// Gia đình đủ Papa + Mama, đang dùng thử/có gói → Main shell.
  active,

  /// Người thân chưa có lời mời → CIR-WAIT (BR-053).
  circleWaiting,

  /// Người thân đã tham gia gia đình → CIR-01.
  circleActive,

  /// Gia đình tạm dừng chia sẻ với người thân này → CIR-05.
  circlePaused,

  /// Hết dùng thử/gói → SUB-07 (BR-056).
  expired;

  bool get isParentActive => this == SessionState.active;

  bool get isCircle =>
      this == SessionState.circleWaiting ||
      this == SessionState.circleActive ||
      this == SessionState.circlePaused;

  /// Đang trong luồng thiết lập (đăng nhập/onboarding) — chưa vào app chính.
  bool get isOnboarding => const {
    SessionState.needsProfile,
    SessionState.needsRole,
    SessionState.needsFamily,
    SessionState.waitingPartner,
    SessionState.activatedSetup,
  }.contains(this);
}
