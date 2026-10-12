import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/onboarding_stage/onboarding_stage_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/person_name.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_choice_card.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// ONB-04 (Pencil ZkasK): 3 thẻ Đang mang thai / Bé đã chào đời / Đã có bé và
/// đang mang thai; “Tiếp tục” → ONB-05a hoặc ONB-05b.
class OnboardingStageMobileView extends HookConsumerWidget {
  const OnboardingStageMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingStageControllerProvider);
    final l10n = context.l10n;
    final me = controller.me;
    final partner = controller.partner;
    final stage = controller.stage;
    return AppStepScaffold(
      topBar: const AppTopBar(step: 5, stepCount: kValueOnboardingStepCount),
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
            await context.router.push(
              controller.stage == FamilyStage.born
                  ? const OnboardingChildRoute()
                  : const OnboardingPregnancyRoute(),
            );
          },
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.onboardingStageTitle,
          subtitle: me == null || partner == null
              ? l10n.onboardingStageSubtitle
              : l10n.onbStageSubtitle(
                  memberLabel(
                    l10n,
                    callName: me.callName,
                    displayName: me.displayName,
                  ),
                  memberLabel(
                    l10n,
                    callName: partner.callName,
                    displayName: partner.displayName,
                  ),
                ),
        ),
        Column(
          children: [
            AppChoiceCard(
              title: l10n.onboardingPregnant,
              description: l10n.onboardingPregnantDescription,
              icon: LucideIcons.heartPulse,
              selected: stage == FamilyStage.pregnant,
              onTap: () => controller.select(FamilyStage.pregnant),
            ),
            const SizedBox(height: AppSpacing.s3),
            AppChoiceCard(
              title: l10n.onboardingBorn,
              description: l10n.onboardingBornDescription,
              icon: LucideIcons.baby,
              color: kColorSecondary7003F7A5C,
              iconBackground: kColorSecondary100E4F2EA,
              selected: stage == FamilyStage.born,
              onTap: () => controller.select(FamilyStage.born),
            ),
            const SizedBox(height: AppSpacing.s3),
            AppChoiceCard(
              title: l10n.onboardingBoth,
              description: l10n.onbStageBothDescription,
              icon: LucideIcons.usersRound,
              color: kColorAccent7009A6A12,
              iconBackground: kColorAccent100FDF1D6,
              selected: stage == FamilyStage.both,
              onTap: () => controller.select(FamilyStage.both),
            ),
          ],
        ),
      ],
    );
  }
}
