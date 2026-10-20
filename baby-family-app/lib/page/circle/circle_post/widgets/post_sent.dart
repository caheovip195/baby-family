part of '../mobile/circle_post_mobile_view.dart';

/// CIR-04b — Đã gửi (Pencil `VlK9Y`): vòng 112 `secondary-100` + 76
/// `secondary-500` `check` 40, “Đã gửi!” 32/800, giải thích 18, thẻ “Đang chờ
/// Bố/Mẹ duyệt” (ảnh 64, lời nhắn 16, “3 ảnh · Haru · vừa gửi”); nút “Về
/// trang Cháu yêu” và “Đăng thêm ảnh” (60).
class _PostSent extends StatelessWidget {
  const _PostSent({
    required this.post,
    required this.children,
    required this.onClose,
    required this.onHome,
    required this.onMore,
  });

  final CirclePostDraft post;
  final List<Child> children;
  final VoidCallback onClose;
  final VoidCallback onHome;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = AppColors.resolve(context, kColorAccent7009A6A12);
    final meta = [
      l10n.homePhotoCount(post.mediaAssets.length),
      if (children.isNotEmpty) children.map((child) => child.name).join(', '),
      l10n.cirPostJustSent,
    ].reduce(l10n.commonDotJoin);
    final thumb = post.mediaAssets.firstOrNull;
    return Column(
      children: [
        _PostAppBar(onClose: onClose),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s6,
              0,
              AppSpacing.s6,
              AppSpacing.s4,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.s10),
                Container(
                  width: 112,
                  height: 112,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSecondary100E4F2EA),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 76,
                    height: 76,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(
                        context,
                        kColorSecondary5006FAE8E,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      size: 40,
                      color: kColorWhite,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                Text(
                  l10n.cirPostSentTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.display.copyWith(height: 44 / 32),
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                Text(
                  l10n.cirPostSentBody,
                  textAlign: TextAlign.center,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.h3.copyWith(
                      fontFamily: AppTypography.bodyFamily,
                      fontWeight: FontWeight.w400,
                      height: 27 / 18,
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: AppColors.resolve(context, kColorBorderEADFD6),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ColoredBox(
                        color: AppColors.resolve(
                          context,
                          kColorAccent100FDF1D6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.cardInset,
                            vertical: AppSpacing.itemGap,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.hourglass,
                                size: 18,
                                color: accent,
                              ),
                              const SizedBox(width: AppSpacing.s2),
                              Expanded(
                                child: Text(
                                  l10n.cirPostPending,
                                  style: AppTypography.adapt(
                                    context,
                                    AppTypography.body.copyWith(
                                      height: 19 / 15,
                                      fontWeight: FontWeight.w700,
                                      color: accent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.cardInset),
                        child: Row(
                          children: [
                            if (thumb != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.tile,
                                ),
                                child: Image(
                                  image: mediaImageProvider(thumb),
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
                                  if (post.message.isNotEmpty)
                                    Text(
                                      post.message,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.adapt(
                                        context,
                                        AppTypography.bodyLarge.copyWith(
                                          fontSize: 16,
                                          height: 22 / 16,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: AppSpacing.s1),
                                  Text(
                                    meta,
                                    style: AppTypography.adapt(
                                      context,
                                      AppTypography.text14.copyWith(
                                        color: kColorTextSecondary6B625B,
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
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s6,
            0,
            AppSpacing.s6,
            36 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            children: [
              AppButton(
                label: l10n.cirPostBackHome,
                height: 60,
                fontSize: 18,
                onPressed: onHome,
              ),
              const SizedBox(height: AppSpacing.s3),
              AppButton.secondary(
                label: l10n.cirPostMore,
                height: 60,
                fontSize: 18,
                onPressed: onMore,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
