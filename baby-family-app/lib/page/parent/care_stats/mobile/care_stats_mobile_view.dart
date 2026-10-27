import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/care/care_stats.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/parent/care_stats/care_stats_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_switcher_title_bar.dart';
import 'package:baby_family/utils/widget/app_week_selector.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/bloom_days_card.dart';
part '../widgets/category_chart_card.dart';

/// CARE-11 — Thống kê chăm con (Pencil `EWZwi`): thanh “Thống kê” 24/800 +
/// bộ chuyển bé, bộ chọn tuần, biểu đồ cột category của cả nhà, số ngày cây
/// nở hoa (`primary-50`), disclaimer (`surface-variant`), dòng riêng tư.
class CareStatsMobileView extends HookConsumerWidget {
  const CareStatsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(careStatsControllerProvider);
    final l10n = context.l10n;
    final stats = controller.stats;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else if (stats == null) {
      body = EmptyState(title: l10n.careStatsEmpty);
    } else {
      body = _content(context, controller, stats);
    }
    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSwitcherTitleBar(
              title: l10n.careStatsTitle,
              titleSize: 24,
              children: controller.children,
              selectedId: controller.subjectId,
              today: controller.today,
              onChanged: controller.selectSubject,
              onManage: () => context.router.push(const ChildrenRoute()),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    CareStatsController controller,
    CareStats stats,
  ) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    final tertiary = AppColors.resolve(context, kColorTextTertiary9C928A);
    final items = <Widget>[
      AppWeekSelector(
        outlined: true,
        onPrevious: controller.previousWeek,
        onNext: controller.canGoNext ? controller.nextWeek : null,
        label: l10n.commonWeekRange(
          '${stats.weekStart.toDayMonth(locale)} – '
          '${stats.weekEnd.toDayMonth(locale)}',
        ),
      ),
      _CategoryChartCard(stats: stats, maxCount: controller.maxCount),
      _BloomDaysCard(stats: stats),
      Container(
        padding: const EdgeInsets.all(AppSpacing.cardInset),
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.info, size: 16, color: secondary),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: Text(
                l10n.careStatsDisclaimer,
                style: AppTypography.small.copyWith(
                  height: 1.4,
                  color: secondary,
                ),
              ),
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.lock, size: 12, color: tertiary),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              l10n.careStatsPrivacy,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(context, AppTypography.tiny),
            ),
          ),
        ],
      ),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.cardInset),
          items[index],
        ],
      ],
    );
  }
}
