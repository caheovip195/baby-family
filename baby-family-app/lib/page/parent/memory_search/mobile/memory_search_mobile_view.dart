import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/page/parent/memory_search/memory_search_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/search_bar_row.dart';
part '../widgets/search_diary_row.dart';
part '../widgets/search_filter_chip.dart';
part '../widgets/search_media_grid.dart';
part '../widgets/search_shortcut_row.dart';

/// Tiêu đề mục kết quả 17/800 (Pencil “Ảnh & video · 9”).
const _sectionStyle = AppTypography.title17;

/// MEM-15 Tìm kiếm (Pencil `fwR2y`).
class MemorySearchMobileView extends HookConsumerWidget {
  const MemorySearchMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memorySearchControllerProvider);
    final l10n = context.l10n;
    if (!controller.loaded) {
      return const BaseScaffold(body: Center(child: CircleLoadingProgress()));
    }
    final child = controller.child;
    final author = controller.memberByUser(controller.authorId);
    final items = <Widget>[
      if (controller.recents.isNotEmpty)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                l10n.memSearchRecent,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kColorTextTertiary9C928A,
                  ),
                ),
              ),
              for (final recent in controller.recents) ...[
                const SizedBox(width: AppSpacing.s2),
                _SearchFilterChip(
                  label: recent,
                  icon: LucideIcons.history,
                  recent: true,
                  onTap: () => controller.search(recent),
                ),
              ],
            ],
          ),
        ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _SearchFilterChip(
              label: switch (controller.kind) {
                MemoryKind.photo => l10n.memoriesPhotos,
                MemoryKind.diary => l10n.commonDiary,
                _ => l10n.memSearchKind,
              },
              selected: controller.kind != null,
              onTap: () => _chooseKind(context, controller),
            ),
            const SizedBox(width: AppSpacing.compact),
            _SearchFilterChip(
              label: child?.name ?? l10n.commonAllFamily,
              avatar: ChildAvatar(child: child, size: 26, borderWidth: 0),
              selected: child != null,
              onTap: () => _chooseChild(context, controller),
            ),
            const SizedBox(width: AppSpacing.compact),
            _SearchFilterChip(
              label: author?.callName ?? l10n.memSearchAuthor,
              selected: author != null,
              onTap: () => _chooseAuthor(context, controller),
            ),
            const SizedBox(width: AppSpacing.compact),
            _SearchFilterChip(
              label: controller.year?.toString() ?? l10n.memSearchKindAll,
              selected: controller.year != null,
              onTap: () => _chooseYear(context, controller),
            ),
          ],
        ),
      ),
      ..._results(context, controller),
    ];
    return BaseScaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SearchBarRow(controller: controller),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  2,
                  AppSpacing.screen,
                  AppSpacing.s5 + MediaQuery.paddingOf(context).bottom,
                ),
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    if (index > 0) const SizedBox(height: AppSpacing.cardInset),
                    items[index],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _results(
    BuildContext context,
    MemorySearchController controller,
  ) {
    final l10n = context.l10n;
    final result = controller.result;
    if (result == null || !controller.hasQuery) {
      // Chưa gõ gì: lối tắt tới Ngày này năm xưa (MEM-16) và Album (MEM-03).
      return [
        AppGroupedList(
          children: [
            _SearchShortcutRow(
              icon: LucideIcons.calendarHeart,
              label: l10n.memOnThisDayTitle,
              onTap: () => context.router.push(const OnThisDayRoute()),
            ),
            _SearchShortcutRow(
              icon: LucideIcons.folderHeart,
              label: l10n.memoriesAlbum,
              onTap: () => context.router.push(const AlbumsRoute()),
            ),
            if (controller.pendingCount > 0)
              _SearchShortcutRow(
                icon: LucideIcons.imagePlus,
                label: l10n.memShortcutPending,
                onTap: () => context.router.push(const PendingReviewRoute()),
              ),
            _SearchShortcutRow(
              icon: LucideIcons.filePen,
              label: l10n.memShortcutDrafts,
              onTap: () => context.router.push(const DraftsRoute()),
            ),
            _SearchShortcutRow(
              icon: LucideIcons.trash2,
              label: l10n.memShortcutTrash,
              onTap: () => context.router.push(const TrashRoute()),
            ),
          ],
        ),
      ];
    }
    final media = controller.media;
    final diaries = controller.diaries;
    final sectionStyle = AppTypography.adapt(context, _sectionStyle);
    Widget header(String title, {VoidCallback? onAll}) => Row(
      children: [
        Expanded(child: Text(title, style: sectionStyle)),
        if (onAll != null)
          GestureDetector(
            onTap: onAll,
            behavior: HitTestBehavior.opaque,
            child: Text(
              l10n.commonSeeAll,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                height: 16 / 13,
                color: AppColors.resolve(context, kColorPrimary700A2402F),
              ),
            ),
          ),
      ],
    );
    void open(Memory memory) =>
        context.router.push(MemoryDetailRoute(memoryId: memory.id));
    return [
      Text(
        l10n.memSearchResults(controller.total, result.query),
        style: AppTypography.adapt(
          context,
          AppTypography.caption.copyWith(
            fontWeight: FontWeight.w500,
            height: 16 / 13,
          ),
        ),
      ),
      if (controller.total == 0)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
          child: Text(
            l10n.memSearchNoResult,
            textAlign: TextAlign.center,
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
        ),
      if (media.isNotEmpty) ...[
        header(
          l10n.memSearchMedia(media.length),
          onAll:
              !controller.showAllMedia &&
                  media.length > MemorySearchController.previewTiles
              ? controller.expandMedia
              : null,
        ),
        _SearchMediaGrid(
          memories: controller.showAllMedia
              ? media
              : media.take(MemorySearchController.previewTiles).toList(),
          more: controller.showAllMedia
              ? 0
              : media.length - MemorySearchController.previewTiles,
          onTap: open,
          onMore: controller.expandMedia,
        ),
      ],
      if (diaries.isNotEmpty) ...[
        header(l10n.memSearchDiaries(diaries.length)),
        AppGroupedList(
          children: [
            for (final diary in diaries)
              _SearchDiaryRow(
                memory: diary,
                meta: l10n.memDotMeta2(
                  diary.occurredAt.toFormDate(l10n.localeName),
                  controller.memberByUser(diary.authorId)?.callName ?? '',
                ),
                onTap: () => open(diary),
              ),
          ],
        ),
      ],
    ];
  }

  /// Sheet chọn một giá trị lọc; trả về chỉ số lựa chọn (null = đóng).
  Future<int?> _choose(
    BuildContext context,
    String title,
    List<String> labels,
    int selected,
  ) => showAppBottomSheet<int>(
    context,
    builder: (sheetContext) => AppBottomSheet(
      title: title,
      gap: 0,
      children: [
        for (var index = 0; index < labels.length; index++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              labels[index],
              style: AppTypography.adapt(sheetContext, AppTypography.body),
            ),
            trailing: index == selected
                ? Icon(
                    LucideIcons.check,
                    color: AppColors.resolve(
                      sheetContext,
                      kColorPrimary600C2513F,
                    ),
                  )
                : null,
            onTap: () => Navigator.of(sheetContext).pop(index),
          ),
      ],
    ),
  );

  Future<void> _chooseKind(
    BuildContext context,
    MemorySearchController controller,
  ) async {
    final l10n = context.l10n;
    const kinds = [null, MemoryKind.photo, MemoryKind.diary];
    final index = await _choose(context, l10n.memSearchKind, [
      l10n.memSearchKindAll,
      l10n.memoriesPhotos,
      l10n.commonDiary,
    ], kinds.indexOf(controller.kind));
    if (index != null) {
      controller.setKind(kinds[index]);
    }
  }

  Future<void> _chooseChild(
    BuildContext context,
    MemorySearchController controller,
  ) async {
    final l10n = context.l10n;
    final ids = [null, ...controller.children.map((child) => child.id)];
    final index = await _choose(context, l10n.memoriesChildren, [
      l10n.commonAllFamily,
      ...controller.children.map((child) => child.name),
    ], ids.indexOf(controller.childId));
    if (index != null) {
      await controller.setChild(ids[index]);
    }
  }

  Future<void> _chooseAuthor(
    BuildContext context,
    MemorySearchController controller,
  ) async {
    final l10n = context.l10n;
    final seen = <String>{};
    final people = controller.members
        .where((member) => member.userId != null && seen.add(member.userId!))
        .toList();
    final ids = [null, ...people.map((member) => member.userId)];
    final index = await _choose(context, l10n.memSearchAuthor, [
      l10n.memSearchKindAll,
      ...people.map((member) => member.callName),
    ], ids.indexOf(controller.authorId));
    if (index != null) {
      controller.setAuthor(ids[index]);
    }
  }

  Future<void> _chooseYear(
    BuildContext context,
    MemorySearchController controller,
  ) async {
    final l10n = context.l10n;
    final years = [null, ...controller.years];
    final index = await _choose(context, l10n.memSearchYear, [
      l10n.memSearchKindAll,
      ...controller.years.map((year) => '$year'),
    ], years.indexOf(controller.year));
    if (index != null) {
      controller.setYear(years[index]);
    }
  }
}
