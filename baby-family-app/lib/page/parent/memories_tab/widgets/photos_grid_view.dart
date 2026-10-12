part of '../mobile/memories_tab_mobile_view.dart';

/// MEM-02 “Ảnh” (không có trong Pencil — tài liệu 9.4): lưới 3 cột dày
/// (cách 2) nhóm theo tháng, tiêu đề tháng 16/700. Chạm ảnh → MEM-07.
class _PhotosGridView extends StatelessWidget {
  const _PhotosGridView({required this.controller});

  final MemoriesTabController controller;

  @override
  Widget build(BuildContext context) {
    final groups = controller.photoGroups;
    if (groups.isEmpty) {
      return EmptyState(
        title: context.l10n.stateEmptyMemories,
        description: context.l10n.stateEmptyMemoryDescription,
      );
    }
    final format = DateFormat.yMMMM(context.localeName);
    final padding = _listPadding(context);
    return CustomScrollView(
      slivers: [
        for (final group in groups) ...[
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              AppSpacing.s4,
              padding.right,
              AppSpacing.s2,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                toBeginningOfSentenceCase(format.format(group.month)),
                style: AppTypography.adapt(context, AppTypography.title16),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: padding.left),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: [
                for (final photo in group.photos)
                  MemoryGridTile(
                    asset: photo.asset,
                    label: photo.memory.title ?? photo.memory.body,
                    onTap: () => context.router.push(
                      MemoryDetailRoute(memoryId: photo.memory.id),
                    ),
                  ),
              ],
            ),
          ),
        ],
        SliverToBoxAdapter(child: SizedBox(height: padding.bottom)),
      ],
    );
  }
}
