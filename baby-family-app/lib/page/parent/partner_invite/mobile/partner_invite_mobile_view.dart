import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/page/parent/partner_invite/partner_invite_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/invite_code.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/invite_approval_row.dart';
import 'package:baby_family/utils/widget/invite_code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/recipient_preview.dart';

/// FAM-02 — Mời bạn đời (Pencil `VGRgb`, seed `partnerLeft`): banner “Papa đã
/// rời…”, chọn vai trò Papa/Mama, thẻ mã mời, người nhận sẽ thấy gì, xác nhận
/// lần cuối, “Gửi lời mời…”, “Sao chép link mời”, “Thu hồi lời mời”.
class PartnerInviteMobileView extends HookConsumerWidget {
  const PartnerInviteMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(partnerInviteControllerProvider);
    final l10n = context.l10n;
    final invite = controller.invite;
    final familyName = controller.family?.name ?? '';
    if (controller.hasError) {
      return BaseScaffold(
        appBar: const AppTopBar(),
        body: Center(child: ErrorState(onRetry: controller.load)),
      );
    }
    final code = invite?.code ?? '';

    Future<void> share() async {
      final link = await controller.markSent();
      await controller.share(l10n.onbInviteShareMessage(code, link));
    }

    Future<void> copyLink() async {
      final link = await controller.markSent();
      await Clipboard.setData(ClipboardData(text: link));
      if (context.mounted) {
        showAppSnackBar(context, l10n.commonCopied);
      }
    }

    Future<void> revoke() async {
      await controller.revoke();
      if (!context.mounted) {
        return;
      }
      showAppSnackBar(context, l10n.famPartnerRevoked);
      await context.router.maybePop();
    }

    const gap = SizedBox(height: AppSpacing.cardInset);
    return BaseScaffold(
      appBar: const AppTopBar(),
      body: !controller.loaded
          ? const SizedBox.shrink()
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                28 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                if (controller.partnerLeft) ...[
                  AppInfoNote(
                    icon: LucideIcons.house,
                    text: l10n.famPartnerLeftBanner(
                      controller.leftPartnerCallName,
                      familyName,
                    ),
                    lineHeight: 1.45,
                    alignTop: true,
                  ),
                  gap,
                ],
                Text(
                  l10n.familyInvitePartnerTitle,
                  style: AppTypography.adapt(context, AppTypography.h1),
                ),
                const SizedBox(height: AppSpacing.compact),
                Text(
                  l10n.famPartnerInviteSubtitle,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.text14.copyWith(
                      height: 1.45,
                      color: kColorTextSecondary6B625B,
                    ),
                  ),
                ),
                gap,
                Text(
                  l10n.famPartnerInviteRole,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.caption.copyWith(
                      height: 16 / 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: [
                    for (final (role, label) in [
                      (FamilyRole.father, kValueDefaultCallNameFather),
                      (FamilyRole.mother, kValueDefaultCallNameMother),
                    ])
                      AppChip(
                        label: label,
                        selected: controller.role == role,
                        onTap: () => controller.selectRole(role),
                      ),
                  ],
                ),
                gap,
                if (invite != null) ...[
                  InviteCodeCard(
                    code: formatInviteCode(code),
                    onCopy: () async {
                      await Clipboard.setData(ClipboardData(text: code));
                      if (context.mounted) {
                        showAppSnackBar(context, l10n.commonCopied);
                      }
                    },
                  ),
                  gap,
                ],
                _RecipientPreview(
                  familyName: familyName,
                  children: controller.children,
                  inviterName: controller.me?.displayName ?? '',
                  inviterCallName: controller.me?.callName ?? '',
                ),
                gap,
                InviteApprovalRow(
                  label: l10n.onboardingInviteApproval,
                  value: controller.requireApproval,
                  onChanged: controller.toggleApproval,
                ),
                const SizedBox(height: AppSpacing.cardInset + AppSpacing.s1),
                AppButton(
                  label: l10n.onboardingShareInvite,
                  isLoading: controller.isLoading,
                  onPressed: invite == null ? null : share,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                AppButton.secondary(
                  label: l10n.onboardingCopyInvite,
                  onPressed: invite == null ? null : copyLink,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                Center(
                  child: AppPillButton(
                    label: l10n.famPartnerRevoke,
                    icon: LucideIcons.link2Off,
                    height: 34,
                    fontSize: 14,
                    color: kColorTransparent,
                    foreground: kColorErrorD14B4B,
                    onPressed: invite == null ? null : revoke,
                  ),
                ),
              ],
            ),
    );
  }
}
