import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/mission_create/mission_create_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_child_chip.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/create_option_chip.dart';
part '../widgets/create_request_hint.dart';
part '../widgets/create_step_header.dart';
part '../widgets/create_title_field.dart';
part '../widgets/create_top_bar.dart';

/// CARE-03 “Thêm nhiệm vụ” (Pencil `gi5z6`).
class MissionCreateMobileView extends HookConsumerWidget {
  const MissionCreateMobileView({this.childId, this.templateId, super.key});

  final String? childId;
  final String? templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(missionCreateControllerProvider);
    final titleController = useTextEditingController();
    useEffect(() {
      controller
          .init(childId: childId, templateId: templateId)
          .then((_) => titleController.text = controller.title);
      return null;
    }, const []);
    final l10n = context.l10n;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);

    Future<void> openLibrary() async {
      final id = await context.router.push<String>(const MissionLibraryRoute());
      if (id == null) {
        return;
      }
      await controller.applyTemplate(id);
      titleController.text = controller.title;
    }

    Future<void> pickTime() async {
      final parts = (controller.dueTime ?? '').split(':');
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.tryParse(parts.first) ?? 19,
          minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
        ),
      );
      if (picked != null) {
        controller.setDueTime(
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}',
        );
      }
    }

    Future<void> save() async {
      final router = context.router;
      await controller.save();
      await router.maybePop(true);
    }

    final repeatLabel = controller.repeat == MissionRepeat.customDays
        ? controller.repeatDays
              .map((day) => l10n.careWeekday(weekdayCode(day)))
              .join(', ')
        : l10n.careRepeatOption(controller.repeat.name);

    return BaseScaffold(
      appBar: _CreateTopBar(title: l10n.careAddMission),
      body: !controller.loaded
          ? const Center(child: CircleLoadingProgress())
          : ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.s1,
                AppSpacing.screen,
                AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                _CreateTitleField(
                  controller: titleController,
                  icon: missionIcon(controller.icon),
                  onChanged: controller.setTitle,
                  onLibrary: openLibrary,
                ),
                const SizedBox(height: AppSpacing.s5),
                _CreateStepHeader(number: 1, label: l10n.careForWho),
                const SizedBox(height: AppSpacing.itemGap),
                Row(
                  children: [
                    for (final (scope, label) in [
                      (MissionScope.oneChild, l10n.careOneChild),
                      (MissionScope.manyChildren, l10n.careManyChildren),
                      (MissionScope.family, l10n.commonAllFamily),
                      (MissionScope.couple, l10n.careBothParents),
                    ]) ...[
                      if (scope != MissionScope.oneChild)
                        const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: _CreateOptionChip(
                          label: label,
                          selected: controller.scope == scope,
                          onTap: () => controller.setScope(scope),
                        ),
                      ),
                    ],
                  ],
                ),
                if (controller.showsChildren) ...[
                  const SizedBox(height: AppSpacing.itemGap),
                  Wrap(
                    spacing: AppSpacing.s2,
                    runSpacing: AppSpacing.s2,
                    children: [
                      for (final child in controller.babies)
                        AppChildChip(
                          label: child.name,
                          selected: controller.childIds.contains(child.id),
                          avatar: ChildAvatar(
                            child: child,
                            size: 32,
                            borderColor: kColorSurfaceFFFFFF,
                          ),
                          onTap: () => controller.toggleChild(child.id),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.s5),
                _CreateStepHeader(number: 2, label: l10n.careWhoQuestion),
                const SizedBox(height: AppSpacing.itemGap),
                Row(
                  children: [
                    Expanded(
                      child: _CreateOptionChip(
                        label: l10n.careMine,
                        selected: controller.ownerKind == MissionOwnerKind.me,
                        onTap: () => controller.setOwner(MissionOwnerKind.me),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: _CreateOptionChip(
                        label: l10n.careTogether,
                        selected:
                            controller.ownerKind == MissionOwnerKind.together,
                        onTap: () =>
                            controller.setOwner(MissionOwnerKind.together),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.itemGap),
                _CreateRequestHint(
                  text: l10n.careAskPartnerPrompt(controller.partnerCallName),
                  onTap: () => context.router.push(
                    RequestComposeRoute(title: controller.title),
                  ),
                ),
                const SizedBox(height: AppSpacing.s5),
                _CreateStepHeader(number: 3, label: l10n.careWhenQuestion),
                const SizedBox(height: AppSpacing.itemGap),
                Row(
                  children: [
                    Expanded(
                      child: _CreateOptionChip(
                        icon: LucideIcons.calendar,
                        label: controller.tomorrow
                            ? l10n.careTomorrow
                            : l10n.careTodayShort,
                        onTap: controller.toggleDay,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: _CreateOptionChip(
                        icon: LucideIcons.clock8,
                        label: controller.dueTime ?? l10n.careTimeAny,
                        onTap: pickTime,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: _CreateOptionChip(
                        icon: LucideIcons.repeat,
                        label: repeatLabel,
                        onTap: controller.nextRepeat,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.itemGap),
                InkWell(
                  onTap: controller.nextReminder,
                  child: Row(
                    children: [
                      Icon(LucideIcons.bellRing, size: 16, color: secondary),
                      const SizedBox(width: AppSpacing.s2),
                      Flexible(
                        child: Text(
                          l10n.careReminderOption(controller.reminder.name),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.caption,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s5),
                Row(
                  children: [
                    Icon(LucideIcons.camera, size: 20, color: secondary),
                    const SizedBox(width: AppSpacing.s3),
                    Expanded(
                      child: Text(
                        l10n.careMemoryPrompt,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s3),
                    AppSwitch(
                      value: controller.memoryPrompt,
                      onChanged: controller.setMemoryPrompt,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s5),
                AppButton(
                  label: l10n.careSaveMission,
                  isLoading: controller.isLoading,
                  onPressed: save,
                ),
              ],
            ),
    );
  }
}
