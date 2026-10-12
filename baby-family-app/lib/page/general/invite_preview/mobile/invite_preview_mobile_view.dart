import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/family/invite_info.dart';
import 'package:baby_family/page/general/invite_preview/invite_preview_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/person_name.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_call_name_picker.dart';
import 'package:baby_family/utils/widget/app_family_cover.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/child_access_row.dart';
part '../widgets/invite_family_card.dart';
part '../widgets/visibility_row.dart';

/// INV-01 (Pencil gTSrl bạn đời / BSCuD người thân): thẻ gia đình (bìa + người
/// mời + vai trò), danh sách thấy/không thấy, (bạn đời) “Các con gọi bạn là”
/// hoặc (người thân) quyền với từng bé; “Tham gia…” / “Từ chối”.
class InvitePreviewMobileView extends HookConsumerWidget {
  const InvitePreviewMobileView({this.code, super.key});

  final String? code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(invitePreviewControllerProvider(code));
    final l10n = context.l10n;
    final data = controller.data;
    if (controller.invalid) {
      return AppStepScaffold(
        topBar: const AppTopBar(),
        children: [
          ErrorState(
            title: l10n.inviteInvalidTitle,
            description: l10n.inviteInvalidDescription,
          ),
        ],
      );
    }
    if (data == null) {
      return const AppStepScaffold(
        topBar: AppTopBar(),
        children: [Center(child: CircleLoadingProgress())],
      );
    }
    final invite = data.invite;
    final partner = controller.isPartner;
    final relation = invite.relation?.name ?? RelativeRelation.other.name;
    final pronoun = l10n.invPronoun(relation);
    final pronounTitle = l10n.invPronounTitle(relation);
    final inviterLabel = memberLabel(
      l10n,
      callName: invite.inviterCallName ?? '',
      displayName: invite.inviterName ?? '',
    );
    String names(List<Child> children) =>
        children.map((child) => child.name).join(l10n.invNameSeparator);
    final permission = invite.canComment
        ? l10n.circleViewComment
        : l10n.invViewOnly;
    return AppStepScaffold(
      topBar: const AppTopBar(),
      gap: AppSpacing.s5,
      actionGap: AppSpacing.itemGap,
      actions: [
        AppButton(
          label: partner
              ? l10n.inviteJoinAsParent(controller.callName)
              : l10n.inviteJoin,
          isLoading: controller.isLoading,
          onPressed: () async {
            final signedIn = controller.signedIn;
            await controller.accept();
            if (!context.mounted) {
              return;
            }
            if (signedIn) {
              await context.router.replaceAll([
                routeForSession(controller.session),
              ]);
            } else {
              await context.router.push(const AuthRoute());
            }
          },
        ),
        AppButton.secondary(
          label: l10n.inviteDecline,
          onPressed: () async {
            await controller.decline();
            if (context.mounted) {
              await context.router.maybePop();
            }
          },
        ),
      ],
      children: [
        _InviteFamilyCard(
          invite: invite,
          inviterLine: partner
              ? l10n.invInviterParent(
                  invite.inviterName ?? '',
                  invite.inviterCallName ?? '',
                )
              : l10n.invInviterRelative(
                  invite.inviterName ?? '',
                  invite.inviterCallName ?? '',
                  pronoun,
                ),
          roleLine: partner
              ? l10n.invRoleParent(controller.callName)
              : l10n.invRoleRelative(invite.callName ?? '', permission),
          partner: partner,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (partner) ...[
              _VisibilityRow(
                icon: LucideIcons.check,
                label: l10n.invParentSees,
              ),
              _VisibilityRow(
                icon: LucideIcons.check,
                label: l10n.invParentManage(invite.inviterCallName ?? ''),
              ),
              _VisibilityRow(
                icon: LucideIcons.info,
                muted: true,
                label: l10n.invParentApproval(inviterLabel),
              ),
            ] else ...[
              _VisibilityRow(
                icon: LucideIcons.check,
                label: l10n.invRelativeSees(pronounTitle, names(data.children)),
              ),
              _VisibilityRow(
                icon: LucideIcons.eyeOff,
                muted: true,
                label: data.hiddenChildren.isEmpty
                    ? l10n.invRelativeHidden(pronounTitle)
                    : l10n.invRelativeHiddenChildren(
                        pronounTitle,
                        names(data.hiddenChildren),
                      ),
              ),
              if (invite.canPost)
                _VisibilityRow(
                  icon: LucideIcons.info,
                  muted: true,
                  label: l10n.invRelativeApproval(pronoun),
                ),
              if (data.children.isNotEmpty) ...[
                for (final child in data.children)
                  _ChildAccessRow(
                    child: child,
                    today: controller.today,
                    permission: permission,
                  ),
              ],
            ],
          ],
        ),
        if (partner)
          AppCallNamePicker(
            father: invite.role != FamilyRole.mother,
            value: controller.callName,
            onChanged: controller.changeCallName,
          ),
      ],
    );
  }
}
