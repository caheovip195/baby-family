part of '../mobile/couple_tab_mobile_view.dart';

/// Ô tính năng US-00 (`Check-in cảm xúc`…): `surface` bo 16, đệm 10/12, cách
/// 10; ô icon 32 bo 10 `us-100` (icon 16 `us-700`); tên 13/700 + mô tả 11.
class _PartnerLeftFeature extends StatelessWidget {
  const _PartnerLeftFeature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.itemGap,
      ),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs100EAE2F8),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.resolve(context, kColorUs7006A549F),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: kColorTextPrimary2E2A27,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
