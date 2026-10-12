import 'dart:math' as math;

import 'package:baby_family/generated/l10n/app_localizations.dart';

// Âm lịch Việt Nam (múi giờ +7) — thuật toán Hồ Ngọc Đức. Dùng cho lịch
// (CARE-07 “27/8 âm”), sự kiện âm lịch (CAL-02 “Rằm tháng 10 → 23/11/2026”),
// ngày sinh âm (CHD-01 “11/3 Ất Tỵ”) và cột mốc truyền thống. Viết MỘT lần ở
// đây (Skill 11) — có test `test/utils/lunar_date_test.dart`.

const _timeZone = 7.0;

int _jdFromDate(int day, int month, int year) {
  final a = (14 - month) ~/ 12;
  final y = year + 4800 - a;
  final m = month + 12 * a - 3;
  var jd =
      day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045;
  if (jd < 2299161) {
    jd = day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - 32083;
  }
  return jd;
}

DateTime _dateFromJd(int jd) {
  int a;
  int b;
  int c;
  if (jd > 2299160) {
    a = jd + 32044;
    b = (4 * a + 3) ~/ 146097;
    c = a - (b * 146097) ~/ 4;
  } else {
    b = 0;
    c = jd + 32082;
  }
  final d = (4 * c + 3) ~/ 1461;
  final e = c - (1461 * d) ~/ 4;
  final m = (5 * e + 2) ~/ 153;
  final day = e - (153 * m + 2) ~/ 5 + 1;
  final month = m + 3 - 12 * (m ~/ 10);
  final year = b * 100 + d - 4800 + m ~/ 10;
  return DateTime(year, month, day);
}

int _newMoonDay(int k) {
  final t = k / 1236.85;
  final t2 = t * t;
  final t3 = t2 * t;
  const dr = math.pi / 180;
  var jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
  jd1 += 0.00033 * math.sin((166.56 + 132.87 * t - 0.009173 * t2) * dr);
  final m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3;
  final mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3;
  final f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3;
  var c1 =
      (0.1734 - 0.000393 * t) * math.sin(m * dr) +
      0.0021 * math.sin(2 * dr * m);
  c1 = c1 - 0.4068 * math.sin(mpr * dr) + 0.0161 * math.sin(dr * 2 * mpr);
  c1 -= 0.0004 * math.sin(dr * 3 * mpr);
  c1 = c1 + 0.0104 * math.sin(dr * 2 * f) - 0.0051 * math.sin(dr * (m + mpr));
  c1 =
      c1 -
      0.0074 * math.sin(dr * (m - mpr)) +
      0.0004 * math.sin(dr * (2 * f + m));
  c1 =
      c1 -
      0.0004 * math.sin(dr * (2 * f - m)) -
      0.0006 * math.sin(dr * (2 * f + mpr));
  c1 =
      c1 +
      0.0010 * math.sin(dr * (2 * f - mpr)) +
      0.0005 * math.sin(dr * (2 * mpr + m));
  final deltat = t < -11
      ? 0.001 +
            0.000839 * t +
            0.0002261 * t2 -
            0.00000845 * t3 -
            0.000000081 * t * t3
      : -0.000278 + 0.000265 * t + 0.000262 * t2;
  final jdNew = jd1 + c1 - deltat;
  return (jdNew + 0.5 + _timeZone / 24).floor();
}

int _sunLongitude(int jdn) {
  final t = (jdn - 2451545.5 - _timeZone / 24) / 36525;
  final t2 = t * t;
  const dr = math.pi / 180;
  final m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2;
  final l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2;
  var dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * math.sin(dr * m);
  dl +=
      (0.019993 - 0.000101 * t) * math.sin(dr * 2 * m) +
      0.000290 * math.sin(dr * 3 * m);
  var l = (l0 + dl) * dr;
  l -= math.pi * 2 * (l / (math.pi * 2)).floor();
  return (l / math.pi * 6).floor();
}

int _lunarMonth11(int year) {
  final off = _jdFromDate(31, 12, year) - 2415021;
  final k = (off / 29.530588853).floor();
  var nm = _newMoonDay(k);
  if (_sunLongitude(nm) >= 9) {
    nm = _newMoonDay(k - 1);
  }
  return nm;
}

