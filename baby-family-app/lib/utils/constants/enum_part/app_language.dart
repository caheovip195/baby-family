part of '../enum.dart';

/// Ngôn ngữ app hỗ trợ (tài liệu nghiệp vụ mục 11.3, kỹ thuật 22.12).
///
/// Thêm ngôn ngữ mới: thêm giá trị ở đây + file `lib/l10n/arb/app_<code>.arb`
/// + bản dịch catalog/template ở server. Thứ tự = thứ tự hiển thị ở bộ chọn.
enum AppLanguage {
  vi('vi', 'Tiếng Việt'),
  en('en', 'English');

  const AppLanguage(this.code, this.nativeName);

  /// Mã BCP-47 gửi server (`Accept-Language`, `PATCH /v1/me {locale}`).
  final String code;

  /// Tên ngôn ngữ viết bằng chính ngôn ngữ đó — không dịch.
  final String nativeName;

  Locale get locale => Locale(code);

  /// Ngôn ngữ mặc định khi thiết bị dùng ngôn ngữ chưa hỗ trợ.
  static const fallback = AppLanguage.vi;

  static AppLanguage? fromCode(String? code) {
    if (code == null) {
      return null;
    }
    final languageCode = code.split(RegExp('[-_]')).first.toLowerCase();
    for (final language in AppLanguage.values) {
      if (language.code == languageCode) {
        return language;
      }
    }
    return null;
  }
}
