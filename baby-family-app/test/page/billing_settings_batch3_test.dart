// BILLING, INVITE, FAMILY & SETTINGS (batch 3): SUB-02…06, INV-02/03/04,
// FAM-02/05/08, SET-05, SET-13 — render (390/360, light/dark, text 1.3),
// Pencil copy and the main flows / entry points.
import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/design_qa.dart';

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

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

/// Lets a snack bar leave so it does not cover the next tap target.
Future<void> _waitSnackBar(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

final _screens = <String, (PageRouteInfo, DemoSeed, String)>{
  'SUB-03': (const FamilyPlanRoute(), DemoSeed.active, 'mama'),
  'SUB-04': (const UpgradePlanRoute(), DemoSeed.house, 'mama'),
  'SUB-06': (
    const MainShellRoute(children: [HomeTabRoute()]),
    DemoSeed.paymentIssue,
    'mama',
  ),
  'INV-02': (InvitePreviewRoute(code: 'HETHAN01'), DemoSeed.active, 'mama'),
  'INV-03': (InvitePreviewRoute(code: 'KHOA2026'), DemoSeed.active, 'mama'),
  'INV-04': (InvitePreviewRoute(code: 'CHOXN001'), DemoSeed.active, 'papa'),
  'FAM-02': (const PartnerInviteRoute(), DemoSeed.partnerLeft, 'mama'),
  'FAM-05': (const PendingInvitesRoute(), DemoSeed.active, 'mama'),
  'SET-05': (const AiSettingsRoute(), DemoSeed.active, 'mama'),
  'SET-13': (const BlockedPeopleRoute(), DemoSeed.active, 'mama'),
};

void main() {
  setUpAll(() async {
    await loadAppFonts();
    PackageInfo.setMockInitialValues(
      appName: 'Baby Family',
      packageName: 'vn.babyfamily',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  group('design qa', () {
    for (final entry in _screens.entries) {
      testWidgets('design qa ${entry.key}', (tester) async {
        final (route, seed, actor) = entry.value;
        await pumpRoute(tester, route, seed: seed, actor: actor);
        await saveDesignShot(
          tester,
          entry.key.toLowerCase().replaceAll('-', '_'),
        );
      });
    }

    testWidgets('design qa SUB-02', (tester) async {
      await pumpRoute(tester, const PlansRoute(), seed: DemoSeed.trial);
      await _tap(tester, find.text('Nâng cấp Family · 599.000đ'));
      await saveDesignShot(tester, 'sub_02');
    });

    testWidgets('design qa SUB-05', (tester) async {
      await pumpRoute(
        tester,
        MemoryComposerRoute(kind: MemoryKind.photo.name, childId: 'haru'),
      );
      await _tap(tester, find.byIcon(LucideIcons.plus).first);
      await saveDesignShot(tester, 'sub_05');
    });

    testWidgets('design qa FAM-08', (tester) async {
      await pumpRoute(tester, const MainShellRoute(children: [HomeTabRoute()]));
      await tester.longPress(find.byIcon(LucideIcons.houseHeart));
      await tester.pumpAndSettle();
      await saveDesignShot(tester, 'fam_08');
    });
  });

  group('render without overflow', () {
    for (final entry in _screens.entries) {
      for (final dark in [false, true]) {
        testWidgets('${entry.key} 360dp ×1.3 ${dark ? 'dark' : 'light'}', (
          tester,
        ) async {
          final (route, seed, actor) = entry.value;
          final router = await pumpRoute(
            tester,
            route,
            seed: seed,
            actor: actor,
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

    testWidgets('SUB-02 / SUB-05 / FAM-08 sheets 360dp ×1.3', (tester) async {
      await pumpRoute(
        tester,
        const PlansRoute(),
        seed: DemoSeed.trial,
        size: kNarrowSize,
        textScale: 1.3,
      );
      await _tap(tester, find.text('Nâng cấp Family · 599.000đ'));
      expect(find.text('Tiếp tục với App Store'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('SUB-05 sheet 360dp ×1.3', (tester) async {
      await pumpRoute(
        tester,
        MemoryComposerRoute(kind: MemoryKind.photo.name, childId: 'haru'),
        size: kNarrowSize,
        textScale: 1.3,
      );
      await _tap(tester, find.byIcon(LucideIcons.plus).first);
      expect(find.text('Video này dài 12 phút'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('FAM-08 sheet 360dp ×1.3', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(children: [HomeTabRoute()]),
        size: kNarrowSize,
        textScale: 1.3,
      );
      await tester.longPress(find.byIcon(LucideIcons.houseHeart));
      await tester.pumpAndSettle();
      expect(find.text('Chuyển gia đình'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('SUB-03', () {
    testWidgets('shows the Family plan, storage and usage', (tester) async {
      await pumpRoute(tester, const FamilyPlanRoute());
      for (final text in [
        'Gói của gia đình',
        'Gói Family',
        '599.000đ/năm',
        'Đang hoạt động',
        '08/12/2026',
        'Mama (bạn)',
        'App Store',
        'Cả Nhà Lan',
        '3,2 GB',
        'đã dùng / 200 GB',
        'Ảnh · 2,1 GB',
        'Video · 0,9 GB',
        'Âm thanh · 0,2 GB',
        'Bà nội · Bà ngoại · Ông ngoại',
        '3/12',
        'Còn 286/300',
        'Làm mới vào 01/11/2026',
        'Ảnh gốc · 50 ảnh mỗi ký ức',
        '10 phút',
        'Quản lý trong App Store',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      final note = find.textContaining(
        'chỉ Mama đổi hoặc huỷ được. Papa sẽ thấy',
      );
      await tester.scrollUntilVisible(
        note,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(note, findsOneWidget);
    });

    testWidgets('“Đổi gói” opens SUB-01 (Family) / SUB-04 (House)', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const FamilyPlanRoute());
      await _tap(tester, find.text('Đổi gói'));
      expect(router.topRoute.name, PlansRoute.name);
    });

    testWidgets('House plan: “Đổi gói” opens SUB-04', (tester) async {
      final router = await pumpRoute(
        tester,
        const FamilyPlanRoute(),
        seed: DemoSeed.house,
      );
      expect(find.text('Gói House'), findsOneWidget);
      await _tap(tester, find.text('Đổi gói'));
      expect(router.topRoute.name, UpgradePlanRoute.name);
    });

    testWidgets('SET-01 “Gói & thanh toán” opens SUB-03', (tester) async {
      final router = await pumpRoute(tester, const SettingsRoute());
      await _tap(tester, find.text('Gói & thanh toán'));
      expect(router.topRoute.name, FamilyPlanRoute.name);
    });
  });

  group('SUB-04 / SUB-02', () {
    testWidgets('compare table, price and non-payer note', (tester) async {
      await pumpRoute(tester, const UpgradePlanRoute(), seed: DemoSeed.house);
      for (final text in [
        'Nâng cấp lên Family để mời ông bà',
        'Nhà mình đang dùng gói House · Mama thanh toán qua App Store. '
            'Family mở thêm ông bà, người thân và dung lượng lớn hơn.',
        'Tối đa 12',
        '50 GB',
        '200 GB',
        '≤ 3 phút',
        '≤ 5 phút',
        '399.000đ/năm',
        'Nâng cấp lên Family · 599.000đ/năm',
        'PAPA SẼ THẤY (KHÔNG PHẢI NGƯỜI THANH TOÁN)',
        'Gửi lời nhắn cho Mama',
      ]) {
        final finder = find.text(text);
        if (finder.evaluate().isEmpty) {
          await tester.scrollUntilVisible(
            finder,
            200,
            scrollable: find.byType(Scrollable).first,
          );
        }
        expect(finder, findsOneWidget, reason: text);
      }
      expect(find.text('≤ 10 phút'), findsNWidgets(2));
    });

    testWidgets('upgrade → SUB-02 → mock purchase → Family plan', (
      tester,
    ) async {
      await pumpRoute(tester, const UpgradePlanRoute(), seed: DemoSeed.house);
      await _tap(tester, find.text('Nâng cấp lên Family · 599.000đ/năm'));
      for (final text in [
        'Xác nhận gói Family',
        'Cho cả Nhà Lan · Papa, Mama và người thân',
        '≈ 50.000đ/tháng',
        '1 năm · tự động gia hạn',
        'Ngay khi App Store xác nhận',
        'Tài khoản App Store của bạn',
        'Mời ngay tối đa 12 ông bà, người thân',
        '200 GB · video ≤ 10 phút · lưu ảnh gốc',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      // Not in trial → no trial note.
      expect(find.textContaining('Thời gian dùng thử còn lại'), findsNothing);
      final container = _container(tester);
      await _tap(tester, find.text('Tiếp tục với App Store'));
      expect(find.text('Nhà mình đã lên gói Family 🎉'), findsOneWidget);
      final family = await container
          .read(familyServiceProvider)
          .currentFamily();
      expect(family!.plan.state, PlanState.family);
    });

    testWidgets('SUB-01 from trial: SUB-02 shows the trial note', (
      tester,
    ) async {
      await pumpRoute(tester, const PlansRoute(), seed: DemoSeed.trial);
      await _tap(tester, find.text('Nâng cấp Family · 599.000đ'));
      expect(
        find.text(
          'Thời gian dùng thử còn lại không cộng dồn — chu kỳ năm tính từ '
          'hôm nay',
        ),
        findsOneWidget,
      );
    });
  });

  group('SUB-05', () {
    testWidgets('long video on the Family plan → save as diary (MEM-13)', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        MemoryComposerRoute(kind: MemoryKind.photo.name, childId: 'haru'),
      );
      await _tap(tester, find.byIcon(LucideIcons.plus).first);
      expect(find.text('Video này dài 12 phút'), findsOneWidget);
      expect(
        find.text(
          'Gói Family lưu được video tối đa 10 phút mỗi video. Bạn có thể '
          'cắt ngắn lại, hoặc giữ khoảnh khắc này bằng lời kể.',
        ),
        findsOneWidget,
      );
      expect(find.text('Cắt video còn 10 phút'), findsOneWidget);
      expect(
        find.text(
          'Nhà mình đang dùng gói cao nhất (Family) nên không cần nâng cấp '
          'thêm.',
        ),
        findsOneWidget,
      );
      await _tap(tester, find.text('Lưu dạng nhật ký chữ'));
      expect(router.topRoute.name, DiaryEditorRoute.name);
    });

    testWidgets('House plan: 3-minute limit and the upgrade link → SUB-04', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        MemoryComposerRoute(kind: MemoryKind.photo.name, childId: 'haru'),
        seed: DemoSeed.house,
      );
      await _tap(tester, find.byIcon(LucideIcons.plus).first);
      expect(find.text('Cắt video còn 3 phút'), findsOneWidget);
      await _tap(tester, find.text('Nâng cấp lên Family'));
      expect(router.topRoute.name, UpgradePlanRoute.name);
    });
  });

  group('SUB-06', () {
    testWidgets('payment issue banner: action → SUB-03, close hides it', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        const MainShellRoute(children: [HomeTabRoute()]),
        seed: DemoSeed.paymentIssue,
      );
      expect(find.text('Thanh toán gia hạn chưa thành công'), findsOneWidget);
      expect(
        find.text(
          'Kiểm tra phương thức thanh toán để không gián đoạn. Gói Family '
          'của nhà mình vẫn hoạt động trong lúc này.',
        ),
        findsOneWidget,
      );
      await _tap(tester, find.text('Kiểm tra trong App Store'));
      expect(router.topRoute.name, FamilyPlanRoute.name);
      await _tap(tester, find.byTooltip('Quay lại'));
      await _tap(tester, find.bySemanticsLabel('Đóng'));
      expect(find.text('Thanh toán gia hạn chưa thành công'), findsNothing);
    });

    testWidgets('no banner when the payment is fine', (tester) async {
      await pumpRoute(tester, const MainShellRoute(children: [HomeTabRoute()]));
      expect(find.text('Thanh toán gia hạn chưa thành công'), findsNothing);
    });
  });

  group('FAM-08', () {
    testWidgets('long-press the family avatar lists both families', (
      tester,
    ) async {
      await pumpRoute(tester, const MainShellRoute(children: [HomeTabRoute()]));
      await tester.longPress(find.byIcon(LucideIcons.houseHeart));
      await tester.pumpAndSettle();
      for (final text in [
        'Chuyển gia đình',
        'Bạn là Mama ở Nhà Lan và là người thân ở một gia đình khác.',
        'Mama (Bố/Mẹ)',
        'Hana, Haru, Bơ · Papa Minh · đang xem',
        'Nhà anh Tuấn',
        'Cô Lan (người thân)',
        'Theo dõi bé Bin · Xem + Bình luận',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      await _tap(tester, find.text('Nhà anh Tuấn'));
      expect(find.text('Chuyển gia đình'), findsNothing);
      expect(find.text('Bản mẫu chỉ có dữ liệu của Nhà Lan.'), findsOneWidget);
    });
  });

  group('INV-02 / INV-03 / INV-04', () {
    testWidgets('expired code → INV-02 → “Nhập mã mời khác”', (tester) async {
      final router = await pumpRoute(
        tester,
        InvitePreviewRoute(code: 'HETHAN01'),
      );
      expect(find.text('Lời mời không còn hiệu lực'), findsOneWidget);
      expect(find.text('Nhờ người mời gửi lại link mới nhé.'), findsOneWidget);
      expect(
        find.text('Nếu đã có mã 8 ký tự mới, bạn có thể nhập mã ngay.'),
        findsOneWidget,
      );
      await _tap(tester, find.text('Nhập mã mời khác'));
      expect(router.topRoute.name, InviteCodeRoute.name);
    });

    testWidgets('parent elsewhere → INV-03 → leave help (SET-11)', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        InvitePreviewRoute(code: 'KHOA2026'),
      );
      for (final text in [
        'Mama · Nhà Lan',
        'Bạn đang là Mama ở một gia đình khác',
        'Khoa mời bạn tham gia Nhà Khoa',
        'Vai trò đề xuất: Mẹ của các bé',
        'Tham gia như người thân',
        'Huỷ',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      await _tap(tester, find.text('Tìm hiểu cách rời gia đình hiện tại'));
      expect(router.topRoute.name, HelpRoute.name);
    });

    testWidgets('pending approval → INV-04 steps', (tester) async {
      await pumpRoute(
        tester,
        InvitePreviewRoute(code: 'CHOXN001'),
        actor: 'papa',
      );
      for (final text in [
        'Đã gửi yêu cầu',
        'Lan sẽ xác nhận để hoàn tất. Bạn có thể đóng app — mình sẽ báo '
            'ngay khi xong.',
        'Bạn đã nhận lời mời vào Nhà Lan',
        'Vai trò: Papa của các bé',
        'Chờ Lan xác nhận',
        'Nhà mình bắt đầu 3 tháng dùng thử miễn phí',
        'Bạn sẽ nhận thông báo “Chào mừng về nhà!”',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
    });
  });

  group('FAM-02', () {
    testWidgets('partner left: new invite code, preview, revoke', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        const PartnerInviteRoute(),
        seed: DemoSeed.partnerLeft,
      );
      for (final text in [
        'Papa đã rời Nhà Lan (xoá tài khoản). Nhà mình đang ở chế độ chỉ '
            'xem & tải về cho tới khi có bạn đời mới.',
        'Mời bạn đời cùng tham gia',
        'R4TB · 2HWN',
        'Hết hạn sau 7 ngày · dùng 1 lần',
        'Nhà Lan · Hana, Haru, Bơ',
        'Lời mời từ Lan (Mama) · chỉ tên và ảnh đại diện các bé',
        'Tôi xác nhận lần cuối khi bạn đời tham gia',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      await _tap(tester, find.text('Mama'));
      await _tap(tester, find.text('Thu hồi lời mời'));
      expect(find.text('Đã thu hồi lời mời'), findsOneWidget);
    });
  });

  group('FAM-05', () {
    testWidgets('pending & expired invites; revoke and renew', (tester) async {
      await pumpRoute(tester, const PendingInvitesRoute());
      for (final text in [
        'Người thân Nhà Lan: 3 đang tham gia · 1 đang chờ',
        '4/12',
        'Ông nội',
        'Chưa mở link',
        'Lời mời người thân · Bố của Papa · Hana, Haru · Xem + Bình luận',
        'Tạo 07/10 · hết hạn 21/10/2026 · còn 14 ngày',
        'Dì Mai',
        'Lời mời người thân · Em gái của Mama · Hana · Xem',
        'Hết hạn 30/09/2026 · link không còn mở được',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      await _tap(tester, find.text('Gửi lại link'));
      expect(find.text('Đã gửi lại link cho Ông nội'), findsOneWidget);
      await _waitSnackBar(tester);
      await _tap(tester, find.text('Thu hồi'));
      expect(
        find.text('Người thân Nhà Lan: 3 đang tham gia · 0 đang chờ'),
        findsOneWidget,
      );
      await _waitSnackBar(tester);
      await _tap(tester, find.text('Tạo lời mời mới'));
      expect(find.text('Đã hết hạn'.toUpperCase()), findsNothing);
      expect(
        find.text('Người thân Nhà Lan: 3 đang tham gia · 1 đang chờ'),
        findsOneWidget,
      );
    });

    testWidgets('“Mời thêm người thân” → FAM-03 → back to FAM-05', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const PendingInvitesRoute());
      await _tap(tester, find.text('Mời thêm người thân'));
      expect(router.topRoute.name, RelativeInviteRoute.name);
      await _tap(tester, find.text('Tạo lời mời'));
      expect(router.topRoute.name, PendingInvitesRoute.name);
    });
  });

  group('SET-05', () {
    testWidgets('quota, features and toggles; SET-01 entry', (tester) async {
      final router = await pumpRoute(tester, const SettingsRoute());
      await _tap(tester, find.text('AI hỗ trợ'));
      expect(router.topRoute.name, AiSettingsRoute.name);
      for (final text in [
        'Dùng AI hỗ trợ',
        'Làm mới 01/11/2026',
        'Gói Family · 300 lượt mỗi tháng cho cả nhà',
        'Gợi ý chú thích',
        'Gửi: vài từ bạn gõ, loại ký ức, tuổi bé — không gửi ảnh',
        'Recap tuần',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.textContaining('286', findRichText: true), findsOneWidget);
      final container = _container(tester);
      await _tap(tester, find.text('Tóm tắt Cầu nối'));
      final ai = await container.read(settingsServiceProvider).aiSettings();
      expect(
        ai.features.firstWhere((f) => f.code == 'bridge_summary').enabled,
        isTrue,
      );
    });
  });

  group('SET-13', () {
    testWidgets('SET-04 → SET-13, unblock', (tester) async {
      final router = await pumpRoute(tester, const PrivacySettingsRoute());
      await _tap(tester, find.text('Người bị chặn'));
      expect(router.topRoute.name, BlockedPeopleRoute.name);
      for (final text in [
        'ĐANG CHẶN · 1 NGƯỜI',
        'Cô Hạnh',
        'Người thân ở Nhà anh Tuấn',
        'Chặn từ 02/10/2026',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      await _tap(tester, find.text('Bỏ chặn'));
      expect(find.text('Đã bỏ chặn Cô Hạnh'), findsOneWidget);
      expect(find.text('Bạn chưa chặn ai'), findsOneWidget);
    });
  });
}
