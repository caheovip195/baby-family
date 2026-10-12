import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/page/parent/children/children_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/archived_child_row.dart';
part '../widgets/child_list_card.dart';

/// CHD-03 “Các con” (Pencil `Dcj0x`).
class ChildrenMobileView extends HookConsumerWidget {
  const ChildrenMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(childrenControllerProvider);
    final l10n = context.l10n;
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);

    void open(Child child) => context.router.push(
      child.isPregnancy
          ? PregnancyJourneyRoute(pregnancyId: child.id)
          : ChildProfileRoute(childId: child.id),
    );

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      final children = controller.children;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.familyChildren,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          Row(
            children: [
              Icon(LucideIcons.gripVertical, size: 14, color: tertiary),
              const SizedBox(width: AppSpacing.compact),
              Expanded(
                child: Text(
                  l10n.childrenReorderHint,
                  style: AppTypography.adapt(context, AppTypography.caption),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: children.length,
            onReorderItem: controller.reorder,
            itemBuilder: (context, index) =>
                ReorderableDelayedDragStartListener(
                  key: ValueKey(children[index].id),
                  index: index,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: index < children.length - 1
                          ? AppSpacing.itemGap
                          : 0,
                    ),
                    child: _ChildListCard(
                      child: children[index],
                      today: controller.today,
                      onTap: () => open(children[index]),
                    ),
                  ),
                ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Material(
            color: AppColors.resolve(context, kColorPrimary50FFF4F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              side: BorderSide(
                color: AppColors.resolve(context, kColorPrimary300F7A796),
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.router.push(const ChildAddRoute()),
              child: SizedBox(
                height: AppSpacing.buttonHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.plus,
                      size: 18,
                      color: AppColors.resolve(context, kColorPrimary600C2513F),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Text(
                      l10n.childAddTitle,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyStrong.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kColorPrimary600C2513F,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (controller.archived.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardInset),
            InkWell(
              onTap: controller.toggleArchived,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.itemGap),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n
                            .childrenArchived(controller.archived.length)
                            .toUpperCase(),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      controller.archivedExpanded
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      size: 16,
                      color: AppColors.resolve(
                        context,
                        kColorTextSecondary6B625B,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.archivedExpanded) ...[
              for (final child in controller.archived) ...[
                const SizedBox(height: AppSpacing.cardInset),
                _ArchivedChildRow(
                  child: child,
                  privateCount: controller.privateMemories[child.id] ?? 0,
                  onRestore: () => controller.restore(child.id),
                ),
              ],
              const SizedBox(height: AppSpacing.cardInset),
              Text(
                l10n.childrenArchiveNote(kValueChildDeleteAfterArchiveDays),
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    height: 17 / 12,
                    color: kColorTextTertiary9C928A,
                  ),
                ),
              ),
            ],
          ],
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
