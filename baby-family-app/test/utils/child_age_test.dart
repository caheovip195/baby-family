import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // “Hôm nay” của câu chuyện thiết kế Pencil.
  final today = DateTime(2026, 10, 7);
  final vi = lookupAppLocalizations(const Locale('vi'));
  final en = lookupAppLocalizations(const Locale('en'));

  group('childAgeParts', () {
    test('Haru born 01/05/2026 is 5 months 6 days', () {
      final age = childAgeParts(DateTime(2026, 5, 1), today);
      expect((age.years, age.months, age.days), (0, 5, 6));
      expect(childAgeText(vi, DateTime(2026, 5, 1), today), '5 tháng 6 ngày');
      expect(childAgeText(en, DateTime(2026, 5, 1), today), '5 months 6 days');
    });

    test('Hana born 01/06/2024 is 2 years 4 months', () {
      expect(childAgeText(vi, DateTime(2024, 6, 1), today), '2 tuổi 4 tháng');
    });

    test('month boundaries and newborns', () {
      expect(childAgeText(vi, DateTime(2026, 9, 30), today), '7 ngày tuổi');
      expect(childAgeText(vi, DateTime(2026, 9, 7), today), '4 tuần 2 ngày');
      expect(childAgeText(vi, DateTime(2026, 9, 2), today), '5 tuần');
      expect(childAgeText(vi, DateTime(2026, 7, 7), today), '3 tháng');
      expect(childAgeText(vi, DateTime(2025, 10, 7), today), '12 tháng');
      expect(childAgeText(vi, DateTime(2024, 10, 7), today), '2 tuổi');
      // 31st → shorter month: 31/08 to 07/10 = 1 month (30/09) + 7 days.
      final age = childAgeParts(DateTime(2026, 8, 31), today);
      expect((age.months, age.days), (1, 7));
      expect(childAgeParts(DateTime(2027, 1, 1), today).days, 0);
    });

    test('month index and range (MEM-01 chapters)', () {
      final birth = DateTime(2026, 5, 1);
      expect(childAgeInMonths(birth, today), 5);
      expect(childMonthIndex(birth, today), 6);
      final range = childMonthRange(birth, 6);
      expect(range.start, DateTime(2026, 10, 1));
      expect(range.end, DateTime(2026, 11, 1));
      expect(childMonthDate(birth, 6), DateTime(2026, 11, 1));
      expect(childAgeInDays(birth, today), 159);
    });
  });

  group('pregnancy', () {
    final due = DateTime(2027, 1, 24);

    test('Bơ (due 24/01/2027) is week 24 + 3 days, 109 days left', () {
      final week = pregnancyWeek(due, today);
      expect((week.week, week.day), (24, 3));
      expect(pregnancyWeekText(vi, due, today), 'Tuần 24 + 3 ngày');
      expect(pregnancyWeekText(en, due, today), 'Week 24 + 3 days');
      expect(daysUntil(due, today), 109);
      expect(trimesterOf(week.week), Trimester.second);
    });

    test('whole weeks and trimesters', () {
      expect(pregnancyWeekText(vi, due, DateTime(2026, 10, 4)), 'Tuần 24');
      expect(trimesterOf(13), Trimester.first);
      expect(trimesterOf(28), Trimester.third);
      final estimated = dueDateFromWeek(24, today, day: 3);
      expect(estimated, due);
    });
  });
}
