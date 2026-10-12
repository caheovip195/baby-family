import 'package:intl/intl.dart';

/// Định dạng ngày giờ theo locale (tài liệu kỹ thuật 22.12).
/// Truyền `context.localeName`; bỏ trống dùng `Intl.defaultLocale`.
extension DateTimeFormatExt on DateTime {
  /// vi: `07/10/2026` • en: `10/7/2026`.
  String toDisplayDate([String? locale]) => DateFormat.yMd(locale).format(this);

  /// Fixed-width Vietnamese form dates, locale conventions elsewhere.
  String toFormDate(String locale) => locale.startsWith('vi')
      ? DateFormat('dd/MM/yyyy', locale).format(this)
      : DateFormat.yMd(locale).format(this);

  /// vi: `7 thg 10, 2026` • en: `Oct 7, 2026`.
  String toDisplayDateMedium([String? locale]) =>
      DateFormat.yMMMd(locale).format(this);

  /// Giờ 24h `HH:mm`.
  String toDisplayTime([String? locale]) =>
      DateFormat('HH:mm', locale).format(this);

  /// `yyyy-MM-dd` — ngày nghiệp vụ gửi API (không phụ thuộc locale).
  String get toApiDate => DateFormat('yyyy-MM-dd', 'en').format(this);

  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

/// Ngày/tháng ngắn của các thẻ ký ức.
extension DateTimeShortExt on DateTime {
  /// vi: `07/10` • en: `Oct 7`.
  String toDayMonth(String locale) => locale.startsWith('vi')
      ? DateFormat('dd/MM', locale).format(this)
      : DateFormat.MMMd(locale).format(this);

  /// Khoảng ngày gọn tới [end] (MEM-03a, REC-02): vi cùng tháng
  /// `14 – 18/09/2026`, khác tháng `28/08 – 03/09/2026`; khác năm / ngôn ngữ
  /// khác: đủ hai ngày. Cùng ngày → một ngày.
  String toRangeLabel(DateTime end, String locale) {
    final last = end.toFormDate(locale);
    if (isSameDay(end)) {
      return last;
    }
    if (!locale.startsWith('vi') || year != end.year) {
      return '${toFormDate(locale)} – $last';
    }
    final first = month == end.month
        ? DateFormat('dd', locale).format(this)
        : toDayMonth(locale);
    return '$first – $last';
  }
}
