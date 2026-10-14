import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/circle/circle_paused/circle_paused_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/circle_tab_bar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/paused_card.dart';

/// CIR-05 — Gia đình tạm dừng chia sẻ (Pencil `ADYog`): lời chào, tên gia
/// đình, thẻ tạm dừng (vòng `us` + `pause`), “Ảnh của cháu vẫn được giữ an
/// toàn”, Đóng / Rời gia đình; thanh tab người thân hiển thị nhưng mọi tab
/// đều dẫn về trạng thái này.
class CirclePausedMobileView extends HookConsumerWidget {
  const CirclePausedMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(circlePausedControllerProvider);
    final l10n = context.l10n;
    final view = controller.view;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (view == null) {
      body = const SizedBox.shrink();
    } else {
      final family = view.family.name;
      body = SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    constraints.maxHeight -
                    MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.s2,
                      AppSpacing.screen,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cirHello(view.viewer.callName),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.h3.copyWith(
                              fontFamily: AppTypography.bodyFamily,
                              fontWeight: FontWeight.w400,
                              color: kColorTextSecondary6B625B,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s1),
                        Text(
                          family,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.display.copyWith(
                              fontSize: 30,
                              height: 41 / 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.s5 + 80,
                      AppSpacing.screen,
                      AppSpacing.s6,
                    ),
                    child: _PausedCard(
                      family: family,
                      onClose: SystemNavigator.pop,
                      onLeave: () =>
                          context.router.push(const LeaveFamilyRoute()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return BaseScaffold(
      extendBody: true,
      body: body,
      bottomNavigationBar: CircleTabBar(
        current: CircleTab.home,
        onSelected: (_) {},
      ),
    );
  }
}
