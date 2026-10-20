part of '../mobile/albums_mobile_view.dart';

/// Thẻ album của nhà mình (`aZN6m`): nền `surface`, viền, bo 16; bìa cao 96;
/// thân đệm 8/10/10/10 — tên 13/700 (2 dòng), meta 11 `text-tertiary`.
class _FamilyAlbumCard extends StatelessWidget {
  const _FamilyAlbumCard({
    required this.album,
    required this.meta,
    required this.onTap,
  });

  final Album album;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final asset = album.coverAsset;
    return Semantics(
      button: true,
      label: album.title,
      excludeSemantics: true,
      child: Material(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 96,
                child: asset != null
                    ? Image(image: mediaImageProvider(asset), fit: BoxFit.cover)
                    : ColoredBox(
                        color: AppColors.resolve(
                          context,
                          kColorSurfaceVariantF7F1EC,
                        ),
                        child: Icon(
                          LucideIcons.image,
                          color: AppColors.resolve(
                            context,
                            kColorTextTertiary9C928A,
                          ),
                        ),
                      ),
              ),
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
                      album.title,
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
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.adapt(context, AppTypography.tiny),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
