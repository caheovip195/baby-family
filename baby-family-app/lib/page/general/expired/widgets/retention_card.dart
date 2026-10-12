part of '../mobile/expired_mobile_view.dart';

/// Thẻ giữ dữ liệu (Pencil `N61WD`): icon `shield-check` trên nền
/// `secondary-100` bo 12, tiêu đề 14/700, mô tả 12.
class _RetentionCard extends StatelessWidget {
  const _RetentionCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Row(
        children: [
          const AppIconBadge(
            icon: LucideIcons.shieldCheck,
            radius: AppRadius.tile,
            color: kColorSecondary100E4F2EA,
            foreground: kColorSecondary7003F7A5C,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
