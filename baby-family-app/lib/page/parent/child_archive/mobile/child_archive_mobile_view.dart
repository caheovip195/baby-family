import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/child_archive/child_archive_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/input_decoration.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_check_mark.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/archive_child_card.dart';
part '../widgets/archive_effect_row.dart';
part '../widgets/archived_status_card.dart';
part '../widgets/delete_confirm_box.dart';
part '../widgets/delete_locked_box.dart';
part '../widgets/delete_name_field.dart';

/// CHD-05 — Lưu trữ / Xoá bé (Pencil `ijWOs`); bé đã lưu trữ → CHD-05b
/// (`tR0OK`): đủ 7 ngày thì hiện 2 bước xác nhận, chưa đủ thì khoá kèm ngày
/// được xoá.
class ChildArchiveMobileView extends HookConsumerWidget {
  const ChildArchiveMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(childArchiveControllerProvider(childId));
    final l10n = context.l10n;
    final child = controller.child;
    final info = controller.info;

    /// Rời CHD-05 và hồ sơ bé (bé đã ẩn / đã xoá).
    void leave() => context.router.popUntil(
      (route) =>
          route.isFirst ||
          (route.settings.name != ChildArchiveRoute.name &&
              route.settings.name != ChildProfileRoute.name),
    );

    Future<void> archive() async {
      final name = child?.name ?? '';
      await controller.archive();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(context, l10n.chdArchived(name));
      leave();
    }

    Future<void> restore() async {
      final name = child?.name ?? '';
      await controller.restore();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(context, l10n.chdRestored(name));
      await context.router.maybePop();
    }

    Future<void> delete() async {
      final name = child?.name ?? '';
      await controller.delete();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(context, l10n.chdDeleted(name));
      leave();
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (child == null || info == null) {
      body = const SizedBox.shrink();
    } else {
      const gap = SizedBox(height: AppSpacing.cardInset);
      final name = child.name;
      final shared = controller.sharedWithNames;
      final List<Widget> content;
      if (!controller.isArchived) {
        final deletable = info.deletableFrom;
        content = [
          Text(
            l10n.childArchiveTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          _ArchiveChildCard(controller: controller),
          gap,
          AppCapsLabel(l10n.chdArchiveSection(name)),
          gap,
          Container(
            padding: const EdgeInsets.all(AppSpacing.cardInset),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Column(
              children: [
                _ArchiveEffectRow(
                  icon: LucideIcons.eyeOff,
                  text: l10n.chdArchiveEffectHide(name),
                ),
                if (info.privateMemoryCount > 0)
                  _ArchiveEffectRow(
                    icon: LucideIcons.imageOff,
                    text: l10n.chdArchiveEffectPrivate(
                      info.privateMemoryCount,
                      name,
                    ),
                  ),
                if (info.sharedMemoryCount > 0 && shared.isNotEmpty)
                  _ArchiveEffectRow(
                    icon: LucideIcons.users,
                    iconColor: kColorSecondary7003F7A5C,
                    text: l10n.chdArchiveEffectShared(
                      info.sharedMemoryCount,
                      shared,
                    ),
                  ),
                _ArchiveEffectRow(
                  icon: LucideIcons.rotateCcw,
                  iconColor: kColorSecondary7003F7A5C,
                  text: l10n.chdArchiveEffectRestore,
                  last: true,
                ),
              ],
            ),
          ),
          gap,
          AppButton(label: l10n.chdArchiveAction(name), onPressed: archive),
          gap,
          AppCapsLabel(l10n.chdArchiveDeleteSection),
          gap,
          _DeleteLockedBox(
            body: l10n.chdArchiveLockedBody(
              deletable?.toFormDate(l10n.localeName) ?? '',
              name,
            ),
          ),
        ];
      } else {
        content = [
          Text(
            l10n.chdDeleteTitle(name),
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          _ArchivedStatusCard(controller: controller),
          gap,
          Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                if (info.privateMemoryCount > 0)
                  _ArchiveEffectRow(
                    icon: LucideIcons.trash2,
                    iconColor: kColorErrorD14B4B,
                    text: l10n.chdDeleteEffectTrash(
                      info.privateMemoryCount,
                      name,
                    ),
                  ),
                if (shared.isNotEmpty)
                  _ArchiveEffectRow(
                    icon: LucideIcons.users,
                    iconColor: kColorSecondary7003F7A5C,
                    text: l10n.chdDeleteEffectShared(shared),
                    last: true,
                  ),
              ],
            ),
          ),
          gap,
          if (controller.canDelete) ...[
            AppCapsLabel(l10n.chdDeleteStep1),
            gap,
            _DeleteConfirmBox(
              checked: controller.understood,
              text: l10n.chdDeleteConfirm1(name),
              onTap: controller.toggleUnderstood,
            ),
            gap,
            AppCapsLabel(l10n.chdDeleteStep2),
            gap,
            _DeleteNameField(controller: controller),
            gap,
            AppButton(
              label: l10n.chdDeleteAction(name),
              icon: LucideIcons.trash2,
              color: kColorErrorD14B4B,
              onPressed: controller.canConfirmDelete ? delete : null,
            ),
          ] else
            _DeleteLockedBox(
              body: l10n.chdArchiveLockedBodyArchived(
                info.deletableFrom?.toFormDate(l10n.localeName) ?? '',
                name,
              ),
            ),
          gap,
          AppButton.secondary(
            label: l10n.chdDeleteRestoreInstead(name),
            onPressed: restore,
          ),
        ];
      }
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: content,
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
