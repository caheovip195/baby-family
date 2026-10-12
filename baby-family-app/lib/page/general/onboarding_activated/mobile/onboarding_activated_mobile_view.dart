import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/page/general/onboarding_activated/onboarding_activated_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/couple_avatars.dart';
part '../widgets/trial_card.dart';

/// ONB-ACT (Pencil zKXgc): nền `primary-50`; 2 avatar Papa (peach) / Mama
/// (mint) chồng 16; tim 44; “Nhà mình đã đủ Papa & Mama 🎉”; thẻ dùng thử
/// (viền `primary-300`); nút “Thiết lập cho bé” → ONB-04.
class OnboardingActivatedMobileView extends HookConsumerWidget {
  const OnboardingActivatedMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingActivatedControllerProvider);
    final l10n = context.l10n;
    final endsAt = controller.family?.plan.endsAt;
    final house = controller.offer(PlanState.house)?.priceText;
    final family = controller.offer(PlanState.family)?.priceText;
    return AppStepScaffold(
      backgroundColor: kColorPrimary50FFF4F1,
      topPadding: AppSpacing.s4,
      gap: AppSpacing.s5,
      actions: [
        AppButton(
          label: l10n.onboardingSetupChild,
          onPressed: () => context.router.push(const OnboardingStageRoute()),
        ),
      ],
      children: [
        _CoupleAvatars(parents: controller.parents),
        Center(
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary600C2513F),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.heart,
              size: 22,
              color: AppColors.onPrimary(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
          child: AppStepHeading(
            title: l10n.onboardingActivatedTitle,
            subtitle: l10n.onboardingActivatedSubtitle,
            center: true,
            titleHeight: 1.3,
            gap: AppSpacing.itemGap,
          ),
        ),
        _TrialCard(
          until: endsAt == null
              ? null
              : l10n.onbTrialUntil(
                  DateFormat('dd/MM/yyyy', context.localeName).format(endsAt),
                ),
          after: house == null || family == null
              ? null
              : l10n.onbTrialAfter(house, family),
        ),
      ],
    );
  }
}
