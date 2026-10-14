part of '../mobile/circle_memory_detail_mobile_view.dart';

/// Một lời chúc (Pencil “Comment Ông ngoại”): avatar 40, bong bóng bo
/// [4,18,18,18] đệm [10,14] — tên 16/700, nội dung 17; lời của mình nền
/// `primary-50`, tên “Bà (bạn)” và “Sửa” / “Xoá” 15/600 bên dưới.
class _WishTile extends StatelessWidget {
  const _WishTile({
    required this.wish,
    required this.author,
    required this.mine,
    required this.ownName,
    required this.onEdit,
    required this.onDelete,
  });

  final MemoryComment wish;
  final Member? author;
  final bool mine;
  final String ownName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = author?.callName ?? wish.authorName;
    final role = author?.role ?? wish.authorRole;
    final link = AppTypography.adapt(
      context,
      AppTypography.bodyStrong.copyWith(color: kColorPrimary700A2402F),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (role == FamilyRole.relative || role == null)
          AppRelativeAvatar(name: name, relation: author?.relation, size: 40)
        else
          AppInitialAvatar(
            name: name,
            color: parentAvatarColor(role),
            size: 40,
          ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.cardInset,
                  vertical: AppSpacing.itemGap,
                ),
                decoration: BoxDecoration(
                  color: AppColors.resolve(
                    context,
                    mine ? kColorPrimary50FFF4F1 : kColorSurfaceVariantF7F1EC,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.s1),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mine ? ownName : name,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title16.copyWith(
                          fontFamily: AppTypography.bodyFamily,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      wish.body,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyLarge.copyWith(height: 25 / 17),
                      ),
                    ),
                  ],
                ),
              ),
              if (mine)
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.compact,
                    left: AppSpacing.s1,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: onEdit,
                        child: Text(l10n.memCommentEdit, style: link),
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      InkWell(
                        onTap: onDelete,
                        child: Text(
                          l10n.memCommentDelete,
                          style: link.copyWith(
                            color: AppColors.resolve(
                              context,
                              kColorTextSecondary6B625B,
                            ),
                          ),
                        ),
                      ),
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
