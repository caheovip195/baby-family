part of '../mobile/memory_search_mobile_view.dart';

/// Dòng nhật ký (`g97IF`): đệm 12/14, cách 12; ô icon 36 `accent-100`
/// (`notebook-pen` 18); tiêu đề 14/700, trích 12 `text-secondary` (2 dòng),
/// meta 11 `text-tertiary`.
class _SearchDiaryRow extends StatelessWidget {
  const _SearchDiaryRow({
    required this.memory,
    required this.meta,
    required this.onTap,
  });

  final Memory memory;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardInset,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.resolve(context, kColorAccent100FDF1D6),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                LucideIcons.notebookPen,
                size: 18,
                color: AppColors.resolve(context, kColorAccent600B7862B),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memory.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (memory.body != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      memory.body!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: AppTypography.adapt(context, AppTypography.tiny),
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
