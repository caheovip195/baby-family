import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';

// Tuổi bé, tuần thai, số ngày còn lại, tháng tuổi — viết MỘT lần ở đây (Skill 11).
// Mọi hàm nhận `today` để test và để dùng “hôm nay” của dữ liệu mẫu (AppClock).

DateTime _date(DateTime value) => DateTime(value.year, value.month, value.day);

/// Cộng [months] tháng, giữ ngày nhưng kẹp về ngày cuối tháng (31/08 + 1 tháng
/// = 30/09).
DateTime _addMonths(DateTime value, int months) {
  final firstOfTarget = DateTime(value.year, value.month + months);
  final lastDay = DateTime(firstOfTarget.year, firstOfTarget.month + 1, 0).day;
  return DateTime(
    firstOfTarget.year,
    firstOfTarget.month,
    value.day > lastDay ? lastDay : value.day,
  );
}

/// Tuổi theo lịch: số năm, tháng, ngày tròn từ [birth] tới [today].
({int years, int months, int days}) childAgeParts(
  DateTime birth,
  DateTime today,
) {
  final from = _date(birth);
  final to = _date(today);
  if (to.isBefore(from)) {
    return (years: 0, months: 0, days: 0);
  }
  var months = (to.year - from.year) * 12 + to.month - from.month;
  if (_addMonths(from, months).isAfter(to)) {
    months--;
  }
  final anchor = _addMonths(from, months);
  final days = to.difference(anchor).inDays;
  return (years: months ~/ 12, months: months % 12, days: days);
}

/// Legacy API used by the old `?screen=` pages (lib/page/**/legacy_*).
({int years, int months}) childAge(DateTime birthday, DateTime reference) {
  final parts = childAgeParts(birthday, reference);
  return (years: parts.years, months: parts.months);
}

/// Tổng số tháng tròn.
int childAgeInMonths(DateTime birth, DateTime today) {
  final parts = childAgeParts(birth, today);
  return parts.years * 12 + parts.months;
}

/// Số ngày tuổi.
int childAgeInDays(DateTime birth, DateTime today) =>
    _date(today).difference(_date(birth)).inDays;

/// Tháng thứ mấy của bé (MEM-01 “Tháng thứ 6 của Haru”, ảnh tháng 6) =
/// số tháng tròn + 1.
int childMonthIndex(DateTime birth, DateTime today) =>
    childAgeInMonths(birth, today) + 1;

/// Khoảng ngày của tháng thứ [monthIndex] (bắt đầu 1): `[start, end)`.
({DateTime start, DateTime end}) childMonthRange(
  DateTime birth,
  int monthIndex,
) {
  final from = _date(birth);
  return (
    start: _addMonths(from, monthIndex - 1),
    end: _addMonths(from, monthIndex),
  );
}

/// Ngày bé tròn [months] tháng.
DateTime childMonthDate(DateTime birth, int months) =>
    _addMonths(_date(birth), months);

/// Tuần thai `(week, day)` từ ngày dự sinh: LMP = dự sinh − 280 ngày.
({int week, int day}) pregnancyWeek(DateTime dueDate, DateTime today) {
  final lmp = _date(
    dueDate,
  ).subtract(const Duration(days: kValuePregnancyTotalDays));
  final elapsed = _date(today).difference(lmp).inDays;
  if (elapsed < 0) {
    return (week: 0, day: 0);
  }
  return (week: elapsed ~/ 7, day: elapsed % 7);
}

/// Ngày dự sinh suy ra khi người dùng chỉ biết tuần thai (ONB-05a).
DateTime dueDateFromWeek(int week, DateTime today, {int day = 0}) =>
    _date(today).add(Duration(days: kValuePregnancyTotalDays - week * 7 - day));

/// Số ngày còn lại tới [target] (âm nếu đã qua). HOME-03 “Còn 109 ngày gặp Bơ”.
int daysUntil(DateTime target, DateTime today) =>
    _date(target).difference(_date(today)).inDays;

/// Tam cá nguyệt theo tuần thai: 1–13, 14–27, 28+.
Trimester trimesterOf(int week) {
  if (week < 14) {
    return Trimester.first;
  }
  if (week < 28) {
    return Trimester.second;
  }
  return Trimester.third;
}

/// Nhãn tuổi bé theo tài liệu nghiệp vụ 7.3: 0–13 ngày “5 ngày tuổi”,
/// 2–12 tuần “6 tuần 3 ngày”, 3–23 tháng “17 tháng 29 ngày”, từ 2 tuổi
/// “2 tuổi 4 tháng” (Pencil HOME-01, SW-01, FAM-01, CHD-01).
String childAgeText(AppLocalizations l10n, DateTime birth, DateTime today) {
  final age = childAgeParts(birth, today);
  final months = age.years * 12 + age.months;
  if (months >= 24) {
    return age.months == 0
        ? l10n.commonAgeYears(age.years)
        : l10n.commonAgeYearsMonths(age.years, age.months);
  }
  if (months >= 3) {
    return age.days == 0
        ? l10n.commonAgeMonths(months)
        : l10n.commonAgeMonthsDays(months, age.days);
  }
  final days = childAgeInDays(birth, today);
  if (days < 14) {
    return l10n.commonAgeDaysOld(days < 0 ? 0 : days);
  }
  return days % 7 == 0
      ? l10n.commonAgeWeeks(days ~/ 7)
      : l10n.commonAgeWeeksDays(days ~/ 7, days % 7);
}

/// Tuổi rút gọn theo năm + tháng tròn (bỏ ngày lẻ) cho mốc thời gian đã qua:
/// “4 tháng”, “1 tuổi 4 tháng”, “2 tuổi” (Pencil MEM-16 Ngày này năm xưa).
String childAgeShortText(AppLocalizations l10n, DateTime birth, DateTime at) {
  final age = childAgeParts(birth, at);
  if (age.years == 0) {
    return l10n.commonAgeMonths(age.months);
  }
  return age.months == 0
      ? l10n.commonAgeYears(age.years)
      : l10n.commonAgeYearsMonths(age.years, age.months);
}

/// “Tuần 24 + 3 ngày” (ngày lẻ = 0 → “Tuần 24”).
String pregnancyWeekText(
  AppLocalizations l10n,
  DateTime dueDate,
  DateTime today,
) {
  final value = pregnancyWeek(dueDate, today);
  return value.day == 0
      ? l10n.commonPregnancyWeekOnly(value.week)
      : l10n.commonPregnancyWeekDay(value.week, value.day);
}
