import 'package:auto_route/auto_route.dart';
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

part '../widgets/privacy_point.dart';

/// ONB-08 (Pencil Q1fpJu): huy hiệu khoá 80 (`us-100`), “Không gian riêng của
/// nhà mình”, 3 điểm cam kết, nút “Mình hiểu rồi” → ONB-10.
class OnboardingPrivacyMobileView extends HookConsumerWidget {
  const OnboardingPrivacyMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppStepScaffold(
      topPadding: AppSpacing.s10,
      gap: 28,
      actions: [
        AppButton(
          label: l10n.onboardingUnderstood,
          onPressed: () =>
              context.router.push(const OnboardingNotificationsRoute()),
        ),
      ],
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs100EAE2F8),
              borderRadius: BorderRadius.circular(AppRadius.sheet),
            ),
            child: Icon(
              LucideIcons.lockKeyhole,
              size: 36,
              color: AppColors.resolve(context, kColorUs7006A549F),
            ),
          ),
        ),
        AppStepHeading(
          title: l10n.onboardingPrivacyTitle,
          subtitle: l10n.onboardingPrivacySubtitle,
          center: true,
        ),
        Column(
          children: [
            _PrivacyPoint(
              icon: LucideIcons.shieldCheck,
              color: kColorSecondary7003F7A5C,
              background: kColorSecondary100E4F2EA,
              title: l10n.onboardingPrivacyInvited,
              description: l10n.onboardingPrivacyInvitedDescription,
            ),
            const SizedBox(height: 18),
            _PrivacyPoint(
              icon: LucideIcons.heartHandshake,
              color: kColorUs7006A549F,
              background: kColorUs100EAE2F8,
              title: l10n.onboardingPrivacyUs,
              description: l10n.onboardingPrivacyUsDescription,
            ),
            const SizedBox(height: 18),
            _PrivacyPoint(
              icon: LucideIcons.download,
              color: kColorAccent7009A6A12,
              background: kColorAccent100FDF1D6,
              title: l10n.onboardingPrivacyData,
              description: l10n.onboardingPrivacyDataDescription,
            ),
          ],
        ),
      ],
    );
  }
}
