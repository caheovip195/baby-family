part of '../mobile/memories_tab_mobile_view.dart';

/// Thẻ bộ sưu tập (`YZcDE`…): nền `surface`, viền, bo 18; bìa cao 96 (ảnh,
/// hoặc nền màu + icon 30 / câu trích 15/800); thân đệm 8/10/10/10: tên
/// 13/700, phụ 11 `text-secondary`.
class _CollectionCard extends StatelessWidget {
  const _CollectionCard({
    required this.item,
    required this.subtitle,
    required this.onTap,
    this.quote,
  });

  final CollectionSummary item;
  final String subtitle;
  final String? quote;
  final VoidCallback onTap;

  static const _covers = <String, (Color, IconData?)>{
    'quotes': (kColorPrimary100FFE3DC, null),
    'voices': (kColorSecondary100E4F2EA, LucideIcons.audioLines),
    'letters': (kColorAccent100FDF1D6, LucideIcons.mail),
    'together': (kColorUs100EAE2F8, LucideIcons.heartHandshake),
    'keepsakes': (kColorSurfaceVariantF7F1EC, LucideIcons.gem),
  };

  @override
  Widget build(BuildContext context) {
    final style = _covers[item.code];
    final asset = item.coverAsset;
    final Widget cover;
    if (style == null && asset != null) {
      cover = Image.asset(asset, fit: BoxFit.cover);
    } else {
      final icon = style?.$2;
      cover = ColoredBox(
        color: AppColors.resolve(
          context,
          style?.$1 ?? kColorSurfaceVariantF7F1EC,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Center(
            child: icon != null || quote == null
                ? Icon(
                    icon ?? LucideIcons.images,
                    size: 30,
                    color: AppColors.resolve(context, kColorTextPrimary2E2A27),
                  )
                : Text(
                    '“$quote”',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.title16.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 20 / 15,
                      ),
                    ),
                  ),
          ),
        ),
      );
    }
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
            SizedBox(height: 96, child: cover),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.itemGap,
                AppSpacing.s2,
                AppSpacing.itemGap,
                AppSpacing.itemGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 16 / 13,
                        color: kColorTextPrimary2E2A27,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.tiny.copyWith(
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
    );
  }
}
