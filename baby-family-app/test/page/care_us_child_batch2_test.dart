import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    testWidgets('design qa care_07', (tester) async {
      await pumpRoute(tester, const CalendarRoute());
      expect(find.text('Thứ Tư, 07/10'), findsOneWidget);
      expect(find.text('5 mục'), findsOneWidget);
      expect(find.text('Nhiệm vụ · Haru · của tôi'), findsOneWidget);
      await saveDesignShot(tester, 'care_07');
    });

    testWidgets('design qa cal_02', (tester) async {
      await pumpRoute(
        tester,
        const EventCreateRoute(),
        size: const Size(390, 1203),
      );
      expect(find.text('Rằm tháng 10 âm lịch'), findsOneWidget);
      expect(find.text('Năm nay: Thứ Hai, 23/11/2026'), findsOneWidget);
      await saveDesignShot(tester, 'cal_02');
    });

    testWidgets('design qa care_08', (tester) async {
      await pumpRoute(
        tester,
        const MissionHistoryRoute(),
        size: const Size(390, 1014),
      );
      expect(find.text('Hôm nay · Thứ Tư 07/10'), findsOneWidget);
      expect(find.text('Đã xong 08:40 · Gắn kết'), findsOneWidget);
      expect(find.text('Papa · đã xong'), findsNWidgets(3));
      await saveDesignShot(tester, 'care_08');
    });

    testWidgets('design qa care_10', (tester) async {
      await pumpRoute(tester, const BadgesRoute(), size: const Size(390, 1272));
      expect(find.text('Đã mở 4 / 10 huy hiệu'), findsOneWidget);
      expect(find.text('Gần nhất: Tuần đồng đội · 28/09/2026'), findsOneWidget);
      await saveDesignShot(tester, 'care_10');
    });

    testWidgets('design qa care_12', (tester) async {
      await pumpRoute(
        tester,
        const MissionSettingsRoute(),
        size: const Size(390, 1189),
      );
      expect(find.text('Hỏi lúc 21:00'), findsOneWidget);
      expect(find.text('Trước 15′'), findsOneWidget);
      await saveDesignShot(tester, 'care_12');
    });

    testWidgets('design qa us_06', (tester) async {
      await pumpRoute(
        tester,
        const ThanksWallRoute(),
        size: const Size(390, 1000),
      );
      expect(find.text('Tháng 10'), findsOneWidget);
      expect(find.text('Papa · 06/10'), findsWidgets);
      await saveDesignShot(tester, 'us_06');
    });

    testWidgets('design qa us_07', (tester) async {
      await pumpRoute(
        tester,
        const PrivateJournalRoute(),
        size: const Size(390, 1113),
      );
      expect(find.text('Đêm thứ ba liền'), findsOneWidget);
      expect(find.text('Thứ Ba, 06/10 · 23:40'), findsOneWidget);
      expect(find.text('Đã chia sẻ 1 đoạn với Papa'), findsOneWidget);
      await saveDesignShot(tester, 'us_07');
    });

    testWidgets('design qa us_15', (tester) async {
      await pumpRoute(
        tester,
        const CoupleSettingsRoute(),
        size: const Size(390, 1070),
      );
      expect(find.text('Luôn chia sẻ với Papa'), findsOneWidget);
      expect(find.text('30 ngày'), findsOneWidget);
      await saveDesignShot(tester, 'us_15');
    });

    testWidgets('design qa chd_01', (tester) async {
      await pumpRoute(
        tester,
        ChildProfileRoute(childId: 'haru'),
        size: const Size(390, 1258),
      );
      expect(find.text('Nguyễn Minh Khang · 17 tháng 29 ngày'), findsOneWidget);
      expect(find.text('Thứ Ba, 08/04/2025'), findsOneWidget);
      expect(find.text('Âm lịch: 11/03 Ất Tỵ'), findsOneWidget);
      await saveDesignShot(tester, 'chd_01');
    });

    testWidgets('design qa chd_02', (tester) async {
      await pumpRoute(
        tester,
        ChildEditRoute(childId: 'haru'),
        size: const Size(390, 1229),
      );
      expect(find.text('Sửa hồ sơ Haru'), findsOneWidget);
      await saveDesignShot(tester, 'chd_02');
    });

    testWidgets('design qa chd_03', (tester) async {
      await pumpRoute(tester, const ChildrenRoute());
      expect(find.text('Tuần 24 + 3 ngày · dự sinh 24/01'), findsOneWidget);
      expect(find.text('Lưu trữ 02/10/2026 · 0 ký ức riêng'), findsOneWidget);
      await saveDesignShot(tester, 'chd_03');
    });

    testWidgets('design qa chd_04', (tester) async {
      await pumpRoute(
        tester,
        const ChildAddRoute(),
        size: const Size(390, 945),
      );
      expect(find.text('Tạo hành trình thai kỳ mới (Thai #4)'), findsOneWidget);
      await saveDesignShot(tester, 'chd_04');
    });
  });

  final routes = <String, PageRouteInfo>{
    'care_07': const CalendarRoute(),
    'cal_02': const EventCreateRoute(),
    'care_08': const MissionHistoryRoute(),
    'care_10': const BadgesRoute(),
    'care_12': const MissionSettingsRoute(),
    'us_06': const ThanksWallRoute(),
    'us_07': const PrivateJournalRoute(),
    'us_15': const CoupleSettingsRoute(),
    'chd_01': ChildProfileRoute(childId: 'haru'),
    'chd_02': ChildEditRoute(childId: 'haru'),
    'chd_03': const ChildrenRoute(),
    'chd_04': const ChildAddRoute(),
  };

  group('360 dp + text 1.3 + dark', () {
    for (final entry in routes.entries) {
      testWidgets('${entry.key} narrow', (tester) async {
        await pumpRoute(tester, entry.value, size: kNarrowSize, textScale: 1.3);
        expect(tester.takeException(), isNull);
      });
      testWidgets('${entry.key} dark', (tester) async {
        await pumpRoute(tester, entry.value, themeMode: ThemeMode.dark);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('navigation', () {
    testWidgets('CARE-01 calendar icon → CARE-07 → CAL-02', (tester) async {
      final router = await pumpRoute(
        tester,
        const MainShellRoute(children: [CareTabRoute()]),
      );
      await tester.tap(find.byIcon(LucideIcons.calendarDays).first);
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CalendarRoute.name);
      await tester.tap(find.text('Sự kiện').last);
      await tester.pumpAndSettle();
      expect(router.topRoute.name, EventCreateRoute.name);
      await tester.dragUntilVisible(
        find.text('Lưu sự kiện'),
        find.byType(ListView).last,
        const Offset(0, -300),
      );
      await tester.tap(find.text('Lưu sự kiện'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CalendarRoute.name);
    });

    testWidgets('CARE-07 week day tap + month mode', (tester) async {
      await pumpRoute(tester, const CalendarRoute());
      await tester.tap(find.text('Tháng'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('11').first);
      await tester.pumpAndSettle();
      expect(find.text('Chủ Nhật, 11/10'), findsOneWidget);
      expect(find.text('Cả nhà về thăm Ông bà ngoại'), findsOneWidget);
    });

    testWidgets('CARE-09 ⋯ → CARE-10 / CARE-08 / CARE-12', (tester) async {
      final router = await pumpRoute(tester, const FamilyTreeRoute());
      for (final (label, name) in [
        ('Huy hiệu của nhà mình', BadgesRoute.name),
        ('Lịch sử nhiệm vụ', MissionHistoryRoute.name),
        ('Cài đặt nhiệm vụ', MissionSettingsRoute.name),
      ]) {
        await tester.tap(find.byIcon(LucideIcons.ellipsis));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(router.topRoute.name, name);
        await router.maybePop();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('US-01 gear / thanks / journal', (tester) async {
      final router = await pumpRoute(
        tester,
        const MainShellRoute(children: [CoupleTabRoute()]),
      );
      await tester.tap(find.byIcon(LucideIcons.settings).first);
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CoupleSettingsRoute.name);
      await router.maybePop();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Nhật ký riêng'), 200);
      await tester.tap(find.text('Nhật ký riêng'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, PrivateJournalRoute.name);
    });

    testWidgets('US-07 write a page', (tester) async {
      await pumpRoute(tester, const PrivateJournalRoute());
      await tester.tap(find.text('Viết trang mới'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Trang thử');
      await tester.tap(find.text('Lưu trang'));
      await tester.pumpAndSettle();
      expect(find.text('Trang thử'), findsOneWidget);
    });

    testWidgets('CHD-03 add → CHD-04 → new profile', (tester) async {
      final router = await pumpRoute(tester, const ChildrenRoute());
      await tester.tap(find.text('Thêm bé'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, ChildAddRoute.name);
      await tester.tap(find.text('Thêm bé').last);
      await tester.pumpAndSettle();
      expect(router.topRoute.name, ChildProfileRoute.name);
    });

    testWidgets('CHD-01 edit → CHD-02 save', (tester) async {
      final router = await pumpRoute(
        tester,
        ChildProfileRoute(childId: 'haru'),
      );
      await tester.tap(find.text('Sửa hồ sơ'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, ChildEditRoute.name);
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, ChildProfileRoute.name);
    });
  });
}
