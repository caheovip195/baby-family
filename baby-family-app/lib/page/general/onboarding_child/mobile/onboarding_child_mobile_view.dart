import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/page/general/onboarding_child/onboarding_child_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_avatar_picker.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/added_child_chip.dart';
part '../widgets/birthday_field.dart';

/// ONB-05b (Pencil ARG0K): chip các bé đã thêm; thẻ form (avatar 64, “Tên hoặc
/// tên ở nhà”, “Ngày sinh · tuổi”, giới tính Bé trai/Bé gái/Bỏ qua); “Thêm bé
/// khác”; “Hoàn tất” → ONB-08.
class OnboardingChildMobileView extends HookConsumerWidget {
  const OnboardingChildMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingChildControllerProvider);
    final name = useTextEditingController(text: controller.initialName);
    useEffect(() {
      name.text = controller.initialName;
      return null;
    }, [controller.formVersion]);
    final l10n = context.l10n;
    final today = controller.today;
    final birthDate = controller.birthDate;
    final color = kChildPalette[controller.childCount % kChildPalette.length];
    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: birthDate ?? today,
        firstDate: DateTime(today.year - 18),
        lastDate: today,
      );
      if (picked != null) {
        controller.setBirthDate(picked);
      }
    }

    return AppStepScaffold(
      topBar: const AppTopBar(step: 5, stepCount: kValueOnboardingStepCount),
      gap: AppSpacing.s5,
      actions: [
        AppButton(
          label: l10n.onboardingComplete,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.complete(name.text);
            if (context.mounted) {
              await context.router.push(const OnboardingPrivacyRoute());
            }
          },
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.onboardingChildTitle,
          subtitle: l10n.onboardingChildSubtitle,
        ),
        if (controller.babies.isNotEmpty)
          Wrap(
            spacing: AppSpacing.itemGap,
            runSpacing: AppSpacing.itemGap,
            children: [
              for (final child in controller.babies)
                _AddedChildChip(child: child, today: today),
            ],
          ),
        Container(
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
              Row(
                children: [
                  AppAvatarPicker(
                    size: 64,
                    iconSize: 24,
                    background: kColorSecondary100E4F2EA,
                    iconColor: kColorSecondary7003F7A5C,
                    borderColor: color,
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.cardInset),
                  Expanded(
                    child: Text(
                      l10n.onboardingChildAvatarOptional,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.text14.copyWith(
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              AppTextField(
                label: l10n.onboardingChildName,
                controller: name,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.s4),
              _BirthdayField(
                label: l10n.onboardingBirthday,
                value: birthDate == null
                    ? ''
                    : l10n.commonChildNameAge(
                        DateFormat(
                          'dd/MM/yyyy',
                          context.localeName,
                        ).format(birthDate),
                        childAgeText(l10n, birthDate, today),
                      ),
                onTap: pickDate,
              ),
              const SizedBox(height: AppSpacing.s4),
              Wrap(
                spacing: AppSpacing.s2,
                runSpacing: AppSpacing.s2,
                children: [
                  for (final (gender, label) in [
                    (ChildGender.boy, l10n.onboardingBoy),
                    (ChildGender.girl, l10n.onboardingGirl),
                    (ChildGender.unknown, l10n.onboardingSkipGender),
                  ])
                    AppChip(
                      label: label,
                      selected: controller.gender == gender,
                      onTap: () => controller.setGender(gender),
                    ),
                ],
              ),
            ],
          ),
        ),
        Material(
          color: kColorTransparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: BorderSide(
              color: AppColors.resolve(context, kColorBorderEADFD6),
              width: 1.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => controller.addAnother(name.text),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSpacing.s12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.plus,
                    size: 18,
                    color: AppColors.resolve(
                      context,
                      kColorTextSecondary6B625B,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  Flexible(
                    child: Text(
                      l10n.onboardingAddChild,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.label.copyWith(
                          color: kColorTextSecondary6B625B,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
