import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

/// Taps the last widget showing [text] after scrolling it into view.
Future<void> _tap(WidgetTester tester, String text) async {
  final finder = find.text(text).last;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _shot(WidgetTester tester, String name, bool shots) async {
  if (!shots) {
    return;
  }
  // Decode asset images for real so the PNG shows the illustrations.
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pumpAndSettle();
  await saveDesignShot(tester, name);
}

/// Walks the whole parent flow (doc 9.2): Welcome → AUTH-01 → 02 → 03 → 04 →
/// ONB-03 → 06 → 07 → WAIT → ACT → 04 → 05a → 05b → 08 → 10 → 09 → Home.
Future<void> _parentFlow(
  WidgetTester tester, {
  Size size = kDesignSize,
  ThemeMode themeMode = ThemeMode.light,
  double textScale = 1,
  bool shots = false,
}) async {
  final router = await pumpRoute(
    tester,
    const WelcomeRoute(),
    seed: DemoSeed.fresh,
    size: size,
    themeMode: themeMode,
    textScale: textScale,
  );
  final suffix = themeMode == ThemeMode.dark ? '_dark' : '';
  await _shot(tester, 'onb_01_1$suffix', shots);
  expect(find.text('Bỏ qua'), findsOneWidget);
  await _tap(tester, 'Tiếp tục');
  await _shot(tester, 'onb_01_2$suffix', shots);
  await _tap(tester, 'Tiếp tục');
  await _shot(tester, 'onb_01_3$suffix', shots);
  expect(find.text('Bỏ qua'), findsNothing);
  await _tap(tester, 'Bắt đầu');
  expect(router.topRoute.name, AuthRoute.name);
  await _shot(tester, 'auth_01$suffix', shots);
  // BF-20261013-005: trial length comes from the catalog trial policy (7 days).
  expect(find.text('7 ngày miễn phí'), findsOneWidget);
  await _tap(tester, 'Dùng số điện thoại');
  expect(router.topRoute.name, AuthPhoneRoute.name);
  await _shot(tester, 'auth_02$suffix', shots);
  await _tap(tester, 'Gửi mã');
  expect(router.topRoute.name, AuthOtpRoute.name);
  await _shot(tester, 'auth_03$suffix', shots);
  await _tap(tester, 'Xác nhận');
  expect(router.topRoute.name, AuthProfileRoute.name);
  await _shot(tester, 'auth_04$suffix', shots);
  await _tap(tester, 'Tiếp tục');
  expect(router.topRoute.name, OnboardingRoleRoute.name);
  await _shot(tester, 'onb_03$suffix', shots);
  await _tap(tester, 'Tiếp tục');
  expect(router.topRoute.name, OnboardingFamilyRoute.name);
  await _shot(tester, 'onb_06$suffix', shots);
  await _tap(tester, 'Tạo gia đình');
  expect(router.topRoute.name, OnboardingInvitePartnerRoute.name);
  await _shot(tester, 'onb_07$suffix', shots);
  expect(
    find.text(
      'Baby Family cần cả Papa và Mama. Khi Papa tham gia, nhà mình bắt đầu '
      '7 ngày dùng thử miễn phí.',
    ),
    findsOneWidget,
  );
  await _tap(tester, 'Sao chép link mời');
  expect(router.topRoute.name, OnboardingWaitingRoute.name);
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
  await _shot(tester, 'onb_wait$suffix', shots);
  expect(
    find.text(
      'Khi Papa nhận lời mời, nhà mình sẽ được mở khoá và bắt đầu 7 ngày dùng '
      'thử miễn phí.',
    ),
    findsOneWidget,
  );
  await _tap(tester, 'Hiện mã QR');
  await _tap(tester, 'Mô phỏng bạn đời tham gia');
  expect(router.topRoute.name, OnboardingActivatedRoute.name);
  await _shot(tester, 'onb_act$suffix', shots);
  // Mock today 07/10/2026 20:25 + 604800 s → ends 14/10/2026.
  expect(find.text('7 ngày dùng thử miễn phí'), findsOneWidget);
  expect(
    find.text('Đến hết ngày 14/10/2026 · không cần thẻ thanh toán'),
    findsOneWidget,
  );
  await _tap(tester, 'Thiết lập cho bé');
  expect(router.topRoute.name, OnboardingStageRoute.name);
  await _shot(tester, 'onb_04$suffix', shots);
  await _tap(tester, 'Đã có bé và đang mang thai');
  await _tap(tester, 'Tiếp tục');
  expect(router.topRoute.name, OnboardingPregnancyRoute.name);
  await _shot(tester, 'onb_05a$suffix', shots);
  await _tap(tester, 'Tiếp tục');
  expect(router.topRoute.name, OnboardingChildRoute.name);
  await _shot(tester, 'onb_05b$suffix', shots);
  await _tap(tester, 'Hoàn tất');
  expect(router.topRoute.name, OnboardingPrivacyRoute.name);
  await _shot(tester, 'onb_08$suffix', shots);
  await _tap(tester, 'Mình hiểu rồi');
  expect(router.topRoute.name, OnboardingNotificationsRoute.name);
  await _shot(tester, 'onb_10$suffix', shots);
  await _tap(tester, 'Bật thông báo');
  expect(router.topRoute.name, OnboardingFirstMemoryRoute.name);
  await _shot(tester, 'onb_09$suffix', shots);
  await _tap(tester, 'Để sau');
  expect(router.topRoute.name, HomeTabRoute.name);
}

final _single = <(String, PageRouteInfo)>[
  ('inv_05', const InviteCodeRoute()),
  ('inv_01_partner', InvitePreviewRoute(code: 'K7Q29MXA')),
  ('inv_01_relative', InvitePreviewRoute(code: 'B4N0I123')),
  ('cir_wait', const CircleWaitingRoute()),
];

/// Share sheet, clipboard and permission dialogs answer immediately in tests.
void _mockPlatform() {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  for (final (channel, result) in [
    (
      'dev.fluttercommunity.plus/share',
      'dev.fluttercommunity.plus/share/unavailable',
    ),
    ('flutter.baseflow.com/permissions/methods', null),
  ]) {
    messenger.setMockMethodCallHandler(
      MethodChannel(channel),
      (call) async =>
          call.method == 'requestPermissions' ? <int, int>{} : result,
    );
  }
  messenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async => null,
  );
}

