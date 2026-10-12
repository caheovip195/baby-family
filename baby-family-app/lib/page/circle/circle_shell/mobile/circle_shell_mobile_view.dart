import 'package:auto_route/auto_route.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/circle_tab_bar.dart';
import 'package:flutter/material.dart';

/// Shell người thân: nội dung tab chạy dưới thanh tab (extendBody) — các tab
/// chừa `MediaQuery.paddingOf(context).bottom` ở cuối danh sách.
class CircleShellMobileView extends StatelessWidget {
  const CircleShellMobileView({super.key});

  static const routes = [
    CircleHomeRoute(),
    CircleChildRoute(),
    CirclePostRoute(),
    CircleMeRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: routes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final current = CircleTab.values[tabsRouter.activeIndex];
        return BaseScaffold(
          // Android back: về tab Cháu yêu trước khi thoát app.
          canPop: current == CircleTab.home,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && current != CircleTab.home) {
              tabsRouter.setActiveIndex(CircleTab.home.index);
            }
          },
          extendBody: true,
          body: child,
          bottomNavigationBar: CircleTabBar(
            current: current,
            onSelected: (tab) => tabsRouter.setActiveIndex(tab.index),
          ),
        );
      },
    );
  }
}
