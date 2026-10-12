import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/care/hearts_entry.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/parent/family_tree/family_tree_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/care_more_sheet.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/tree_hearts_history.dart';
part '../widgets/tree_hero.dart';
part '../widgets/tree_more_button.dart';
part '../widgets/tree_next_level_card.dart';
part '../widgets/tree_stat_tile.dart';

/// CARE-09 “Cây gia đình” (Pencil `eRR9k`): nền `secondary-100`.
class FamilyTreeMobileView extends HookConsumerWidget {
  const FamilyTreeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(familyTreeControllerProvider);
    final tree = controller.tree;
    final hearts = controller.hearts;
    final l10n = context.l10n;
    Widget body;
    if (tree == null || hearts == null) {
      body = Center(
        child: controller.hasError
            ? ErrorState(onRetry: controller.load)
            : const CircleLoadingProgress(),
      );
    } else {
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _TreeHero(level: tree.level, name: tree.name),
          if (tree.nextName != null) ...[
            const SizedBox(height: AppSpacing.s5),
            _TreeNextLevelCard(
              nextName: tree.nextName!,
              percent: tree.progressPercent,
              reward: tree.nextReward,
            ),
          ],
          const SizedBox(height: AppSpacing.s5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TreeStatTile(
                  value: '${tree.weekCareMoments}',
                  label: l10n.careTreeMoments,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: _TreeStatTile(
                  value: '${tree.weekTogether}',
                  label: l10n.careTreeTogether,
                ),
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: _TreeStatTile(
                  value: '${tree.weekBloomDays}',
                  label: l10n.careTreeBloomDays,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s5),
          Text(
            l10n.careTreeContributionTitle,
            style: AppTypography.adapt(context, AppTypography.h3),
          ),
          const SizedBox(height: AppSpacing.s5),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, (value, label)) in [
                  (hearts.today, l10n.careTreeToday),
                  (hearts.week, l10n.careTreeWeek),
                  (hearts.total, l10n.careTreeTotal),
                ].indexed) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.s2),
                  Expanded(
                    child: _TreeStatTile.hearts(
                      value: l10n.careHeartsValue(value),
                      label: label,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hearts.recent.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s5),
            _TreeHeartsHistory(
              entries: hearts.recent
                  .take(FamilyTreeController.recentCount)
                  .toList(),
              today: controller.today,
            ),
          ],
          const SizedBox(height: AppSpacing.s5),
          Text(
            l10n.careHeartsPrivacy,
            style: AppTypography.adapt(context, AppTypography.small),
          ),
        ],
      );
    }
    return BaseScaffold(
      backgroundColor: kColorSecondary100E4F2EA,
      appBar: const AppTopBar(
        backgroundColor: kColorSecondary100E4F2EA,
        trailing: _TreeMoreButton(),
      ),
      body: body,
    );
  }
}
