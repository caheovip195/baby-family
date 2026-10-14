part of '../mobile/pending_review_mobile_view.dart';

/// Bài chờ lâu, thu gọn (Pencil “Pending 3”): thẻ bo 16 đệm 12 cách 12 —
/// ảnh 56, lời nhắn 14/600, “Bà ngoại · 29/09 · Hana” 12, nhãn “Đã chờ 8
/// ngày”, `chevron-right`. Chạm để mở.
class _PendingCollapsedRow extends StatelessWidget {
  const _PendingCollapsedRow({
    required this.post,
    required this.controller,
    required this.onTap,
  });

  final Memory post;
  final PendingReviewController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final names = [
      for (final child in controller.children)
        if (post.childIds.contains(child.id)) child.name,
    ];
    final meta = [
      controller.authorOf(post)?.callName ?? '',
      (post.createdAt ?? post.occurredAt).toDayMonth(l10n.localeName),
      if (names.isNotEmpty) names.join(', '),
    ].reduce(l10n.commonDotJoin);
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Row(
            children: [
              MemoryThumb(
                kind: post.kind,
                asset: post.mediaAssets.firstOrNull,
                size: 56,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memoryTitle(post),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      meta,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    AppTagPill(
                      label: l10n.memPendingWaited(controller.waitedDays(post)),
                      icon: LucideIcons.hourglass,
                      dense: true,
                      color: kColorAccent100FDF1D6,
                      foreground: kColorAccent7009A6A12,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.resolve(context, kColorTextTertiary9C928A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
