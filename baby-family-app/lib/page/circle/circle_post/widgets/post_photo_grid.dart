part of '../mobile/circle_post_mobile_view.dart';

/// Ảnh đã chọn (Pencil “Grid”): ô 83×96 bo 14 có nút bỏ 26 (`#2E2A2799`,
/// `x` 14 trắng) góc trên phải; ô “Thêm” 76×96 nền `primary-50` viền
/// `primary-300` (`image-plus` 26 + 14/600).
class _PostPhotoGrid extends StatelessWidget {
  const _PostPhotoGrid({required this.controller});

  static const _height = 96.0;

  final CirclePostController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final radius = BorderRadius.circular(AppRadius.md);
    final accent = AppColors.resolve(context, kColorPrimary700A2402F);
    final tiles = <Widget>[
      for (final asset in controller.assets)
        Expanded(
          flex: 83,
          child: SizedBox(
            height: _height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: radius,
                  child: Image(
                    image: mediaImageProvider(asset),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: AppSpacing.compact,
                  right: AppSpacing.compact,
                  child: Semantics(
                    button: true,
                    label: l10n.cirPostRemovePhoto,
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: () => controller.removePhoto(asset),
                      child: Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.resolve(
                            context,
                            kColorSheetScrim2E2A27Alpha60,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 14,
                          color: kColorWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      Expanded(
        flex: 76,
        child: Material(
          color: AppColors.resolve(context, kColorPrimary50FFF4F1),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: AppColors.resolve(context, kColorPrimary300F7A796),
            ),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            onTap: controller.canAddPhoto ? controller.addPhoto : null,
            child: SizedBox(
              height: _height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.imagePlus, size: 26, color: accent),
                  const SizedBox(height: AppSpacing.s1),
                  Text(
                    l10n.commonAdd,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.text14.copyWith(
                        fontWeight: FontWeight.w600,
                        color: accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
    return Row(
      children: [
        for (final (index, tile) in tiles.indexed) ...[
          if (index > 0) const SizedBox(width: AppSpacing.s2),
          tile,
        ],
      ],
    );
  }
}
