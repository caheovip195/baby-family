import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../helpers/design_qa.dart';

PregnancyJourneyRoute _journey(PregnancyTab tab) =>
    PregnancyJourneyRoute(pregnancyId: 'bo', tab: tab.name);

/// Golden tests decode asset images asynchronously — precache them so the
/// design shots show the photos.
Future<void> _shot(WidgetTester tester, String name) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pumpAndSettle();
  await saveDesignShot(tester, name);
}

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    for (final tab in PregnancyTab.values) {
      testWidgets('design qa PREG ${tab.name}', (tester) async {
        await pumpRoute(tester, _journey(tab));
        await _shot(tester, 'preg_${tab.name}');
      });
    }

    testWidgets('design qa PREG-05 B1/B2/B3', (tester) async {
      await pumpRoute(tester, BirthRoute(pregnancyId: 'bo'));
      await _shot(tester, 'preg_05_b1');
      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();
      await _shot(tester, 'preg_05_b2');
      await tester.tap(find.text('Xem thẻ chào mừng'));
      await tester.pumpAndSettle();
      await _shot(tester, 'preg_05_b3');
    });

    testWidgets('design qa PREG timeline dark', (tester) async {
      await pumpRoute(
        tester,
        _journey(PregnancyTab.timeline),
        themeMode: ThemeMode.dark,
      );
      await _shot(tester, 'preg_timeline_dark');
    });

    testWidgets('design qa PREG-06', (tester) async {
      await pumpRoute(tester, PregnancyArchiveRoute(pregnancyId: 'bo'));
      await _shot(tester, 'preg_06');
    });

    testWidgets('design qa PREG-07', (tester) async {
      await pumpRoute(tester, BabyNamesRoute(pregnancyId: 'bo'));
      await _shot(tester, 'preg_07');
    });
  });

  group('layout', () {
    final routes = <String, PageRouteInfo Function()>{
      for (final tab in PregnancyTab.values)
        'journey ${tab.name}': () => _journey(tab),
      'birth': () => BirthRoute(pregnancyId: 'bo'),
      'archive': () => PregnancyArchiveRoute(pregnancyId: 'bo'),
      'names': () => BabyNamesRoute(pregnancyId: 'bo'),
    };
    for (final entry in routes.entries) {
      testWidgets('${entry.key} 360dp ×1.3 light', (tester) async {
        await pumpRoute(
          tester,
          entry.value(),
          size: kNarrowSize,
          textScale: 1.3,
        );
        expect(tester.takeException(), isNull);
      });
      testWidgets('${entry.key} 390dp dark', (tester) async {
        await pumpRoute(tester, entry.value(), themeMode: ThemeMode.dark);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('flows', () {
    testWidgets('PREG-01 menu → PREG-06 archive', (tester) async {
      final router = await pumpRoute(tester, _journey(PregnancyTab.timeline));
      await tester.tap(find.byIcon(LucideIcons.ellipsis).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lưu trữ'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, PregnancyArchiveRoute.name);
    });

    testWidgets('PREG-01 menu → PREG-05 birth', (tester) async {
      final router = await pumpRoute(tester, _journey(PregnancyTab.timeline));
      await tester.tap(find.byIcon(LucideIcons.ellipsis).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bé đã chào đời'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, BirthRoute.name);
    });

    testWidgets('PREG-01 tabs switch', (tester) async {
      await pumpRoute(tester, _journey(PregnancyTab.timeline));
      await tester.tap(find.text('Chuẩn bị'));
      await tester.pumpAndSettle();
      expect(find.text('Đã chuẩn bị 12/30'), findsOneWidget);
      await tester.tap(find.text('Túi đồ đi sinh cho mẹ'));
      await tester.pumpAndSettle();
      expect(find.text('Đã chuẩn bị 13/30'), findsOneWidget);
      await tester.tap(find.text('Bụng bầu'));
      await tester.pumpAndSettle();
      expect(find.text('T24 · chụp'), findsOneWidget);
    });

    testWidgets('PREG-05 B1 → B2 → B3 → Home', (tester) async {
      final router = await pumpRoute(tester, BirthRoute(pregnancyId: 'bo'));
      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xem thẻ chào mừng'));
      await tester.pumpAndSettle();
      expect(find.text('Chào mừng An Nhiên! 💜'), findsOneWidget);
      await tester.tap(find.text('Hoàn tất & báo tin 🎉'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, HomeTabRoute.name);
    });

    testWidgets('PREG-06 confirm → Home', (tester) async {
      final router = await pumpRoute(
        tester,
        PregnancyArchiveRoute(pregnancyId: 'bo'),
      );
      await tester.tap(find.text('Tạm dừng hành trình'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lưu trữ'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, HomeTabRoute.name);
    });

    testWidgets('PREG-07 select, like and choose', (tester) async {
      await pumpRoute(tester, BabyNamesRoute(pregnancyId: 'bo'));
      await tester.tap(find.text('Minh Anh'));
      await tester.pumpAndSettle();
      expect(find.text('Chọn “Minh Anh” làm tên của Bơ'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Mama thích').at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chọn “Minh Anh” làm tên của Bơ'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
