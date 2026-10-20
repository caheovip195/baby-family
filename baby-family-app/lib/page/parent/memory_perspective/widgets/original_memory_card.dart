part of '../mobile/memory_perspective_mobile_view.dart';

/// Tóm tắt ký ức gốc (`b0ejbP`): nền `surface`, viền, bo 16, đệm 12, cách
/// 12; ảnh 64 bo 12; “MAMA KỂ · HÔM NAY” 10/800 `text-tertiary`; câu đầu của
/// chú thích 14/600.
class _OriginalMemoryCard extends StatelessWidget {
  const _OriginalMemoryCard({required this.controller});

  final MemoryPerspectiveController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memory = controller.memory!;
    final photo = memory.mediaAssets.firstOrNull;
    final when = memory.occurredAt.isSameDay(controller.today)
        ? l10n.memoriesToday
        : memory.occurredAt.toDayMonth(context.localeName);
    final tag = l10n.memOriginalTag(controller.author?.callName ?? '', when);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Row(
        children: [
          if (photo != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.tile),
              child: Image(
                image: mediaImageProvider(photo),
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tag.toUpperCase(),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.micro.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  (memory.body ?? memory.title ?? '').firstSentence,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(fontWeight: FontWeight.w600),
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
