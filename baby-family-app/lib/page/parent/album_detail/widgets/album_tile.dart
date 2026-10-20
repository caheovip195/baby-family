part of '../mobile/album_detail_mobile_view.dart';

/// Ô lưới album (`p9OZbB`): ảnh phủ kín, bo 4 (ô đầu bo trái trên 12); video
/// có nhãn “▶ 0:24” (`#2E2A2799`, 10/600 trắng) góc phải dưới, đệm 6.
class _AlbumTile extends StatelessWidget {
  const _AlbumTile({
    required this.item,
    required this.first,
    this.selected = false,
    this.onTap,
  });

  final AlbumItem item;
  final bool first;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const small = Radius.circular(4);
    final radius = BorderRadius.only(
      topLeft: first ? const Radius.circular(AppRadius.tile) : small,
      topRight: small,
      bottomLeft: small,
      bottomRight: small,
    );
    final duration = item.durationSec;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        foregroundDecoration: selected
            ? BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                  color: AppColors.resolve(context, kColorPrimary600C2513F),
                  width: 3,
                ),
              )
            : null,
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image(image: mediaImageProvider(item.asset), fit: BoxFit.cover),
              if (item.isVideo)
                Positioned(
                  right: AppSpacing.compact,
                  bottom: AppSpacing.compact,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.compact,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: kColorSheetScrim2E2A27Alpha60,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.play,
                          size: 10,
                          color: kColorWhite,
                        ),
                        if (duration != null) ...[
                          const SizedBox(width: 3),
                          Text(
                            memoryDuration(duration),
                            style: AppTypography.micro.copyWith(
                              fontWeight: FontWeight.w600,
                              color: kColorWhite,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
