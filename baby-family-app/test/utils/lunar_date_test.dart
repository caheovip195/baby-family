import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/helper/lunar_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('solar → lunar (CARE-07 week, story v2 birthdays)', () {
    final today = solarToLunar(DateTime(2026, 10, 7));
    expect((today.day, today.month), (27, 8));
    final first = solarToLunar(DateTime(2026, 10, 10));
    expect((first.day, first.month), (1, 9));
    final haru = solarToLunar(DateTime(2025, 4, 8));
    expect((haru.day, haru.month, haru.year), (11, 3, 2025));
    final tet = solarToLunar(DateTime(2027, 2, 6));
    expect((tet.day, tet.month, tet.year), (1, 1, 2027));
  });

  test('lunar → solar (CAL-02 “Rằm tháng 10” 2026)', () {
    expect(lunarToSolar(15, 10, 2026), DateTime(2026, 11, 23));
    expect(lunarToSolar(1, 1, 2026), DateTime(2026, 2, 17));
  });

  test('can chi', () {
    final vi = lookupAppLocalizations(const Locale('vi'));
    expect(lunarYearName(vi, 2025), 'Ất Tỵ');
    expect(lunarYearName(vi, 2026), 'Bính Ngọ');
  });
}
