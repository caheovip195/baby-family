part of '../mobile/memories_tab_mobile_view.dart';

/// Thẻ tổng kết tuần trên dòng thời gian (thẻ `WEEKLY_RECAP` của server): nền
/// `primary-50` bo 16, biểu tượng + “Tuần của nhà mình” + khoảng ngày → REC-02.
class _RecapWeekCard extends StatelessWidget {
  const _RecapWeekCard({required this.entry});

  final RecapWeekEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeName;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.cardInset),
      child: Material(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () => context.router.push(const WeeklyRecapRoute()),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardInset),
            child: Row(
              children: [
                Icon(
                  LucideIcons.sparkles,
                  size: 20,
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.recapWeekTitle,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.memChapterRange(
                          entry.weekStart.toDayMonth(locale),
                          entry.weekEnd.toDayMonth(locale),
                        ),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: AppColors.resolve(context, kColorTextTertiary9C928A),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
