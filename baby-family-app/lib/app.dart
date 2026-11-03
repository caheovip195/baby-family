import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/care.dart';
import 'package:baby_family/data/provider/chat.dart';
import 'package:baby_family/data/provider/connectivity.dart';
import 'package:baby_family/data/provider/growth.dart';
import 'package:baby_family/data/provider/memory.dart';
import 'package:baby_family/data/provider/push.dart';
import 'package:baby_family/data/provider/session.dart';
import 'package:baby_family/data/provider/us.dart';
import 'package:baby_family/data/provider/year_book.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/broadcast_manager.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/deep_link_route.dart';
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
      // BF-20261030-005: chạm thông báo đẩy → mở đúng màn theo vai trò.
      final openedSubscription = ref
          .read(pushServiceProvider)
          .openedLinks()
          .listen(BroadcastManager().addDeepLink);
      final deepLinkSubscription = BroadcastManager().deepLinkStream.listen(
        (link) => unawaited(_openDeepLink(ref, link)),
      );
      // App đang mở: hệ điều hành không hiện banner → thanh báo + “Xem”.
      final foregroundSubscription = ref
          .read(pushServiceProvider)
          .foregroundMessages()
          .listen((message) => _showForeground(ref, message));
      return () {
        openedSubscription.cancel();
        foregroundSubscription.cancel();
        deepLinkSubscription.cancel();
        sessionExpiredSubscription.cancel();
        BroadcastManager().close();
      };
    }, []);

    // App vào nền: lưu bản chụp phiên / gia đình / bé để mở app lúc mất mạng
    // đúng trạng thái mới nhất (BF-20261022-005).
    useOnAppLifecycleStateChange((previous, state) {
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.hidden) {
        unawaited(ref.read(sessionServiceProvider).persistOffline());
        // Nhắn tin (BF-20261101-001): ngắt realtime khi ở nền để server gửi
        // push cho tin mới.
        ref.read(chatServiceProvider).pause();
      } else if (state == AppLifecycleState.resumed) {
        unawaited(ref.read(chatServiceProvider).resume());
      }
    });

    // Nhắn tin: kết nối realtime khi đã vào app chính với gia đình server;
    // đăng xuất / đổi gia đình → bỏ trạng thái phiên cũ.
    void attachChat(SessionState state) => unawaited(
      ref
          .read(chatServiceProvider)
          .attach(
            active:
                state == SessionState.active ||
                state == SessionState.circleActive,
            parent: state == SessionState.active,
          ),
    );
    useEffect(() {
      attachChat(ref.read(sessionProvider).state);
      return null;
    }, const []);
    ref.listen(sessionProvider, (previous, next) => attachChat(next.state));

    // Offline-first (BF-20261022-001): có mạng lại → gửi các ký ức đang chờ.
    ref.listen(isOfflineProvider, (previous, next) {
      if (previous?.value == true && next.value == false) {
        unawaited(ref.read(memoryServiceProvider).syncPending());
        unawaited(ref.read(careServiceProvider).syncPending());
        unawaited(ref.read(usServiceProvider).syncPending());
        unawaited(ref.read(growthServiceProvider).syncPending());
        unawaited(ref.read(yearBookServiceProvider).syncPending());
        unawaited(ref.read(chatServiceProvider).resume());
      }
    });

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

/// Chờ Splash điều hướng xong (phiên đã sẵn sàng) rồi mở route của deep link;
/// phiên chưa vào app chính (onboarding, tạm dừng…) thì bỏ qua.
Future<void> _openDeepLink(WidgetRef ref, String link) async {
  for (var attempt = 0; attempt < 40; attempt++) {
    final state = ref.read(sessionServiceProvider).current.state;
    final ready =
        appRouter.current.name != SplashRoute.name &&
        (state == SessionState.active || state == SessionState.circleActive);
    if (ready) {
      final path = routeForDeepLink(link, circle: state.isCircle);
      if (path != null) {
        await appRouter.pushPath(path);
      }
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}

void _showForeground(
  WidgetRef ref,
  ({String title, String body, String? link}) message,
) {
  final l10n = lookupAppLocalizations(ref.read(appLanguageProvider).locale);
  final state = ref.read(sessionServiceProvider).current.state;
  final link = message.link;
  final canOpen =
      link != null && routeForDeepLink(link, circle: state.isCircle) != null;
  final text = [
    message.title,
    message.body,
  ].where((part) => part.isNotEmpty).join(' · ');
  scaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        action: canOpen
            ? SnackBarAction(
                label: l10n.notiOpen,
                onPressed: () => BroadcastManager().addDeepLink(link),
              )
            : null,
      ),
    );
}
