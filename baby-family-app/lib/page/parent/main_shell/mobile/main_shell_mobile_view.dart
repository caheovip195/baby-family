import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/main_shell/main_shell_controller.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_tab_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/quick_create_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Shell: nội dung tab chạy dưới thanh tab (extendBody) — các tab chừa
/// `MediaQuery.paddingOf(context).bottom` ở cuối danh sách.
class MainShellMobileView extends ConsumerWidget {
  const MainShellMobileView({super.key});

  static const routes = [
    HomeTabRoute(),
    MemoriesTabRoute(),
    CareTabRoute(),
    CoupleTabRoute(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(mainShellControllerProvider);
    return AutoTabsRouter(
      routes: routes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final current = MainTab.values[tabsRouter.activeIndex];
        return BaseScaffold(
          // Android back: về tab Trang chủ trước khi thoát app.
          canPop: current == MainTab.home,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && current != MainTab.home) {
              tabsRouter.setActiveIndex(MainTab.home.index);
            }
          },
          extendBody: true,
          body: child,
          bottomNavigationBar: AppTabBar(
            current: current,
            onSelected: (tab) => tabsRouter.setActiveIndex(tab.index),
            onCreate: () => _openQuickCreate(context, tabsRouter, controller),
          ),
        );
      },
    );
  }

  Future<void> _openQuickCreate(
    BuildContext context,
    TabsRouter tabsRouter,
    MainShellController controller,
  ) async {
    final action = await showQuickCreateSheet(context);
    if (action == null || !context.mounted) {
      return;
    }
    final childId = controller.subjectId;
    final router = context.router;
    switch (action) {
      case QuickCreateAction.memory:
        await router.push(
          MemoryComposerRoute(kind: MemoryKind.photo.name, childId: childId),
        );
      case QuickCreateAction.diary:
        await router.push(DiaryEditorRoute(childId: childId));
      case QuickCreateAction.milestone:
        await router.push(
          MemoryComposerRoute(
            kind: MemoryKind.milestone.name,
            childId: childId,
          ),
        );
      case QuickCreateAction.letter:
        await router.push(LetterComposerRoute(childId: childId));
      case QuickCreateAction.mission:
        await router.push(MissionCreateRoute(childId: childId));
      case QuickCreateAction.event:
        await router.push(const EventCreateRoute());
      case QuickCreateAction.checkin:
        controller.requestCoupleAction(action);
        tabsRouter.setActiveIndex(MainTab.us.index);
      case QuickCreateAction.request:
        await router.push(RequestComposeRoute());
      case QuickCreateAction.thanks:
        await router.push(ThanksComposeRoute());
    }
  }
}
