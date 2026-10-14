part of '../mobile/month_recap_mobile_view.dart';

/// Một câu nói/giọng nói (`W5pkG`): nút phát 34 tròn `surface` (`play` 14
/// `secondary-700`), tiêu đề 13/600 (dòng 1.4) + meta 11 `text-secondary`,
/// thời lượng 12/700 `secondary-700`.
class _MonthVoiceRow extends StatelessWidget {
  const _MonthVoiceRow({
    required this.title,
    required this.meta,
    required this.duration,
  });

  final String title;
  final String meta;
  final String duration;

  @override
  Widget build(BuildContext context) {
    final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            shape: BoxShape.circle,
          ),
          child: Icon(LucideIcons.play, size: 14, color: strong),
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
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: kColorTextPrimary2E2A27,
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                meta,
                style: AppTypography.adapt(
                  context,
                  AppTypography.tiny.copyWith(color: kColorTextSecondary6B625B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Text(
          duration,
          style: AppTypography.small.copyWith(
            fontWeight: FontWeight.w700,
            color: strong,
          ),
        ),
      ],
    );
  }
}
