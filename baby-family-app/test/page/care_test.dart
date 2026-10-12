import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/mission_card.dart';
import 'package:baby_family/utils/widget/mission_completion_sheet.dart';
import 'package:baby_family/utils/widget/mission_swap_sheet.dart';
import 'package:baby_family/utils/widget/mission_template_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../helpers/design_qa.dart';

const _careShell = MainShellRoute(children: [CareTabRoute()]);

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

/// Bỏ mọi nhiệm vụ hôm nay → STATE-03.
Future<void> _clearBoard(WidgetTester tester) async {
  final service = _container(tester).read(careServiceProvider);
  final board = await service.board();
  for (final mission in board.all) {
    await service.removeFromToday(mission.id);
  }
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  group('design qa', () {
    testWidgets('design qa care_01 (Của tôi)', (tester) async {
      await pumpRoute(tester, _careShell);
      expect(find.text('Hearts của tôi hôm nay: 5'), findsOneWidget);
      expect(find.text('Đọc sách tranh 10 phút'), findsOneWidget);
      expect(find.text('Gợi ý hôm nay · Gắn kết · +5 💗'), findsOneWidget);
      expect(find.text('Tự tạo · +2 💗'), findsOneWidget);
      expect(find.text('Đã xong 08:40 · +5 💗'), findsOneWidget);
      expect(find.text('4/8 việc của nhà mình'), findsOneWidget);
      await saveDesignShot(tester, 'care_01');
    });

    testWidgets('design qa care_01 dark', (tester) async {
      await pumpRoute(tester, _careShell, themeMode: ThemeMode.dark);
      await saveDesignShot(tester, 'care_01_dark');
    });

    testWidgets('design qa care_01b (Của Papa)', (tester) async {
      await pumpRoute(tester, _careShell);
      await tester.tap(find.textContaining('Của Papa'));
      await tester.pumpAndSettle();
      expect(find.text('Papa đã xong cả 3 việc hôm nay'), findsOneWidget);
      expect(find.text('Đã cảm ơn'), findsOneWidget);
      expect(find.text('Cảm ơn'), findsNWidgets(2));
      expect(find.textContaining('💗'), findsNothing);
      await saveDesignShot(tester, 'care_01b');
    });

    testWidgets('design qa care_01c (Cùng nhau)', (tester) async {
      await pumpRoute(tester, _careShell);
      await tester.tap(find.textContaining('Cùng nhau'));
      await tester.pumpAndSettle();
      expect(find.text('Cả nhà đi dạo công viên'), findsOneWidget);
      await saveDesignShot(tester, 'care_01c');
    });

    testWidgets('design qa care_05 swap sheet', (tester) async {
      await pumpRoute(tester, _careShell);
      await tester.longPress(find.text('Đọc sách tranh 10 phút'));
      await tester.pumpAndSettle();
      expect(find.byType(MissionSwapSheet), findsOneWidget);
      expect(find.text('Hát cho Hana một bài'), findsOneWidget);
      expect(find.text('Còn 2 lần đổi hôm nay'), findsOneWidget);
      await saveDesignShot(tester, 'care_05');
      await tester.tap(find.text('Đổi sang việc này'));
      await tester.pumpAndSettle();
      expect(find.byType(MissionSwapSheet), findsNothing);
      expect(find.text('Hát cho Hana một bài'), findsOneWidget);
    });

    testWidgets('design qa care_06 completion sheet + undo', (tester) async {
      await pumpRoute(tester, _careShell);
      final card = find.widgetWithText(MissionCard, 'Đọc sách tranh 10 phút');
      await tester.tap(
        find.descendant(of: card, matching: find.byType(InkResponse)).first,
      );
      await tester.pumpAndSettle();
      expect(find.byType(MissionCompletionSheet), findsOneWidget);
      expect(find.text('Tuyệt vời! +5 💗 cho cây'), findsOneWidget);
      await saveDesignShot(tester, 'care_06');
      await tester.tap(find.text('Hoàn tác'));
      await tester.pumpAndSettle();
      expect(find.text('Hearts của tôi hôm nay: 5'), findsOneWidget);
    });

    testWidgets('design qa state_03 empty board', (tester) async {
      await pumpRoute(tester, _careShell);
      await _clearBoard(tester);
      expect(find.text('Hôm nay chưa có việc nào'), findsOneWidget);
      expect(find.text('GỢI Ý CHO HARU · 17 THÁNG'), findsOneWidget);
      expect(find.text('Tắm cho Haru buổi tối'), findsOneWidget);
      await saveDesignShot(tester, 'state_03');
      await tester.tap(find.byType(MissionTemplateTile).first);
      await tester.pumpAndSettle();
      expect(find.text('Hôm nay chưa có việc nào'), findsNothing);
    });

    testWidgets('design qa care_03 create', (tester) async {
      await pumpRoute(tester, MissionCreateRoute());
      expect(find.text('Tắm cho Haru'), findsOneWidget);
      expect(find.text('T2, T4, T6'), findsOneWidget);
      expect(
        find.text('Muốn nhờ Papa một việc? Gửi lời nhờ →'),
        findsOneWidget,
      );
      await saveDesignShot(tester, 'care_03');
    });

    testWidgets('design qa care_09 tree', (tester) async {
      await pumpRoute(tester, const FamilyTreeRoute());
      expect(find.text('Cây xanh'), findsOneWidget);
      expect(find.text('97%'), findsOneWidget);
      expect(find.text('742 💗'), findsOneWidget);
      expect(find.text('86 💗'), findsOneWidget);
      await saveDesignShot(tester, 'care_09');
    });

    testWidgets('design qa care_02 detail + care_04 library', (tester) async {
      await pumpRoute(tester, MissionDetailRoute(missionId: 'ms-read'));
      expect(find.text('Hoàn thành'), findsOneWidget);
      await saveDesignShot(tester, 'care_02');
    });

    testWidgets('design qa care_04 library', (tester) async {
      await pumpRoute(tester, const MissionLibraryRoute());
      expect(find.byType(MissionTemplateTile), findsWidgets);
      await saveDesignShot(tester, 'care_04');
    });
  });

  group('flows', () {
    testWidgets('FAB → CARE-03 → save → board shows the new mission', (
      tester,
    ) async {
      final router = await pumpRoute(tester, _careShell);
      expect(find.textContaining('1/4', findRichText: true), findsOneWidget);
      await tester.tap(find.text('Thêm nhiệm vụ'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MissionCreateRoute.name);
      await tester.tap(find.text('Lưu nhiệm vụ'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CareTabRoute.name);
      expect(find.textContaining('1/5', findRichText: true), findsOneWidget);
    });

    testWidgets('CARE-03 Thư viện → CARE-04 → pick → back', (tester) async {
      final router = await pumpRoute(tester, MissionCreateRoute());
      await tester.tap(find.text('Thư viện'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MissionLibraryRoute.name);
      await tester.tap(find.text('Gọi video cho ông bà'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MissionCreateRoute.name);
      expect(find.text('Gọi video cho ông bà'), findsOneWidget);
    });

    testWidgets('tree card → CARE-09, request row → US-04, card → CARE-02', (
      tester,
    ) async {
      final router = await pumpRoute(tester, _careShell);
      await tester.tap(find.text('Cây hôm nay'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, FamilyTreeRoute.name);
      await router.maybePop();
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('lời nhờ đang mở'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, RequestDetailRoute.name);
      await router.maybePop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tắm cho Haru buổi tối'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, MissionDetailRoute.name);
    });

    testWidgets('partner tab: quick thanks', (tester) async {
      await pumpRoute(tester, _careShell);
      await tester.tap(find.textContaining('Của Papa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cảm ơn').first);
      await tester.pumpAndSettle();
      expect(find.text('Đã cảm ơn'), findsNWidgets(2));
    });
  });

  group('layout 360 dp / text 1.3 / dark', () {
    final routes = <String, PageRouteInfo Function()>{
      'care tab': () => _careShell,
      'create': MissionCreateRoute.new,
      'detail': () => MissionDetailRoute(missionId: 'ms-walk'),
      'library': () => const MissionLibraryRoute(),
      'tree': () => const FamilyTreeRoute(),
    };
    for (final entry in routes.entries) {
      testWidgets('${entry.key} has no overflow', (tester) async {
        await pumpRoute(
          tester,
          entry.value(),
          size: kNarrowSize,
          textScale: 1.3,
          themeMode: ThemeMode.dark,
        );
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('partner tab + empty board narrow', (tester) async {
      await pumpRoute(tester, _careShell, size: kNarrowSize, textScale: 1.3);
      await tester.tap(find.textContaining('Của Papa'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await _clearBoard(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('english locale renders', (tester) async {
      await pumpRoute(tester, _careShell, language: AppLanguage.en);
      expect(tester.takeException(), isNull);
    });
  });

  group('care service additions', () {
    test(
      'missionDraft (CARE-03 sample) and missionDays (week strip)',
      () async {
        final container = ProviderContainer(overrides: mockOverrides());
        addTearDown(container.dispose);
        final care = container.read(careServiceProvider);
        final draft = await care.missionDraft();
        expect(draft.title, 'Tắm cho Haru');
        expect(draft.dueTime, '19:30');
        expect(draft.repeatDays, [1, 3, 5]);
        final forHana = await care.missionDraft(childId: 'hana');
        expect(forHana.title, 'Tắm cho Hana');
        final days = await care.missionDays(
          DateTime(2026, 10, 6),
          DateTime(2026, 10, 12),
        );
        expect(days, {
          DateTime(2026, 10, 6),
          DateTime(2026, 10, 7),
          DateTime(2026, 10, 8),
        });
      },
    );
  });
}
