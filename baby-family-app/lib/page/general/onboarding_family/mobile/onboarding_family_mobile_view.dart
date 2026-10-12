import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/onboarding_family/onboarding_family_controller.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/person_name.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_family_cover.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-06 (Pencil pkzPB): ảnh bìa xem trước (tên gia đình + “Mama Lan · đang
/// chờ Papa”), ô “Tên gia đình”, 3 chip gợi ý, nút “Tạo gia đình”.
class OnboardingFamilyMobileView extends HookConsumerWidget {
  const OnboardingFamilyMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingFamilyControllerProvider);
    final l10n = context.l10n;
    final name = useTextEditingController(
      text: controller.firstName.isEmpty
          ? ''
          : l10n.onbFamilyDefaultName(controller.firstName),
    );
    useListenable(name);
    final member = memberLabel(
      l10n,
      callName: controller.callName,
      displayName: controller.firstName,
    );
    final suggestions = [
      l10n.onbFamilySuggestion1,
      l10n.onbFamilySuggestion2,
      l10n.onbFamilySuggestion3,
    ];
    return AppStepScaffold(
      topBar: const AppTopBar(step: 3, stepCount: kValueOnboardingStepCount),
      actions: [
        AppButton(
          label: l10n.onboardingCreateFamily,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.create(name.text);
            if (context.mounted) {
              await context.router.push(const OnboardingInvitePartnerRoute());
            }
          },
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.onboardingFamilyTitle,
          subtitle: l10n.onboardingFamilySubtitle,
        ),
        AppFamilyCover(
          name: name.text.trim().isEmpty
              ? l10n.onboardingFamilyName
              : name.text.trim(),
          subtitle: l10n.onbFamilyCoverWaiting(
            member,
            controller.partnerCallName,
          ),
          editLabel: l10n.onbChangeCover,
          onEdit: () {},
        ),
        AppTextField(
          label: l10n.onboardingFamilyName,
          controller: name,
          textInputAction: TextInputAction.done,
        ),
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final label in suggestions)
              AppChip(
                label: label,
                selected: name.text.trim() == label,
                showCheck: false,
                onTap: () => name.text = label,
              ),
          ],
        ),
      ],
    );
  }
}
