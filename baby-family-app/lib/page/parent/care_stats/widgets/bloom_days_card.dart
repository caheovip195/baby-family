part of '../mobile/care_stats_mobile_view.dart';

/// Ngày cây nở hoa (`adoYG`): nền `primary-50` bo 20, đệm 16, cách 12; hình
/// cây 72; “5” 26/800 + “/ 7 ngày” 14/600 + nhãn 13; hàng 7 ngày (chấm 36:
/// nở hoa = nền `surface` + `flower-2` 18 `primary-600`, chưa = `#FFFFFF80` +
/// `sprout` `text-tertiary`; thứ 11/600).
class _BloomDaysCard extends StatelessWidget {
  const _BloomDaysCard({required this.stats});

  final CareStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final days = stats.bloomed;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorPrimary50FFF4F1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.images.gyDMl.image(width: 72, height: 72),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${stats.bloomDays}',
                          style: AppTypography.adapt(
                            context,
                            AppTypography.h1.copyWith(height: 35 / 26),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s1),
                        Flexible(
                          child: Text(
                            l10n.careStatsBloomOf(days.length),
                            style: AppTypography.adapt(
                              context,
                              AppTypography.text14.copyWith(
                                fontWeight: FontWeight.w600,
                                color: kColorTextSecondary6B625B,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.careStatsBloomLabel,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              for (var index = 0; index < days.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.compact),
                Expanded(child: _day(context, index, days[index])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _day(BuildContext context, int index, bool bloomed) {
    final date = stats.weekStart.dateOnly.add(Duration(days: index));
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bloomed
                ? AppColors.resolve(context, kColorSurfaceFFFFFF)
                : (AppColors.isDark(context)
                      ? AppColors.resolve(context, kColorSurfaceVariantF7F1EC)
                      : kColorWhiteAlpha50),
            shape: BoxShape.circle,
          ),
          child: Icon(
            bloomed ? LucideIcons.flower2 : LucideIcons.sprout,
            size: 18,
            color: AppColors.resolve(
              context,
              bloomed ? kColorPrimary600C2513F : kColorTextTertiary9C928A,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s1),
        Text(
          context.l10n.careWeekday(weekdayCode(date.weekday)),
          style: AppTypography.adapt(
            context,
            AppTypography.tiny.copyWith(
              fontWeight: FontWeight.w600,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
      ],
    );
  }
}
