import 'package:intl/intl.dart';

/// Đọc ngày người dùng gõ trong ô ngày — ngược với
/// `DateTimeFormatExt.toFormDate(locale)` (vi `dd/MM/yyyy`, ngôn ngữ khác
/// `yMd` của locale, vd. en `10/26/2026`). Chấp nhận `.`/`-` thay cho `/`.
/// Sai định dạng hoặc ngày không tồn tại (tháng 13, 31/02…) → null, không
/// tự cuộn sang ngày khác (BF-20261026-004).
///
/// Dùng ở PREG-06 (ngày sinh) và sheet sửa thai kỳ (ngày dự sinh).
DateTime? parseFormDate(String text, String locale) {
  final value = text.trim();
  if (value.isEmpty) {
    return null;
  }
  final format = locale.startsWith('vi')
      ? DateFormat('dd/MM/yyyy', locale)
      : DateFormat.yMd(locale);
  final separator = format.pattern?.contains('/') == true ? '/' : null;
  final normalized = separator == null
      ? value
      : value.replaceAll(RegExp(r'[.\-]'), separator);
  try {
    final date = format.parseStrict(normalized);
    return DateTime(date.year, date.month, date.day);
  } on FormatException {
    return null;
  }
}
