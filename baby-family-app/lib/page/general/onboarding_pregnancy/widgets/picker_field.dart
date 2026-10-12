part of '../mobile/onboarding_pregnancy_mobile_view.dart';

/// Ô chọn (ngày dự sinh / tuần thai): cao 52, nền `surface-variant`, bo 14,
/// giá trị 15 + icon 20 `text-secondary` bên phải.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
    borderRadius: BorderRadius.circular(AppRadius.md),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.fieldHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: AppTypography.adapt(context, AppTypography.body),
              ),
            ),
            Icon(
              icon,
              size: 20,
              color: AppColors.resolve(context, kColorTextSecondary6B625B),
            ),
          ],
        ),
      ),
    ),
  );
}
