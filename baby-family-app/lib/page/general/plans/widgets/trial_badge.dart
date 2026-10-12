part of '../mobile/plans_mobile_view.dart';

/// Nhãn “Dùng thử còn N ngày” (Pencil `MSIAb`): nền `accent-100`, icon timer.
class _TrialBadge extends StatelessWidget {
  const _TrialBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorTextPrimary2E2A27);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.compact,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorAccent100FDF1D6),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.timer, size: 14, color: color),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              text,
              style: AppTypography.adapt(
                context,
                AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: kColorTextPrimary2E2A27,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
