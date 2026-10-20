import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/data/model/memory/memory_perspective.dart';
import 'package:baby_family/page/parent/memory_detail/memory_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_dialog.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/report_sheet.dart';
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
          if (memory.commentsEnabled)
            _CommentInput(controller: controller)
          else
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: Text(
                  context.l10n.memCommentsOff,
                  textAlign: TextAlign.center,
                  style: AppTypography.adapt(context, AppTypography.caption),
                ),
              ),
            ),
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
            if (controller.canEdit)
              item(
                LucideIcons.pencil,
                l10n.memEditTitle,
                () => _edit(context, controller),
              ),
            item(
              LucideIcons.flag,
              l10n.famReport,
              () => _report(context, controller),
            ),
            if (controller.canDelete)
              item(
                LucideIcons.trash2,
                l10n.memMoveToTrash,
                () => _moveToTrash(context, controller),
              ),
          ],
        );
      },
    );
  }

  /// ⋯ “Báo cáo” → RPT-01 (bố mẹ có thêm “Gỡ khỏi gia đình”).
  Future<void> _report(
    BuildContext context,
    MemoryDetailController controller,
  ) async {
    final reasons = await controller.reportReasons();
    if (!context.mounted) {
      return;
    }
    await showReportSheet(
      context,
      target: ReportTarget.memory,
      reasons: reasons,
      canRemove: controller.me?.role.isParent ?? false,
      onSubmit: controller.report,
      onTrack: () => context.router.push(const HelpRoute()),
    );
  }

  /// ⋯ “Sửa ký ức” → MEM-09; lưu xong đọc lại chi tiết.
  Future<void> _edit(
    BuildContext context,
    MemoryDetailController controller,
  ) async {
    final memory = controller.memory;
    if (memory == null) {
      return;
    }
    final saved = await context.router.push<bool>(
      MemoryComposerRoute(memoryId: memory.id),
    );
    if (saved ?? false) {
      await controller.load();
    }
  }

  /// ⋯ “Xoá ký ức” → xác nhận → Thùng rác (MEM-17, giữ 30 ngày).
  Future<void> _moveToTrash(
    BuildContext context,
    MemoryDetailController controller,
  ) async {
    final l10n = context.l10n;
    final days = controller.trashDays;
    final confirmed = await AppDialog.show<bool>(
      context: context,
      title: l10n.memMoveToTrashTitle,
      content: l10n.memMoveToTrashBody(days),
      actions: [
        AppButton.secondary(
          label: l10n.commonCancel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: l10n.commonDelete,
          color: kColorErrorD14B4B,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    if (!(confirmed ?? false) || !context.mounted) {
      return;
    }
    final router = context.router;
    final messenger = ScaffoldMessenger.maybeOf(context);
    await controller.moveToTrash();
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.memMovedToTrash(days)),
          action: SnackBarAction(
            label: l10n.memTrashTitle,
            onPressed: () => router.push(const TrashRoute()),
          ),
        ),
      );
    await router.maybePop();
  }
}
