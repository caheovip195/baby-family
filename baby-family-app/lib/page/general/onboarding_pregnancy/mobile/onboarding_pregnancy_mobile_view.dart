import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/general/onboarding_pregnancy/onboarding_pregnancy_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_step_heading.dart';
import 'package:baby_family/utils/widget/app_step_scaffold.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/baby_count_segment.dart';
part '../widgets/picker_field.dart';

/// ONB-05a (Pencil QcAXM): tên ở nhà + 4 gợi ý; ngày dự sinh (hoặc tuần thai);
/// số bé (segmented tròn); xem trước “Tuần 24 + 3 ngày · Còn 109 ngày nữa gặp
/// Bơ”; “Tiếp tục” → ONB-05b (nếu có cả bé) hoặc ONB-08.
class OnboardingPregnancyMobileView extends HookConsumerWidget {
  const OnboardingPregnancyMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingPregnancyControllerProvider);
    final name = useTextEditingController(text: controller.initialName);
    useEffect(() {
      if (controller.loaded && name.text.isEmpty) {
        name.text = controller.initialName;
      }
      return null;
    }, [controller.loaded]);
    useListenable(name);
    final l10n = context.l10n;
    final dueDate = controller.dueDate;
    final ideas = [
      l10n.onbNicknameIdea1,
      l10n.onbNicknameIdea2,
      l10n.onbNicknameIdea3,
      l10n.onbNicknameIdea4,
    ];
    final labelStyle = AppTypography.adapt(
      context,
      AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
        height: 16 / 13,
      ),
    );
    Future<void> pickDate() async {
      final today = controller.today;
      final picked = await showDatePicker(
        context: context,
        initialDate: dueDate ?? today,
        firstDate: today,
        lastDate: today.add(const Duration(days: kValuePregnancyTotalDays)),
      );
      if (picked != null) {
        controller.setDueDate(picked);
      }
    }

    Future<void> pickWeek() async {
      final picked = await showAppBottomSheet<int>(
        context,
        builder: (sheetContext) => AppBottomSheet(
          title: l10n.onboardingWeek,
          children: [
            Wrap(
              spacing: AppSpacing.s2,
              runSpacing: AppSpacing.s2,
              children: [
                for (
                  var week = kValuePregnancyMinWeek;
                  week <= kValuePregnancyMaxWeek;
                  week++
                )
                  AppChip(
                    label: '$week',
                    selected: week == controller.week,
                    showCheck: false,
                    onTap: () => Navigator.of(sheetContext).pop(week),
                  ),
              ],
            ),
          ],
        ),
      );
      if (picked != null) {
        controller.setWeek(picked);
      }
    }

    final displayName = name.text.trim().isEmpty
        ? controller.initialName
        : name.text.trim();
    return AppStepScaffold(
      topBar: const AppTopBar(step: 5, stepCount: kValueOnboardingStepCount),
      gap: AppSpacing.s5,
      actions: [
        AppButton(
          label: l10n.commonContinue,
          isLoading: controller.isLoading,
          onPressed: () async {
            await controller.submit(name.text);
            if (!context.mounted) {
              return;
            }
            await context.router.push(
              controller.alsoHasChild
                  ? const OnboardingChildRoute()
                  : const OnboardingPrivacyRoute(),
            );
          },
        ),
      ],
      children: [
        AppStepHeading(
          title: l10n.onboardingPregnancyTitle,
          subtitle: l10n.onboardingPregnancySubtitle,
        ),
        AppTextField(
          label: l10n.onboardingNickname,
          controller: name,
          textInputAction: TextInputAction.done,
        ),
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final idea in ideas)
              AppChip(
                label: idea,
                selected: name.text.trim() == idea,
                showCheck: false,
                onTap: () => name.text = idea,
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.weekMode
                  ? l10n.onboardingWeek
                  : l10n.onboardingDueDate,
              style: labelStyle,
            ),
            const SizedBox(height: AppSpacing.s2),
            _PickerField(
              value: controller.weekMode
                  ? l10n.onbWeekValue(controller.week)
                  : dueDate == null
                  ? ''
                  : DateFormat(
                      'dd/MM/yyyy',
                      context.localeName,
                    ).format(dueDate),
              icon: LucideIcons.calendarDays,
              onTap: controller.weekMode ? pickWeek : pickDate,
            ),
            const SizedBox(height: AppSpacing.s2),
            InkWell(
              onTap: controller.toggleWeekMode,
              child: Text(
                controller.weekMode
                    ? l10n.onbKnowDueDate
                    : l10n.onboardingKnowWeek,
                style: AppTypography.adapt(
                  context,
                  AppTypography.text14.copyWith(
                    fontWeight: FontWeight.w600,
                    color: kColorPrimary600C2513F,
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.onboardingBabyCount, style: labelStyle),
            const SizedBox(height: AppSpacing.s2),
            _BabyCountSegment(
              labels: [
                l10n.onboardingSingle,
                l10n.onboardingTwins,
                l10n.onboardingTriplets,
              ],
              selectedIndex: controller.babyCount - 1,
              onChanged: (index) => controller.setBabyCount(index + 1),
            ),
          ],
        ),
        if (dueDate != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.cardInset,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorPrimary50FFF4F1),
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.sprout,
                  size: 24,
                  color: AppColors.resolve(context, kColorSecondary7003F7A5C),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pregnancyWeekText(l10n, dueDate, controller.today),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.title16.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.onbMeetCountdown(
                          daysUntil(dueDate, controller.today),
                          displayName,
                        ),
                        style: AppTypography.adapt(
                          context,
                          AppTypography.caption.copyWith(height: 16 / 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
