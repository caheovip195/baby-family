part of '../mobile/home_tab_mobile_view.dart';

/// Chương hiện tại (Pencil `OC0hK`): ô “Ảnh tháng 6” 72×90 (`secondary-100`,
/// viền 2 `secondary-500`, bo 14) + “CHƯƠNG HIỆN TẠI” 10/800, “Tháng thứ 6 của
/// Haru” 17/800, số liệu 12.
class _HomeChapterCard extends StatelessWidget {
  const _HomeChapterCard({
    required this.controller,
    required this.child,
    required this.chapter,
  });

  final HomeTabController controller;
  final Child child;
  final ChapterSummary chapter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final strong = AppColors.resolve(context, kColorSecondary7003F7A5C);
    final photo = controller.monthlyPhotos
        .where((item) => item.monthIndex == chapter.monthIndex)
        .firstOrNull
        ?.asset;
    return AppCard(
      onTap: () => _openTab(context, MainTab.memories),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.router.push(
              MonthlyCameraRoute(childId: child.id, month: chapter.monthIndex),
            ),
            child: photo != null
                ? _Photo(
                    asset: photo,
                    height: 90,
                    width: 72,
                    radius: AppRadius.md,
                  )
                : Container(
                    width: 72,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.resolve(
                        context,
                        kColorSecondary100E4F2EA,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.resolve(
                          context,
                          kColorSecondary5006FAE8E,
                        ),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.camera, size: 20, color: strong),
                        const SizedBox(height: AppSpacing.s1),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.homeMonthlySlot(chapter.monthIndex),
                            maxLines: 1,
                            style: AppTypography.micro.copyWith(
                              fontWeight: FontWeight.w700,
                              color: strong,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.cardInset),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeCurrentChapter,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.micro.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  l10n.homeChapterTitle(chapter.monthIndex, child.name),
                  style: AppTypography.adapt(context, AppTypography.title17),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  l10n.homeChapterStats(
                    chapter.memoryCount,
                    chapter.firstsCount,
                    chapter.voiceCount,
                  ),
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
