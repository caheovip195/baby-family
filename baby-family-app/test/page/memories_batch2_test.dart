import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/generated/l10n/app_localizations_vi.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/quick_create_sheet.dart';
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

List<Override> _subject(String? id) => [
  selectedSubjectProvider.overrideWith(() => _Subject(id)),
];

/// Màn batch 2 của khu Ký ức (route để dựng lại đúng khung Pencil).
final _screens = <String, PageRouteInfo>{
  'mem_03': const AlbumsRoute(),
  'mem_03a': AlbumDetailRoute(albumId: 'al-que-ngoai'),
  'mem_08': PhotoViewerRoute(memoryId: 'm-hana-holds-haru', index: 2),
  'mem_10': MemoryCommentsRoute(memoryId: 'm-hana-holds-haru'),
  'mem_11': MilestonePickerRoute(childId: 'haru'),
  'mem_13': DiaryEditorRoute(),
  'mem_14': LetterComposerRoute(),
  'mem_15': const MemorySearchRoute(),
  'mem_16': const OnThisDayRoute(),
  'rec_02': const WeeklyRecapRoute(),
};

const _memoriesTab = MainShellRoute(children: [MemoriesTabRoute()]);

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
  if (find.text(text).evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      find.text(text),
      300,
      scrollable: find.byType(Scrollable).first,
    );
  }
  final finder = find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _back(WidgetTester tester, AppRouter router) async {
  await router.maybePop();
  await tester.pumpAndSettle();
}

