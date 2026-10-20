import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/memory_comment.dart';
import 'package:baby_family/page/circle/circle_memory_detail/circle_memory_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/input_decoration.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/parent_color.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_dialog.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_relative_avatar.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/circle_big_action.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/report_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/detail_menu.dart';
part '../widgets/hero_photo.dart';
part '../widgets/round_icon_button.dart';
part '../widgets/wish_input.dart';
part '../widgets/wish_tile.dart';

/// CIR-03 — Chi tiết ký ức của người thân (Pencil `gml5c`): ảnh lớn 380,
/// menu ⋯ chỉ “Báo cáo” (tải ảnh chỉ khi bố mẹ cho phép), tác giả, chú
/// thích 20, “Đã thả tim” / “Gửi lời chúc”, ai đã thả tim, lời chúc.
class CircleMemoryDetailMobileView extends HookConsumerWidget {
  const CircleMemoryDetailMobileView({required this.memoryId, super.key});

  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      circleMemoryDetailControllerProvider(memoryId),
    );
    final l10n = context.l10n;
    final memory = controller.memory;
    final focus = useFocusNode();

    Future<void> report() async {
      final reasons = await controller.reportReasons();
      if (!context.mounted) {
        return;
      }
      await showReportSheet(
        context,
        target: ReportTarget.memory,
        reasons: reasons,
        onSubmit: controller.report,
      );
    }

    Future<void> openMenu() async {
      await _showDetailMenu(
        context,
        canDownload: controller.canDownload,
        who: relativePronounCode(controller.viewer?.relation),
        onReport: report,
        onDownload: () => showAppSnackBar(context, l10n.memViewerDownloaded),
      );
    }

    Future<void> editWish(MemoryComment wish) async {
      final body = await showAppTextInputSheet(
        context,
        title: l10n.memCommentEditing,
        actionLabel: l10n.commonSave,
        initialValue: wish.body,
      );
      if (body != null && body.trim().isNotEmpty) {
        await controller.editWish(wish, body.trim());
      }
    }

    Future<void> deleteWish(MemoryComment wish) async {
      final confirmed = await AppDialog.show<bool>(
        context: context,
        title: l10n.memCommentDelete,
        content: wish.body,
        actions: [
          AppButton.secondary(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton(
            label: l10n.memCommentDelete,
            color: kColorErrorD14B4B,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
      if (confirmed ?? false) {
        await controller.deleteWish(wish);
      }
    }

    if (controller.hasError) {
      return BaseScaffold(
        body: Center(child: ErrorState(onRetry: controller.load)),
      );
    }
    if (memory == null) {
      return BaseScaffold(
        appBar: AppBar(),
        body: controller.loaded
            ? Center(child: EmptyState(title: l10n.cirDetailMissing))
            : const SizedBox.shrink(),
      );
    }
    return BaseScaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _HeroPhoto(
                  asset: memory.mediaAssets.firstOrNull,
                  onBack: () => context.router.maybePop(),
                  onMore: openMenu,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.sectionGap,
                    AppSpacing.screen,
                    AppSpacing.screen,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _content(
                      context,
                      controller,
                      memory,
                      onWish: focus.requestFocus,
                      onEdit: editWish,
                      onDelete: deleteWish,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (controller.canComment)
            _WishInput(focusNode: focus, onSend: controller.sendWish),
        ],
      ),
    );
  }

  List<Widget> _content(
    BuildContext context,
    CircleMemoryDetailController controller,
    Memory memory, {
    required VoidCallback onWish,
    required ValueChanged<MemoryComment> onEdit,
    required ValueChanged<MemoryComment> onDelete,
  }) {
    final l10n = context.l10n;
    final author = controller.memberOf(memory.authorId);
    final child = controller.children
        .where((kid) => memory.childIds.contains(kid.id))
        .firstOrNull;
    final birth = child?.birthDate;
    final meta = [
      memoryDayTime(l10n, memory.occurredAt, controller.now),
      if (child != null && birth != null)
        l10n.cirDetailAuthorAge(
          child.name,
          childAgeText(l10n, birth, memory.occurredAt),
        ),
    ].reduce(l10n.commonDotJoin);
    final who = relativePronounCode(controller.viewer?.relation);
    final me = controller.viewer?.callName;
    final names = [
      for (final name in memory.reactorNames)
        name == me ? l10n.cirDetailYou(who) : name,
    ];
    final reacted = names.isEmpty
        ? null
        : names.length == 1
        ? names.first
        : l10n.commonListAnd(
            names.sublist(0, names.length - 1).join(', '),
            names.last,
          );
    final caption = memory.body ?? memory.title;
    const gap = SizedBox(height: AppSpacing.sectionGap);
    final secondary = AppTypography.adapt(
      context,
      AppTypography.body.copyWith(color: kColorTextSecondary6B625B),
    );
    return [
      Row(
        children: [
          AppInitialAvatar(
            name: author?.callName ?? '',
            color: parentAvatarColor(author?.role),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author == null ? '' : memberFullName(author),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.bodyLarge.copyWith(
                      height: 22 / 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(meta, style: secondary),
              ],
            ),
          ),
        ],
      ),
      if (caption != null) ...[
        gap,
        Text(
          caption,
          style: AppTypography.adapt(
            context,
            AppTypography.bodyLarge.copyWith(fontSize: 20, height: 29 / 20),
          ),
        ),
      ],
      gap,
      Row(
        children: [
          Expanded(
            child: CircleBigAction(
              icon: LucideIcons.heart,
              label: controller.liked ? l10n.cirDetailLiked : l10n.circleLike,
              color: controller.liked
                  ? kColorPrimary500EE7B67
                  : kColorPrimary50FFF4F1,
              foreground: controller.liked
                  ? kColorWhite
                  : kColorPrimary700A2402F,
              filled: controller.liked,
              onTap: controller.toggleHeart,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: CircleBigAction(
              icon: LucideIcons.messageCircle,
              label: l10n.circleSendWish,
              color: kColorSecondary100E4F2EA,
              foreground: kColorSecondary7003F7A5C,
              onTap: controller.canComment ? onWish : () {},
            ),
          ),
        ],
      ),
      if (reacted != null) ...[
        gap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                LucideIcons.heart,
                size: 18,
                color: AppColors.resolve(context, kColorPrimary600C2513F),
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(l10n.cirDetailReactedBy(reacted), style: secondary),
            ),
          ],
        ),
      ],
      gap,
      Divider(
        height: 1,
        thickness: 1,
        color: AppColors.resolve(context, kColorBorderEADFD6),
      ),
      gap,
      Text(
        l10n.cirDetailWishes(controller.wishes.length),
        style: AppTypography.adapt(context, AppTypography.title20),
      ),
      for (final wish in controller.wishes) ...[
        gap,
        _WishTile(
          wish: wish,
          author: controller.memberOf(wish.authorId),
          mine: controller.isMine(wish),
          ownName: l10n.cirDetailYou(who),
          onEdit: () => onEdit(wish),
          onDelete: () => onDelete(wish),
        ),
      ],
    ];
  }
}
