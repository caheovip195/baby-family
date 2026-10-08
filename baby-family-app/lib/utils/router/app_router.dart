import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/welcome/welcome_page.dart';
import 'package:flutter/widgets.dart';

part 'app_router.gr.dart';

/// Khai báo route. Mã màn ↔ route ↔ API: tài liệu kỹ thuật mục 23.
/// Mỗi màn mới: thêm `@RoutePage()` vào Page, khai báo ở [routes], chạy
/// `make runner`.
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      const RouteType.material(enablePredictiveBackGesture: false);

  @override
  final List<AutoRoute> routes = [
    // --- general ---
    AutoRouteCustom(page: WelcomeRoute.page, path: '/welcome').route(),
  ];
}

class AutoRouteCustom {
  AutoRouteCustom({
    required this.page,
    required this.path,
    this.initial = false,
  });

  final PageInfo page;
  final String path;
  final bool initial;

  AutoRoute route({
    List<AutoRouteCustom> children = const [],
    List<AutoRouteGuard> guards = const [],
  }) {
    return CustomRoute(
      page: page,
      path: path,
      guards: guards,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      initial: initial,
      children: children.map((e) => e.route()).toList(),
    );
  }
}
