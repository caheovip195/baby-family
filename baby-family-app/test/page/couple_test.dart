import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    testWidgets('design qa US-01', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
      );
      await saveDesignShot(tester, 'us_01');
    });

    testWidgets('design qa US-01 dark', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
        themeMode: ThemeMode.dark,
      );
      await saveDesignShot(tester, 'us_01_dark');
    });

    testWidgets('design qa US-02', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
      );
      await tester.tap(find.text('Mama (bạn)'));
      await tester.pumpAndSettle();
      await saveDesignShot(tester, 'us_02');
    });

    testWidgets('design qa US-03', (tester) async {
      await pumpRoute(tester, RequestComposeRoute());
      await saveDesignShot(tester, 'us_03');
    });

    testWidgets('design qa US-04 receiver', (tester) async {
      await _pumpPendingRequest(tester);
      await saveDesignShot(tester, 'us_04');
    });

    testWidgets('design qa US-04b accepted', (tester) async {
      await pumpRoute(
        tester,
        RequestDetailRoute(requestId: 'rq-1'),
        actor: 'papa',
      );
      await saveDesignShot(tester, 'us_04b');
    });

    testWidgets('design qa US-04 sender', (tester) async {
      await pumpRoute(tester, RequestDetailRoute(requestId: 'rq-1'));
      await saveDesignShot(tester, 'us_04_sender');
    });

    testWidgets('design qa US-05', (tester) async {
      await pumpRoute(tester, ThanksComposeRoute());
      await saveDesignShot(tester, 'us_05');
    });
  });

  group('layout', () {
    final routes = <String, PageRouteInfo Function()>{
      'US-01': () => const MainShellRoute(children: [CoupleTabRoute()]),
      'US-03': RequestComposeRoute.new,
      'US-04': () => RequestDetailRoute(requestId: 'rq-1'),
      'US-05': ThanksComposeRoute.new,
    };
    for (final entry in routes.entries) {
      for (final dark in [false, true]) {
        testWidgets('${entry.key} 360dp x1.3 ${dark ? 'dark' : 'light'}', (
          tester,
        ) async {
          await pumpRoute(
            tester,
            entry.value(),
            size: kNarrowSize,
            textScale: 1.3,
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            actor: entry.key == 'US-04' ? 'papa' : 'mama',
          );
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('US-02 sheet 360dp x1.3', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
        size: kNarrowSize,
        textScale: 1.3,
      );
      await tester.tap(find.text('Mama (bạn)'));
      await tester.pumpAndSettle();
      expect(find.text('Hôm nay bạn thế nào?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('US-04 receiver 360dp x1.3', (tester) async {
      await _pumpPendingRequest(tester, size: kNarrowSize, textScale: 1.3);
      expect(find.text('Nhận — để anh lo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('flow', () {
    testWidgets('US-01 shows the couple hub from mock data', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
      );
      expect(find.text('Chỉ hai bạn nhìn thấy'), findsOneWidget);
      expect(find.text('Ổn'), findsOneWidget);
      expect(find.text('Mệt'), findsOneWidget);
      expect(find.text("Cần yên tĩnh 20'"), findsOneWidget);
      expect(find.text('Bạn nhờ Papa trông Haru 30 phút'), findsOneWidget);
      expect(find.text('Papa đã nhận · 19:10'), findsOneWidget);
      expect(find.text('Papa · hôm qua'), findsOneWidget);
    });

    testWidgets('US-01 → US-02 save updates my mood', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
      );
      await tester.tap(find.text('Mama (bạn)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gửi cho Papa'));
      await tester.pumpAndSettle();
      expect(find.text('Hôm nay bạn thế nào?'), findsNothing);
      // Cả hai ô giờ là “Mệt” (sheet điền sẵn như Pencil).
      expect(find.text('Mệt'), findsNWidgets(2));
    });

    testWidgets('QC-01 check-in opens US-02 on the couple tab', (tester) async {
      await pumpRoute(tester, const MainShellRoute());
      await tester.tap(find.bySemanticsLabel('Tạo mới'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check-in').last);
      await tester.pumpAndSettle();
      expect(find.text('Hôm nay bạn thế nào?'), findsOneWidget);
    });

    testWidgets('open request → US-04 sender view', (tester) async {
      final router = await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
      );
      await tester.tap(find.text('Bạn nhờ Papa trông Haru 30 phút'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, RequestDetailRoute.name);
      expect(find.text('Lời nhờ của bạn'), findsOneWidget);
      expect(find.text('Papa đã nhận'), findsOneWidget);
    });

    testWidgets('US-03 send → US-04 sender view', (tester) async {
      final router = await pumpRoute(tester, RequestComposeRoute());
      expect(find.text('Nhờ Papa'), findsOneWidget);
      expect(find.text('Gửi cho Papa · đang mở 1/5'), findsOneWidget);
      await tester.tap(find.text('Gửi cho Papa · đang mở 1/5'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, RequestDetailRoute.name);
      expect(find.text('Cần nghỉ 30 phút — trông Haru giúp'), findsOneWidget);
      expect(find.text('Huỷ lời nhờ'), findsOneWidget);
    });

    testWidgets('US-04 Nhận → US-04b → Đã xong → US-05', (tester) async {
      final router = await _pumpPendingRequest(tester);
      await tester.tap(find.text('Nhận — để anh lo'));
      await tester.pumpAndSettle();
      expect(find.text('Bạn đã nhận lời nhờ'), findsOneWidget);
      await tester.tap(find.text('Đã xong ✓'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, ThanksComposeRoute.name);
      await tester.tap(find.text('Gửi cho Mama'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CoupleTabRoute.name);
    });
  });
}

/// rq-1 gửi lúc 19:02, Papa chưa nhận (trạng thái US-04 `jDPm9`).
Future<AppRouter> _pumpPendingRequest(
  WidgetTester tester, {
  Size size = kDesignSize,
  double textScale = 1,
}) async {
  final router = await pumpRoute(
    tester,
    const MainShellRoute(children: [CoupleTabRoute()]),
    actor: 'papa',
    size: size,
    textScale: textScale,
  );
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  container.read(mockStoreProvider)
    ..update('requests', 'rq-1', {
      'status': 'sent',
      'seenAt': null,
      'acceptedAt': null,
      'remindAt': null,
    })
    ..commit();
  await tester.pumpAndSettle();
  unawaited(router.push(RequestDetailRoute(requestId: 'rq-1')));
  await tester.pumpAndSettle();
  return router;
}
