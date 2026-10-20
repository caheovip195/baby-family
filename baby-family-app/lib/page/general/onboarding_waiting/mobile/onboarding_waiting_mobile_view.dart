import 'package:auto_route/auto_route.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/general/onboarding_waiting/onboarding_waiting_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/invite_code.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_dialog.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/invite_status_row.dart';
part '../widgets/waiting_qr_sheet.dart';

/// ONB-WAIT (Pencil L3DRls): tên gia đình + cài đặt; minh hoạ 240; “Đang chờ
/// Papa tham gia…”; thẻ trạng thái lời mời; “Gửi lại lời mời”, “Hiện mã QR”,
/// “Huỷ gia đình này”. Mock: snackbar sau khi gửi lại và sheet QR có nút
/// “Mô phỏng bạn đời tham gia” → ONB-ACT.
class OnboardingWaitingMobileView extends HookConsumerWidget {
  const OnboardingWaitingMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingWaitingControllerProvider);
    final l10n = context.l10n;
    final partner = controller.partnerCallName;
    final invite = controller.invite;
    Future<void> simulate() async {
      final joined = await controller.simulateJoined();
      if (joined && context.mounted) {
        await context.router.replaceAll([const OnboardingActivatedRoute()]);
      }
    }

    // Bản server: bạn đời đã tham gia (poll) → ONB-ACT.
    useEffect(() {
      if (controller.joined) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.router.replaceAll([const OnboardingActivatedRoute()]);
          }
        });
      }
      return null;
    }, [controller.joined]);

    // 7.3 bước 6: xác nhận lần cuối người vừa nhận lời mời.
    final approvalName = controller.approvalCallName;
    useEffect(() {
      if (approvalName == null) {
        return null;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) {
          return;
        }
        final approve = await AppDialog.show<bool>(
          context: context,
          barrierDismissible: false,
          title: l10n.onboardingPartnerApproveTitle(approvalName),
          content: l10n.onboardingPartnerApproveBody(controller.trialDays),
          actions: [
            AppButton.text(
              label: l10n.onboardingPartnerReject,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            AppButton(
              label: l10n.onboardingPartnerApprove,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
        if (approve != null && context.mounted) {
          await runWithErrorSnackBar(
            context,
            () => controller.decide(approve: approve),
          );
        }
      });
      return null;
    }, [approvalName]);

    final daysLeft = controller.daysLeft;
    return AppStepScaffold(
      topPadding: AppSpacing.s4,
      gap: AppSpacing.s5,
      actionGap: AppSpacing.itemGap,
      actions: [
        AppButton(
          label: l10n.onboardingResendInvite,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.resend(l10n.onbInviteShareMessage);
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.onboardingInviteSent),
                action: controller.usesServer
                    ? null
                    : SnackBarAction(
                        label: l10n.onboardingActivateDemo,
                        onPressed: simulate,
                      ),
              ),
            );
          },
        ),
        AppButton.secondary(
          label: l10n.onboardingShowQr,
          onPressed: () => showAppBottomSheet<void>(
            context,
            builder: (_) => _WaitingQrSheet(
              code: formatInviteCode(invite?.code ?? ''),
              onSimulate: controller.usesServer
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      simulate();
                    },
            ),
          ),
        ),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
            onPressed: () => AppDialog.show<void>(
              context: context,
              title: l10n.onboardingCancelFamily,
              content: l10n.onbCancelFamilyMessage,
              actions: [
                AppButton(
                  label: l10n.commonConfirm,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final cancelled = await runWithErrorSnackBar(
                      context,
                      controller.cancelFamily,
                    );
                    if (cancelled && context.mounted) {
                      await context.router.replaceAll([
                        const OnboardingRoleRoute(),
                      ]);
                    }
                  },
                ),
                AppButton.text(
                  label: l10n.commonCancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            child: Text(
              l10n.onboardingCancelFamily,
              style: AppTypography.adapt(
                context,
                AppTypography.text14.copyWith(color: kColorTextTertiary9C928A),
              ),
            ),
          ),
        ),
      ],
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                controller.family?.name ?? '',
                style: AppTypography.adapt(
                  context,
                  AppTypography.h3.copyWith(height: 25 / 18),
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.settingsTitle,
              onPressed: () => context.router.push(const SettingsRoute()),
              icon: Icon(
                LucideIcons.settings,
                size: 22,
                color: AppColors.resolve(context, kColorTextSecondary6B625B),
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
          child: Image.asset(
            Assets.images.generated1791380839354.path,
            height: 240,
            fit: BoxFit.cover,
          ),
        ),
        AppStepHeading(
          title: l10n.onboardingWaitingTitle(partner),
          subtitle: l10n.onbWaitingSubtitle(partner, controller.trialDays),
          center: true,
          titleSize: 24,
        ),
        if (invite != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.itemGap,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceFFFFFF),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
            ),
            child: Column(
              children: [
                if (invite.sentAt != null)
                  _InviteStatusRow(
                    icon: LucideIcons.send,
                    label: l10n.onbWaitingSentAt(
                      DateFormat.Hm(context.localeName).format(invite.sentAt!),
                    ),
                  ),
                if (invite.openedAt != null)
                  _InviteStatusRow(
                    icon: LucideIcons.eye,
                    label: l10n.onbWaitingOpened(partner),
                  ),
                if (daysLeft != null)
                  _InviteStatusRow(
                    icon: LucideIcons.timer,
                    label: l10n.onbWaitingExpires(daysLeft),
                    muted: true,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
