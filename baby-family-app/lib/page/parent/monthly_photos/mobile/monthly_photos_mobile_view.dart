import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/monthly_photos/monthly_photos_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/month_cell.dart';
part '../widgets/monthly_tool.dart';

/// MEM-20 Con lớn từng tháng (Pencil `KfCF1`).
class MonthlyPhotosMobileView extends HookConsumerWidget {
  const MonthlyPhotosMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(monthlyPhotosControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(childId));
      return null;
    }, const []);
    final l10n = context.l10n;
    final child = controller.child;
    return BaseScaffold(
      appBar: AppBackTitleBar(
        title: l10n.memoriesMonthly,
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
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: [
                    for (var year = 0; year < controller.yearCount; year++)
                      AppChip(
                        label: l10n.memoriesYearOrdinal('${year + 1}'),
                        selected: controller.album == year,
                        onTap: () => controller.selectAlbum(year),
                      ),
                    AppChip(
                      label: l10n.memPregnancyAlbum,
                      selected: controller.pregnancyAlbum,
                      onTap: () => controller.selectAlbum(controller.yearCount),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.cardInset),
                if (controller.pregnancyAlbum)
                  EmptyState(
                    title: l10n.stateEmptyMemoryTitle(child?.name ?? ''),
                    description: l10n.stateEmptyMemoryDescription,
                  )
                else ...[
                  for (var row = 0; row < 4; row++) ...[
                    if (row > 0) const SizedBox(height: AppSpacing.s2),
                    Row(
                      children: [
                        for (var column = 0; column < 3; column++) ...[
                          if (column > 0) const SizedBox(width: AppSpacing.s2),
                          Expanded(
                            child: _MonthCell(
                              month: controller.firstMonth + row * 3 + column,
                              controller: controller,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.cardInset),
                  Row(
                    children: [
                      Expanded(
                        child: _MonthlyTool(
                          icon: LucideIcons.columns2,
                          label: l10n.memoriesCompare,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: _MonthlyTool(
                          icon: LucideIcons.layoutGrid,
                          label: l10n.memoriesCollage,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: _MonthlyTool(
                          icon: LucideIcons.film,
                          label: l10n.memoriesVideo,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}
