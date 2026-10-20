import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/page/circle/circle_child/circle_child_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/child_header.dart';
part '../widgets/first_card.dart';
part '../widgets/month_section.dart';

/// CIR-02 — Trang của cháu (Pencil `Vy0TS`). Tab “Ký ức” của Circle shell;
/// nút quay lại về tab Cháu yêu.
class CircleChildMobileView extends HookConsumerWidget {
  const CircleChildMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(circleChildControllerProvider);
    final l10n = context.l10n;
    final child = controller.child;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (controller.view == null) {
      body = const SizedBox.shrink();
    } else if (child == null) {
      body = Center(child: EmptyState(title: l10n.cirChildEmpty));
    } else {
      final months = controller.months;
      final title = AppTypography.adapt(context, AppTypography.title20);
      void open(Memory memory) =>
          context.router.push(CircleMemoryDetailRoute(memoryId: memory.id));
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _CircleChildHeader(
            child: child,
            today: controller.today,
            monthsTomorrow: controller.monthsTomorrow,
          ),
          if (controller.firsts.isNotEmpty) ...[
            const SizedBox(height: 22),
            Text(l10n.cirChildFirsts, style: title),
            const SizedBox(height: AppSpacing.s3),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (index, first) in controller.firsts.indexed) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.itemGap),
                    _CircleFirstCard(
                      memory: first,
                      age: childAgeText(
                        l10n,
                        child.birthDate!,
                        first.occurredAt,
                      ),
                      index: index,
                      onTap: () => open(first),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 22),
          Text(l10n.cirChildMemories, style: title),
          if (months.isEmpty) ...[
            const SizedBox(height: AppSpacing.cardInset),
            EmptyState(title: l10n.cirChildEmpty),
          ],
          for (final (index, (month, memories)) in months.indexed)
            _MonthSection(
              child: child,
              month: month,
              memories: memories,
              detailed: index == 0,
              controller: controller,
              onOpen: open,
            ),
        ],
      );
    }
    return BaseScaffold(
      isLoading: controller.isLoading && controller.view == null,
      appBar: AppTopBar(
        onBack: () =>
            AutoTabsRouter.of(context).setActiveIndex(CircleTab.home.index),
      ),
      body: body,
    );
  }
}
