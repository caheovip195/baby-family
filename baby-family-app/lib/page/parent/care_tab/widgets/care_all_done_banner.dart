part of '../mobile/care_tab_mobile_view.dart';

/// “Mama đã xong cả 3 việc hôm nay” (Pencil `qTD9X`): nền `secondary-100` bo
/// 14, đệm 12/14, `party-popper` 20 + chữ 14/700 `secondary-700`.
class _CareAllDoneBanner extends StatelessWidget {
  const _CareAllDoneBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.resolve(context, kColorSecondary7003F7A5C);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardInset,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSecondary100E4F2EA),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.partyPopper, size: 20, color: color),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Text(
              text,
              style: AppTypography.text14.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
