part of '../mobile/memories_tab_mobile_view.dart';

/// Tab “Dòng thời gian” (`LcleA`): đệm 16/20/24/20, cách 16 — header bé,
/// chip lọc, chương tháng xen ký ức. Trống → STATE-02 (`fXNoV`).
class _TimelineView extends StatelessWidget {
  const _TimelineView({required this.controller});

  final MemoriesTabController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (controller.memories.isEmpty) {
      final child = controller.subject;
      return EmptyState(
        title: child == null
            ? l10n.stateEmptyMemories
            : l10n.stateEmptyMemoryTitle(child.name),
        description: l10n.stateEmptyMemoryDescription,
        actionLabel: l10n.stateAddMemory,
        onAction: () => context.router.push(
          MemoryComposerRoute(
            kind: MemoryKind.photo.name,
            childId: controller.subjectId,
          ),
        ),
      );
    }
    final items = controller.timeline;
    final filters = {
      MemoryFilter.all: l10n.memoriesAll,
      MemoryFilter.milestones: l10n.memoriesMilestones,
      MemoryFilter.photos: l10n.memoriesPhotos,
      MemoryFilter.voices: l10n.memFilterVoice,
    };
    return ListView.separated(
      padding: _listPadding(context),
      itemCount: items.length + 2,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s4),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ChildHeader(controller: controller);
        }
        if (index == 1) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final entry in filters.entries) ...[
                  if (entry.key != MemoryFilter.all)
                    const SizedBox(width: AppSpacing.s2),
                  AppChip(
                    label: entry.value,
                    selected: controller.filter == entry.key,
                    onTap: () => controller.selectFilter(entry.key),
                  ),
                ],
              ],
            ),
          );
        }
        return switch (items[index - 2]) {
          final ChapterSummary chapter => _ChapterCard(
            chapter: chapter,
            controller: controller,
          ),
          final Memory memory => _TimelineMemory(
            memory: memory,
            controller: controller,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