/// MEM-15 với “nhà trẻ” đã tìm, lọc Hana (khung Pencil).
Future<AppRouter> _searchNhaTre(WidgetTester tester) async {
  final router = await pumpRoute(
    tester,
    const MemorySearchRoute(),
    overrides: _subject('hana'),
  );
  await tester.enterText(find.byType(TextField), 'nhà trẻ');
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
  return router;
}

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    for (final entry in _screens.entries) {
      testWidgets('design qa ${entry.key}', (tester) async {
        await pumpRoute(tester, entry.value);
        await _shot(tester, entry.key);
      });
    }
    testWidgets('design qa mem_15_results', (tester) async {
      await _searchNhaTre(tester);
      await _shot(tester, 'mem_15_results');
    });
    testWidgets('design qa mem_03a_menu', (tester) async {
      await pumpRoute(tester, AlbumDetailRoute(albumId: 'al-que-ngoai'));
      await tester.tap(find.bySemanticsLabel('Thêm thao tác'));
      await tester.pumpAndSettle();
      await _shot(tester, 'mem_03a_menu');
    });
  });

  group('layout', () {
    for (final entry in _screens.entries) {
      testWidgets('${entry.key} fits 360 dp, text 1.3, dark', (tester) async {
        await pumpRoute(
          tester,
          entry.value,
          size: kNarrowSize,
          textScale: 1.3,
          themeMode: ThemeMode.dark,
        );
        expect(tester.takeException(), isNull);
      });
    }
    testWidgets('mem_15 results fit 360 dp, text 1.3', (tester) async {
      await pumpRoute(
        tester,
        const MemorySearchRoute(),
        size: kNarrowSize,
        textScale: 1.3,
      );
      await tester.enterText(find.byType(TextField), 'nhà trẻ');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('content', () {
    test('childAgeShortText: “4 tháng”, “1 tuổi 4 tháng”, “2 tuổi”', () {
      final l10n = AppLocalizationsVi();
      final birth = DateTime(2024, 6, 1);
      expect(childAgeShortText(l10n, birth, DateTime(2024, 10, 7)), '4 tháng');
      expect(
        childAgeShortText(l10n, birth, DateTime(2025, 10, 7)),
        '1 tuổi 4 tháng',
      );
      expect(childAgeShortText(l10n, birth, DateTime(2026, 6, 1)), '2 tuổi');
    });

    testWidgets('MEM-03 shows auto and family albums from the frame', (
      tester,
    ) async {
      await pumpRoute(tester, const AlbumsRoute());
      expect(find.text('Haru · 17 ảnh'), findsOneWidget);
      expect(find.text('18 cột mốc'), findsOneWidget);
      expect(find.text('Trung thu của Hana & Haru'), findsOneWidget);
      expect(find.text('15 ký ức · Papa & Mama'), findsOneWidget);
    });

    testWidgets('MEM-03a shows range, creator and the 0:24 video', (
      tester,
    ) async {
      await pumpRoute(tester, AlbumDetailRoute(albumId: 'al-que-ngoai'));
      expect(find.text('32 ký ức · 14 – 18/09/2026'), findsOneWidget);
      expect(find.text('Mama tạo'), findsOneWidget);
      expect(find.text('0:24'), findsOneWidget);
    });

    testWidgets('MEM-11 Truyền thống Việt 7 / 9 đã ghi', (tester) async {
      await pumpRoute(tester, MilestonePickerRoute(childId: 'haru'));
      expect(find.text('7 / 9 đã ghi'), findsOneWidget);
      expect(find.text('Đã ghi · 08/04/2026'), findsOneWidget);
    });

    testWidgets('MEM-14 letter opens on Haru’s 18th birthday', (tester) async {
      await pumpRoute(tester, LetterComposerRoute());
      expect(find.text('Gửi Haru của Mama,'), findsOneWidget);
      expect(find.text('Haru mở vào 08/04/2043'), findsOneWidget);
      expect(find.text('Mở vào 08/04/2043 · Sinh nhật thứ 18'), findsOneWidget);
    });

    testWidgets('MEM-15 “nhà trẻ” → 9 photos + 3 diaries', (tester) async {
      await _searchNhaTre(tester);
      expect(find.text('12 kết quả cho “nhà trẻ”'), findsOneWidget);
      expect(find.text('Ảnh & video · 9'), findsOneWidget);
      expect(find.text('Nhật ký · 3'), findsOneWidget);
      expect(find.text('+3'), findsOneWidget);
      expect(find.text('07/10/2026 · Mama'), findsOneWidget);
    });

    testWidgets('MEM-16 groups by year with child ages', (tester) async {
      await pumpRoute(tester, const OnThisDayRoute());
      expect(find.text('Ngày 7 tháng 10 của nhà mình'), findsOneWidget);
      expect(find.text('2 năm kỷ niệm · 3 ký ức'), findsOneWidget);
      expect(find.text('07/10/2025 · Hana 1 tuổi 4 tháng'), findsOneWidget);
      expect(find.text('07/10/2024 · Hana 4 tháng'), findsOneWidget);
    });

    testWidgets('REC-02 highlight matches the frame', (tester) async {
      await pumpRoute(tester, const WeeklyRecapRoute());
      expect(find.text('Tuần này · 05 – 11/10/2026 · Cả nhà'), findsOneWidget);
      expect(find.text('Lần đầu tự đánh răng'), findsOneWidget);
      expect(find.text('Hana · 06/10 · Papa kể'), findsOneWidget);
    });
  });

  group('flows', () {
    testWidgets('MEM-01 search → MEM-15 → MEM-16 shortcut', (tester) async {
      final router = await pumpRoute(tester, _memoriesTab);
      await tester.tap(find.bySemanticsLabel('Tìm kiếm ký ức').first);
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MemorySearchRoute.name);
      await _tapText(tester, 'Ngày này năm xưa');
      expect(router.topRoute.name, OnThisDayRoute.name);
      await _back(tester, router);
      await _tapText(tester, 'Album');
      expect(router.topRoute.name, AlbumsRoute.name);
    });

    testWidgets('MEM-22 album card → MEM-03 → MEM-03a → menu sheet', (
      tester,
    ) async {
      final router = await pumpRoute(tester, _memoriesTab);
      await tester.tap(find.text('Bộ sưu tập'));
      await tester.pumpAndSettle();
      await _tapText(tester, 'Album của nhà mình');
      expect(router.topRoute.name, AlbumsRoute.name);
      await _tapText(tester, 'Về quê ngoại · Tháng 9');
      expect(router.topRoute.name, AlbumDetailRoute.name);
      await tester.tap(find.bySemanticsLabel('Thêm thao tác'));
      await tester.pumpAndSettle();
      expect(find.text('Đổi tên'), findsOneWidget);
      expect(find.text('Ký ức trong album vẫn được giữ lại'), findsOneWidget);
    });

    testWidgets('MEM-03 new album opens its detail', (tester) async {
      final router = await pumpRoute(tester, const AlbumsRoute());
      await _tapText(tester, 'Album mới');
      await tester.enterText(find.byType(TextField), 'Đi biển');
      await _tapText(tester, 'Tạo album');
      expect(router.topRoute.name, AlbumDetailRoute.name);
      expect(find.text('Đi biển'), findsOneWidget);
    });

    testWidgets('MEM-07 hero → MEM-08 (swipe down closes), Xem tất cả → '
        'MEM-10', (tester) async {
      final router = await pumpRoute(
        tester,
        MemoryDetailRoute(memoryId: 'm-hana-holds-haru'),
      );
      await tester.tapAt(const Offset(195, 200));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, PhotoViewerRoute.name);
      expect(find.text('1 / 3'), findsOneWidget);
      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('2 / 3'), findsOneWidget);
      await tester.fling(find.byType(PageView), const Offset(0, 400), 1500);
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MemoryDetailRoute.name);
      await _tapText(tester, 'Xem tất cả');
      expect(router.topRoute.name, MemoryCommentsRoute.name);
    });

    testWidgets('MEM-10 reply goes into the thread', (tester) async {
      await pumpRoute(
        tester,
        MemoryCommentsRoute(memoryId: 'm-hana-holds-haru'),
      );
      expect(find.text('Bình luận (6)'), findsOneWidget);
      await _tapText(tester, 'Trả lời');
      expect(find.text('Đang trả lời Bà nội'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Dạ bà ơi');
      await tester.tap(find.bySemanticsLabel('Gửi'));
      await tester.pumpAndSettle();
      expect(find.text('Bình luận (7)'), findsOneWidget);
      expect(find.text('Dạ bà ơi'), findsOneWidget);
      await tester.longPress(find.text('Dạ bà ơi'));
      await tester.pumpAndSettle();
      expect(find.text('Sao chép'), findsOneWidget);
      expect(find.text('Sửa'), findsOneWidget);
      await tester.tap(find.text('Xoá'));
      await tester.pumpAndSettle();
      expect(find.text('Bình luận (6)'), findsOneWidget);
    });

    testWidgets('MEM-05 “Đánh dấu cột mốc” → MEM-11 → back with milestone', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        MemoryComposerRoute(kind: MemoryKind.photo.name, childId: 'haru'),
      );
      await _tapText(tester, 'Đánh dấu cột mốc');
      expect(router.topRoute.name, MilestonePickerRoute.name);
      await _tapText(tester, 'Cắt tóc máu');
      expect(router.topRoute.name, MemoryComposerRoute.name);
      expect(find.text('Cắt tóc máu'), findsOneWidget);
    });

    testWidgets('QC-01 Nhật ký → MEM-13 (save closes), Thư gửi con → MEM-14 '
        '(seal closes)', (tester) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      Future<void> quick(String label) async {
        await tester.tap(find.bySemanticsLabel('Tạo mới'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(QuickCreateSheet),
            matching: find.bySemanticsLabel(label),
          ),
        );
        await tester.pumpAndSettle();
      }

      await quick('Nhật ký');
      expect(router.topRoute.name, DiaryEditorRoute.name);
      expect(find.text('Ngày đầu Hana đi nhà trẻ'), findsOneWidget);
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, HomeTabRoute.name);
      // Chờ snack bar “Đã lưu nhật ký” tự ẩn.
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await quick('Thư gửi con');
      expect(router.topRoute.name, LetterComposerRoute.name);
      await _tapText(tester, 'Niêm phong thư');
      expect(router.topRoute.name, HomeTabRoute.name);
    });

    testWidgets('HOME-01 “Tuần này của nhà mình” → REC-02 → close', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      await _tapText(tester, 'Tuần này của nhà mình');
      expect(router.topRoute.name, WeeklyRecapRoute.name);
      await tester.tap(find.bySemanticsLabel('Đóng'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, HomeTabRoute.name);
    });
  });
}
