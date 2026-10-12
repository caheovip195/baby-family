part of '../mobile/badges_mobile_view.dart';

/// Thẻ tổng (Pencil `kKdNE`): nền `secondary-100` bo 16 đệm 14 cách 14; icon
/// `award` 24 trong vòng `surface` 48; “Đã mở 4 / 10 huy hiệu” 16/800, thanh 8
/// nền trắng, “Gần nhất: …” 12/600 `secondary-700`.
class _BadgesSummary extends StatelessWidget {
  const _BadgesSummary({
    required this.done,
    required this.total,
    required this.latest,
  });

  final int done;
  final int total;
  final String? latest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardInset),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSecondary100E4F2EA),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            ),
            child: Icon(
              LucideIcons.award,
              size: 24,
              color: AppColors.resolve(context, kColorSecondary7003F7A5C),
            ),
          ),
          const SizedBox(width: AppSpacing.cardInset),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.careBadgesUnlocked(done, total),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.title16.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                AppProgressBar(
                  value: total == 0 ? 0 : done / total,
                  trackColor: kColorSurfaceFFFFFF,
                ),
                if (latest != null) ...[
                  const SizedBox(height: AppSpacing.compact),
                  Text(
                    latest!,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kColorSecondary7003F7A5C,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
