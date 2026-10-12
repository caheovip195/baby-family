import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_tab_bar.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/quick_create_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:lucide_flutter/lucide_flutter.dart';

import '../helpers/design_qa.dart';

const _home = MainShellRoute(children: [HomeTabRoute()]);

List<Override> _subject(String id) => [
  selectedSubjectProvider.overrideWith(() => _Subject(id)),
];

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

/// Giải mã ảnh asset trước khi chụp (ảnh trong test chỉ hiện sau runAsync).
Future<void> _precache(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    testWidgets('design qa HOME-01', (tester) async {
      await pumpRoute(tester, _home);
      await _precache(tester);
      await saveDesignShot(tester, 'home_01');
    });

    testWidgets('design qa HOME-01 full', (tester) async {
      await pumpRoute(tester, _home, size: const Size(390, 2290));
      await _precache(tester);
      await saveDesignShot(tester, 'home_01_full');
    });

    testWidgets('design qa HOME-01 dark', (tester) async {
      await pumpRoute(tester, _home, themeMode: ThemeMode.dark);
      await _precache(tester);
      await saveDesignShot(tester, 'home_01_dark');
    });

    testWidgets('design qa HOME-02', (tester) async {
      await pumpRoute(
        tester,
        _home,
        size: const Size(390, 1530),
        overrides: _subject('haru'),
      );
      await _precache(tester);
      await saveDesignShot(tester, 'home_02');
    });

    testWidgets('design qa HOME-03', (tester) async {
      await pumpRoute(
        tester,
        _home,
        size: const Size(390, 1331),
        overrides: _subject('bo'),
      );
      await _precache(tester);
      await saveDesignShot(tester, 'home_03');
    });

    testWidgets('design qa NOTI-01', (tester) async {
      await pumpRoute(tester, const NotificationsRoute());
      await _precache(tester);
      await saveDesignShot(tester, 'noti_01');
    });

    testWidgets('design qa SW-01', (tester) async {
      await pumpRoute(tester, _home);
      await tester.tap(find.byType(ChildSwitcher));
      await tester.pumpAndSettle();
      await _precache(tester);
      await saveDesignShot(tester, 'sw_01');
    });

    testWidgets('design qa QC-01', (tester) async {
      await pumpRoute(tester, _home);
      await tester.tap(find.bySemanticsLabel('Tạo mới'));
      await tester.pumpAndSettle();
      await _precache(tester);
      await saveDesignShot(tester, 'qc_01');
    });
  });

  group('HOME-01 Cả nhà', () {
    testWidgets('shows the design content from the mock family', (
      tester,
    ) async {
      await pumpRoute(tester, _home, size: const Size(390, 2290));
      for (final text in [
        'Chào buổi tối,',
        'Mama Lan 🌙',
        'Hôm nay của các con',
        '9 khoảnh khắc',
        '5 ảnh',
        '4 ảnh',
        'Tuần 24',
        'Haru tròn 18 tháng 🎉',
        'Chuẩn bị chụp ảnh tháng — đã có 17/18 ảnh',
        'Papa & Mama · chỉ hai bạn',
        'Papa đang mệt',
        'Cần yên tĩnh khoảng 20 phút',
        '4/8 việc của nhà mình',
        '💗 5 của tôi',
        'Đọc sách tranh 10 phút',
        'Gợi ý hôm nay · Gắn kết · +5 💗',
        '+ 2 việc nữa của tôi · 💗 chỉ bạn thấy',
        'GỢI Ý GHI LẠI · HANA 2 TUỔI',
        'Câu nào của Hana hôm nay làm bạn bật cười?',
        'Papa vừa thêm 6 ảnh của Haru',
        'Buổi tắm tối nay · 20 phút trước',
        'Mẹ ơi, trăng đi theo con kìa! Trăng thích con hả mẹ?',
        'Hana · 2 tuổi 4 tháng · Papa ghi lại tối qua',
        'Lần đầu Hana bế em Haru 🥹',
        'Hana & Haru · Mama đăng · 2 giờ trước',
        'Tuần này của nhà mình',
        'Cây xanh · 97% tới Cây trổ hoa 🌸',
      ]) {
        expect(find.text(text), findsWidgets, reason: text);
      }
    });

    for (final (name, size, scale, theme) in [
      ('390 light', kDesignSize, 1.0, ThemeMode.light),
      ('360 x1.3', kNarrowSize, 1.3, ThemeMode.light),
      ('360 dark x1.3', kNarrowSize, 1.3, ThemeMode.dark),
    ]) {
      for (final subject in [null, 'haru', 'bo']) {
        testWidgets('no overflow $name subject=$subject', (tester) async {
          await pumpRoute(
            tester,
            _home,
            size: size,
            textScale: scale,
            themeMode: theme,
            overrides: subject == null ? const [] : _subject(subject),
          );
          final scrollable = find.byType(Scrollable).first;
          for (var step = 0; step < 12; step++) {
            await tester.drag(scrollable, const Offset(0, -400));
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('bell opens NOTI-01', (tester) async {
      final router = await pumpRoute(tester, _home);
      await tester.tap(find.bySemanticsLabel('Thông báo'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, NotificationsRoute.name);
    });

    testWidgets('family avatar opens FAM-01', (tester) async {
      final router = await pumpRoute(tester, _home);
      await tester.tap(find.bySemanticsLabel('Gia đình mình'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, FamilyRoute.name);
    });

    testWidgets('story ring opens MEM-25', (tester) async {
      final router = await pumpRoute(tester, _home);
      await tester.tap(find.text('Haru').first);
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MemoryStoryRoute.name);
    });

    testWidgets('monthly photo button opens MEM-21', (tester) async {
      final router = await pumpRoute(tester, _home);
      await _tapVisible(tester, find.text('Chụp ảnh tháng'));
      expect(router.topRoute.name, MonthlyCameraRoute.name);
    });

    testWidgets('see all missions switches to the care tab', (tester) async {
      final router = await pumpRoute(tester, _home);
      await _tapVisible(tester, find.text('Xem tất cả'));
      expect(router.topRoute.name, CareTabRoute.name);
    });

    testWidgets('prompt opens MEM-23', (tester) async {
      final router = await pumpRoute(tester, _home);
      await _tapVisible(tester, find.text('Ghi câu nói'));
      expect(router.topRoute.name, MemoryQuoteRoute.name);
    });

    testWidgets('feed memory opens MEM-07', (tester) async {
      final router = await pumpRoute(tester, _home);
      await _tapVisible(tester, find.text('Papa vừa thêm 6 ảnh của Haru'));
      expect(router.topRoute.name, MemoryDetailRoute.name);
    });

    testWidgets('tree opens CARE-09', (tester) async {
      final router = await pumpRoute(tester, _home);
      await _tapVisible(tester, find.text('Cây xanh · 97% tới Cây trổ hoa 🌸'));
      expect(router.topRoute.name, FamilyTreeRoute.name);
    });

    testWidgets('SW-01 switches the subject to HOME-02 and back', (
      tester,
    ) async {
      await pumpRoute(tester, _home);
      await tester.tap(find.byType(ChildSwitcher));
      await tester.pumpAndSettle();
      expect(find.text('Xem theo'), findsOneWidget);
      expect(find.text('Thai #3 · Bơ'), findsOneWidget);
      expect(find.text('Tuần 24 + 3 ngày'), findsOneWidget);
      await tester.tap(find.text('17 tháng 29 ngày'));
      await tester.pumpAndSettle();
      expect(find.text('Hôm nay của Haru'), findsOneWidget);
      await tester.tap(find.byIcon(LucideIcons.chevronLeft));
      await tester.pumpAndSettle();
      expect(find.text('Mama Lan 🌙'), findsOneWidget);
    });
  });

  group('HOME-02 bé đã sinh', () {
    testWidgets('shows Haru profile and opens monthly photos', (tester) async {
      final router = await pumpRoute(
        tester,
        _home,
        size: const Size(390, 1530),
        overrides: _subject('haru'),
      );
      for (final text in [
        'Haru',
        '17 tháng 29 ngày · sinh 08/04/2025 (11/3 âm lịch)',
        'Ký ức',
        'Giọng nói',
        'Cột mốc',
        'Thư cho con',
        'Hôm nay của Haru',
        'Xem dạng story',
        'CHƯƠNG HIỆN TẠI',
        'Tháng thứ 18 của Haru',
        '31 ký ức · 2 lần đầu · 4 đoạn ghi âm',
        'Ảnh tháng 18',
        'Những lần đầu gần đây',
        'Bước đi đầu tiên',
        'Gọi “Mẹ”',
        'Lần đầu tiếp theo?',
        'Chạy · Nói câu 2 từ',
        'Tiếng cười giòn tan khi Papa thổi bụng',
        'Con lớn từng tháng',
        '17/18 ảnh',
        'Việc cho Haru hôm nay',
        'Tắm cho Haru buổi tối',
        'Gợi ý hôm nay · 19:30 · +5 💗',
      ]) {
        expect(find.text(text), findsWidgets, reason: text);
      }
      await _tapVisible(tester, find.text('17/18 ảnh'));
      expect(router.topRoute.name, MonthlyPhotosRoute.name);
    });

    testWidgets('quick action opens the voice composer', (tester) async {
      final router = await pumpRoute(
        tester,
        _home,
        overrides: _subject('haru'),
      );
      await _tapVisible(tester, find.text('Giọng nói'));
      expect(router.topRoute.name, MemoryComposerRoute.name);
    });

    testWidgets('firsts “Tất cả” opens MEM-12', (tester) async {
      final router = await pumpRoute(
        tester,
        _home,
        overrides: _subject('haru'),
      );
      await _tapVisible(tester, find.text('Tất cả'));
      expect(router.topRoute.name, FirstsRoute.name);
    });
  });

  group('HOME-03 thai kỳ', () {
    testWidgets('shows Bơ pregnancy home', (tester) async {
      await pumpRoute(
        tester,
        _home,
        size: const Size(390, 1331),
        overrides: _subject('bo'),
      );
      for (final text in [
        'Bơ · Tuần 24',
        'TAM CÁ NGUYỆT 2',
        'Tuần 24 + 3 ngày',
        'Còn 109 ngày gặp Bơ 💜',
        'Dự sinh 24/01/2027',
        'Tuần này Bơ to cỡ bắp ngô · khoảng 30 cm',
        'Ảnh bụng',
        'Siêu âm',
        'Thư cho bé',
        'Bụng bầu theo tuần',
        'T20',
        'T24',
        'Chụp',
        'Lần đầu của Bơ',
        'Que 2 vạch',
        'Nghe tim thai',
        'Bé đạp',
        'Biết giới tính',
        'CẢ HAI CÙNG KỂ · TUẦN 20',
        'Lần đầu bé đạp',
        'Chuẩn bị đón bé',
        '12/30',
        'Túi đồ đi sinh cho mẹ',
        'Cùng nhau',
        'Đặt tên cho Bơ',
      ]) {
        expect(find.text(text), findsWidgets, reason: text);
      }
    });

    testWidgets('names card opens PREG-07, prep opens PREG-04', (tester) async {
      final router = await pumpRoute(tester, _home, overrides: _subject('bo'));
      await _tapVisible(tester, find.text('Đặt tên cho Bơ'));
      expect(router.topRoute.name, BabyNamesRoute.name);
      await router.maybePop();
      await tester.pumpAndSettle();
      await _tapVisible(tester, find.text('Túi đồ đi sinh cho mẹ'));
      expect(router.topRoute.name, PregnancyJourneyRoute.name);
    });
  });

  group('Main shell bar', () {
    testWidgets('FAB is 60 and opens QC-01 with 9 actions', (tester) async {
      await pumpRoute(tester, _home);
      final fab = find.descendant(
        of: find.byType(AppTabBar),
        matching: find.bySemanticsLabel('Tạo mới'),
      );
      expect(tester.getSize(fab).height, 60);
      await tester.tap(fab);
      await tester.pumpAndSettle();
      expect(find.byType(QuickCreateSheet), findsOneWidget);
      for (final text in [
        'Ký ức',
        'Nhật ký',
        'Cột mốc',
        'Thư gửi con',
        'Nhiệm vụ',
        'Sự kiện',
        'Check-in',
        'Lời nhờ',
        'Cảm ơn',
      ]) {
        expect(find.text(text), findsWidgets, reason: text);
      }
    });
  });

  group('NOTI-01', () {
    testWidgets('lists notifications by day and filters', (tester) async {
      await pumpRoute(tester, const NotificationsRoute());
      for (final text in [
        'Thông báo',
        'Đã đọc hết',
        'HÔM NAY',
        'Mama đang cần một chút hỗ trợ. Xem nhé?',
        '5 phút trước',
        '1 giờ trước',
        '3 giờ trước',
        'HÔM QUA',
        '20:15',
        '09:00',
      ]) {
        expect(find.text(text), findsWidgets, reason: text);
      }
      await tester.tap(find.text('Gia đình'));
      await tester.pumpAndSettle();
      expect(
        find.text('Mama đang cần một chút hỗ trợ. Xem nhé?'),
        findsNothing,
      );
      expect(find.text('Bà ngoại đã gửi lời chúc cho Haru'), findsOneWidget);
    });

    testWidgets('tapping an item opens its route', (tester) async {
      final router = await pumpRoute(tester, const NotificationsRoute());
      await tester.tap(find.text('Cây gia đình lên cấp 4 — Cây xanh!'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, FamilyTreeRoute.name);
    });

    testWidgets('no overflow at 360 x1.3 dark', (tester) async {
      await pumpRoute(
        tester,
        const NotificationsRoute(),
        size: kNarrowSize,
        textScale: 1.3,
        themeMode: ThemeMode.dark,
      );
      expect(tester.takeException(), isNull);
    });
  });
}

class _Subject extends SelectedSubjectNotifier {
  _Subject(this.id);

  final String id;

  @override
  String? build() => id;
}
