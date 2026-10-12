part of '../mobile/home_tab_mobile_view.dart';

/// “Hôm nay của các con” (Pencil `UTkUX`): tiêu đề 17/800 + “9 khoảnh khắc”,
/// hàng vòng story cách 14 (cuộn ngang khi nhiều bé) + vòng “Ghi lại”.
class _StoryRow extends StatelessWidget {
  const _StoryRow({required this.controller});

  final HomeTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final router = context.router;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader.compact(
          title: l10n.homeToday,
          actionLabel: l10n.homeMomentCount(controller.stories.length),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final child in controller.children) ...[
                StoryRing(
                  child: child,
                  label: child.name,
                  subtitle: child.isPregnancy
                      ? (child.dueDate == null
                            ? null
                            : l10n.commonPregnancyWeekOnly(
                                pregnancyWeek(
                                  child.dueDate!,
                                  controller.today,
                                ).week,
                              ))
                      : l10n.homePhotoCount(
                          controller.storiesOf(child.id).length,
                        ),
                  badgeCount: controller.unseenStories(child.id),
                  onTap: () => child.isPregnancy
                      ? router.push(
                          PregnancyJourneyRoute(pregnancyId: child.id),
                        )
                      : router.push(MemoryStoryRoute(childId: child.id)),
                ),
                const SizedBox(width: AppSpacing.cardInset),
              ],
              StoryRing.add(
                label: l10n.homeRecord,
                onTap: () => router.push(
                  MemoryComposerRoute(kind: MemoryKind.photo.name),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
