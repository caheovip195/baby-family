import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/generated/l10n/app_localizations.dart';
import 'package:baby_family/page/parent/relative_invite/relative_invite_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_toggle_row.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/child_check_row.dart';
part '../widgets/field_label.dart';

/// Chip quan hệ theo Pencil FAM-03 (3 hàng: 2 · 2 · 3). “Cô / Dì” và
/// “Chú / Bác” cùng mã `auntUncle`; “Khác…” để trống tên gọi.
typedef _RelationChoice = (RelativeRelation, String Function(AppLocalizations));

final List<List<_RelationChoice>> _relationRows = [
  [
    (RelativeRelation.grandpaPaternal, (l) => l.relationPaternalGrandfather),
    (RelativeRelation.grandmaPaternal, (l) => l.relationPaternalGrandmother),
  ],
  [
    (RelativeRelation.grandpaMaternal, (l) => l.relationMaternalGrandfather),
    (RelativeRelation.grandmaMaternal, (l) => l.relationMaternalGrandmother),
  ],
  [
    (RelativeRelation.auntUncle, (l) => l.relationAunt),
    (RelativeRelation.auntUncle, (l) => l.relationUncle),
    (RelativeRelation.other, (l) => l.famRelationOther),
  ],
];

/// Vị trí chip đầu tiên của hàng [row] trong danh sách phẳng.
int _rowStart(int row) =>
    _relationRows.take(row).fold(0, (sum, item) => sum + item.length);

/// Chip mặc định = “Ông nội” (Pencil `T3DyY`, người thân thứ 4 của story v2).
const _defaultRelationIndex = 0;

/// FAM-03 — Mời người thân (Pencil `G6wmB`). “Tạo lời mời” → FAM-05.
class RelativeInviteMobileView extends HookConsumerWidget {
  const RelativeInviteMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(relativeInviteControllerProvider);
    final l10n = context.l10n;
    final choices = [for (final row in _relationRows) ...row];
    final relationIndex = useState(_defaultRelationIndex);
    final callName = useTextEditingController(
      text: choices[_defaultRelationIndex].$2(l10n),
    );
    final plan = controller.family?.plan;

    void selectRelation(int index) {
      relationIndex.value = index;
      final choice = choices[index];
      callName.text = choice.$1 == RelativeRelation.other
          ? ''
          : choice.$2(l10n);
    }

    Future<void> create() async {
      final name = callName.text.trim().isEmpty
          ? choices[relationIndex.value].$2(l10n)
          : callName.text.trim();
      final invite = await controller.createInvite(
        relation: choices[relationIndex.value].$1,
        callName: name,
      );
      if (!context.mounted || invite == null) {
        return;
      }
      await controller.share(
        l10n.famInviteShareMessage(
          name,
          joinNames(l10n, controller.selectedChildNames),
          invite.code,
          invite.link ?? '',
        ),
      );
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(
        context,
        l10n.famInviteShared(name, invite.link ?? invite.code),
      );
      // FAM-05: lời mời mới hiện trong “Lời mời đang chờ”.
      final fromPending = context.router.stack.any(
        (route) => route.name == PendingInvitesRoute.name,
      );
      if (fromPending) {
        await context.router.maybePop();
      } else {
        await context.router.replace(const PendingInvitesRoute());
      }
    }

    const sectionGap = SizedBox(height: AppSpacing.s5);
    const labelGap = SizedBox(height: AppSpacing.itemGap);
    const permissionTitle = TextStyle(
      fontFamily: AppTypography.bodyFamily,
      fontSize: 14,
      height: 18 / 14,
      fontWeight: FontWeight.w600,
      color: kColorTextPrimary2E2A27,
    );
    return BaseScaffold(
      appBar: const AppTopBar(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.familyInvite,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          if (plan != null && plan.relativeSlotsMax > 0) ...[
            const SizedBox(height: AppSpacing.compact),
            Text(
              l10n.famInviteSlots(
                plan.relativeSlotsUsed,
                plan.relativeSlotsMax,
              ),
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(color: kColorTextSecondary6B625B),
              ),
            ),
          ],
          sectionGap,
          _FieldLabel(l10n.familyRelationship),
          labelGap,
          for (final (rowIndex, row) in _relationRows.indexed) ...[
            if (rowIndex > 0) const SizedBox(height: AppSpacing.s2),
            Wrap(
              spacing: AppSpacing.s2,
              runSpacing: AppSpacing.s2,
              children: [
                for (final (offset, choice) in row.indexed)
                  AppChip(
                    label: choice.$2(l10n),
                    selected:
                        _rowStart(rowIndex) + offset == relationIndex.value,
                    onTap: () => selectRelation(_rowStart(rowIndex) + offset),
                  ),
              ],
            ),
          ],
          sectionGap,
          AppTextField(label: l10n.familyCallName, controller: callName),
          sectionGap,
          _FieldLabel(l10n.familyFollowing),
          labelGap,
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              children: [
                for (final (index, child) in controller.children.indexed) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.cardInset),
                  _ChildCheckRow(
                    child: child,
                    selected: controller.selectedChildIds.contains(child.id),
                    onTap: () => controller.toggleChild(child.id),
                  ),
                ],
              ],
            ),
          ),
          sectionGap,
          _FieldLabel(l10n.familyPermissions),
          labelGap,
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              children: [
                AppToggleRow(
                  icon: LucideIcons.eye,
                  title: l10n.familyPhotosPermission,
                  subtitle: l10n.famPhotosPermissionHint,
                  titleStyle: permissionTitle,
                  value: controller.canView,
                  onChanged: controller.setCanView,
                ),
                const SizedBox(height: AppSpacing.cardInset),
                AppToggleRow(
                  icon: LucideIcons.messageCircleHeart,
                  title: l10n.familyFirstsPermission,
                  subtitle: l10n.famCommentPermissionHint,
                  titleStyle: permissionTitle,
                  value: controller.canComment,
                  onChanged: controller.setCanComment,
                ),
                const SizedBox(height: AppSpacing.cardInset),
                AppToggleRow(
                  icon: LucideIcons.imagePlus,
                  title: l10n.familyDownloadPermission,
                  subtitle: l10n.famPostPermissionHint,
                  titleStyle: permissionTitle,
                  value: controller.canPost,
                  onChanged: controller.setCanPost,
                ),
              ],
            ),
          ),
          sectionGap,
          Text(
            l10n.famInviteNote,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(
                height: 1.45,
                color: kColorTextTertiary9C928A,
              ),
            ),
          ),
          sectionGap,
          AppButton(
            label: l10n.familyCreateInvite,
            isLoading: controller.isLoading,
            onPressed: create,
          ),
        ],
      ),
    );
  }
}
