import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/provider/app_setting.dart';
import 'package:baby_family/data/provider/auth.dart';
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
      return () {
        sessionExpiredSubscription.cancel();
        BroadcastManager().close();
      };
    }, []);

    final language = ref.watch(appLanguageProvider);
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: AppTypography.readableTextScaler(mediaQuery.textScaler),
      ),
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: AppTheme.light(),
        locale: language.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        routerConfig: appRouter.config(
          navigatorObservers: () => [AutoRouteObserver()],
          deepLinkBuilder: (platformDeepLink) async {
            final session = await ref.read(authProvider).currentSession();
            if (session != null) {
              // TODO(team): điều hướng theo trạng thái gia đình/gói
              // (tài liệu kỹ thuật 22.4: ONB-03, ONB-WAIT, CIR-WAIT, SUB-07,
              // HOME-01, CIR-01) khi có các màn này.
              return DeepLink.single(const WelcomeRoute());
            }
            return DeepLink.single(const WelcomeRoute());
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
      ),
    );
  }
}
