import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_tab_bar.dart';
import 'package:baby_family/utils/widget/quick_create_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/design_qa.dart';

void main() {
  setUpAll(loadAppFonts);

  group('Splash redirect (SPL-01)', () {
    testWidgets('fresh seed → Welcome', (tester) async {
      final router = await pumpRoute(
        tester,
        const SplashRoute(),
        seed: DemoSeed.fresh,
      );
      expect(router.topRoute.name, WelcomeRoute.name);
      expect(find.text('Lưu giữ hành trình của con'), findsOneWidget);
    });

    testWidgets('active seed → Main shell / Home tab', (tester) async {
      final router = await pumpRoute(tester, const SplashRoute());
      expect(router.topRoute.name, HomeTabRoute.name);
      expect(find.byType(AppTabBar), findsOneWidget);
    });

    testWidgets('circle seed → CIR-01', (tester) async {
      final circle = await pumpRoute(
        tester,
        const SplashRoute(),
        seed: DemoSeed.circle,
      );
      expect(circle.topRoute.name, CircleHomeRoute.name);
    });

    testWidgets('expired seed → SUB-07', (tester) async {
      final expired = await pumpRoute(
        tester,
        const SplashRoute(),
        seed: DemoSeed.expired,
      );
      expect(expired.topRoute.name, ExpiredRoute.name);
    });
  });

  group('Main shell', () {
    testWidgets('tabs switch and keep state; back returns home', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      expect(find.text('Trang chủ'), findsOneWidget);
      expect(find.text('Ký ức'), findsOneWidget);
      expect(find.text('Chăm con'), findsOneWidget);
      expect(find.text('Papa & Mama'), findsOneWidget);

      await tester.tap(find.text('Chăm con'));
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CareTabRoute.name);
      expect(find.text('Cây hôm nay'), findsOneWidget);

      // Android back on a non-home tab returns to Trang chủ.
      final handled = await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(handled, isTrue);
      expect(router.topRoute.name, HomeTabRoute.name);
    });

    testWidgets('FAB opens QC-01 with 9 actions and routes them', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      await tester.tap(find.bySemanticsLabel('Tạo mới'));
      await tester.pumpAndSettle();
      expect(find.byType(QuickCreateSheet), findsOneWidget);
      for (final label in [
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
        expect(
          find.descendant(
            of: find.byType(QuickCreateSheet),
            matching: find.bySemanticsLabel(label),
          ),
          findsOneWidget,
          reason: label,
        );
      }
      await tester.tap(
        find.descendant(
          of: find.byType(QuickCreateSheet),
          matching: find.bySemanticsLabel('Nhật ký'),
        ),
      );
      await tester.pumpAndSettle();
      expect(router.topRoute.name, DiaryEditorRoute.name);
    });

    testWidgets('check-in from QC-01 opens the Papa & Mama tab', (
      tester,
    ) async {
      final router = await pumpRoute(tester, const MainShellRoute());
      await tester.tap(find.bySemanticsLabel('Tạo mới'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(QuickCreateSheet),
          matching: find.bySemanticsLabel('Check-in'),
        ),
      );
      await tester.pumpAndSettle();
      expect(router.topRoute.name, CoupleTabRoute.name);
    });

    testWidgets('no overflow at 360 dp, text scale 1.3, dark', (tester) async {
      await pumpRoute(
        tester,
        const MainShellRoute(),
        size: kNarrowSize,
        textScale: 1.3,
        themeMode: ThemeMode.dark,
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(AppTabBar), findsOneWidget);
    });

    testWidgets('design qa: main shell tab bar', (tester) async {
      await pumpRoute(tester, const MainShellRoute());
      await saveDesignShot(tester, 'main_shell_home');
    });
  });

  group('every route opens', () {
    final routes = <PageRouteInfo>[
      const WelcomeRoute(),
      const AuthRoute(),
      const AuthPhoneRoute(),
      const AuthOtpRoute(),
      const AuthProfileRoute(),
      const OnboardingRoleRoute(),
      const OnboardingFamilyRoute(),
      const OnboardingInvitePartnerRoute(),
      const OnboardingWaitingRoute(),
      const OnboardingActivatedRoute(),
      const OnboardingStageRoute(),
      const OnboardingPregnancyRoute(),
      const OnboardingChildRoute(),
      const OnboardingPrivacyRoute(),
      const OnboardingNotificationsRoute(),
      const OnboardingFirstMemoryRoute(),
      const InviteCodeRoute(),
      InvitePreviewRoute(code: 'K7Q29MXA'),
      const CircleWaitingRoute(),
      const CircleHomeRoute(),
      MemoryComposerRoute(kind: 'photo'),
      MemoryDetailRoute(memoryId: 'm-hana-holds-haru'),
      MemoryPerspectiveRoute(memoryId: 'm-hana-holds-haru'),
      MemoryQuoteRoute(childId: 'hana'),
      MemoryStoryRoute(childId: 'haru'),
      MonthlyPhotosRoute(childId: 'haru'),
      MonthlyCameraRoute(childId: 'haru'),
      FirstsRoute(childId: 'haru'),
      CollectionDetailRoute(code: 'monthly'),
      MissionCreateRoute(),
      MissionDetailRoute(missionId: 'ms-read'),
      const MissionLibraryRoute(),
      const FamilyTreeRoute(),
      RequestComposeRoute(),
      RequestDetailRoute(requestId: 'rq-1'),
      ThanksComposeRoute(),
      const FamilyRoute(),
      const RelativeInviteRoute(),
      const PlansRoute(),
      const ExpiredRoute(),
      const SettingsRoute(),
      const DisplaySettingsRoute(),
      const NotificationsRoute(),
      PregnancyJourneyRoute(pregnancyId: 'bo'),
      BirthRoute(pregnancyId: 'bo'),
      PregnancyArchiveRoute(pregnancyId: 'bo'),
      BabyNamesRoute(pregnancyId: 'bo'),
      // Batch 2.
      const AlbumsRoute(),
      AlbumDetailRoute(albumId: 'al-que-ngoai'),
      PhotoViewerRoute(memoryId: 'm-hana-holds-haru', index: 2),
      MemoryCommentsRoute(memoryId: 'm-hana-holds-haru'),
      MilestonePickerRoute(childId: 'haru'),
      DiaryEditorRoute(childId: 'hana'),
      LetterComposerRoute(childId: 'haru'),
      const MemorySearchRoute(),
      const OnThisDayRoute(),
      const WeeklyRecapRoute(),
      const CalendarRoute(),
      const EventCreateRoute(),
      const MissionHistoryRoute(),
      const BadgesRoute(),
      const MissionSettingsRoute(),
      const ThanksWallRoute(),
      const PrivateJournalRoute(),
      const CoupleSettingsRoute(),
      ChildProfileRoute(childId: 'haru'),
      ChildEditRoute(childId: 'haru'),
      const ChildrenRoute(),
      const ChildAddRoute(),
      RelativeDetailRoute(memberId: 'm-ba-ngoai'),
      const FamilySettingsRoute(),
      const ProfileSettingsRoute(),
      const NotificationSettingsRoute(),
      const PrivacySettingsRoute(),
      const SecuritySettingsRoute(),
      const MyDataRoute(),
      const DeleteAccountRoute(),
      const HelpRoute(),
      const AboutRoute(),
    ];
    for (final route in routes) {
      testWidgets(route.routeName, (tester) async {
        final router = await pumpRoute(tester, route);
        expect(router.topRoute.name, route.routeName);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
