import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/child_add/child_add_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/relative_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_avatar_picker.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_choice_card.dart';
import 'package:baby_family/utils/widget/app_outline_chip.dart';
import 'package:baby_family/utils/widget/app_picker_field.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// CHD-04 “Thêm bé” (Pencil `COfI3`).
class ChildAddMobileView extends HookConsumerWidget {
  const ChildAddMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(childAddControllerProvider);
    final l10n = context.l10n;
    final name = useTextEditingController();
    if (!controller.loaded) {
      return const BaseScaffold(
        appBar: AppTopBar(),
        body: Center(child: CircleLoadingProgress()),
      );
    }
    final labelStyle = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
        height: 16 / 13,
      ),
    );
    final today = controller.today;

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: controller.date ?? today,
        firstDate: controller.expecting ? today : DateTime(today.year - 18),
        lastDate: controller.expecting
            ? today.add(const Duration(days: kValuePregnancyTotalDays))
            : today,
      );
      if (picked != null) {
        controller.setDate(picked);
      }
    }

    Future<void> submit() async {
      final router = context.router;
      final typed = name.text.trim();
      final child = await controller.submit(
        typed.isEmpty ? l10n.onbNicknameIdea1 : typed,
      );
      if (child == null) {
        return;
      }
      await router.replace(
        child.isPregnancy
            ? PregnancyJourneyRoute(pregnancyId: child.id)
            : ChildProfileRoute(childId: child.id),
      );
    }

    final formCard = Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.resolve(context, kColorBorderEADFD6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!controller.expecting) ...[
            Row(
              children: [
                AppAvatarPicker(
                  size: 64,
                  iconSize: 22,
                  background: kColorSecondary100E4F2EA,
                  iconColor: kColorSecondary7003F7A5C,
                  onTap: () {},
                ),
                const SizedBox(width: AppSpacing.cardInset),
                Expanded(
                  child: Text(
                    l10n.onboardingChildAvatarOptional,
                    style: AppTypography.adapt(context, AppTypography.caption),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s4),
          ],
          AppTextField(
            label: controller.expecting
                ? l10n.onboardingNickname
                : l10n.onboardingChildName,
            hint: l10n.childNameHint,
            controller: name,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.s4),
          AppPickerField(
            label: controller.expecting
                ? l10n.onboardingDueDate
                : l10n.childBirthDate,
            placeholder: controller.expecting
                ? l10n.childDueDateHint
                : l10n.childBirthDateHint,
            value: controller.date?.toFormDate(l10n.localeName),
            onTap: pickDate,
          ),
          if (!controller.expecting) ...[
            const SizedBox(height: AppSpacing.s4),
            Text(l10n.childGenderOptional, style: labelStyle),
            const SizedBox(height: AppSpacing.s2),
            Wrap(
              spacing: AppSpacing.s2,
              runSpacing: AppSpacing.s2,
              children: [
                for (final gender in ChildGender.values)
                  AppOutlineChip(
                    label: l10n.childGender(gender.name),
                    height: 34,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.cardInset,
                    ),
                    gap: AppSpacing.s1,
                    selectedStrokeWidth: 1,
                    selected: controller.gender == gender,
                    leading: controller.gender == gender
                        ? Icon(
                            LucideIcons.check,
                            size: 13,
                            color: AppColors.resolve(
                              context,
                              kColorPrimary600C2513F,
                            ),
                          )
                        : null,
                    onTap: () => controller.setGender(gender),
                  ),
              ],
            ),
          ],
        ],
      ),
    );

    return BaseScaffold(
      appBar: const AppTopBar(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.childAddTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.childAddSubtitle(
              controller.familyName,
              joinNames(l10n, [
                for (final child in controller.children) child.name,
              ]),
            ),
            style: AppTypography.adapt(context, AppTypography.caption),
          ),
          const SizedBox(height: AppSpacing.s4),
          AppChoiceCard(
            title: l10n.childAddBorn,
            description: l10n.childAddBornHint,
            icon: LucideIcons.baby,
            selected: !controller.expecting,
            onTap: () => controller.setExpecting(false),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          AppChoiceCard(
            title: l10n.childAddExpecting,
            description: l10n.childAddExpectingHint(
              controller.nextPregnancyOrder,
            ),
            icon: LucideIcons.sprout,
            color: kColorUs7006A549F,
            iconBackground: kColorUs100EAE2F8,
            selected: controller.expecting,
            onTap: () => controller.setExpecting(true),
          ),
          const SizedBox(height: AppSpacing.s4),
          formCard,
          const SizedBox(height: AppSpacing.s4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.itemGap,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              borderRadius: BorderRadius.circular(AppRadius.tile),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.users,
                  size: 16,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    l10n.childAddShareNote,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(height: 17 / 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          AppButton(
            label: l10n.childAddTitle,
            isLoading: controller.isLoading,
            onPressed: submit,
          ),
        ],
      ),
    );
  }
}
