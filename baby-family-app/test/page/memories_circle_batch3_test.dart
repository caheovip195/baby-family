// MEMORIES, CIRCLE & MODERATION (batch 3): MEM-17/18/19, RPT-01/02, CHD-05,
// CIR-02…06, SET-10 — design shots, render (360 ×1.3, dark) and main flows.
import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/page/parent/child_archive/child_archive_controller.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

/// CHD-05b: Khang lưu trữ từ 28/09 (Pencil tR0OK) → đủ 7 ngày.
Future<void> _archiveKhangLongAgo(WidgetTester tester) async {
  final container = _container(tester);
  container.read(mockStoreProvider).find('children', 'khang')!['archivedAt'] =
      DateTime(2026, 9, 28, 10).toIso8601String();
  await container.read(childArchiveControllerProvider('khang')).load();
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

final _screens = <String, (PageRouteInfo, DemoSeed)>{
  'MEM-17': (const TrashRoute(), DemoSeed.active),
  'MEM-18': (const DraftsRoute(), DemoSeed.active),
  'MEM-19': (const PendingReviewRoute(), DemoSeed.active),
  'CHD-05': (ChildArchiveRoute(childId: 'khang'), DemoSeed.active),
  'CIR-01': (
    const CircleShellRoute(children: [CircleHomeRoute()]),
    DemoSeed.circle,
  ),
  'CIR-02': (
    const CircleShellRoute(children: [CircleChildRoute()]),
    DemoSeed.circle,
  ),
  'CIR-03': (
    CircleMemoryDetailRoute(memoryId: 'c-haru-roll'),
    DemoSeed.circle,
  ),
  'CIR-04': (
    const CircleShellRoute(children: [CirclePostRoute()]),
    DemoSeed.circle,
  ),
  'CIR-05': (const CirclePausedRoute(), DemoSeed.circlePaused),
  'CIR-06': (
    const CircleShellRoute(children: [CircleMeRoute()]),
    DemoSeed.circle,
  ),
  'SET-10': (const LeaveFamilyRoute(), DemoSeed.circle),
};

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    for (final entry in _screens.entries) {
      testWidgets('design qa ${entry.key}', (tester) async {
        final (route, seed) = entry.value;
        await pumpRoute(tester, route, seed: seed);
        await saveDesignShot(
          tester,
          entry.key.toLowerCase().replaceAll('-', '_'),
        );
      });
    }
    testWidgets('design qa MEM-17b', (tester) async {
      await pumpRoute(tester, const TrashRoute());
      await _tap(tester, find.text('Xoá vĩnh viễn').first);
      await saveDesignShot(tester, 'mem_17b');
    });
    testWidgets('design qa CHD-05 before archiving', (tester) async {
      await pumpRoute(tester, ChildArchiveRoute(childId: 'khang'));
      final container = _container(tester);
      await container.read(childServiceProvider).restoreChild('khang');
      await container.read(childArchiveControllerProvider('khang')).load();
      await tester.pumpAndSettle();
      await saveDesignShot(tester, 'chd_05_ijwos');
    });
    testWidgets('design qa CHD-05b', (tester) async {
      await pumpRoute(tester, ChildArchiveRoute(childId: 'khang'));
      await _archiveKhangLongAgo(tester);
      await _tap(tester, find.textContaining('Tôi hiểu Khang'));
      await tester.enterText(find.byType(TextField), 'Khang');
      await tester.pumpAndSettle();
      await saveDesignShot(tester, 'chd_05b');
    });
    testWidgets('design qa CIR-03 menu', (tester) async {
      await pumpRoute(
        tester,
        CircleMemoryDetailRoute(memoryId: 'c-haru-roll'),
        seed: DemoSeed.circle,
      );
      await _tap(tester, find.bySemanticsLabel('Thêm thao tác'));
      await saveDesignShot(tester, 'cir_03_menu');
    });
    testWidgets('design qa RPT-01', (tester) async {
      await pumpRoute(
        tester,
        CircleMemoryDetailRoute(memoryId: 'c-haru-roll'),
        seed: DemoSeed.circle,
      );
      await _tap(tester, find.bySemanticsLabel('Thêm thao tác'));
      await _tap(tester, find.text('Báo cáo'));
      await _tap(tester, find.text('Lo ngại an toàn trẻ em'));
      await saveDesignShot(tester, 'rpt_01');
      await _tap(tester, find.text('Gửi báo cáo'));
      await saveDesignShot(tester, 'rpt_01b');
    });
    testWidgets('design qa CIR-04b', (tester) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CirclePostRoute()]),
        seed: DemoSeed.circle,
      );
      await _tap(tester, find.text('Gửi ảnh'));
      await saveDesignShot(tester, 'cir_04b');
    });
    testWidgets('design qa MEM-19 rejecting', (tester) async {
      await pumpRoute(tester, const PendingReviewRoute(), size: const Size(390, 1178));
      await _tap(tester, find.text('Từ chối').at(1));
      await saveDesignShot(tester, 'mem_19_reject');
    });
  });

  group('render without overflow', () {
    for (final entry in _screens.entries) {
      for (final dark in [false, true]) {
        testWidgets('${entry.key} 360dp ×1.3 ${dark ? 'dark' : 'light'}', (
          tester,
        ) async {
          final (route, seed) = entry.value;
          final router = await pumpRoute(
            tester,
            route,
            seed: seed,
            size: kNarrowSize,
            textScale: 1.3,
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          );
          expect(tester.takeException(), isNull);
          final top = route.initialChildren?.lastOrNull ?? route;
          expect(router.topRoute.name, top.routeName);
        });
      }
    }
  });
}
