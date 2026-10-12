part of '../mobile/pregnancy_journey_mobile_view.dart';

/// PREG-01 Dòng thời gian (Pencil `zb5B0`): đệm 16/20/24/20, cách 14 — nhóm
/// theo tuần, mới nhất trước.
class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.controller});

  final PregnancyJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final pregnancyId = controller.child!.id;
    final children = <Widget>[];
    for (final week in controller.timeline) {
      children.add(_WeekHeader(week: week));
      if (week.bumpSlot) {
        children.add(
          _TimelineBumpSlot(
            week: week.week,
            ghostWeek: week.ghostWeek,
            onTap: () => _openComposer(context, pregnancyId, MemoryKind.bump),
          ),
        );
      }
      for (final memory in week.items) {
        void open() =>
            context.router.push(MemoryDetailRoute(memoryId: memory.id));
        children.add(switch (memory.kind) {
          MemoryKind.ultrasound => _UltrasoundCard(
            memory: memory,
            author: controller.callNameOf(memory.authorId),
            onTap: open,
          ),
          MemoryKind.milestone => _MilestoneCard(memory: memory, onTap: open),
          _ => _TimelineMemoryCard(
            memory: memory,
            author: controller.callNameOf(memory.authorId),
            onTap: open,
          ),
        });
      }
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s4,
        AppSpacing.screen,
        AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
      ),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.cardInset),
      itemBuilder: (_, index) => children[index],
    );
  }
}
