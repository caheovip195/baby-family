part of '../mobile/on_this_day_mobile_view.dart';

/// Thẻ hôm nay (`AYARV`): nền `accent-100` bo 20, đệm 14/16, cách 12; tờ lịch
/// 52×56 nền `surface` bo 12 viền `#F0DDB0` (“TH 10” 10/700 `primary-600`,
/// “07” 22/800); tiêu đề 16/800 + phụ đề 12 `text-secondary`.
class _TodayHeader extends StatelessWidget {
  const _TodayHeader({
    required this.month,
    required this.day,
    required this.title,
    required this.subtitle,
  });

  final String month;
  final String day;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.cardInset,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorAccent100FDF1D6),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 52, minHeight: 56),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.tile),
              border: Border.all(
                color: AppColors.resolve(context, kColorAccentBorderF0DDB0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: AppTypography.micro.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.resolve(context, kColorPrimary600C2513F),
                  ),
                ),
                Text(
                  day,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h2.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.title16.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
