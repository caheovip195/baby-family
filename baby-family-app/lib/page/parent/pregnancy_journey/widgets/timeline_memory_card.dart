part of '../mobile/pregnancy_journey_mobile_view.dart';

/// Thẻ ký ức thai kỳ (Pencil `GY9YM`): nền `surface`, viền `border`, bo 16;
/// ảnh cao 170; thân đệm 14, cách 6: tiêu đề 15/700, meta 12 (icon
/// `heart-handshake` 12 `us-700` khi cả hai cùng kể).
class _TimelineMemoryCard extends StatelessWidget {
  const _TimelineMemoryCard({
    required this.memory,
    required this.onTap,
    this.author,
  });

  final Memory memory;
  final String? author;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photo = memory.mediaAssets.firstOrNull;
    final week = memory.pregnancyWeek;
    final day = memory.pregnancyDay ?? 0;
    final meta = [
      if (memory.bothTell) l10n.memoriesTogether,
      if (week != null)
        day == 0
            ? l10n.commonPregnancyWeekOnly(week)
            : l10n.pregWeekDayShort(week, day),
      if (author != null) l10n.pregPostedBy(author!),
    ].join(' · ');
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photo != null)
              Image(
                image: mediaImageProvider(photo),
                height: 170,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(height: 170),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title ?? memory.body ?? '',
                    style: AppTypography.adapt(
                      context,
                      AppTypography.bodyStrong.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 19 / 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  Row(
                    children: [
                      if (memory.bothTell) ...[
                        Icon(
                          LucideIcons.heartHandshake,
                          size: 12,
                          color: AppColors.resolve(context, kColorUs7006A549F),
                        ),
                        const SizedBox(width: AppSpacing.compact),
                      ],
                      Expanded(
                        child: Text(
                          meta,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
