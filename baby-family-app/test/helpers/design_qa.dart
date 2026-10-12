// Design-QA helpers for area agents: render a screen/widget with the real
// fonts + Lucide icons, the mock data of a seed, a theme and a locale, then
// save a PNG under build/design_qa/ to compare with Pencil TakeScreenshot.
//
//   fvm flutter test test/page/home_test.dart --update-goldens \
//     --plain-name 'design qa'
//   → build/design_qa/<name>.png (git-ignored, never committed)
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/mock_store.dart';
import 'package:baby_family/data/repository_imp/mock_store.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/helper/app_clock.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;
import 'package:intl/date_symbol_data_local.dart';

/// iPhone 13/14 logical size used by every Pencil frame (390 × 844).
const kDesignSize = Size(390, 844);

/// Narrow Android phone used by the quality bar (no overflow at 360 dp).
const kNarrowSize = Size(360, 780);

bool _fontsLoaded = false;

/// Loads Nunito, Be Vietnam Pro, Dancing Script and the Lucide icon font so goldens show real
/// text and icons instead of Ahem boxes. Call once in `setUpAll`.
Future<void> loadAppFonts() async {
  if (_fontsLoaded) {
    return;
  }
  Future<void> load(String family, List<String> assets) async {
    final loader = FontLoader(family);
    for (final asset in assets) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }

  await load('Nunito', [
    'assets/fonts/Nunito-Bold.ttf',
    'assets/fonts/Nunito-ExtraBold.ttf',
  ]);
  await load('BeVietnamPro', [
    'assets/fonts/BeVietnamPro-Regular.ttf',
    'assets/fonts/BeVietnamPro-Medium.ttf',
    'assets/fonts/BeVietnamPro-SemiBold.ttf',
  ]);
  await load('DancingScript', ['assets/fonts/DancingScript-Variable.ttf']);
  // Package fonts are registered as `packages/<package>/<family>`.
  await load('packages/lucide_flutter/LucideIcons', [
    'packages/lucide_flutter/assets/lucide.ttf',
  ]);
  for (final language in AppLanguage.values) {
    await initializeDateFormatting(language.code);
  }
  _fontsLoaded = true;
}

class _FixedLanguage extends AppLanguageNotifier {
  _FixedLanguage(this.value);

  final AppLanguage value;

  @override
  AppLanguage build() => value;
}

/// Provider overrides for a mock seed with a frozen “today” (07/10/2026 20:25).
/// Pass to `ProviderScope(overrides: ...)` in your own tests too.
List<Override> mockOverrides({
  DemoSeed seed = DemoSeed.active,
  String actor = 'mama',
  AppLanguage language = AppLanguage.vi,
}) {
  final clock = AppClock.fixed(kValueDemoStartTime, frozen: true);
  return [
    appClockProvider.overrideWithValue(clock),
    mockStoreProvider.overrideWith(
      (ref) => MockStore(clock: clock, seed: seed, actor: actor),
    ),
    appLanguageProvider.overrideWith(() => _FixedLanguage(language)),
  ];
}

void _setSize(WidgetTester tester, Size size, double textScale) {
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  // Static skeletons/animations so pumpAndSettle and goldens are stable.
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
  });
}

/// Pumps a single widget (shared kit, card, sheet content) inside a themed
/// `MaterialApp` with l10n and the mock providers. The widget is placed in a
/// `Scaffold` body with 20 px side padding like a Pencil screen.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget widget, {
  Size size = kDesignSize,
  ThemeMode themeMode = ThemeMode.light,
  AppLanguage language = AppLanguage.vi,
  DemoSeed seed = DemoSeed.active,
  double textScale = 1,
  bool wrapInScaffold = true,
  List<Override> overrides = const [],
}) async {
  _setSize(tester, size, textScale);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...mockOverrides(seed: seed, language: language),
        ...overrides,
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        locale: language.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: wrapInScaffold
            ? Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.screen),
                    child: widget,
                  ),
                ),
              )
            : widget,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Pumps the real router at [route] (full page with app bar, shell, sheets…).
/// Use this for screens: `await pumpRoute(tester, const NotificationsRoute())`.
/// Shell tabs: `pumpRoute(tester, const MainShellRoute(children: [CareTabRoute()]))`.
Future<AppRouter> pumpRoute(
  WidgetTester tester,
  PageRouteInfo route, {
  Size size = kDesignSize,
  ThemeMode themeMode = ThemeMode.light,
  AppLanguage language = AppLanguage.vi,
  DemoSeed seed = DemoSeed.active,
  String actor = 'mama',
  double textScale = 1,
  List<Override> overrides = const [],
}) async {
  _setSize(tester, size, textScale);
  final router = AppRouter();
  final container = ProviderContainer(
    overrides: [
      ...mockOverrides(seed: seed, actor: actor, language: language),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        locale: language.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: router.config(deepLinkBuilder: (_) => DeepLink([route])),
      ),
    ),
  );
  await tester.pumpAndSettle();
  // Let timers (Splash minimum display, debounces) finish, then settle again.
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  return router;
}

/// Saves the current frame to `build/design_qa/<name>.png` — only when the
/// test runs with `--update-goldens` (otherwise a no-op, so `make test` never
/// fails on design shots). Compare it with Pencil `TakeScreenshot([frameId])`.
Future<void> saveDesignShot(WidgetTester tester, String name) async {
  if (!autoUpdateGoldenFiles) {
    return;
  }
  final file = File('${Directory.current.path}/build/design_qa/$name.png');
  await expectLater(
    find.byWidgetPredicate((widget) => widget is MaterialApp).first,
    matchesGoldenFile(file.uri),
  );
}
