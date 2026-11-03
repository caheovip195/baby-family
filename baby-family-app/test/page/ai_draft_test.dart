import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

/// BF-20261028-010/011: bản nháp AI trên giao diện (bản mock, không gọi mạng).
void main() {
  setUpAll(loadAppFonts);

  testWidgets('MEM-04: caption ideas fill the caption box', (tester) async {
    await pumpRoute(tester, MemoryComposerRoute(), size: const Size(390, 1400));
    await tester.enterText(find.byType(TextField).first, 'Bé cười');
    await tester.tap(find.text('Gợi ý chú thích'));
    await tester.pumpAndSettle();
    expect(find.text('Bé cười — một ngày thật vui'), findsOneWidget);
    await tester.tap(find.text('Bé cười — một ngày thật vui'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller?.text,
      'Bé cười — một ngày thật vui',
    );
  });

  testWidgets('US-11: AI summary of what both shared', (tester) async {
    await pumpRoute(
      tester,
      BridgeSessionRoute(sessionId: 'br-1'),
      size: const Size(390, 1600),
    );
    await tester.scrollUntilVisible(find.text('✨ Tóm tắt giúp hai bạn'), 200);
    await tester.tap(find.text('✨ Tóm tắt giúp hai bạn'));
    await tester.pumpAndSettle();
    expect(
      find.text('Hai bạn đều đang mệt và cần được hiểu nhau hơn.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('CARE-04: AI ideas come from the library itself', (tester) async {
    await pumpRoute(tester, const MissionLibraryRoute());
    await tester.tap(find.text('✨ Gợi ý cho hôm nay'));
    await tester.pumpAndSettle();
    expect(find.text('Gợi ý cho hôm nay'), findsOneWidget);
    expect(find.text('Gợi ý bởi AI'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
