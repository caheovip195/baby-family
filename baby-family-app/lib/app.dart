import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/push.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/helper/broadcast_manager.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appRouter = AppRouter();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class RootApp extends BaseHookWidget {
  const RootApp({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // Phiên bị server chấm dứt (401): dọn các việc gắn với phiên ở đây.
      final sessionExpiredSubscription = BroadcastManager().sessionExpiredStream
          .listen((_) {});
      // ONB-10: đã cho phép thông báo từ trước → gửi lại push token (có thể đổi).
      unawaited(ref.read(pushServiceProvider).syncIfAuthorized());
      return () {
        sessionExpiredSubscription.cancel();
        BroadcastManager().close();
      };
    }, []);

    final language = ref.watch(appLanguageProvider);
    final appearance = ref.watch(appAppearanceProvider);
    final appScale = ref.watch(appTextScaleProvider);
    final reduceMotion = ref.watch(appReduceMotionProvider);
    return MaterialApp.router(
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            disableAnimations: mediaQuery.disableAnimations || reduceMotion,
            textScaler: AppTypography.readableTextScaler(
              TextScaler.linear(
                (mediaQuery.textScaler.scale(14) / 14) * appScale,
              ),
            ),
          ),
          child: child!,
        );
      },
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: appearance,
      locale: language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter.config(
        navigatorObservers: () => [AutoRouteObserver()],
        // Mọi lần mở app đi qua Splash (SPL-01) — Splash đọc phiên rồi
        // điều hướng (`routeForSession`). Deep link hợp lệ được giữ nguyên.
        deepLinkBuilder: (platformDeepLink) {
          if (platformDeepLink.isValid && platformDeepLink.path != '/') {
            return platformDeepLink;
          }
          return DeepLink.single(const SplashRoute());
        },
        placeholder: (context) => const Material(
          child: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
