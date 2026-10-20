part of '../mobile/care_tab_mobile_view.dart';

/// “Cây hôm nay” (Pencil `opwSc`): nền `secondary-100` bo 16, đệm 14, cách
/// 14; ảnh cây 72; tiêu đề 17/800, “4/8 việc của nhà mình” 13/600
/// `secondary-700`, lá 16 cách 3 (xong `secondary-500`, chưa `border`), gợi ý
/// 11. Chỉ đếm số việc — không hiện Hearts (mục 7.13.7). Chạm → CARE-09.
class _CareTreeCard extends StatelessWidget {
  const _CareTreeCard({
    required this.done,
    required this.total,
    required this.onTap,
  });

  final int done;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloomed = total > 0 && done >= total;
    return Material(
      color: AppColors.resolve(context, kColorSecondary100E4F2EA),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              Image(
                image: mediaImageProvider(Assets.images.utV0f.path),
                width: 72,
                height: 72,
                excludeFromSemantics: true,
              ),
              const SizedBox(width: AppSpacing.cardInset),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.careTodayTree,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title17,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    Text(
                      l10n.careProgress(done, total),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 16 / 13,
                          color: kColorSecondary7003F7A5C,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    Wrap(
                      spacing: 3,
                      runSpacing: 3,
                      children: [
                        for (var index = 0; index < total; index++)
                          Icon(
                            LucideIcons.leaf,
                            size: 16,
                            color: AppColors.resolve(
                              context,
                              index < done
                                  ? kColorSecondary5006FAE8E
                                  : kColorBorderEADFD6,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    Text(
                      bloomed ? l10n.careTreeBloomed : l10n.careTreeBloom,
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
      ),
    );
  }
}
