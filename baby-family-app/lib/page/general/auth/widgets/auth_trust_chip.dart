part of '../mobile/auth_mobile_view.dart';

/// Chip tin cậy AUTH-01: cao 32, đệm 10, nền `surface`, viền `border`, icon 14
/// `primary-600` + chữ 12/600 `text-secondary`.
class _AuthTrustChip extends StatelessWidget {
  const _AuthTrustChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: AppSpacing.s8),
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.itemGap),
    decoration: BoxDecoration(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      borderRadius: BorderRadius.circular(AppRadius.full),
      border: Border.all(color: AppColors.resolve(context, kColorBorderEADFD6)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.resolve(context, kColorPrimary600C2513F),
        ),
        const SizedBox(width: AppSpacing.compact),
        Flexible(
          child: Text(
            label,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(
                fontWeight: FontWeight.w600,
                color: kColorTextSecondary6B625B,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
