part of '../mobile/memory_detail_mobile_view.dart';

/// Bình luận (`qLhzT`): avatar chữ 32 (người thân `accent-100`, Papa/Mama
/// `child-peach`), bong bóng `surface-variant` bo 4/16/16/16 đệm 8/12; tên
/// 13/700, nội dung 14 (1.4).
class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment, required this.controller});

  final MemoryComment comment;
  final MemoryDetailController controller;

  static final _initialStyle = AppTypography.title16.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );

  @override
  Widget build(BuildContext context) {
    final member = controller.memberByUser(comment.authorId);
    final name = member == null ? comment.authorName : memberFullName(member);
    final parent = (member?.role ?? comment.authorRole)?.isParent ?? false;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: parent
                ? kColorChildPeachFFB59E
                : AppColors.resolve(context, kColorAccent100FDF1D6),
            shape: BoxShape.circle,
            border: parent
                ? Border.all(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                  )
                : null,
          ),
          child: Text(
            name.characters.firstOrNull ?? '',
            style: parent
                ? _initialStyle
                : AppTypography.adapt(context, _initialStyle),
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s2,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
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
      ],
    );
  }
}
