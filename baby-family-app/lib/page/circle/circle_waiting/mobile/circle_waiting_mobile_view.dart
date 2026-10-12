import 'package:auto_route/auto_route.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/circle/circle_waiting/circle_waiting_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// CIR-WAIT (Pencil E8YJK, chữ lớn cho ông bà): minh hoạ 220, “Bà cần được con
/// cháu mời vào gia đình”, 3 nút 60px (Nhập mã mời / Quét mã QR / Nhờ con mời
/// mình) và link “Tôi là Papa/Mama của bé”.
class CircleWaitingMobileView extends HookConsumerWidget {
  const CircleWaitingMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(circleWaitingControllerProvider);
    final l10n = context.l10n;
    const bigButton = 60.0;
    const bigFont = 17.0;
    return AppStepScaffold(
      topPadding: AppSpacing.s4,
      gap: AppSpacing.s5,
      actionGap: AppSpacing.s3,
      actions: [
        AppButton(
          label: l10n.inviteTitle,
          height: bigButton,
          fontSize: bigFont,
          onPressed: () => context.router.push(const InviteCodeRoute()),
        ),
        AppButton.secondary(
          label: l10n.inviteScanQr,
          height: bigButton,
          fontSize: bigFont,
          onPressed: () => context.router.push(
            InvitePreviewRoute(code: controller.sampleCode),
          ),
        ),
        AppButton.social(
          label: l10n.circleAskInvite,
          icon: LucideIcons.messageCircleHeart,
          iconColor: kColorPrimary600C2513F,
          height: bigButton,
          fontSize: bigFont,
          onPressed: () => controller.askChild(l10n.circleAskMessage),
        ),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
            onPressed: () async {
              await controller.switchRole();
              if (context.mounted) {
                await context.router.replaceAll([const OnboardingRoleRoute()]);
              }
            },
            child: Text(
              l10n.circleSwitchRole,
              style: AppTypography.adapt(
                context,
                AppTypography.body.copyWith(color: kColorTextSecondary6B625B),
              ),
            ),
          ),
        ),
      ],
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sheet),
          child: Image.asset(
            Assets.images.generated1791380691593.path,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        AppStepHeading(
          title: l10n.circleWaitingTitle,
          subtitle: l10n.circleWaitingSubtitle,
          center: true,
          titleHeight: 1.3,
          subtitleSize: 17,
          gap: AppSpacing.itemGap,
        ),
      ],
    );
  }
}
