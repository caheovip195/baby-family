part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Header tuần thai (Pencil `o2autV`): đệm 0/20/12/20, cách 10 — vòng 48
/// `us-100` + mầm 24 `us-700`; “Tuần 24 + 3 ngày” 18/800, phụ 12.
class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader({required this.controller});

  final PregnancyJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final week = controller.week;
    final stats = controller.stats;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs100EAE2F8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.sprout,
              size: 24,
              color: AppColors.resolve(context, kColorUs7006A549F),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (week != null)
                  Text(
                    week.day == 0
                        ? l10n.commonPregnancyWeekOnly(week.week)
                        : l10n.commonPregnancyWeekDay(week.week, week.day),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 25 / 18,
                      ),
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  l10n.pregJourneyStats(
                    controller.daysLeft ?? 0,
                    stats?.memories ?? 0,
                    stats?.firsts ?? 0,
                  ),
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
