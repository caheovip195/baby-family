import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/extension/date_time.dart';

/// Giờ tối bắt đầu từ 18:00 — “tối qua” thay cho “hôm qua”.
const _eveningHour = 18;

/// Thời gian tương đối theo thiết kế (HOME-01 feed, NOTI-01, MEM-07):
/// “Vừa xong”, “20 phút trước”, “2 giờ trước” (cùng ngày), “tối qua” /
/// “hôm qua”, còn lại là ngày theo locale. [now] lấy từ `AppClock`.
String relativeTimeText(
  AppLocalizations l10n,
  DateTime time,
  DateTime now, {
  String? locale,
}) {
  final diff = now.difference(time);
  if (diff.inMinutes < 1) {
    return l10n.commonJustNow;
  }
  if (diff.inMinutes < Duration.minutesPerHour) {
    return l10n.commonMinutesAgo(diff.inMinutes);
  }
  if (time.isSameDay(now)) {
    return l10n.commonHoursAgo(diff.inHours);
  }
  if (time.isSameDay(now.subtract(const Duration(days: 1)))) {
    return time.hour >= _eveningHour
        ? l10n.commonLastNight
        : l10n.commonYesterdayLower;
  }
  return time.toDisplayDate(locale);
}
