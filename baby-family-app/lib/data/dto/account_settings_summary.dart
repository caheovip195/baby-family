/// Giá trị phụ trên các dòng của SET-01 (lượt AI, khoá ứng dụng).
class AccountSettingsSummary {
  const AccountSettingsSummary({
    this.aiRemaining,
    this.aiTotal,
    this.appLockName,
  });

  final int? aiRemaining;
  final int? aiTotal;

  /// Tên phương thức khoá ứng dụng (“Face ID”) — tên hệ thống, không dịch.
  final String? appLockName;
}
