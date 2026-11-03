import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

/// BF-20261028-004: CHD-06 Tăng trưởng (bản mock).
void main() {
  setUpAll(loadAppFonts);

  testWidgets('CHD-06: add a measurement from the empty state', (tester) async {
    await pumpRoute(tester, GrowthRoute(childId: 'haru'));
    expect(
      find.text(
        'Chưa có lần đo nào. Thêm cân nặng hoặc chiều cao của lần khám gần '
        'nhất nhé.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('không thay thế tư vấn của bác sĩ'), findsOne);
    await tester.tap(find.text('Thêm lần đo').last);
    await tester.pumpAndSettle();
    // Chưa nhập số nào: báo lỗi, không đóng sheet.
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Nhập cân nặng hoặc chiều cao hợp lệ.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), '9,5');
    await tester.enterText(find.byType(TextField).at(1), '76');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('9,5 kg · 76 cm'), findsOneWidget);
    expect(find.text('Cần ít nhất 2 lần đo để vẽ biểu đồ.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CHD-01 opens CHD-06 for a born child', (tester) async {
    final router = await pumpRoute(
      tester,
      ChildProfileRoute(childId: 'haru'),
      size: const Size(390, 1400),
    );
    await tester.scrollUntilVisible(find.text('Tăng trưởng'), 200);
    await tester.tap(find.text('Tăng trưởng'));
    await tester.pumpAndSettle();
    expect(router.topRoute.name, GrowthRoute.name);
  });

  testWidgets('CHD-06 narrow + large text', (tester) async {
    await pumpRoute(
      tester,
      GrowthRoute(childId: 'haru'),
      size: kNarrowSize,
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });
}
