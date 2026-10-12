part of '../mobile/home_tab_mobile_view.dart';

/// “Tuần này của nhà mình” (Pencil `VdCIy`): tiêu đề 16/800 + chevron; 3 ô
/// số (nền `surface-variant` bo 12, đệm 10, số 18/800, nhãn 11); 4 ảnh cao 64
/// bo 10.
class _WeekCard extends StatelessWidget {
  const _WeekCard({required this.week});

  final WeekSummary week;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget stat(int value, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.itemGap),
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: AppTypography.adapt(
                context,
                AppTypography.h3.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.adapt(
                context,
                AppTypography.tiny.copyWith(color: kColorTextSecondary6B625B),
              ),
            ),
          ],
        ),
      ),
    );
    final thumbs = week.thumbnails.take(4).toList();
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s4),
      onTap: () => context.router.push(const WeeklyRecapRoute()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.homeThisWeek,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.title16.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              stat(week.moments, l10n.homeMomentLabel),
              const SizedBox(width: AppSpacing.s2),
              stat(week.firsts, l10n.commonFirsts),
              const SizedBox(width: AppSpacing.s2),
              stat(week.quotes, l10n.homeQuoteLabel),
            ],
          ),
          if (thumbs.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s3),
            Row(
              children: [
                for (var index = 0; index < thumbs.length; index++) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.compact),
                  Expanded(
                    child: _Photo(
                      asset: thumbs[index],
                      height: 64,
                      radius: AppRadius.sm,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
