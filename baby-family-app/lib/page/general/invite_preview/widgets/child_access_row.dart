part of '../mobile/invite_preview_mobile_view.dart';

/// Bé được chia sẻ: nền `surface`, viền `border`, bo 14, đệm 10/12; avatar 32
/// + “Tên · tuổi” 14/600 + nhãn quyền (nền `secondary-100`, chữ 12/600
/// `secondary-700`).
class _ChildAccessRow extends StatelessWidget {
  const _ChildAccessRow({
    required this.child,
    required this.today,
    required this.permission,
  });

  final Child child;
  final DateTime today;
  final String permission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final birth = child.birthDate;
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.s2),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.itemGap,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Row(
        children: [
          ChildAvatar(
            child: child,
            size: AppSpacing.s8,
            borderColor: AppColors.resolve(context, kColorSurfaceFFFFFF),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Text(
              birth == null
                  ? child.name
                  : l10n.commonChildNameAge(
                      child.name,
                      childAgeText(l10n, birth, today),
                    ),
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.itemGap,
              vertical: AppSpacing.s1,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSecondary100E4F2EA),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              permission,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(
                  fontWeight: FontWeight.w600,
                  color: kColorSecondary7003F7A5C,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
