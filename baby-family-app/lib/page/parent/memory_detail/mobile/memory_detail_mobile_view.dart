import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/memory_perspective.dart';
import 'package:baby_family/page/parent/memory_detail/memory_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/add_perspective_button.dart';
part '../widgets/author_row.dart';
part '../widgets/comment_input.dart';
part '../widgets/comment_tile.dart';
part '../widgets/detail_hero.dart';
part '../widgets/detail_pill.dart';
part '../widgets/perspective_block.dart';
part '../widgets/reaction_bar.dart';

/// MEM-07 Chi tiết ký ức (Pencil `axhOt`).
class MemoryDetailMobileView extends HookConsumerWidget {
  const MemoryDetailMobileView({required this.memoryId, super.key});

  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memoryDetailControllerProvider(memoryId));
    final memory = controller.memory;
    if (!controller.loaded) {
      return const BaseScaffold(body: Center(child: CircleLoadingProgress()));
    }
    if (controller.hasError || memory == null) {
      return BaseScaffold(
        appBar: AppBar(),
        body: ErrorState(onRetry: controller.load),
      );
    }
    return BaseScaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DetailHero(
                  memory: memory,
                  controller: controller,
                  onMore: () => _openMenu(context, controller),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                    vertical: AppSpacing.s4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _content(context, controller, memory),
                  ),
                ),
              ],
            ),
          ),
          _CommentInput(controller: controller),
        ],
      ),
    );
  }

  List<Widget> _content(
    BuildContext context,
    MemoryDetailController controller,
    Memory memory,
  ) {
    final l10n = context.l10n;
    final tags = <Widget>[
      if (memory.milestoneTitle != null)
        _DetailPill(
          icon: LucideIcons.star,
          label: memory.milestoneTitle!,
          background: kColorAccent100FDF1D6,
          foreground: kColorAccent7009A6A12,
          height: 27,
        ),
      for (final id in memory.childIds)
        if (controller.childById(id) case final child?)
          _DetailPill(
            dotColor: ChildAvatar.colorOf(child),
            label: child.name,
            foreground: kColorTextPrimary2E2A27,
            height: 27,
          ),
    ];
    final moment = <Widget>[
      if (memory.people.isNotEmpty)
        _DetailPill(
          icon: LucideIcons.users,
          label: memory.people.join(', '),
          iconSize: 13,
        ),
      if (memory.feeling != null)
        _DetailPill(
          icon: LucideIcons.smile,
          label: memory.feeling!,
          iconSize: 13,
        ),
    ];
    final items = <Widget>[
      _AuthorRow(memory: memory, controller: controller),
      if ((memory.body ?? memory.title) != null)
        Text(
          memory.body ?? memory.title!,
          style: AppTypography.adapt(
            context,
            AppTypography.bodyLarge.copyWith(fontSize: 16, height: 1.5),
          ),
        ),
      if (tags.isNotEmpty)
        Wrap(spacing: AppSpacing.s2, runSpacing: AppSpacing.s2, children: tags),
      if (moment.isNotEmpty)
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: moment,
        ),
      for (final perspective in controller.perspectives)
        _PerspectiveBlock(
          perspective: perspective,
          controller: controller,
          onTap: perspective.authorId == controller.me?.userId
              ? () => context.router.push(
                  MemoryPerspectiveRoute(memoryId: memory.id),
                )
              : null,
        ),
      if (controller.canAddPerspective)
        _AddPerspectiveButton(
          onTap: () =>
              context.router.push(MemoryPerspectiveRoute(memoryId: memory.id)),
        ),
      _ReactionBar(memory: memory, controller: controller),
      Divider(
        height: 1,
        thickness: 1,
        color: AppColors.resolve(context, kColorBorderEADFD6),
      ),
      Row(
        children: [
          Expanded(
            child: Text(
              l10n.memCommentsCount(controller.comments.length),
              style: AppTypography.adapt(context, AppTypography.title16),
            ),
          ),
          if (controller.comments.length > controller.previewComments.length)
            GestureDetector(
              onTap: () =>
                  context.router.push(MemoryCommentsRoute(memoryId: memory.id)),
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
      ),
      for (final comment in controller.previewComments)
        _CommentTile(comment: comment, controller: controller),
    ];
    return [
      for (var index = 0; index < items.length; index++) ...[
        if (index > 0) const SizedBox(height: AppSpacing.cardInset),
        items[index],
      ],
    ];
  }

  Future<void> _openMenu(
    BuildContext context,
    MemoryDetailController controller,
  ) async {
    final memory = controller.memory;
    if (memory == null) {
      return;
    }
    final l10n = context.l10n;
    final router = context.router;
    await showAppBottomSheet<void>(
      context,
      builder: (sheetContext) {
        Widget item(IconData icon, String label, VoidCallback onTap) =>
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                icon,
                color: AppColors.resolve(
                  sheetContext,
                  kColorTextSecondary6B625B,
                ),
              ),
              title: Text(
                label,
                style: AppTypography.adapt(sheetContext, AppTypography.body),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                onTap();
              },
            );
        return AppBottomSheet(
          gap: 0,
          children: [
            item(
              LucideIcons.heart,
              memory.isFavorite ? l10n.memMenuUnfavorite : l10n.memMenuFavorite,
              controller.toggleFavorite,
            ),
            if (controller.canAddPerspective ||
                controller.myPerspective != null)
              item(
                LucideIcons.heartHandshake,
                controller.myPerspective == null
                    ? l10n.memoriesAddPerspective
                    : l10n.memEditPerspective,
                () => router.push(MemoryPerspectiveRoute(memoryId: memory.id)),
              ),
          ],
        );
      },
    );
  }
}
