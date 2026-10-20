import 'package:baby_family/data/dto/display_prefs.dart';

// FAMILY, BILLING, SETTINGS & CIRCLE: FAM-01, FAM-03, SUB-01, SUB-07, SET-01,
// SET-06, CIR-01 — render (390/360, light/dark, text 1.3) + main flows.
import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/service/app_setting.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/design_qa.dart';

class _FakeAppSettingService implements IAppSettingService {
  @override
  AppLanguage currentLanguage() => AppLanguage.vi;

  @override
  Future<void> changeLanguage(AppLanguage language) async {}

  @override
  DisplayPrefs currentDisplay() => const DisplayPrefs();

  @override
  Future<void> changeDisplay({
    ThemeMode? theme,
    double? textScale,
    bool? showLunar,
  }) async {}

  @override
  Future<DisplayPrefs?> pullServerDisplay() async => null;
}

final _settingsOverrides = [
  appSettingServiceProvider.overrideWithValue(_FakeAppSettingService()),
];

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(Scaffold).first));

Future<void> _tap(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    // Lazily built list rows below the fold.
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

final _screens = <String, (PageRouteInfo, DemoSeed, String)>{
  'FAM-01': (const FamilyRoute(), DemoSeed.active, 'papa'),
  'FAM-03': (const RelativeInviteRoute(), DemoSeed.active, 'papa'),
  'SUB-01': (const PlansRoute(), DemoSeed.active, 'mama'),
  'SUB-07': (const ExpiredRoute(), DemoSeed.expired, 'mama'),
  'SET-01': (const SettingsRoute(), DemoSeed.active, 'papa'),
  'SET-06': (const DisplaySettingsRoute(), DemoSeed.active, 'mama'),
  'CIR-01': (
    const CircleShellRoute(children: [CircleHomeRoute()]),
    DemoSeed.circle,
    'mama',
  ),
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
    testWidgets('design qa CIR-01 dark', (tester) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleHomeRoute()]),
        seed: DemoSeed.circle,
        themeMode: ThemeMode.dark,
      );
      await saveDesignShot(tester, 'cir_01_dark');
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
  });

  group('FAM-01', () {
    testWidgets('shows plan, parents, children and locked relatives', (
      tester,
    ) async {
      // Story v2: the trial variant is the `trial` seed, current user Mama.
      await pumpRoute(tester, const FamilyRoute(), seed: DemoSeed.trial);
      expect(find.text('Nhà Lan'), findsOneWidget);
      expect(find.text('Dùng thử miễn phí'), findsOneWidget);
      expect(find.text('Còn 7 ngày · hết hạn 14/10/2026'), findsOneWidget);
      expect(find.text('3,2 GB / 10 GB'), findsOneWidget);
      expect(find.text('Mama (bạn)'), findsOneWidget);
      expect(find.text('Thai 24 tuần · dự sinh 24/01/2027'), findsOneWidget);
      expect(find.text('Mời ông bà ở gói Family'), findsOneWidget);
    });

    testWidgets('Family plan (active seed) lists the relatives', (
      tester,
    ) async {
      await pumpRoute(tester, const FamilyRoute());
      expect(find.text('Gói Family'), findsOneWidget);
      expect(find.text('3,2 GB / 200 GB'), findsOneWidget);
      expect(find.text('Mama (bạn)'), findsOneWidget);
      expect(find.text('17 tháng 29 ngày'), findsOneWidget);
      for (final name in ['Bà nội', 'Bà ngoại', 'Ông ngoại']) {
        expect(find.text(name), findsWidgets, reason: name);
      }
    });

    testWidgets('“Xem gói House / Family” opens SUB-01', (tester) async {
      final router = await pumpRoute(
        tester,
        const FamilyRoute(),
        seed: DemoSeed.trial,
      );
      await _tap(tester, find.text('Xem gói House / Family'));
      expect(router.topRoute.name, PlansRoute.name);
    });

    testWidgets('locked relatives open SUB-01', (tester) async {
      final router = await pumpRoute(
        tester,
        const FamilyRoute(),
        seed: DemoSeed.trial,
      );
      await _tap(tester, find.text('Mời ông bà ở gói Family'));
      expect(router.topRoute.name, PlansRoute.name);
    });

    testWidgets('buy Family → relatives unlocked → FAM-03 → invite', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        const FamilyRoute(),
        seed: DemoSeed.trial,
      );
      await _tap(tester, find.text('Xem gói House / Family'));
      await _tap(tester, find.text('Nâng cấp Family · 599.000đ'));
      // SUB-02: xác nhận trước bảng thanh toán của Store.
      await _tap(tester, find.text('Tiếp tục với App Store'));
      expect(router.topRoute.name, FamilyRoute.name);
      expect(find.text('Nhà mình đã lên gói Family 🎉'), findsOneWidget);
      expect(find.text('Mời ông bà ở gói Family'), findsNothing);
      await _tap(tester, find.text('Mời người thân (0/12)'));
      expect(router.topRoute.name, RelativeInviteRoute.name);
      expect(find.text('Gói Family · đã dùng 0/12 chỗ người thân'), findsOne);
      // Story v2: “Ông nội” is preselected.
      // Let the purchase snack bar leave so it does not cover the button.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Tạo lời mời'));
      // FAM-05: the new invite shows in “Lời mời đang chờ”.
      expect(router.topRoute.name, PendingInvitesRoute.name);
      expect(find.textContaining('Đã tạo lời mời cho Ông nội'), findsOneWidget);
    });

    testWidgets('settings button opens FAM-07', (tester) async {
      final router = await pumpRoute(tester, const FamilyRoute());
      await _tap(tester, find.byTooltip('Cài đặt gia đình'));
      expect(router.topRoute.name, FamilySettingsRoute.name);
    });
  });

  group('SET-01', () {
    testWidgets('shows profile and row values', (tester) async {
      await pumpRoute(tester, const SettingsRoute());
      expect(find.text('Lan'), findsOneWidget);
      expect(find.text('Mama · Nhà Lan'), findsOneWidget);
      expect(find.text('286/300 lượt'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
      expect(find.text('Face ID'), findsOneWidget);
      expect(find.text('Gói Family'), findsOneWidget);
      expect(find.text('v1.0.0'), findsOneWidget);
    });

    for (final (label, route) in [
      ('Hiển thị & Ngôn ngữ', DisplaySettingsRoute.name),
      ('Gói & thanh toán', FamilyPlanRoute.name),
      ('AI hỗ trợ', AiSettingsRoute.name),
      ('Lan', ProfileSettingsRoute.name),
    ]) {
      testWidgets('“$label” opens $route', (tester) async {
        final router = await pumpRoute(tester, const SettingsRoute());
        await _tap(tester, find.text(label));
        expect(router.topRoute.name, route);
      });
    }

    testWidgets('Đăng xuất resets the session to Welcome', (tester) async {
      final router = await pumpRoute(tester, const SettingsRoute());
      await _tap(tester, find.text('Đăng xuất'));
      expect(router.topRoute.name, WelcomeRoute.name);
    });
  });

  group('SET-06', () {
    testWidgets('lists the 4 app languages in their own names', (tester) async {
      await pumpRoute(tester, const DisplaySettingsRoute());
      for (final language in AppLanguage.values) {
        expect(find.text(language.nativeName), findsOneWidget);
      }
    });

    testWidgets('changes language, theme, text size and toggles', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        const DisplaySettingsRoute(),
        overrides: _settingsOverrides,
      );
      final container = _container(tester);
      await _tap(tester, find.text('English'));
      expect(container.read(appLanguageProvider), AppLanguage.en);
      await _tap(tester, find.text('Tối'));
      expect(container.read(appAppearanceProvider), ThemeMode.dark);
      await _tap(tester, find.text('Rất lớn'));
      expect(
        container.read(appTextScaleProvider),
        AppTextSize.extraLarge.scale,
      );
      await _tap(tester, find.text('Giảm hiệu ứng chuyển động'));
      expect(container.read(appReduceMotionProvider), isTrue);
      await _tap(tester, find.text('Hiện ngày âm lịch'));
      expect(container.read(appLunarDateProvider), isFalse);
    });
  });

  group('SUB-01 / SUB-07', () {
    testWidgets('House can be selected; close goes back', (tester) async {
      final router = await pumpRoute(
        tester,
        const SettingsRoute(),
        seed: DemoSeed.trial,
      );
      await _tap(tester, find.text('Gói & thanh toán'));
      expect(find.text('Dùng thử còn 7 ngày'), findsOneWidget);
      await _tap(tester, find.text('House'));
      expect(find.text('Nâng cấp House · 399.000đ'), findsOneWidget);
      await _tap(tester, find.byTooltip('Đóng'));
      expect(router.topRoute.name, SettingsRoute.name);
    });

    testWidgets('expired: stats, retention, cannot pop, purchase unlocks', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        const ExpiredRoute(),
        seed: DemoSeed.expired,
      );
      expect(
        find.textContaining('248 ký ức và 18 lần đầu của Hana, Haru'),
        findsOneWidget,
      );
      expect(find.text('Dữ liệu được giữ đến 06/10/2027'), findsOneWidget);
      await _tap(tester, find.text('Tải xuống dữ liệu'));
      expect(find.textContaining('Đang chuẩn bị dữ liệu'), findsOneWidget);
      await _tap(tester, find.text('Chọn gói House / Family'));
      expect(router.topRoute.name, PlansRoute.name);
      await _tap(tester, find.text('Nâng cấp Family · 599.000đ'));
      await _tap(tester, find.text('Tiếp tục với App Store'));
      expect(router.topRoute.name, isNot(ExpiredRoute.name));
      expect(router.topRoute.name, isNot(PlansRoute.name));
    });

    testWidgets('expired: Đăng xuất → Welcome', (tester) async {
      final router = await pumpRoute(
        tester,
        const ExpiredRoute(),
        seed: DemoSeed.expired,
      );
      await _tap(tester, find.text('Đăng xuất'));
      expect(router.topRoute.name, WelcomeRoute.name);
    });
  });

  group('CIR-01', () {
    testWidgets('greets the relative and shows Haru’s latest memory', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleHomeRoute()]),
        seed: DemoSeed.circle,
      );
      expect(find.text('Chào Bà ngoại'), findsOneWidget);
      expect(find.text('Cháu yêu của bà'), findsOneWidget);
      expect(find.text('Haru · 17 tháng 29 ngày'), findsOneWidget);
      expect(
        find.text('“Hôm nay con tự đi được 5 bước rồi!” — Mama, 2 giờ trước'),
        findsOneWidget,
      );
      expect(find.text('Bơ'), findsOneWidget);
    });

    testWidgets('kid chips switch the child', (tester) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleHomeRoute()]),
        seed: DemoSeed.circle,
      );
      await _tap(tester, find.text('Hana'));
      expect(find.text('Hana · 2 tuổi 4 tháng'), findsOneWidget);
    });

    testWidgets('Thả tim and Gửi lời chúc (mock)', (tester) async {
      await pumpRoute(
        tester,
        const CircleShellRoute(children: [CircleHomeRoute()]),
        seed: DemoSeed.circle,
      );
      await _tap(tester, find.text('Thả tim'));
      expect(find.text('Đã thả tim cho Haru 💛'), findsOneWidget);
      await _tap(tester, find.text('Gửi lời chúc'));
      await tester.enterText(find.byType(TextField), 'Bà thương cháu');
      await _tap(tester, find.text('Gửi'));
      expect(find.text('Đã gửi lời chúc cho Haru'), findsOneWidget);
    });
  });
}
