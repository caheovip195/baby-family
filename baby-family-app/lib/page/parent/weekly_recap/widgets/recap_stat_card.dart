part of '../mobile/weekly_recap_mobile_view.dart';

/// Ô số liệu (`qJt6b`): nền `surface`, viền, bo 16, đệm 12, cách 6; ô icon 28
/// bo 8 (icon 15); số 26/800 Nunito; nhãn 12 `text-secondary`.
class _RecapStatCard extends StatelessWidget {
  const _RecapStatCard({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, background),
              borderRadius: BorderRadius.circular(AppSpacing.s2),
            ),
            child: Icon(
              icon,
              size: 15,
              color: AppColors.resolve(context, foreground),
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            '$value',
            style: AppTypography.adapt(
              context,
              AppTypography.h1.copyWith(height: 35 / 26),
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(label, style: AppTypography.adapt(context, AppTypography.small)),
        ],
      ),
    );
  }
}
