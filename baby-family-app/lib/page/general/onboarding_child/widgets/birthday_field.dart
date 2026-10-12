part of '../mobile/onboarding_child_mobile_view.dart';

/// Ô “Ngày sinh” theo Pencil Input: nhãn 13/600, cách 8, ô 52 nền
/// `surface-variant` bo 14, giá trị 15 (“01/05/2026 · 5 tháng 6 ngày”); chạm
/// mở lịch.
class _BirthdayField extends StatelessWidget {
  const _BirthdayField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: AppTypography.adapt(
          context,
          AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(height: AppSpacing.s2),
      Material(
        color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(
              minHeight: AppSpacing.fieldHeight,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.s3,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTypography.adapt(context, AppTypography.body),
            ),
          ),
        ),
      ),
    ],
  );
}
