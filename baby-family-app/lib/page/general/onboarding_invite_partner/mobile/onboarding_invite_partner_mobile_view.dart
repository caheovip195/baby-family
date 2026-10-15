import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/onboarding_invite_partner/onboarding_invite_partner_controller.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/invite_code.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/invite_approval_row.dart';
import 'package:baby_family/utils/widget/invite_code_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-07 (Pencil tIOQ7): thẻ mã mời (QR 148, “Mã mời”, mã 24/800 + sao chép,
/// hạn dùng), dòng xác nhận lần cuối có công tắc, nút “Gửi lời mời qua Zalo,
/// Messenger…” và “Sao chép link mời”.
class OnboardingInvitePartnerMobileView extends HookConsumerWidget {
  const OnboardingInvitePartnerMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingInvitePartnerControllerProvider);
    final l10n = context.l10n;
    final code = controller.invite?.code ?? '';
    final partner = controller.partnerCallName;
    void toWaiting() =>
        context.router.replaceAll([const OnboardingWaitingRoute()]);
    void copied() => ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.commonCopied)));
    return AppStepScaffold(
      topBar: const AppTopBar(step: 4, stepCount: kValueOnboardingStepCount),
      gap: AppSpacing.s5,
      actionGap: AppSpacing.itemGap,
      actions: [
        AppButton(
          label: l10n.onboardingShareInvite,
          isLoading: controller.isLoading,
          onPressed: () async {
            final link = await controller.markSent();
            await controller.share(l10n.onbInviteShareMessage(code, link));
            if (context.mounted) {
              toWaiting();
            }
          },
        ),
        AppButton.secondary(
          label: l10n.onboardingCopyInvite,
          onPressed: () async {
            final link = await controller.markSent();
            await Clipboard.setData(ClipboardData(text: link));
            if (context.mounted) {
              copied();
              toWaiting();
            }
          },
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.onboardingInviteTitle(partner),
          subtitle: l10n.onbInviteSubtitle(partner, controller.trialDays),
        ),
        InviteCodeCard(
          code: formatInviteCode(code),
          onCopy: () async {
            await Clipboard.setData(ClipboardData(text: code));
            if (context.mounted) {
              copied();
            }
          },
        ),
        InviteApprovalRow(
          label: l10n.onbInviteApproval(partner),
          value: controller.requireApproval,
          onChanged: controller.toggleApproval,
        ),
      ],
    );
  }
}
