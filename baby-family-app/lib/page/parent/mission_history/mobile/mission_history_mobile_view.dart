import 'package:baby_family/data/model/care/mission_history_day.dart';
import 'package:baby_family/data/model/care/mission_history_entry.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/page/parent/mission_history/mission_history_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/lunar_date.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/parent_color.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/history_day_group.dart';
part '../widgets/history_entry_row.dart';
part '../widgets/history_filter_chip.dart';
part '../widgets/history_legend.dart';

/// CARE-08 “Lịch sử” (Pencil `LxWjt`).
class MissionHistoryMobileView extends HookConsumerWidget {
  const MissionHistoryMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(missionHistoryControllerProvider);
    final l10n = context.l10n;

    Future<void> pickCategory() async {
      final picked = await showAppBottomSheet<String>(
        context,
        builder: (sheetContext) => AppBottomSheet(
          title: l10n.careHistoryCategory,
          gap: 0,
          children: [
            for (final code in [null, ...controller.categories])
              InkWell(
                onTap: () => Navigator.of(sheetContext).pop(code ?? ''),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          code == null
                              ? l10n.careHistoryAll
                              : l10n.careCategoryName(code),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.body,
                          ),
                        ),
                      ),
                      AppRadioMark(
                        selected: controller.category == code,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
      if (picked != null) {
        controller.selectCategory(picked.isEmpty ? null : picked);
      }
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      final days = controller.days;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.careHistoryTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _HistoryFilterChip(
                  label: l10n.careHistoryAll,
                  selected:
                      controller.childId == null && controller.category == null,
                  onTap: () {
                    controller
                      ..selectChild(null)
                      ..selectCategory(null);
                  },
                ),
                for (final child in controller.babies) ...[
                  const SizedBox(width: AppSpacing.s2),
                  _HistoryFilterChip(
                    label: child.name,
                    selected: controller.childId == child.id,
                    avatar: ChildAvatar(child: child, size: 30),
                    onTap: () => controller.selectChild(
                      controller.childId == child.id ? null : child.id,
                    ),
                  ),
                ],
                const SizedBox(width: AppSpacing.s2),
                _HistoryFilterChip(
                  label: controller.category == null
                      ? l10n.careHistoryCategory
                      : l10n.careCategoryName(controller.category!),
                  selected: controller.category != null,
                  dropdown: true,
                  onTap: pickCategory,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          _HistoryLegend(partnerCallName: controller.partnerCallName),
          if (days.isEmpty) ...[
            const SizedBox(height: AppSpacing.s6),
            EmptyState(title: l10n.careHistoryEmpty, illustrationSize: 140),
          ],
          for (final day in days) ...[
            const SizedBox(height: AppSpacing.cardInset),
            _HistoryDayGroup(day: day, controller: controller),
          ],
          const SizedBox(height: AppSpacing.cardInset),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
            child: Row(
              children: [
                Icon(
                  LucideIcons.lock,
                  size: 14,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    l10n.careHistoryNote(controller.partnerCallName),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
