part of '../mobile/couple_week_mobile_view.dart';

/// Ô số liệu tuần (`NwbGm`): nền `surface` bo 16, đệm 14, cách 6; ô icon 32
/// bo 10 `us-100` (icon 16 `us-700`); số 28/800 Nunito `us-700`; nhãn
/// 13/700 (dòng 1.3); gợi ý 11 `text-tertiary` (dòng 1.4).
class _WeekStatTile extends StatelessWidget {
  const _WeekStatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.hint,
  });

  final IconData icon;
  final int value;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final usDark = AppColors.resolve(context, kColorUs7006A549F);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs100EAE2F8),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 16, color: usDark),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            '$value',
            style: AppTypography.h1.copyWith(
              fontSize: 28,
              height: 38 / 28,
              color: usDark,
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            label,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: kColorTextPrimary2E2A27,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.compact),
          Text(
            hint,
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
