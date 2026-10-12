part of '../mobile/memory_comments_mobile_view.dart';

/// Một bình luận (`Gzu64`): avatar chữ 32 (trả lời 26, chữ 13/11 800), cách
/// 10; bong bóng `surface-variant` bo 4/16/16/16 đệm 8/12 — tên 13/700, nội
/// dung 14 (1.4); dòng meta thụt 12, cách 14: thời gian 12 `text-tertiary`,
/// “Trả lời” 12/700 `text-secondary` (chỉ bình luận gốc). Giữ lâu → menu.
class _CommentItem extends StatelessWidget {
  const _CommentItem({
    required this.comment,
    required this.name,
    required this.age,
    required this.reply,
    required this.colors,
    required this.onLongPress,
    this.onReply,
  });

  final MemoryComment comment;
  final String name;
  final String age;
  final bool reply;
  final (Color, Color) colors;
  final ValueChanged<Rect> onLongPress;
  final VoidCallback? onReply;

  @override
  Widget build(BuildContext context) {
    final size = reply ? 26.0 : 32.0;
    final (background, foreground) = colors;
    final white = foreground == kColorWhite;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, background),
            shape: BoxShape.circle,
          ),
          child: Text(
            name.characters.firstOrNull ?? '',
            style: AppTypography.title16.copyWith(
              fontSize: reply ? 11 : 13,
              fontWeight: FontWeight.w800,
              height: reply ? 15 / 11 : 18 / 13,
              color: white
                  ? kColorWhite
                  : AppColors.resolve(context, foreground),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (bubbleContext) => GestureDetector(
                  onLongPress: () {
                    final box = bubbleContext.findRenderObject() as RenderBox?;
                    if (box == null) {
                      return;
                    }
                    onLongPress(box.localToGlobal(Offset.zero) & box.size);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s3,
                      vertical: AppSpacing.s2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.resolve(
                        context,
                        kColorSurfaceVariantF7F1EC,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(AppRadius.lg),
                        bottomLeft: Radius.circular(AppRadius.lg),
                        bottomRight: Radius.circular(AppRadius.lg),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 16 / 13,
                              color: kColorTextPrimary2E2A27,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          comment.body,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.text14.copyWith(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s1),
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.s3),
                child: Row(
                  children: [
                    Text(
                      age,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          color: kColorTextTertiary9C928A,
                        ),
                      ),
                    ),
                    if (onReply != null) ...[
                      const SizedBox(width: AppSpacing.cardInset),
                      GestureDetector(
                        onTap: onReply,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          context.l10n.memCommentReply,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
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
      ],
    );
  }
}
