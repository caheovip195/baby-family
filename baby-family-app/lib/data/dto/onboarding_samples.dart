/// Giá trị mẫu điền sẵn cho luồng đăng nhập/onboarding (bản UI-first, theo
/// thiết kế Pencil: AUTH-02 số điện thoại, AUTH-04 tên, ONB-05a/05b bé mẫu).
/// Nguồn: `assets/data/mock/session.json` → `samples`.
class OnboardingSamples {
  const OnboardingSamples({
    this.phone = '',
    this.otpPrefill = '',
    this.profileName = '',
    this.pregnancyName = '',
    this.dueDate,
    this.childName = '',
    this.birthDate,
    this.partnerInviteCode = '',
    this.relativeInviteCode = '',
  });

  /// Số điện thoại (không gồm mã quốc gia, không số 0 đầu).
  final String phone;

  /// Các số OTP đã gõ sẵn (AUTH-03 vẽ trạng thái đang nhập).
  final String otpPrefill;
  final String profileName;
  final String pregnancyName;
  final DateTime? dueDate;
  final String childName;
  final DateTime? birthDate;

  /// Mã mời mẫu (INV-05) — bạn đời / người thân.
  final String partnerInviteCode;
  final String relativeInviteCode;
}