int _leapMonthOffset(int a11) {
  final k = ((a11 - 2415021.076998695) / 29.530588853 + 0.5).floor();
  var last = 0;
  var i = 1;
  var arc = _sunLongitude(_newMoonDay(k + i));
  do {
    last = arc;
    i++;
    arc = _sunLongitude(_newMoonDay(k + i));
  } while (arc != last && i < 14);
  return i - 1;
}

/// Ngày âm lịch của một ngày dương (múi giờ Việt Nam).
({int day, int month, int year, bool leap}) solarToLunar(DateTime date) {
  final dayNumber = _jdFromDate(date.day, date.month, date.year);
  final k = ((dayNumber - 2415021.076998695) / 29.530588853).floor();
  var monthStart = _newMoonDay(k + 1);
  if (monthStart > dayNumber) {
    monthStart = _newMoonDay(k);
  }
  var a11 = _lunarMonth11(date.year);
  var b11 = a11;
  int lunarYear;
  if (a11 >= monthStart) {
    lunarYear = date.year;
    a11 = _lunarMonth11(date.year - 1);
  } else {
    lunarYear = date.year + 1;
    b11 = _lunarMonth11(date.year + 1);
  }
  final lunarDay = dayNumber - monthStart + 1;
  final diff = (monthStart - a11) ~/ 29;
  var leap = false;
  var lunarMonth = diff + 11;
  if (b11 - a11 > 365) {
    final leapMonthDiff = _leapMonthOffset(a11);
    if (diff >= leapMonthDiff) {
      lunarMonth = diff + 10;
      if (diff == leapMonthDiff) {
        leap = true;
      }
    }
  }
  if (lunarMonth > 12) {
    lunarMonth -= 12;
  }
  if (lunarMonth >= 11 && diff < 4) {
    lunarYear -= 1;
  }
  return (day: lunarDay, month: lunarMonth, year: lunarYear, leap: leap);
}

/// Ngày dương của một ngày âm lịch (null nếu tháng nhuận không tồn tại).
DateTime? lunarToSolar(int day, int month, int year, {bool leap = false}) {
  int a11;
  int b11;
  if (month < 11) {
    a11 = _lunarMonth11(year - 1);
    b11 = _lunarMonth11(year);
  } else {
    a11 = _lunarMonth11(year);
    b11 = _lunarMonth11(year + 1);
  }
  final k = (0.5 + (a11 - 2415021.076998695) / 29.530588853).floor();
  var off = month - 11;
  if (off < 0) {
    off += 12;
  }
  if (b11 - a11 > 365) {
    final leapOff = _leapMonthOffset(a11);
    var leapMonth = leapOff - 2;
    if (leapMonth < 0) {
      leapMonth += 12;
    }
    if (leap && month != leapMonth) {
      return null;
    }
    if (leap || off >= leapOff) {
      off += 1;
    }
  } else if (leap) {
    return null;
  }
  final monthStart = _newMoonDay(k + off);
  return _dateFromJd(monthStart + day - 1);
}

/// Can chi của năm âm lịch: chỉ số thiên can (0 = Giáp … 9 = Quý) và địa chi
/// (0 = Tý … 11 = Hợi). Tên hiển thị lấy từ l10n (`lunarStem*`, `lunarBranch*`).
({int stem, int branch}) lunarYearCanChi(int lunarYear) =>
    (stem: (lunarYear + 6) % 10, branch: (lunarYear + 8) % 12);

/// “Ất Tỵ” — tên năm âm lịch đã dịch.
String lunarYearName(AppLocalizations l10n, int lunarYear) {
  final canChi = lunarYearCanChi(lunarYear);
  return l10n.commonLunarYear('${canChi.stem}', '${canChi.branch}');
}

/// “11/03 Ất Tỵ” — ngày/tháng âm (tháng 2 chữ số) kèm năm can chi (CHD-01/02).
String lunarDateWithYearText(AppLocalizations l10n, DateTime date) {
  final lunar = solarToLunar(date);
  return l10n.childLunarDateYear(
    '${lunar.day}',
    lunar.month.toString().padLeft(2, '0'),
    lunarYearName(l10n, lunar.year),
  );
}
