part of '../mobile/birth_mobile_view.dart';

/// “Ảnh đầu tiên của bé” (Pencil `Fg3cK`): vòng 84 `primary-50` viền 2
/// `primary-300`, camera 26 `primary-600`; chữ 15/700 + phụ 12; cách 14.
class _FirstPhotoPicker extends StatelessWidget {
  const _FirstPhotoPicker({required this.onTap, this.photoAsset});

  final String? photoAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary50FFF4F1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.resolve(context, kColorPrimary300F7A796),
                width: 2,
              ),
            ),
            child: photoAsset == null
                ? Icon(
                    LucideIcons.camera,
                    size: 26,
                    color: AppColors.resolve(context, kColorPrimary600C2513F),
                  )
                : Image(
                    image: mediaImageProvider(photoAsset!),
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: AppSpacing.cardInset),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pregnancyFirstPhoto,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyStrong.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 19 / 15,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.pregnancyFirstPhotoHint,
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
