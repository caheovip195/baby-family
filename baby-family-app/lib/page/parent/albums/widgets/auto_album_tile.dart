part of '../mobile/albums_mobile_view.dart';

/// Thẻ album tự động (`pekpL`): bìa 100×100 bo 16 (ảnh, hoặc nền màu + icon
/// 34 cho Câu nói / Giọng nói; video có nút play 30 trắng); tên 13/700 (tối
/// đa 2 dòng), meta 11 `text-tertiary`, cách 6.
class _AutoAlbumTile extends StatelessWidget {
  const _AutoAlbumTile({
    required this.album,
    required this.meta,
    required this.onTap,
  });

  final Album album;
  final String meta;
  final VoidCallback onTap;

  static const _size = 100.0;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, icon) = switch (album.autoCode) {
      'quotes' => (
        kColorPrimary100FFE3DC,
        kColorPrimary600C2513F,
        LucideIcons.quote,
      ),
      _ => (
        kColorSecondary100E4F2EA,
        kColorSecondary7003F7A5C,
        LucideIcons.audioLines,
      ),
    };
    final asset = album.coverAsset;
    final Widget cover = asset != null
        ? Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(asset, fit: BoxFit.cover),
              if (album.autoCode == 'videos')
                const Center(
                  child: Icon(LucideIcons.play, size: 30, color: kColorWhite),
                ),
            ],
          )
        : DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.resolve(context, background),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 34,
                color: AppColors.resolve(context, foreground),
              ),
            ),
          );
    return Semantics(
      button: true,
      label: album.title,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: _size,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: SizedBox.square(dimension: _size, child: cover),
              ),
              const SizedBox(height: AppSpacing.compact),
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
      ),
    );
  }
}
