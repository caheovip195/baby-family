import 'dart:convert';
import 'dart:io';

import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/widget/language_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Set<String> _messageKeys(String path) {
  final json =
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  return json.keys.where((key) => !key.startsWith('@')).toSet();
}

void main() {
  setUpAll(() async {
    for (final language in AppLanguage.values) {
      await initializeDateFormatting(language.code);
    }
  });

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
    expect(AppLanguage.fromCode('zh-CN'), AppLanguage.zh);
    expect(AppLanguage.fromCode('zh_Hans_CN'), AppLanguage.zh);
    expect(AppLanguage.fromCode('ja-JP'), AppLanguage.ja);
    expect(AppLanguage.fromCode('JA'), AppLanguage.ja);
    expect(AppLanguage.fromCode('fr-FR'), isNull);
    expect(AppLanguage.fromCode(null), isNull);
  });

  test('Ngôn ngữ thiết bị hỗ trợ zh/ja và fallback về vi', () {
    expect(appLanguageForLocales(const [Locale('ja', 'JP')]), AppLanguage.ja);
    expect(appLanguageForLocales(const [Locale('zh', 'CN')]), AppLanguage.zh);
    expect(appLanguageForLocales(const [Locale('fr', 'FR')]), AppLanguage.vi);
    expect(appLanguageForLocales(const []), AppLanguage.vi);
  });

  test('Plural ICU hoạt động ở mọi ngôn ngữ', () {
    expect(
      lookupAppLocalizations(AppLanguage.en.locale).commonDaysLeft(1),
      '1 day left',
    );
    expect(
      lookupAppLocalizations(AppLanguage.vi.locale).commonDaysLeft(3),
      'Còn 3 ngày',
    );
    expect(
      lookupAppLocalizations(AppLanguage.zh.locale).commonDaysLeft(3),
      '还剩 3 天',
    );
    expect(
      lookupAppLocalizations(AppLanguage.ja.locale).commonDaysLeft(3),
      '残り 3 日',
    );
    expect(
      lookupAppLocalizations(AppLanguage.zh.locale).commonDaysLeft(0),
      '今天是最后一天',
    );
    expect(
      lookupAppLocalizations(AppLanguage.ja.locale).commonDaysLeft(0),
      '今日が最終日です',
    );
  });

  test('Ngày zh/ja theo locale, ngày gửi API giữ yyyy-MM-dd', () {
    final date = DateTime(2026, 10, 8, 14, 5);
    expect(date.toDisplayDateMedium('zh'), '2026年10月8日');
    expect(date.toDisplayDateMedium('ja'), '2026年10月8日');
    expect(date.toDisplayTime('zh'), '14:05');
    expect(date.toDisplayTime('ja'), '14:05');
    expect(date.toApiDate, '2026-10-08');
  });

  testWidgets('Bộ chọn zh/ja ở 360dp và cỡ chữ 130% không overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final language in [AppLanguage.zh, AppLanguage.ja]) {
      AppLanguage? selected;
      await tester.pumpWidget(
        MaterialApp(
          locale: language.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.3)),
            child: child ?? const SizedBox.shrink(),
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  selected = await LanguagePickerSheet.show(
                    context,
                    selected: language,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(
        find.text(lookupAppLocalizations(language.locale).languagePickerTitle),
        findsOneWidget,
      );
      for (final available in AppLanguage.values) {
        expect(find.text(available.nativeName), findsOneWidget);
      }
      await tester.tap(find.text(AppLanguage.ja.nativeName));
      await tester.pumpAndSettle();
      expect(selected, AppLanguage.ja);
      expect(tester.takeException(), isNull);
    }
  });
}