void main() {
  setUpAll(loadAppFonts);
  setUp(_mockPlatform);

  group('design qa', () {
    testWidgets('design qa parent flow', (tester) async {
      await _parentFlow(tester, shots: true);
    });
    testWidgets('design qa parent flow dark', (tester) async {
      await _parentFlow(tester, themeMode: ThemeMode.dark, shots: true);
    });
    for (final (name, route) in _single) {
      testWidgets('design qa $name', (tester) async {
        await pumpRoute(tester, route, seed: DemoSeed.fresh);
        await _shot(tester, name, true);
      });
    }
  });

  group('narrow + large text', () {
    testWidgets('parent flow at 360 dp, text 1.3', (tester) async {
      await _parentFlow(tester, size: kNarrowSize, textScale: 1.3);
    });
    for (final (name, route) in _single) {
      testWidgets('$name at 360 dp, text 1.3', (tester) async {
        await pumpRoute(
          tester,
          route,
          seed: DemoSeed.fresh,
          size: kNarrowSize,
          textScale: 1.3,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('invite flows', () {
    testWidgets('partner invite before sign-in → AUTH → ONB-ACT', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        const WelcomeRoute(),
        seed: DemoSeed.fresh,
      );
      await _tap(tester, 'Tôi đã có mã mời');
      expect(router.topRoute.name, InviteCodeRoute.name);
      await _tap(tester, 'Xem lời mời');
      expect(router.topRoute.name, InvitePreviewRoute.name);
      expect(find.text('Lan (Mama) mời bạn tham gia'), findsOneWidget);
      await _tap(tester, 'Tham gia làm Papa');
      expect(router.topRoute.name, AuthRoute.name);
      await _tap(tester, 'Tiếp tục với Apple');
      expect(router.topRoute.name, AuthProfileRoute.name);
      await _tap(tester, 'Tiếp tục');
      expect(router.topRoute.name, OnboardingActivatedRoute.name);
    });

    testWidgets('relative path: ONB-03 → CIR-WAIT → code → CIR-01', (
      tester,
    ) async {
      final router = await pumpRoute(
        tester,
        const AuthRoute(),
        seed: DemoSeed.fresh,
      );
      await _tap(tester, 'Tiếp tục với Google');
      await _tap(tester, 'Tiếp tục');
      expect(router.topRoute.name, OnboardingRoleRoute.name);
      await _tap(tester, 'Người thân');
      expect(find.text('Các con gọi bạn là'), findsNothing);
      await _tap(tester, 'Tiếp tục');
      expect(router.topRoute.name, CircleWaitingRoute.name);
      await _tap(tester, 'Quét mã QR');
      expect(router.topRoute.name, InvitePreviewRoute.name);
      expect(find.text('Bà nội · Xem & bình luận'), findsOneWidget);
      await _tap(tester, 'Tham gia gia đình');
      expect(router.topRoute.name, CircleHomeRoute.name);
    });

    testWidgets('ONB-WAIT cancel family returns to ONB-03', (tester) async {
      final router = await pumpRoute(
        tester,
        const AuthRoute(),
        seed: DemoSeed.fresh,
      );
      await _tap(tester, 'Tiếp tục với Apple');
      await _tap(tester, 'Tiếp tục');
      await _tap(tester, 'Tiếp tục');
      await _tap(tester, 'Tạo gia đình');
      await _tap(tester, 'Gửi lời mời qua Zalo, Messenger…');
      expect(router.topRoute.name, OnboardingWaitingRoute.name);
      await _tap(tester, 'Huỷ gia đình này');
      await _tap(tester, 'Xác nhận');
      expect(router.topRoute.name, OnboardingRoleRoute.name);
    });
  });
}
