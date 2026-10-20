part of '../mobile/memory_comments_mobile_view.dart';

/// Ngữ cảnh ký ức (`BXnBF`): đệm 4/20/12/20, viền dưới; ảnh 48 bo 12, cách
/// 12; tiêu đề 14/700, meta 12 `text-tertiary` “Mama Lan · 07/10/2026 · Cả nhà”.
class _CommentContext extends StatelessWidget {
  const _CommentContext({
    required this.memory,
    required this.author,
    required this.onTap,
  });

  final Memory memory;
  final Member? author;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final asset = memory.mediaAssets.firstOrNull;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          AppSpacing.s3,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
        ),
        child: Row(
          children: [
            if (asset != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.tile),
                child: Image(
                  image: mediaImageProvider(asset),
                  width: 48,
                  height: 48,
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
                    memory.title ?? memory.body ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.memDotMeta3(
                      author == null ? '' : memberFullName(author!),
                      memory.occurredAt.toFormDate(l10n.localeName),
                      memoryVisibilityLabel(l10n, memory.visibility),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        color: kColorTextTertiary9C928A,
                      ),
                    ),
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
