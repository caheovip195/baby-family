part of '../mobile/day_story_mobile_view.dart';

/// Ảnh kèm (`fM4tc`): cao 96 bo 14; dấu chọn 22 tròn góc trên phải
/// (`primary-500` + `check` 13 / `#FFFFFFCC` viền trắng). [_DayPhotoTile.add]:
/// ô thêm 64×96 viền `border` (`plus` 20 `text-tertiary`).
class _DayPhotoTile extends StatelessWidget {
  const _DayPhotoTile({
    required String this.asset,
    required this.selected,
    required VoidCallback this.onTap,
  });

  const _DayPhotoTile.add() : asset = null, selected = false, onTap = null;

  final String? asset;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (asset == null) {
      return Container(
        width: 64,
        height: 96,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.resolve(context, kColorBorderEADFD6),
          ),
        ),
        child: Icon(
          LucideIcons.plus,
          size: 20,
          color: AppColors.resolve(context, kColorTextTertiary9C928A),
        ),
      );
    }
    return Semantics(
      checked: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: SizedBox(
            height: 96,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image(image: mediaImageProvider(asset!), fit: BoxFit.cover),
                Positioned(
                  top: AppSpacing.s2,
                  right: AppSpacing.s2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.resolve(context, kColorPrimary500EE7B67)
                          : kColorWhiteAlpha80,
                      shape: BoxShape.circle,
                      border: selected
                          ? null
                          : Border.all(color: kColorWhite, width: 1.5),
                    ),
                    child: selected
                        ? const Icon(
                            LucideIcons.check,
                            size: 13,
                            color: kColorWhite,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
