import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/milestone_item.dart';
import 'package:baby_family/page/parent/firsts/firsts_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/first_card.dart';

/// MEM-12 Những lần đầu (không có trong Pencil): dựng theo ngôn ngữ của
/// MEM-20 (thanh tiêu đề + ChildSwitcher, lưới thẻ bo 14) và thẻ “Lần đầu
/// tiên” của MEM-01 (huy hiệu sao `accent`).
class FirstsMobileView extends HookConsumerWidget {
  const FirstsMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(firstsControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(childId));
      return null;
    }, const []);
    final l10n = context.l10n;
    final items = controller.visible;
    return BaseScaffold(
      appBar: AppBackTitleBar(
        title: l10n.memFirstsTitle,
        trailing: controller.children.isEmpty
            ? null
            : ChildSwitcher(
                children: controller.children,
                selectedId: controller.childId,
                today: controller.today,
                onChanged: controller.selectChild,
              ),
      ),
      body: !controller.loaded
          ? const Center(child: CircleLoadingProgress())
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s1,
                AppSpacing.screen,
                AppSpacing.s5 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.memFirstsHideMissing,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    AppSwitch(
                      value: controller.hideMissing,
                      onChanged: controller.toggleHideMissing,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.cardInset),
                for (var index = 0; index < items.length; index += 2) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.s2),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _card(context, controller, items[index]),
                        ),
                        const SizedBox(width: AppSpacing.s2),
                        Expanded(
                          child: index + 1 < items.length
                              ? _card(context, controller, items[index + 1])
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _card(
    BuildContext context,
    FirstsController controller,
    MilestoneItem item,
  ) {
    final router = context.router;
    final memoryId = item.memoryId;
    return _FirstCard(
      item: item,
      controller: controller,
      onTap: memoryId != null
          ? () => router.push(MemoryDetailRoute(memoryId: memoryId))
          : () => router.push(
              MemoryComposerRoute(
                kind: MemoryKind.milestone.name,
                childId: controller.childId,
              ),
            ),
    );
  }
}
