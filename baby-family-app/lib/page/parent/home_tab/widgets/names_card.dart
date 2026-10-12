part of '../mobile/home_tab_mobile_view.dart';

/// “Đặt tên cho Bơ” (Pencil `b3F7gD`): nền `primary-50`, bo 16, đệm 16;
/// icon `baby` 22 trên nền tròn 44 `surface`; tiêu đề 15/700, tóm tắt 12;
/// `chevron-right` 18.
class _NamesCard extends StatelessWidget {
  const _NamesCard({
    required this.controller,
    required this.pregnancy,
    required this.onTap,
  });

  final HomeTabController controller;
  final Child pregnancy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      color: kColorPrimary50FFF4F1,
      borderColor: null,
      padding: const EdgeInsets.all(AppSpacing.s4),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.baby,
              size: 22,
              color: AppColors.resolve(context, kColorPrimary600C2513F),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pregnancyNamesFor(pregnancy.name),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyStrong.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.homeNamesSummary(
                    controller.names.length,
                    controller.namesBothLike,
                  ),
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
        ],
      ),
    );
  }
}
