part of '../mobile/pending_review_mobile_view.dart';

/// Người đăng (Pencil “Author”): avatar chữ 36 theo quan hệ, tên 14/700,
/// “Hôm qua, 16:20 · 3 ảnh” 12 `text-secondary`; [trailing] (ảnh nhỏ 52 khi
/// đang từ chối).
class _PendingAuthorRow extends StatelessWidget {
  const _PendingAuthorRow({
    required this.post,
    required this.controller,
    this.trailing,
  });

  final Memory post;
  final PendingReviewController controller;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final author = controller.authorOf(post);
    final name = author?.callName ?? '';
    final meta = [
      memoryDayTime(l10n, post.createdAt ?? post.occurredAt, controller.today),
      if (post.mediaAssets.isNotEmpty)
        l10n.homePhotoCount(post.mediaAssets.length),
    ].reduce(l10n.commonDotJoin);
    return Row(
      children: [
        AppRelativeAvatar(name: name, relation: author?.relation, size: 36),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                meta,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    color: kColorTextSecondary6B625B,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.itemGap),
          trailing!,
        ],
      ],
    );
  }
}
