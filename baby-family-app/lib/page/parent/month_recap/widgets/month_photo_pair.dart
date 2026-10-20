part of '../mobile/month_recap_mobile_view.dart';

/// Ảnh tháng (`a0lyf`): tháng trước rộng 120 (ảnh cao 150 bo 16, nhãn 12/500
/// `text-secondary`) cạnh tháng này (ảnh cao 200 bo 20 viền trắng, nhãn
/// `camera` 13 + 12/700 `primary-700`), canh đáy, cách 10. Chưa có ảnh tháng
/// này → ô chụp ảnh tháng (`camera`).
class _MonthPhotoPair extends StatelessWidget {
  const _MonthPhotoPair({
    required this.previousAsset,
    required this.currentAsset,
    required this.previousLabel,
    required this.currentLabel,
    this.onOpen,
    this.onCapture,
  });

  final String? previousAsset;
  final String? currentAsset;
  final String previousLabel;
  final String currentLabel;
  final VoidCallback? onOpen;
  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    final strong = AppColors.resolve(context, kColorPrimary600C2513F);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (previousAsset != null) ...[
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onOpen,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: Image(
                      image: mediaImageProvider(previousAsset!),
                      height: 150,
                      width: 120,
                      fit: BoxFit.cover,
                      semanticLabel: previousLabel,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.compact),
                Text(
                  previousLabel,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: currentAsset == null ? onCapture : onOpen,
                child: Container(
                  height: 200,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                    ),
                  ),
                  child: currentAsset == null
                      ? Center(
                          child: Icon(
                            LucideIcons.camera,
                            size: 28,
                            color: strong,
                          ),
                        )
                      : Image(
                          image: mediaImageProvider(currentAsset!),
                          fit: BoxFit.cover,
                          semanticLabel: currentLabel,
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.compact),
              Row(
                children: [
                  Icon(LucideIcons.camera, size: 13, color: strong),
                  const SizedBox(width: AppSpacing.s1),
                  Flexible(
                    child: Text(
                      currentLabel,
                      style: AppTypography.small.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.resolve(
                          context,
                          kColorPrimary700A2402F,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
