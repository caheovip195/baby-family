part of '../mobile/day_story_mobile_view.dart';

/// Ảnh bìa (`I2dW4g`): cao 210 bo 20; nút “Đổi ảnh bìa” góc dưới trái (cao
/// 32, đệm 12, nền `#FFFFFFE6`, `image` 14 + 12/700).
class _DayCover extends StatelessWidget {
  const _DayCover({required this.asset, required this.onChange});

  final String? asset;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: SizedBox(
        height: 210,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (asset == null)
              ColoredBox(
                color: AppColors.resolve(context, kColorPrimary50FFF4F1),
              )
            else
              Image(image: mediaImageProvider(asset!), fit: BoxFit.cover),
            Positioned(
              left: AppSpacing.s3,
              bottom: AppSpacing.s3,
              child: Material(
                color: kColorWhiteAlpha90,
                shape: const StadiumBorder(),
                child: InkWell(
                  onTap: onChange,
                  customBorder: const StadiumBorder(),
                  child: Container(
                    height: AppSpacing.s8,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.image,
                          size: 14,
                          color: kColorTextPrimary2E2A27,
                        ),
                        const SizedBox(width: AppSpacing.compact),
                        Text(
                          context.l10n.homeChangeCover,
                          style: AppTypography.small.copyWith(
                            fontWeight: FontWeight.w700,
                            color: kColorTextPrimary2E2A27,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
