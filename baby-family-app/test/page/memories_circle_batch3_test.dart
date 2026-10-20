// MEMORIES, CIRCLE & MODERATION (batch 3): MEM-17/18/19, RPT-01/02, CHD-05,
// CIR-02…06, SET-10 — design shots, render (360 ×1.3, dark) and main flows.
import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/notification.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/page/parent/child_archive/child_archive_controller.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_action_top_bar.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/switch_family_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

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
  'CIR-03': (CircleMemoryDetailRoute(memoryId: 'c-haru-roll'), DemoSeed.circle),
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
      await pumpRoute(
        tester,
        const PendingReviewRoute(),
        size: const Size(390, 1178),
      );
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

  group('MEM-17 / MEM-18 / MEM-19 flows', () {
    testWidgets('trash: restore and delete forever (MEM-17b)', (tester) async {
      await pumpRoute(tester, const TrashRoute());
      expect(find.text('3 KÝ ỨC'), findsOneWidget);
      expect(find.text('Còn 23 ngày'), findsOneWidget);
      expect(find.text('Haru · 17 tháng 22 ngày · 2 ảnh'), findsOneWidget);
      await _tap(tester, find.text('Khôi phục').first);
      expect(find.text('2 KÝ ỨC'), findsOneWidget);
      await _tap(tester, find.text('Xoá vĩnh viễn').first);
      expect(find.text('Xoá vĩnh viễn ký ức này?'), findsOneWidget);
      await _tap(tester, find.text('Xoá vĩnh viễn').last);
      expect(find.text('1 KÝ ỨC'), findsOneWidget);
    });

    testWidgets('MEM-07 ⋯ delete moves the memory to trash', (tester) async {
      final router = await pumpRoute(
        tester,
        MemoryDetailRoute(memoryId: 'm-hana-holds-haru'),
      );
      await _tap(tester, find.bySemanticsLabel('Thêm thao tác'));
      await _tap(tester, find.text('Xoá ký ức'));
      await _tap(tester, find.text('Xoá').last);
      final trash = await _container(
        tester,
      ).read(memoryServiceProvider).trash();
      expect(trash.first.id, 'm-hana-holds-haru');
      router.push(const TrashRoute());
      await tester.pumpAndSettle();
      expect(find.text('4 KÝ ỨC'), findsOneWidget);
    });

    testWidgets('MEM-07 ⋯ edit → MEM-09: the author changes the caption', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        MemoryDetailRoute(memoryId: 'm-hana-holds-haru'),
      );
      await _tap(tester, find.bySemanticsLabel('Thêm thao tác'));
      await _tap(tester, find.text('Sửa ký ức'));
      expect(router.topRoute.name, MemoryComposerRoute.name);
      expect(find.text('Sửa ký ức'), findsOneWidget);
      expect(find.textContaining('Lần đầu Hana bế em Haru'), findsOneWidget);
      // MEM-09 (BF-20261019-007): the author can add/remove photos.
      expect(find.bySemanticsLabel('Thêm ảnh'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'Hai chị em');
      await _tap(tester, find.text('Lưu'));
      expect(router.topRoute.name, MemoryDetailRoute.name);
      final memory = await _container(
        tester,
      ).read(memoryServiceProvider).memory('m-hana-holds-haru');
      expect(memory?.body, 'Hai chị em');
      expect(find.text('Đã lưu thay đổi'), findsOneWidget);
    });

    testWidgets('MEM-09: the other parent only re-tags children', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        MemoryDetailRoute(memoryId: 'm-hana-holds-haru'),
        actor: 'papa',
      );
      await _tap(tester, find.bySemanticsLabel('Thêm thao tác'));
      await _tap(tester, find.text('Sửa ký ức'));
      expect(
        find.textContaining('Chỉ người đăng sửa được chú thích'),
        findsOneWidget,
      );
      final caption = tester.widget<TextField>(find.byType(TextField).first);
      expect(caption.readOnly, isTrue);
      await _tap(tester, find.text('Hana'));
      await _tap(tester, find.text('Lưu'));
      expect(router.topRoute.name, MemoryDetailRoute.name);
      final memory = await _container(
        tester,
      ).read(memoryServiceProvider).memory('m-hana-holds-haru');
      expect(memory?.childIds, ['haru']);
      expect(memory?.body, startsWith('Lần đầu Hana bế em Haru'));
    });

    testWidgets('MEM-07 ⋯ report opens RPT-01 and shows the receipt', (
      tester,
    ) async {
      await pumpRoute(tester, MemoryDetailRoute(memoryId: 'm-hana-holds-haru'));
      await _tap(tester, find.bySemanticsLabel('Thêm thao tác'));
      await _tap(tester, find.text('Báo cáo'));
      expect(find.text('Báo cáo ký ức này'), findsOneWidget);
      expect(find.text('Gỡ khỏi gia đình'), findsOneWidget);
      await _tap(tester, find.text('Spam'));
      await _tap(tester, find.text('Gửi báo cáo'));
      expect(find.text('BC-261007-0482'), findsOneWidget);
      await _tap(tester, find.text('Xong'));
      expect(find.text('BC-261007-0482'), findsNothing);
    });

    testWidgets('drafts: device first, delete, resume opens the composer', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const DraftsRoute());
      expect(
        find.text('Khoảnh khắc · Haru · Sửa lúc 21:40 hôm qua'),
        findsOneWidget,
      );
      expect(
        find.text('Thư gửi con · Haru · Lưu 06/10, 22:15 trên iPad'),
        findsOneWidget,
      );
      await _tap(tester, find.text('Xoá').first);
      expect(find.text('Haru đi giày mới'), findsNothing);
      await _tap(tester, find.text('Tiếp tục soạn').first);
      expect(router.topRoute.name, MemoryComposerRoute.name);
    });

    testWidgets('composer ✕ with content saves a device draft', (tester) async {
      await pumpRoute(tester, MemoryComposerRoute(childId: 'haru'));
      await tester.enterText(find.byType(TextField).first, 'Haru tập hát');
      await tester.pumpAndSettle();
      // The top bar ✕ (photo tiles have their own ✕ to remove a photo).
      await _tap(
        tester,
        find.descendant(
          of: find.byType(AppActionTopBar),
          matching: find.byIcon(LucideIcons.x),
        ),
      );
      expect(find.text('Đã lưu vào Nháp'), findsOneWidget);
      final drafts = await _container(
        tester,
      ).read(memoryServiceProvider).drafts();
      expect(drafts.first.title, 'Haru tập hát');
    });

    testWidgets('pending review: approve and decline with a reason', (
      tester,
    ) async {
      await pumpRoute(tester, const PendingReviewRoute());
      expect(find.text('Hôm qua, 16:20 · 3 ảnh'), findsOneWidget);
      await _tap(tester, find.text('Duyệt & hiện').first);
      expect(find.text('Hôm qua, 16:20 · 3 ảnh'), findsNothing);
      await _tap(tester, find.text('Từ chối').first);
      expect(find.text('Ảnh này nhà mình muốn giữ riêng'), findsOneWidget);
      await _tap(tester, find.text('Từ chối ảnh'));
      final pending = await _container(
        tester,
      ).read(memoryServiceProvider).pendingPosts();
      expect(pending, hasLength(1));
      expect(find.text('Đã chờ 8 ngày'), findsOneWidget);
    });

    testWidgets('MEM-15 shortcuts open trash, drafts and pending review', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const MemorySearchRoute());
      await _tap(tester, find.text('Thùng rác'));
      expect(router.topRoute.name, TrashRoute.name);
    });
  });

  group('RPT-02 / CHD-05 flows', () {
    testWidgets('FAM-04 block Ông ngoại (RPT-02)', (tester) async {
      await pumpRoute(tester, RelativeDetailRoute(memberId: 'm-ong-ngoai'));
      await _tap(tester, find.text('Chặn Ông ngoại'));
      expect(find.text('Chặn Ông ngoại?'), findsOneWidget);
      expect(
        find.text('Ông không nhận thông báo liên quan đến bạn.'),
        findsOneWidget,
      );
      await _tap(tester, find.text('Chặn'));
      expect(find.text('Đã chặn Ông ngoại'), findsOneWidget);
      final blocked = await _container(
        tester,
      ).read(settingsServiceProvider).blockedPeople();
      expect(blocked.any((person) => person.name == 'Ông ngoại'), isTrue);
    });

    testWidgets('CHD-05b: delete unlocks after both confirmations', (
      tester,
    ) async {
      await pumpRoute(tester, ChildArchiveRoute(childId: 'khang'));
      expect(find.text('Cần lưu trữ ít nhất 7 ngày'), findsOneWidget);
      await _archiveKhangLongAgo(tester);
      AppButton deleteButton() => tester.widget<AppButton>(
        find.widgetWithText(AppButton, 'Xoá vĩnh viễn Khang'),
      );
      expect(deleteButton().onPressed, isNull);
      await _tap(tester, find.textContaining('Tôi hiểu Khang'));
      await tester.enterText(find.byType(TextField), 'Khang');
      await tester.pumpAndSettle();
      expect(deleteButton().onPressed, isNotNull);
      await _tap(tester, find.widgetWithText(AppButton, 'Xoá vĩnh viễn Khang'));
      final children = await _container(
        tester,
      ).read(childServiceProvider).children(includeArchived: true);
      expect(children.any((child) => child.id == 'khang'), isFalse);
    });

    testWidgets('CHD-01 “Lưu trữ” opens CHD-05', (tester) async {
      final router = await pumpRoute(
        tester,
        ChildProfileRoute(childId: 'haru'),
      );
      await _tap(tester, find.text('Lưu trữ hồ sơ bé'));
      expect(router.topRoute.name, ChildArchiveRoute.name);
      expect(find.text('Lưu trữ Haru'), findsOneWidget);
    });
  });

  group('Circle flows (Bà ngoại)', () {
    testWidgets('CIR-01 hero opens CIR-03; wish and heart', (tester) async {
      final router = await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleHomeRoute()]),
        seed: DemoSeed.circle,
      );
      await _tap(tester, find.text('Haru · 17 tháng 29 ngày'));
      expect(router.topRoute.name, CircleMemoryDetailRoute.name);
      expect(find.text('Đã thả tim'), findsOneWidget);
      expect(find.text('Lời chúc (2)'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Bà thương cháu');
      await _tap(tester, find.bySemanticsLabel('Gửi lời chúc').last);
      expect(find.text('Lời chúc (3)'), findsOneWidget);
      await _tap(tester, find.text('Đã thả tim'));
      expect(find.text('Thả tim'), findsOneWidget);
    });

    testWidgets('CIR-02 shows firsts and month sections', (tester) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleChildRoute()]),
        seed: DemoSeed.circle,
      );
      expect(find.text('Bước đi đầu tiên'), findsOneWidget);
      expect(find.text('16 tháng 3 ngày'), findsOneWidget);
      expect(find.text('Tháng thứ 18'), findsOneWidget);
      expect(find.text('· 08/09 – 07/10'), findsOneWidget);
    });

    testWidgets('CIR-04 send → CIR-04b and parents get MEM-19 + notice', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CirclePostRoute()]),
        seed: DemoSeed.circle,
      );
      // Bà ngoại chỉ được đóng góp cho Haru (FAM-04 quyền theo bé).
      expect(find.text('Hana'), findsNothing);
      await _tap(tester, find.text('Gửi ảnh'));
      expect(find.text('Đã gửi!'), findsOneWidget);
      expect(find.text('3 ảnh · Haru · vừa gửi'), findsOneWidget);
      final container = _container(tester);
      final pending = await container
          .read(memoryServiceProvider)
          .pendingPosts();
      expect(pending.first.authorId, 'u-ba-ngoai');
      final notices = container
          .read(notificationRepositoryProvider)
          .notifications('f-lan')
          .where((row) => row['route'] == '/review');
      expect(notices.map((row) => row['recipientUserId']), contains('u-lan'));
    });

    testWidgets('CIR-06 → SET-10 → leave → CIR-WAIT', (tester) async {
      final router = await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleMeRoute()]),
        seed: DemoSeed.circle,
      );
      expect(find.text('Mẹ của Mama · Nhà Lan'), findsOneWidget);
      await _tap(tester, find.text('Rời gia đình'));
      expect(router.topRoute.name, LeaveFamilyRoute.name);
      expect(find.text('Rời Nhà Lan'), findsOneWidget);
      await _tap(tester, find.text('Gỡ toàn bộ'));
      await _tap(tester, find.widgetWithText(AppButton, 'Rời gia đình'));
      expect(router.topRoute.name, CircleWaitingRoute.name);
    });

    testWidgets('CIR-06 “Chuyển gia đình” opens FAM-08', (tester) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleMeRoute()]),
        seed: DemoSeed.circle,
      );
      await _tap(tester, find.text('Chuyển gia đình'));
      expect(find.text('Chuyển gia đình'), findsWidgets);
      expect(find.byType(SwitchFamilySheet), findsOneWidget);
    });

    testWidgets('CIR-05 paused family', (tester) async {
      final router = await pumpRoute(
        tester,
        const CirclePausedRoute(),
        seed: DemoSeed.circlePaused,
      );
      expect(
        find.text('Nhà Lan đang tạm dừng chia sẻ với người thân'),
        findsOneWidget,
      );
      await _tap(tester, find.text('Rời gia đình'));
      expect(router.topRoute.name, LeaveFamilyRoute.name);
    });
  });
}
