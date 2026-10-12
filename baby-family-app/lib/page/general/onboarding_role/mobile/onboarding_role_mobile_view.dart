import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/onboarding_role/onboarding_role_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_call_name_picker.dart';
import 'package:baby_family/utils/widget/app_choice_card.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// ONB-03 (Pencil aBybm): 3 thẻ Papa/Mama/Người thân, “Các con gọi bạn là”,
/// nút “Tiếp tục” + link “Tôi đã có mã mời”.
class OnboardingRoleMobileView extends HookConsumerWidget {
  const OnboardingRoleMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingRoleControllerProvider);
    final l10n = context.l10n;
    final role = controller.role;
    return AppStepScaffold(
      topBar: const AppTopBar(step: 1, stepCount: kValueOnboardingStepCount),
      gap: AppSpacing.s5,
      actions: [
        AppButton(
          label: l10n.commonContinue,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.submit();
            if (!context.mounted) {
              return;
            }
            if (controller.role == FamilyRole.relative) {
              await context.router.replaceAll([const CircleWaitingRoute()]);
            } else {
              await context.router.push(const OnboardingFamilyRoute());
            }
          },
        ),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
            onPressed: () => context.router.push(const InviteCodeRoute()),
            child: Text(
              l10n.welcomeHaveInviteCode,
              style: AppTypography.adapt(
                context,
                AppTypography.label.copyWith(color: kColorPrimary600C2513F),
              ),
            ),
          ),
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.onboardingRoleTitle,
          subtitle: l10n.onboardingRoleSubtitle,
        ),
        Column(
          children: [
            AppChoiceCard(
              title: kValueDefaultCallNameFather,
              description: l10n.onboardingPapaDescription,
              icon: LucideIcons.userRound,
              selected: role == FamilyRole.father,
              onTap: () => controller.selectRole(FamilyRole.father),
            ),
            const SizedBox(height: AppSpacing.s3),
            AppChoiceCard(
              title: kValueDefaultCallNameMother,
              description: l10n.onboardingMamaDescription,
              icon: LucideIcons.heart,
              selected: role == FamilyRole.mother,
              onTap: () => controller.selectRole(FamilyRole.mother),
            ),
            const SizedBox(height: AppSpacing.s3),
            AppChoiceCard(
              title: l10n.onboardingCircle,
              description: l10n.onboardingCircleDescription,
              icon: LucideIcons.users,
              color: kColorSecondary7003F7A5C,
              iconBackground: kColorSecondary100E4F2EA,
              selected: role == FamilyRole.relative,
              onTap: () => controller.selectRole(FamilyRole.relative),
            ),
          ],
        ),
        if (role != FamilyRole.relative)
          AppCallNamePicker(
            key: ValueKey(role),
            father: role == FamilyRole.father,
            value: controller.callName,
            onChanged: controller.changeCallName,
          ),
      ],
    );
  }
}
