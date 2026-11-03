import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

/// BF-20261028-007: Bàn giao ca (bản mock).
void main() {
  setUpAll(loadAppFonts);

  testWidgets('a parent hands over with a note and sees the card', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      const MainShellRoute(children: [CoupleTabRoute()]),
      size: const Size(390, 1600),
    );
    await tester.scrollUntilVisible(find.text('Bàn giao ca'), 200);
    await tester.tap(find.text('Bàn giao ca'));
    await tester.pumpAndSettle();
    // Chưa có mốc giờ hay ghi chú: báo lỗi, không gửi.
    await tester.tap(find.text('Gửi bàn giao'));
    await tester.pumpAndSettle();
    expect(
      find.text('Chọn ít nhất một mốc giờ hoặc viết ghi chú.'),
      findsOneWidget,
    );
    await tester.enterText(
      find.byType(TextField).last,
      'Bé hơi quấy, đã thay tã',
    );
    await tester.tap(find.text('Gửi bàn giao'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Bạn đã bàn giao'), findsOneWidget);
    expect(find.text('Bé hơi quấy, đã thay tã'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('handoff sheet fits a narrow screen with large text', (
    tester,
  ) async {
    await pumpRoute(
      tester,
      const MainShellRoute(children: [CoupleTabRoute()]),
      size: kNarrowSize,
      textScale: 1.3,
    );
    await tester.scrollUntilVisible(find.text('Bàn giao ca'), 200);
    await tester.tap(find.text('Bàn giao ca'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
