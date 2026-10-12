part of '../mobile/badges_mobile_view.dart';

/// Ô huy hiệu (Pencil “Giờ ngủ ấm áp”…): đệm 14/12, cách 6, căn giữa, bo 16
/// viền `border`. Đã đạt: nền `surface`, vòng 56 màu, tên 14/700, ngày 11/600
/// `secondary-700`. Chưa đạt: nền `surface-variant`, vòng `surface` icon
/// `text-tertiary`, tên `text-secondary`, điều kiện 11 + thanh tiến độ 5.
class _BadgeTile extends StatelessWidget {
  const _BadgeTile({
    required this.badge,
    required this.detail,
    required this.controller,
    required this.onTap,
  });

  final FamilyBadge badge;
  final String detail;
  final BadgesController controller;
  final VoidCallback onTap;

  /// Vòng icon 56 (dùng lại ở sheet chi tiết).
  static Widget icon(
    BuildContext context,
    FamilyBadge badge,
    BadgesController controller,
  ) {
    final index = controller.earned.indexOf(badge);
    final (background, foreground) = badge.achieved
        ? _earnedPalette[index % _earnedPalette.length]
        : (kColorSurfaceFFFFFF, kColorTextTertiary9C928A);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.resolve(context, background),
      ),
      child: Icon(
        lucideIconByName(badge.icon),
        size: 26,
        color: AppColors.resolve(context, foreground),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final achieved = badge.achieved;
    final progress = badge.progress;
    final target = badge.target;
    return Material(
      color: AppColors.resolve(
        context,
        achieved ? kColorSurfaceFFFFFF : kColorSurfaceVariantF7F1EC,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.cardInset,
          ),
          child: Column(
            children: [
              icon(context, badge, controller),
              const SizedBox(height: AppSpacing.compact),
              Text(
                badge.title,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: achieved
                        ? kColorTextPrimary2E2A27
                        : kColorTextSecondary6B625B,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.compact),
              Text(
                detail,
                textAlign: TextAlign.center,
                style: AppTypography.adapt(
                  context,
                  AppTypography.tiny.copyWith(
                    fontWeight: achieved ? FontWeight.w600 : FontWeight.w400,
                    color: achieved
                        ? kColorSecondary7003F7A5C
                        : kColorTextTertiary9C928A,
                  ),
                ),
              ),
              if (!achieved &&
                  progress != null &&
                  progress > 0 &&
                  target != null) ...[
                const SizedBox(height: AppSpacing.compact),
                AppProgressBar(
                  value: target == 0 ? 0 : progress / target,
                  height: 5,
                  color: kColorTextTertiary9C928A,
                  trackColor: kColorBorderEADFD6,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
