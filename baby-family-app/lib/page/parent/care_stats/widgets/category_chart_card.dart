part of '../mobile/care_stats_mobile_view.dart';

/// Biểu đồ category (`sb0tT`): thẻ `surface` viền bo 20, đệm 16, cách 14;
/// “Nhiệm vụ cả nhà đã hoàn thành” 13 + tổng 30/800 + đơn vị 13; vùng cột cao
/// 180 (cột `primary-500` bo 8/8/4/4, cột cao nhất 130, số 13/700 trên cột);
/// đường đáy `border`; nhãn 11 giữa; ghi chú “Hai ta” 11 `text-tertiary`.
class _CategoryChartCard extends StatelessWidget {
  const _CategoryChartCard({required this.stats, required this.maxCount});

  final CareStats stats;
  final int maxCount;

  static const _chartHeight = 180.0;
  static const _maxBarHeight = 130.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = stats.categories;
    final barColor = AppColors.resolve(context, kColorPrimary500EE7B67);
    Widget spaced(List<Widget> children) => Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.itemGap),
          Expanded(child: children[index]),
        ],
      ],
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.careStatsDone,
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${stats.total}',
                style: AppTypography.adapt(
                  context,
                  AppTypography.h1.copyWith(fontSize: 30, height: 40 / 30),
                ),
              ),
              const SizedBox(width: AppSpacing.compact),
              Flexible(
                child: Text(
                  l10n.careStatsUnit,
                  style: AppTypography.adapt(context, AppTypography.caption),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          SizedBox(
            height: _chartHeight,
            child: spaced([
              for (final item in categories)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${item.count}',
                      textAlign: TextAlign.center,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: kColorTextPrimary2E2A27,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    Container(
                      height: maxCount == 0
                          ? 0
                          : _maxBarHeight * item.count / maxCount,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppSpacing.s2),
                          bottom: Radius.circular(AppSpacing.s1),
                        ),
                      ),
                    ),
                  ],
                ),
            ]),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < categories.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    l10n.careStatsCategory(categories[index].code),
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(
                        height: 1.3,
                        color: kColorTextSecondary6B625B,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Text(
            l10n.careStatsNote,
            style: AppTypography.adapt(
              context,
              AppTypography.tiny.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
