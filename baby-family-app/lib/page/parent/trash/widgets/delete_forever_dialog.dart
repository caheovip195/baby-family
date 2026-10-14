part of '../mobile/trash_mobile_view.dart';

/// MEM-17b — Xác nhận xoá vĩnh viễn (Pencil `BB8YZ`): vòng `trash-2`, tiêu
/// đề 20/800, ô xem trước (ảnh 44 + tên 14/600 + “2 ảnh · 3 bình luận ·
/// 5 lượt thả tim”), lời giải thích 14, nút đỏ “Xoá vĩnh viễn” và “Giữ lại
/// trong thùng rác”. Trả về `true` khi xác nhận.
class _DeleteForeverDialog extends StatelessWidget {
  const _DeleteForeverDialog({required this.memory});

  final Memory memory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hearts = memory.reactions.values.fold<int>(0, (a, b) => a + b);
    final stats = [
      if (memory.mediaAssets.isNotEmpty)
        l10n.homePhotoCount(memory.mediaAssets.length),
      if (memory.commentCount > 0) l10n.memCommentCount(memory.commentCount),
      if (hearts > 0) l10n.memHeartCount(hearts),
    ];
    return AppDialogCard(
      children: [
        const AppDialogIcon(icon: LucideIcons.trash2),
        Text(
          l10n.memTrashConfirmTitle,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(context, AppTypography.title20),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.itemGap),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              MemoryThumb(
                kind: memory.kind,
                asset: memory.mediaAssets.firstOrNull,
                size: 44,
                radius: AppRadius.sm,
              ),
              const SizedBox(width: AppSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memoryTitle(memory),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (stats.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        stats.reduce(l10n.commonDotJoin),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(
                            color: kColorTextSecondary6B625B,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          l10n.memTrashConfirmBody,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              height: 21 / 14,
              color: kColorTextSecondary6B625B,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.compact),
          child: Column(
            children: [
              AppButton(
                label: l10n.commonDeleteForever,
                color: kColorErrorD14B4B,
                onPressed: () => Navigator.of(context).pop(true),
              ),
              const SizedBox(height: AppSpacing.s2),
              AppButton.secondary(
                label: l10n.memTrashKeep,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
