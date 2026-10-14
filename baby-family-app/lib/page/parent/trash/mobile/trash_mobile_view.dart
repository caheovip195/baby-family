import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/page/parent/trash/trash_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_dialog_card.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/memory_thumb.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/delete_forever_dialog.dart';
part '../widgets/trash_action.dart';
part '../widgets/trash_card.dart';

/// MEM-17 — Thùng rác (Pencil `sYkws`); “Xoá vĩnh viễn” mở MEM-17b (`BB8YZ`).
class TrashMobileView extends HookConsumerWidget {
  const TrashMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(trashControllerProvider);
    final l10n = context.l10n;
    final items = controller.items;

    Future<void> restore(Memory memory) async {
      await controller.restore(memory);
      if (context.mounted) {
        showAppSnackBar(context, l10n.memTrashRestored(memoryTitle(memory)));
      }
    }

    Future<void> deleteForever(Memory memory) async {
      final confirmed = await showAppDialogCard<bool>(
        context,
        builder: (_) => _DeleteForeverDialog(memory: memory),
      );
      if (confirmed != true || !context.mounted) {
        return;
      }
      await controller.deleteForever(memory);
      if (context.mounted) {
        showAppSnackBar(context, l10n.memTrashDeleted);
      }
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (items == null) {
      body = const Padding(
        padding: EdgeInsets.all(AppSpacing.screen),
        child: MemoryListSkeleton(),
      );
    } else {
      final secondary = AppTypography.adapt(
        context,
        AppTypography.caption.copyWith(
          height: 19 / 13,
          color: kColorTextSecondary6B625B,
        ),
      );
      const gap = SizedBox(height: AppSpacing.cardInset);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.memTrashTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardInset,
              vertical: AppSpacing.s3,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(
                    LucideIcons.info,
                    size: 18,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(
                    controller.isParent
                        ? l10n.memTrashInfo(controller.trashDays)
                        : l10n.memTrashInfoOwn(controller.trashDays),
                    style: secondary,
                  ),
                ),
              ],
            ),
          ),
          gap,
          if (items.isEmpty)
            EmptyState(
              title: l10n.memTrashEmpty,
              description: l10n.memTrashEmptyHint(controller.trashDays),
            )
          else ...[
            AppCapsLabel(l10n.memTrashCount(items.length)),
            for (final memory in items) ...[
              gap,
              _TrashCard(
                memory: memory,
                meta: _meta(context, controller, memory),
                deletedBy: l10n.memTrashDeletedBy(
                  controller.callNameOf(memory.deletedByUserId),
                  (memory.deletedAt ?? memory.occurredAt).toDayMonth(
                    l10n.localeName,
                  ),
                ),
                daysLeft: controller.daysLeft(memory),
                onRestore: () => restore(memory),
                onDelete: () => deleteForever(memory),
              ),
            ],
            gap,
            Text(
              l10n.memTrashFootnote,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(
                  height: 17 / 12,
                  color: kColorTextTertiary9C928A,
                ),
              ),
            ),
          ],
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  /// “Haru · 17 tháng 22 ngày · 2 ảnh” • “Hana, Haru · 4 ảnh” •
  /// “Nhật ký · Haru · 16 tháng 27 ngày” (tuổi lúc xảy ra).
  static String _meta(
    BuildContext context,
    TrashController controller,
    Memory memory,
  ) {
    final l10n = context.l10n;
    final children = controller.childrenOf(memory);
    final Child? only = children.length == 1 ? children.first : null;
    final birth = only?.birthDate;
    final parts = [
      if (memory.kind != MemoryKind.photo) memoryKindLabel(l10n, memory.kind),
      if (children.isNotEmpty) children.map((child) => child.name).join(', '),
      if (birth != null) childAgeText(l10n, birth, memory.occurredAt),
      if (memory.mediaAssets.isNotEmpty)
        l10n.homePhotoCount(memory.mediaAssets.length),
    ];
    return parts.isEmpty ? '' : parts.reduce(l10n.commonDotJoin);
  }
}
