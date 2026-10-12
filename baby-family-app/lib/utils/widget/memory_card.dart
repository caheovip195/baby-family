import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Thẻ ký ức có ảnh (Pencil HOME-01/MEM-01 “Memory Card · Cả hai cùng kể”
/// `gObIx`): nền `surface`, viền `border`, bo 20; ảnh cao 220; thân đệm 14,
/// cách 8: chú thích 15/600, khối “Cả hai cùng kể” (nền `us-50` bo 12, đệm
/// 8/10, 2 avatar chữ 24 chồng nhau, nhãn 11/800 `us-700`, trích 12
/// `text-secondary`), dòng meta 12 + cảm xúc (emoji 14 + số 12).
class MemoryCard extends StatelessWidget {
  const MemoryCard({
    required this.caption,
    required this.meta,
    this.photoAsset,
    this.photoHeight = 220,
    this.bothTellPreview,
    this.bothTellInitials = const ('M', 'P'),
    this.reactionEmojis,
    this.reactionCount = 0,
    this.onTap,
    super.key,
  });

  final String caption;

  /// “Hana & Haru · Mama đăng · 2 giờ trước”.
  final String meta;
  final String? photoAsset;
  final double photoHeight;

  /// Trích góc nhìn thứ hai (“Papa kể: “…””) — null → ẩn khối Cả hai cùng kể.
  final String? bothTellPreview;

  /// Chữ cái của người đăng và người kể thêm (Mama coral, Papa xanh lá).
  final (String, String) bothTellInitials;
  final String? reactionEmojis;
  final int reactionCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: BorderSide(color: AppColors.resolve(context, kColorBorderEADFD6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photoAsset != null)
              Image.asset(
                photoAsset!,
                height: photoHeight,
                fit: BoxFit.cover,
                semanticLabel: caption,
                errorBuilder: (_, _, _) => SizedBox(height: photoHeight),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    caption,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.bodyStrong.copyWith(height: 19 / 15),
                    ),
                  ),
                  if (bothTellPreview != null) ...[
                    const SizedBox(height: AppSpacing.s2),
                    _BothTell(
                      preview: bothTellPreview!,
                      initials: bothTellInitials,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.s2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          meta,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small,
                          ),
                        ),
                      ),
                      if (reactionEmojis != null) ...[
                        const SizedBox(width: AppSpacing.s2),
                        Text(
                          reactionEmojis!,
                          style: AppTypography.adapt(
                            context,
                            AppTypography.text14,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s1),
                        Text(
                          '$reactionCount',
                          style: AppTypography.adapt(
                            context,
                            AppTypography.small,
                          ),
                        ),
                      ],
                    ],
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

class _BothTell extends StatelessWidget {
  const _BothTell({required this.preview, required this.initials});

  final String preview;
  final (String, String) initials;

  @override
  Widget build(BuildContext context) {
    final background = AppColors.resolve(context, kColorUs50F6F2FC);
    Widget dot(String text, Color color) => Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: background, width: 2),
      ),
      child: Text(
        text,
        style: AppTypography.micro.copyWith(
          fontWeight: FontWeight.w800,
          color: kColorWhite,
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.itemGap,
        vertical: AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 24,
            child: Stack(
              children: [
                dot(initials.$1, kColorPrimary500EE7B67),
                Positioned(
                  left: 16,
                  child: dot(initials.$2, kColorSecondary5006FAE8E),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.memoriesTogether,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.tiny.copyWith(
                      fontWeight: FontWeight.w800,
                      color: kColorUs7006A549F,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.adapt(context, AppTypography.small),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
