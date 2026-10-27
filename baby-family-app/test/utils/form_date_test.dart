import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/helper/form_date.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// BF-20261026-004: ô ngày đọc đúng định dạng đã điền sẵn theo ngôn ngữ.
void main() {
  setUpAll(() async {
    for (final locale in ['vi', 'en', 'zh', 'ja']) {
      await initializeDateFormatting(locale);
    }
  });

  test('round-trips toFormDate in every app language', () {
    final day = DateTime(2026, 11, 9);
    for (final locale in ['vi', 'en', 'zh', 'ja']) {
      expect(
        parseFormDate(day.toFormDate(locale), locale),
        day,
        reason: locale,
      );
    }
  });

  test('en reads month first; vi reads day first', () {
    expect(parseFormDate('10/26/2026', 'en'), DateTime(2026, 10, 26));
    expect(parseFormDate('26/10/2026', 'vi'), DateTime(2026, 10, 26));
    expect(parseFormDate('26-10-2026', 'vi'), DateTime(2026, 10, 26));
  });

  test('impossible dates are rejected, not rolled over', () {
    // Trước đây “10/26/2026” (en) thành 2/10/2028.
    expect(parseFormDate('10/26/2026', 'vi'), isNull);
    expect(parseFormDate('31/02/2026', 'vi'), isNull);
    expect(parseFormDate('13/1/2026', 'en'), isNull);
    expect(parseFormDate('', 'vi'), isNull);
    expect(parseFormDate('hôm qua', 'vi'), isNull);
  });
}
