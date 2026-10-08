import 'dart:convert';
import 'dart:io';

import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:flutter_test/flutter_test.dart';

Set<String> _messageKeys(String path) {
  final json =
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return json.keys.where((key) => !key.startsWith('@')).toSet();
}

void main() {
  test('Mọi file ARB có đủ key như template app_vi.arb', () {
    final template = _messageKeys('lib/l10n/arb/app_vi.arb');
    final arbFiles = Directory(
      'lib/l10n/arb',
    ).listSync().whereType<File>().where((file) => file.path.endsWith('.arb'));
    for (final file in arbFiles) {
      final keys = _messageKeys(file.path);
      expect(
        template.difference(keys),
        isEmpty,
        reason: '${file.path} thiếu bản dịch',
      );
      expect(
        keys.difference(template),
        isEmpty,
        reason: '${file.path} có key không tồn tại trong template',
      );
    }
  });

  test('AppLanguage khớp với supportedLocales của AppLocalizations', () {
    final supported = AppLocalizations.supportedLocales
        .map((locale) => locale.languageCode)
        .toSet();
    expect(AppLanguage.values.map((e) => e.code).toSet(), supported);
  });

  test('AppLanguage.fromCode nhận cả mã vùng', () {
    expect(AppLanguage.fromCode('vi-VN'), AppLanguage.vi);
    expect(AppLanguage.fromCode('en_US'), AppLanguage.en);
    expect(AppLanguage.fromCode('ja'), isNull);
  });

  test('Plural ICU hoạt động ở cả vi và en', () {
    expect(
      lookupAppLocalizations(AppLanguage.en.locale).commonDaysLeft(1),
      '1 day left',
    );
    expect(
      lookupAppLocalizations(AppLanguage.vi.locale).commonDaysLeft(3),
      'Còn 3 ngày',
    );
  });
}
