import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/misc.dart' show Override;

import '../helpers/design_qa.dart';

class _Subject extends SelectedSubjectNotifier {
  _Subject(this.id);

  final String? id;

  @override
  String? build() => id;
}

/// Chủ thể đang xem = [id] (Pencil MEM-01 vẽ theo Haru).
List<Override> _subject(String? id) => [
  selectedSubjectProvider.overrideWith(() => _Subject(id)),
];

const _memoriesTab = MainShellRoute(children: [MemoriesTabRoute()]);

/// Mọi màn của khu Ký ức (route + cấu hình để dựng lại đúng khung Pencil).
final _screens =
    <String, (PageRouteInfo, {String actor, List<Override> overrides})>{
      'mem_01': (_memoriesTab, actor: 'mama', overrides: _subject('haru')),
      'mem_01_all': (_memoriesTab, actor: 'mama', overrides: const []),
      'mem_05': (MemoryComposerRoute(), actor: 'mama', overrides: const []),
      'mem_05_letter': (
        MemoryComposerRoute(kind: MemoryKind.letter.name),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_05_voice': (
        MemoryComposerRoute(kind: MemoryKind.voice.name, childId: 'haru'),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_05_diary': (
        MemoryComposerRoute(kind: MemoryKind.diary.name, childId: 'hana'),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_07': (
        MemoryDetailRoute(memoryId: 'm-hana-holds-haru'),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_12': (
        FirstsRoute(childId: 'haru'),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_20': (
        MonthlyPhotosRoute(childId: 'haru'),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_21': (
        MonthlyCameraRoute(childId: 'haru', month: 6),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_22_detail': (
        CollectionDetailRoute(code: 'keepsakes'),
        actor: 'mama',
        overrides: const [],
      ),
      'mem_24': (
        MemoryPerspectiveRoute(memoryId: 'm-hana-holds-haru'),
        actor: 'papa',
        overrides: const [],
      ),
      'mem_25': (
        MemoryStoryRoute(childId: 'haru'),
        actor: 'mama',
        overrides: const [],
      ),
    };

Future<AppRouter> _pump(
  WidgetTester tester,
  String name, {
  Size size = kDesignSize,
  ThemeMode themeMode = ThemeMode.light,
  double textScale = 1,
}) {
  final screen = _screens[name]!;
  return pumpRoute(
    tester,
    screen.$1,
    actor: screen.actor,
    overrides: screen.overrides,
    size: size,
    themeMode: themeMode,
    textScale: textScale,
  );
}

