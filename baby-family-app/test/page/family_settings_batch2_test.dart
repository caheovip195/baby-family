// FAMILY & SETTINGS batch 2: FAM-04 (+FAM-06), FAM-07, SET-02/03/04/07/08/
// 09/09b/09c/11/12 and the story-v2 updates of FAM-01, FAM-03, SET-01 —
// render (390/360, light/dark, text 1.3) + main flows.
import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/settings/delete_account_info.dart';
import 'package:baby_family/data/provider/child.dart';
import 'package:baby_family/data/provider/family.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/settings.dart';
import 'package:baby_family/data/service_imp/settings.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/design_qa.dart';

/// SET-09b biến thể `sA3Ch`: người dùng là Parent duy nhất.
class _OnlyParentSettingsService extends SettingsServiceImp {
  _OnlyParentSettingsService(
    super.sessionRepository,
    super.clock,
    super.repository,
    super.familyRepository,
    super.childRepository,
  );

  @override
  Future<DeleteAccountInfo> deleteAccountInfo() async =>
      (await super.deleteAccountInfo()).copyWith(onlyParent: true);
}

final _onlyParentOverrides = [
  settingsServiceProvider.overrideWith(
    (ref) => _OnlyParentSettingsService(
      ref.watch(sessionRepositoryProvider),
      ref.watch(appClockProvider),
      ref.watch(settingsRepositoryProvider),
      ref.watch(familyRepositoryProvider),
      ref.watch(childRepositoryProvider),
    ),
  ),
];

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

/// Đi tới bước [screen] của SET-09 (1 = Tác động).
Future<void> _toDeleteStep(WidgetTester tester, int screen) async {
  for (var step = 1; step < screen; step++) {
    await _tap(tester, find.text('Tiếp tục'));
  }
}

final _screens = <String, (PageRouteInfo, DemoSeed)>{
  'fam_01': (const FamilyRoute(), DemoSeed.active),
  'fam_01_trial': (const FamilyRoute(), DemoSeed.trial),
  'fam_03': (const RelativeInviteRoute(), DemoSeed.active),
  'fam_04': (RelativeDetailRoute(memberId: 'm-ba-ngoai'), DemoSeed.active),
  'fam_07': (const FamilySettingsRoute(), DemoSeed.active),
  'set_01': (const SettingsRoute(), DemoSeed.active),
  'set_02': (const ProfileSettingsRoute(), DemoSeed.active),
  'set_03': (const NotificationSettingsRoute(), DemoSeed.active),
  'set_04': (const PrivacySettingsRoute(), DemoSeed.active),
  'set_07': (const SecuritySettingsRoute(), DemoSeed.active),
  'set_08': (const MyDataRoute(), DemoSeed.active),
  'set_09': (const DeleteAccountRoute(), DemoSeed.active),
  'set_11': (const HelpRoute(), DemoSeed.active),
  'set_12': (const AboutRoute(), DemoSeed.active),
};

