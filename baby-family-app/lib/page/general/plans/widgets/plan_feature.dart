part of '../mobile/plans_mobile_view.dart';

/// Lợi ích của gói (Pencil `y86nay`): `check` 16 `secondary-500` + chữ 14;
/// không có: `x` 16 + chữ `text-tertiary`.
class _PlanFeature extends StatelessWidget {
  const _PlanFeature({required this.text, this.included = true});

  final String text;
  final bool included;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          included ? LucideIcons.check : LucideIcons.x,
          size: 16,
          color: AppColors.resolve(
            context,
            included ? kColorSecondary5006FAE8E : kColorTextTertiary9C928A,
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Expanded(
          child: Text(
            text,
            style: AppTypography.adapt(
              context,
              AppTypography.text14.copyWith(
                color: included
                    ? kColorTextPrimary2E2A27
                    : kColorTextTertiary9C928A,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
