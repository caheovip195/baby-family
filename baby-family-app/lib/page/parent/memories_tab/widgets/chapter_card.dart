part of '../mobile/memories_tab_mobile_view.dart';

/// Chương tháng (`czRPJ`, `QVHFf`): nền `secondary-100` bo 16, đệm 14,
/// cách 14; bìa 76×96 bo 14 (ảnh tháng, hoặc ô chụp ảnh tháng với camera +
/// “Ngày mai”); khoảng ngày 11/700, tiêu đề 18/800, số liệu 12,
/// “Xem lại tháng này” 12/700 `secondary-700` → REC-03 (thẻ → MEM-20).
class _ChapterCard extends StatelessWidget {
  const _ChapterCard({required this.chapter, required this.controller});

  final ChapterSummary chapter;
  final MemoriesTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = controller.childById(chapter.childId);
    final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
    final locale = context.localeName;
    final range = l10n.memChapterRange(
      chapter.start.toDayMonth(locale),
      chapter.end.subtract(const Duration(days: 1)).toDayMonth(locale),
    );
    final stats = chapter.hasMonthlyPhoto
        ? l10n.memChapterStatsMonthly(chapter.memoryCount, chapter.firstsCount)
        : l10n.memChapterStats(
            chapter.memoryCount,
            chapter.firstsCount,
            chapter.voiceCount,
          );
    void openMonthly() {
      if (child != null) {
        context.router.push(MonthlyPhotosRoute(childId: child.id));
      }
    }

    return Material(
      color: AppColors.resolve(context, kColorSecondary100E4F2EA),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: openMonthly,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardInset),
          child: Row(
            children: [
              _cover(context, child, strong),
              const SizedBox(width: AppSpacing.cardInset),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.current ? l10n.memChapterCurrent(range) : range,
                      style: AppTypography.tiny.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: strong,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      l10n.memChapterTitle(
                        chapter.monthIndex,
                        child?.name ?? '',
                      ),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.title17.copyWith(
                          fontSize: 18,
                          height: 25 / 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      stats,
                      style: AppTypography.adapt(context, AppTypography.small),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    InkWell(
                      onTap: child == null
                          ? null
                          : () => context.router.push(
                              MonthRecapRoute(childId: child.id),
                            ),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.circlePlay, size: 14, color: strong),
                          const SizedBox(width: AppSpacing.s1),
                          Flexible(
                            child: Text(
                              l10n.memChapterReplay,
                              style: AppTypography.small.copyWith(
                                fontWeight: FontWeight.w700,
                                color: strong,
                              ),
                            ),
                          ),
                        ],
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

  Widget _cover(BuildContext context, Child? child, Color strong) {
    final asset = chapter.coverAsset;
    final birth = child?.birthDate;
    if (chapter.current && !chapter.hasMonthlyPhoto && birth != null) {
      final days = daysUntil(
        childMonthDate(birth, chapter.monthIndex),
        controller.today,
      );
      return GestureDetector(
        onTap: () => context.router.push(
          MonthlyCameraRoute(childId: child!.id, month: chapter.monthIndex),
        ),
        child: Container(
          width: 76,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.resolve(context, kColorSecondary5006FAE8E),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.camera, size: 20, color: strong),
              const SizedBox(height: AppSpacing.s1),
              Text(
                context.l10n.memDueIn(days.clamp(0, 999)),
                textAlign: TextAlign.center,
                style: AppTypography.micro.copyWith(
                  fontWeight: FontWeight.w700,
                  color: strong,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      width: 76,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.resolve(context, kColorSurfaceFFFFFF),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: asset == null
          ? Icon(LucideIcons.image, size: 20, color: strong)
          : Image.asset(asset, fit: BoxFit.cover),
    );
  }
}