/// Chiều cao frame Pencil — ảnh QA chụp cả trang để so với frame.
const _frameHeights = <String, double>{
  'fam_01': 1148,
  'fam_01_trial': 1046,
  'fam_03': 1028,
  'fam_04': 1236,
  'fam_07': 1085,
  'set_01': 921,
  'set_02': 1030,
  'set_03': 1249,
  'set_04': 1067,
  'set_08': 897,
  'set_09': 1060,
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
        final (route, seed) = entry.value;
        await pumpRoute(
          tester,
          route,
          seed: seed,
          size: Size(390, _frameHeights[entry.key] ?? kDesignSize.height),
        );
        await saveDesignShot(tester, entry.key);
      });
    }
    testWidgets('design qa set_09b', (tester) async {
      await pumpRoute(tester, const DeleteAccountRoute());
      await _toDeleteStep(tester, 2);
      await saveDesignShot(tester, 'set_09b');
    });
    testWidgets('design qa set_09b only parent', (tester) async {
      await pumpRoute(
        tester,
        const DeleteAccountRoute(),
        overrides: _onlyParentOverrides,
      );
      await _toDeleteStep(tester, 2);
      await saveDesignShot(tester, 'set_09b_only');
    });
    testWidgets('design qa set_09c', (tester) async {
      await pumpRoute(tester, const DeleteAccountRoute());
      await _toDeleteStep(tester, 3);
      await _tap(tester, find.text('Tiếp tục với Apple'));
      await _tap(
        tester,
        find.text('Tôi đã hiểu và muốn xoá tài khoản của mình'),
      );
      await saveDesignShot(tester, 'set_09c');
    });
    testWidgets('design qa fam_04 dark', (tester) async {
      await pumpRoute(
        tester,
        RelativeDetailRoute(memberId: 'm-ba-ngoai'),
        themeMode: ThemeMode.dark,
      );
      await saveDesignShot(tester, 'fam_04_dark');
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
          expect(router.topRoute.name, route.routeName);
        });
      }
    }
    for (final screen in [2, 3]) {
      testWidgets('set_09 step $screen 360dp ×1.3', (tester) async {
        await pumpRoute(
          tester,
          const DeleteAccountRoute(),
          size: kNarrowSize,
          textScale: 1.3,
        );
        await _toDeleteStep(tester, screen);
        expect(tester.takeException(), isNull);
      });
    }
    testWidgets('set_09b only parent 360dp ×1.3', (tester) async {
      await pumpRoute(
        tester,
        const DeleteAccountRoute(),
        size: kNarrowSize,
        textScale: 1.3,
        overrides: _onlyParentOverrides,
      );
      await _toDeleteStep(tester, 2);
      expect(tester.takeException(), isNull);
    });
  });

  group('FAM-01 (Family plan)', () {
    testWidgets('lists relatives with relation, children and permissions', (
      tester,
    ) async {
      await pumpRoute(tester, const FamilyRoute());
      expect(find.text('599.000đ/năm · gia hạn 08/12/2026'), findsOneWidget);
      expect(find.text('Quản lý gói'), findsOneWidget);
      expect(find.text('Mẹ của Papa · Theo dõi Hana, Haru'), findsOneWidget);
      expect(find.text('Xem, bình luận · được tải ảnh'), findsOneWidget);
      expect(find.text('Bố của Mama · Theo dõi Hana, Haru'), findsOneWidget);
      expect(find.text('Mời người thân (3/12)'), findsOneWidget);
    });

    testWidgets('“Quản lý gói” opens SUB-01', (tester) async {
      final router = await pumpRoute(tester, const FamilyRoute());
      await _tap(tester, find.text('Quản lý gói'));
      expect(router.topRoute.name, PlansRoute.name);
    });

    testWidgets('relative row opens FAM-04, invite opens FAM-03', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const FamilyRoute());
      await _tap(tester, find.text('Bà ngoại'));
      expect(router.topRoute.name, RelativeDetailRoute.name);
      await _tap(tester, find.byTooltip('Quay lại'));
      await _tap(tester, find.text('Mời người thân (3/12)'));
      expect(router.topRoute.name, RelativeInviteRoute.name);
    });

    testWidgets('“Thêm con / thai kỳ” opens CHD-04', (tester) async {
      final router = await pumpRoute(tester, const FamilyRoute());
      await _tap(tester, find.text('Thêm con / thai kỳ'));
      expect(router.topRoute.name, ChildAddRoute.name);
    });
  });

  group('FAM-03', () {
    testWidgets('Ông nội is preselected, 3/12 slots used', (tester) async {
      await pumpRoute(tester, const RelativeInviteRoute());
      expect(find.text('Gói Family · đã dùng 3/12 chỗ người thân'), findsOne);
      final field = tester.widget<EditableText>(find.byType(EditableText));
      expect(field.controller.text, 'Ông nội');
    });
  });

  group('FAM-04 / FAM-06', () {
    testWidgets('shows the relative and per-child grants from data', (
      tester,
    ) async {
      await pumpRoute(tester, RelativeDetailRoute(memberId: 'm-ba-ngoai'));
      expect(find.text('Quan hệ: Bà ngoại · Tham gia 12/08/2026'), findsOne);
      expect(find.text('Hoạt động 2 giờ trước'), findsOneWidget);
      expect(find.text('SĐT ••• ••• 892'), findsOneWidget);
      expect(find.text('14 ký ức'), findsOneWidget);
      expect(find.text('Thai kỳ · Tuần 24'), findsOneWidget);
      // Bơ is shared with Bà ngoại (CIR-01) → no “Chưa chia sẻ”.
      expect(find.text('Chưa chia sẻ'), findsNothing);
      expect(find.text('Tạm ẩn'), findsNWidgets(3));
    });

    testWidgets('hide a child, share it again, toggle download', (
      tester,
    ) async {
      await pumpRoute(tester, RelativeDetailRoute(memberId: 'm-ba-ngoai'));
      await _tap(tester, find.text('Tạm ẩn').last);
      expect(find.text('Đang tạm ẩn'), findsOneWidget);
      await _tap(tester, find.text('Chia sẻ'));
      expect(find.text('Đang tạm ẩn'), findsNothing);
      await _tap(tester, find.text('Cho phép tải ảnh về máy'));
      expect(find.text('Bật — bà lưu được ảnh về máy'), findsOneWidget);
    });

    testWidgets('“Gỡ khỏi gia đình” confirms and returns to FAM-01', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const FamilyRoute());
      await _tap(tester, find.text('Ông ngoại'));
      await _tap(tester, find.text('Gỡ khỏi gia đình'));
      expect(find.text('Gỡ Ông ngoại khỏi gia đình?'), findsOneWidget);
      await _tap(tester, find.text('Gỡ khỏi gia đình').last);
      expect(router.topRoute.name, FamilyRoute.name);
      expect(find.text('Bố của Mama · Theo dõi Hana, Haru'), findsNothing);
    });
  });

  group('FAM-07', () {
    testWidgets('shows settings and saves changes', (tester) async {
      await pumpRoute(tester, const FamilySettingsRoute());
      expect(find.text('GMT+7 · Hà Nội'), findsOneWidget);
      expect(find.text('Tiếng Việt'), findsOneWidget);
      await _tap(tester, find.text('Âm lịch'));
      expect(find.text('Dương lịch'), findsOneWidget);
    });
  });

  group('SET-01', () {
    for (final (label, route) in [
      ('Lan', ProfileSettingsRoute.name),
      ('Thông báo', NotificationSettingsRoute.name),
      ('Quyền riêng tư', PrivacySettingsRoute.name),
      ('Bảo mật & Thiết bị', SecuritySettingsRoute.name),
      ('Dữ liệu của tôi', MyDataRoute.name),
      ('Trợ giúp', HelpRoute.name),
      ('Giới thiệu', AboutRoute.name),
      ('Xoá tài khoản', DeleteAccountRoute.name),
    ]) {
      testWidgets('“$label” opens $route', (tester) async {
        final router = await pumpRoute(tester, const SettingsRoute());
        await _tap(tester, find.text(label));
        expect(router.topRoute.name, route);
      });
    }
  });

  group('SET-02', () {
    testWidgets('shows sign-in methods; save returns to SET-01', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const SettingsRoute());
      await _tap(tester, find.text('Lan'));
      expect(find.text('lan•••@icloud.com'), findsOneWidget);
      expect(find.text('Chưa liên kết'), findsOneWidget);
      await _tap(tester, find.text('Liên kết'));
      expect(find.text('Chưa liên kết'), findsNothing);
      await _tap(tester, find.text('Lưu thay đổi'));
      expect(router.topRoute.name, SettingsRoute.name);
    });
  });

  group('SET-03', () {
    testWidgets('lists 11 groups with the partner in the quiet rule', (
      tester,
    ) async {
      await pumpRoute(tester, const NotificationSettingsRoute());
      expect(find.text('Gộp lại trong 30 phút'), findsOneWidget);
      expect(find.text('Lời nhờ của Papa vượt giờ yên tĩnh'), findsOneWidget);
      expect(find.text('Tắt — lời nhờ “Sớm nhé” cũng chờ sau 6:30'), findsOne);
      await _tap(tester, find.text('Lời nhờ của Papa vượt giờ yên tĩnh'));
      expect(find.text('Bật — lời nhờ “Sớm nhé” vẫn báo ngay'), findsOne);
      await tester.scrollUntilVisible(
        find.text('1 người'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
    });
  });

  group('SET-04', () {
    testWidgets('dashboard from real grants; link opens FAM-01', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const PrivacySettingsRoute());
      expect(find.text('3 người thân'), findsNWidgets(2));
      expect(find.text('128'), findsOneWidget);
      expect(find.text('Bà nội'), findsOneWidget);
      await _tap(tester, find.text('Papa & Mama').first);
      await _tap(tester, find.text('Xem chi tiết & chỉnh quyền'));
      expect(router.topRoute.name, FamilyRoute.name);
    });
  });

  group('SET-07', () {
    testWidgets('signs out one device, then every device → Welcome', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const SecuritySettingsRoute());
      expect(find.text('Hà Nội · Đang dùng'), findsOneWidget);
      expect(find.text('Hà Nội · 2 ngày trước'), findsOneWidget);
      expect(find.text('Hải Phòng · 15/09/2026'), findsOneWidget);
      await _tap(tester, find.text('Đăng xuất').first);
      expect(find.text('iPad mini'), findsNothing);
      await _tap(tester, find.text('Đăng xuất mọi thiết bị'));
      await _tap(tester, find.text('Đăng xuất').last);
      expect(router.topRoute.name, WelcomeRoute.name);
    });
  });

  group('SET-08', () {
    testWidgets('export status and clear cache', (tester) async {
      await pumpRoute(tester, const MyDataRoute());
      expect(find.text('Đang chuẩn bị · 45%'), findsOneWidget);
      expect(find.text('Dữ liệu cá nhân · 214 MB'), findsOneWidget);
      expect(find.text('Đang xuất…'), findsOneWidget);
      await _tap(tester, find.text('Xoá cache'));
      expect(find.text('0 MB trên máy'), findsOneWidget);
    });
  });

  group('SET-09', () {
    testWidgets('walks the 3 screens and deletes → Welcome', (tester) async {
      final router = await pumpRoute(tester, const DeleteAccountRoute());
      expect(find.text('BƯỚC 1/4'), findsOneWidget);
      expect(find.text('142 ký ức bạn đã đăng'), findsOneWidget);
      await _toDeleteStep(tester, 2);
      expect(find.text('Nhà Lan sẽ ra sao?'), findsOneWidget);
      expect(
        find.text('Minh vẫn xem và tải về mọi ký ức của Hana, Haru và Bơ'),
        findsOneWidget,
      );
      await _tap(tester, find.byTooltip('Quay lại'));
      expect(find.text('BƯỚC 1/4'), findsOneWidget);
      await _toDeleteStep(tester, 3);
      expect(find.text('Tài khoản chờ xoá 30 ngày — đến 06/11/2026'), findsOne);
      await _tap(tester, find.text('Tiếp tục với Apple'));
      expect(find.text('Đã xác thực · lan•••@icloud.com'), findsOneWidget);
      await _tap(tester, find.text('Xoá tài khoản'));
      expect(router.topRoute.name, WelcomeRoute.name);
    });

    testWidgets('only parent: choose to delete the family to continue', (
      tester,
    ) async {
      await pumpRoute(
        tester,
        const DeleteAccountRoute(),
        overrides: _onlyParentOverrides,
      );
      await _toDeleteStep(tester, 2);
      expect(find.text('Ai sẽ giữ kỷ niệm của các con?'), findsOneWidget);
      expect(find.text('Mời Parent mới'), findsOneWidget);
      await _tap(tester, find.text('Xoá cả gia đình'));
      await _tap(tester, find.text('Tiếp tục'));
      expect(find.text('Xác nhận lần cuối'), findsOneWidget);
    });
  });

  group('SET-11 / SET-12', () {
    testWidgets('help shows FAQ, reports and contacts', (tester) async {
      await pumpRoute(tester, const HelpRoute());
      expect(find.text('Làm sao mời ông bà xem ảnh cháu?'), findsOneWidget);
      expect(find.text('1 đang xử lý'), findsOneWidget);
      expect(find.text('hotro@babyfamily.vn'), findsOneWidget);
      expect(find.text('1900 6868'), findsOneWidget);
    });

    testWidgets('about shows version and opens licences', (tester) async {
      await pumpRoute(tester, const AboutRoute());
      expect(find.text('Phiên bản 1.0.0'), findsOneWidget);
      expect(find.text('© 2026 Baby Family'), findsOneWidget);
      await _tap(tester, find.text('Giấy phép mã nguồn mở'));
      expect(find.byType(LicensePage), findsOneWidget);
    });
  });
}