/// Golden: chờ giải mã ảnh asset (Image.asset tải bất đồng bộ).
Future<void> _shot(WidgetTester tester, String name) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  await tester.pumpAndSettle();
  await saveDesignShot(tester, name);
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final finder = find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    for (final name in _screens.keys) {
      testWidgets('design qa $name', (tester) async {
        await _pump(tester, name);
        await _shot(tester, name);
      });
    }
    testWidgets('design qa mem_01_dark', (tester) async {
      await _pump(tester, 'mem_01', themeMode: ThemeMode.dark);
      await _shot(tester, 'mem_01_dark');
    });
    testWidgets('design qa mem_02', (tester) async {
      await _pump(tester, 'mem_01');
      await tester.tap(find.text('Ảnh').first);
      await tester.pumpAndSettle();
      await _shot(tester, 'mem_02');
    });
    testWidgets('design qa mem_22', (tester) async {
      await _pump(tester, 'mem_01');
      await tester.tap(find.text('Bộ sưu tập'));
      await tester.pumpAndSettle();
      await _shot(tester, 'mem_22');
    });
    testWidgets('design qa mem_23', (tester) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      router.push(MemoryQuoteRoute());
      await tester.pumpAndSettle();
      await _shot(tester, 'mem_23');
    });
  });

  group('layout', () {
    for (final name in _screens.keys) {
      testWidgets('$name fits 360 dp, text 1.3, dark', (tester) async {
        await _pump(
          tester,
          name,
          size: kNarrowSize,
          textScale: 1.3,
          themeMode: ThemeMode.dark,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('flows', () {
    testWidgets('MEM-01 timeline shows design content and opens MEM-07', (
      tester,
    ) async {
      final router = await _pump(tester, 'mem_01');
      expect(find.text('Haru · 17 tháng 29 ngày'), findsOneWidget);
      expect(
        find.text('186 ký ức · 6 lần đầu · 9 đoạn ghi âm'),
        findsOneWidget,
      );
      expect(find.text('Tháng thứ 18 của Haru'), findsOneWidget);
      expect(find.text('08/09 – 07/10 · ĐANG DIỄN RA'), findsOneWidget);
      await _tapText(tester, 'Lần đầu Hana bế em Haru 🥹');
      expect(router.topRoute.name, MemoryDetailRoute.name);
      expect(find.text('Papa kể'), findsOneWidget);
      expect(find.text('Bình luận (6)'), findsOneWidget);
    });

    testWidgets('MEM-01 filter Ghi âm keeps only voice clips', (tester) async {
      await _pump(tester, 'mem_01');
      await _tapText(tester, 'Ghi âm');
      expect(
        find.text('Tiếng cười giòn tan khi Papa thổi bụng'),
        findsOneWidget,
      );
      expect(find.text('Vòng tay sơ sinh của Haru'), findsNothing);
    });

    testWidgets('MEM-22 cards open MEM-20, MEM-12 and collection detail', (
      tester,
    ) async {
      final router = await _pump(tester, 'mem_01');
      await tester.tap(find.text('Bộ sưu tập'));
      await tester.pumpAndSettle();
      expect(find.text('Haru · 17/18 ảnh'), findsOneWidget);
      expect(find.text('Hana · 34 câu'), findsOneWidget);
      await _tapText(tester, 'Con lớn từng tháng');
      expect(router.topRoute.name, MonthlyPhotosRoute.name);
      await router.maybePop();
      await tester.pumpAndSettle();
      await _tapText(tester, 'Những lần đầu');
      expect(router.topRoute.name, FirstsRoute.name);
      await router.maybePop();
      await tester.pumpAndSettle();
      await _tapText(tester, 'Kỷ vật');
      expect(router.topRoute.name, CollectionDetailRoute.name);
    });

    // BF-20261026-001: chưa có bé đã sinh / câu nói gắn với bé → không hiện
    // “ · 0/0 ảnh”, “ · 34 câu” thiếu tên bé.
    testWidgets('MEM-22 quotes card without a child has no dangling dot', (
      tester,
    ) async {
      await pumpRoute(tester, _memoriesTab, seed: DemoSeed.pregnant);
      await tester.tap(find.text('Bộ sưu tập'));
      await tester.pumpAndSettle();
      expect(find.textContaining(RegExp(r'^ · ')), findsNothing);
      expect(find.text('0/0 ảnh'), findsOneWidget);
      expect(find.textContaining(RegExp(r'^\d+ câu$')), findsOneWidget);
    });

    testWidgets('MEM-05 save returns to the previous screen', (tester) async {
      final router = await _pump(tester, 'mem_01');
      router.push(MemoryComposerRoute(kind: MemoryKind.photo.name));
      await tester.pumpAndSettle();
      expect(
        find.text('Lần đầu Hana bế em Haru, cả hai cười tít mắt'),
        findsOneWidget,
      );
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MemoriesTabRoute.name);
    });

    testWidgets('MEM-07 → MEM-24 → save shows the perspective on MEM-07', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        MemoryDetailRoute(memoryId: 'm-keepsake-bracelet'),
        actor: 'papa',
      );
      expect(find.text('Papa kể'), findsNothing);
      await _tapText(tester, 'Thêm góc nhìn của bạn');
      expect(router.topRoute.name, MemoryPerspectiveRoute.name);
      await tester.enterText(find.byType(TextField), 'Anh nhớ hôm đó.');
      await _tapText(tester, 'Lưu góc nhìn · Cả hai cùng kể');
      expect(router.topRoute.name, MemoryDetailRoute.name);
      expect(find.text('Papa kể'), findsOneWidget);
      expect(find.text('Anh nhớ hôm đó.'), findsOneWidget);
    });

    testWidgets('MEM-21 shutter → MEM-05 monthly photo → back to MEM-20', (
      tester,
    ) async {
      final router = await _pump(tester, 'mem_20');
      await _tapText(tester, 'Tháng 18 · ngày mai');
      expect(router.topRoute.name, MonthlyCameraRoute.name);
      await tester.tap(find.bySemanticsLabel('Chụp ảnh'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MemoryComposerRoute.name);
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MonthlyPhotosRoute.name);
      expect(find.text('18 tháng'), findsOneWidget);
    });

    testWidgets('MEM-23 saves a quote and closes the sheet', (tester) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      router.push(MemoryQuoteRoute());
      await tester.pumpAndSettle();
      expect(
        find.text('Mẹ ơi, trăng đi theo con kìa! Trăng thích con hả mẹ?'),
        findsOneWidget,
      );
      await _tapText(tester, 'Lưu câu nói');
      expect(router.topRoute.name, HomeTabRoute.name);
    });

    testWidgets('MEM-25 taps through stories and closes at the end', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      router.push(MemoryStoryRoute(childId: 'haru'));
      await tester.pumpAndSettle();
      expect(find.text('Hôm nay của Haru'), findsOneWidget);
      await tester.tapAt(const Offset(350, 400));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, HomeTabRoute.name);
    });
  });
}
