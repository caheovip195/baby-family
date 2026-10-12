part of '../mobile/onboarding_notifications_mobile_view.dart';

/// Thông báo mẫu: nền `surface`, viền `border`, bo 18, đệm 14, cách 12; ô icon
/// 36 bo 10 (icon 18); dòng ứng dụng 11 `text-tertiary`, tiêu đề 14/600, nội
/// dung 13 `text-secondary`.
class _NotificationPreview extends StatelessWidget {
  const _NotificationPreview({
    required this.icon,
    required this.color,
    required this.background,
    required this.meta,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String meta;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.cardInset),
    decoration: BoxDecoration(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      borderRadius: BorderRadius.circular(AppSpacing.sectionGap),
      border: Border.all(color: AppColors.resolve(context, kColorBorderEADFD6)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, background),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: AppColors.resolve(context, color)),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meta,
                style: AppTypography.adapt(context, AppTypography.tiny),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(height: 16 / 13),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
