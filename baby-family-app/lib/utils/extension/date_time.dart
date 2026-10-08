import 'package:intl/intl.dart';

/// Định dạng ngày giờ theo locale (tài liệu kỹ thuật 22.12).
/// Truyền `context.localeName`; bỏ trống dùng `Intl.defaultLocale`.
extension DateTimeFormatExt on DateTime {
  /// vi: `07/10/2026` • en: `10/7/2026`.
  String toDisplayDate([String? locale]) => DateFormat.yMd(locale).format(this);

  /// vi: `7 thg 10, 2026` • en: `Oct 7, 2026`.
  String toDisplayDateMedium([String? locale]) =>
      DateFormat.yMMMd(locale).format(this);

  /// Giờ 24h `HH:mm`.
  String toDisplayTime([String? locale]) => DateFormat.Hm(locale).format(this);

  /// `yyyy-MM-dd` — ngày nghiệp vụ gửi API (không phụ thuộc locale).
  String get toApiDate => DateFormat('yyyy-MM-dd', 'en').format(this);

  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
