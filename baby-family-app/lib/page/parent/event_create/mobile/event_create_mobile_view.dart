import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/page/parent/event_create/event_create_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/parent_color.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_action_top_bar.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_outline_chip.dart';
import 'package:baby_family/utils/widget/app_setting_row.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/event_date_card.dart';
part '../widgets/event_people_section.dart';
part '../widgets/event_section.dart';
part '../widgets/event_title_field.dart';

/// Màu chấm loại sự kiện (Pencil “Loại sự kiện”).
Color _kindDot(CalendarEventKind kind) => switch (kind) {
  CalendarEventKind.child => kColorPrimary500EE7B67,
  CalendarEventKind.family => kColorAccent500F4BF5C,
  CalendarEventKind.couple => kColorUs5009B85D1,
  CalendarEventKind.anniversary => kColorSecondary5006FAE8E,
  _ => kColorTextTertiary9C928A,
};

/// CAL-02 “Tạo sự kiện” (Pencil `xlxDc`).
class EventCreateMobileView extends HookConsumerWidget {
  const EventCreateMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(eventCreateControllerProvider);
    final l10n = context.l10n;
    final title = useTextEditingController();
    final note = useTextEditingController();
    useEffect(() {
      controller.init().then((_) {
        title.text = controller.event.title;
        note.text = controller.event.note ?? '';
      });
      return null;
    }, const []);

    Future<void> save() async {
      final router = context.router;
      final messenger = context;
      await controller.save();
      if (messenger.mounted) {
        showAppSnackBar(messenger, l10n.calendarEventSaved);
      }
      await router.maybePop(true);
    }

    final topBar = AppActionTopBar(
      title: l10n.calendarCreateEvent,
      actionLabel: '',
      onAction: null,
    );
    if (!controller.loaded) {
      return BaseScaffold(
        appBar: topBar,
        body: const Center(child: CircleLoadingProgress()),
      );
    }
    final event = controller.event;
    return BaseScaffold(
      appBar: topBar,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          28 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          _EventTitleField(
            controller: title,
            icon: lucideIconByName(event.icon),
            onChanged: controller.setTitle,
          ),
          const SizedBox(height: AppSpacing.s5),
          _EventSection(
            label: l10n.calendarEventType,
            children: [
              Wrap(
                spacing: AppSpacing.s2,
                runSpacing: AppSpacing.itemGap,
                children: [
                  for (final kind in EventCreateController.kinds)
                    AppOutlineChip(
                      label: l10n.calendarEventKind(kind.name),
                      selected: event.kind == kind,
                      onTap: () => controller.setKind(kind),
                      leading: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.resolve(context, _kindDot(kind)),
                        ),
                      ),
                      trailing: kind == CalendarEventKind.couple
                          ? Icon(
                              LucideIcons.lock,
                              size: 12,
                              color: AppColors.resolve(
                                context,
                                kColorUs7006A549F,
                              ),
                            )
                          : null,
                    ),
                ],
              ),
              Text(
                l10n.calendarEventTypeHint,
                style: AppTypography.adapt(
                  context,
                  AppTypography.small.copyWith(color: kColorTextTertiary9C928A),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s5),
          _EventSection(
            label: l10n.calendarDate,
            children: [_EventDateCard(controller: controller)],
          ),
          const SizedBox(height: AppSpacing.s5),
          _EventSection(
            label: l10n.calendarRelatedChildren,
            children: [
              Wrap(
                spacing: AppSpacing.s2,
                runSpacing: AppSpacing.s2,
                children: [
                  for (final child in controller.children)
                    _personChip(
                      context,
                      label: child.name,
                      selected: event.childIds.contains(child.id),
                      avatar: ChildAvatar(child: child, size: 32),
                      onTap: () => controller.toggleChild(child.id),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s5),
          _EventPeopleSection(
            people: [?controller.me, ?controller.partner],
            controller: controller,
            chip: _personChip,
          ),
          const SizedBox(height: AppSpacing.s5),
          _EventSection(
            label: l10n.calendarReminders,
            children: [
              Wrap(
                spacing: AppSpacing.s2,
                runSpacing: AppSpacing.s2,
                children: [
                  for (final code in event.reminders)
                    AppOutlineChip(
                      label: l10n.calendarReminder(code),
                      selected: true,
                      selectedWeight: FontWeight.w600,
                      onTap: () => controller.toggleReminder(code),
                    ),
                  if (event.reminders.length < kEventReminderCodes.length)
                    AppOutlineChip(
                      label: l10n.calendarAddReminder,
                      leading: Icon(
                        LucideIcons.plus,
                        size: 14,
                        color: AppColors.resolve(
                          context,
                          kColorTextSecondary6B625B,
                        ),
                      ),
                      onTap: controller.addReminder,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s5),
          AppTextField(
            label: l10n.calendarNote,
            hint: l10n.calendarNoteHint,
            controller: note,
            onChanged: controller.setNote,
          ),
          const SizedBox(height: AppSpacing.s5),
          AppButton(
            label: l10n.calendarSaveEvent,
            isLoading: controller.isLoading,
            onPressed: save,
          ),
        ],
      ),
    );
  }

  /// Chip người/bé (Pencil “Hana”, “Mama”): cao 40, đệm 4/12/4/4, avatar 32,
  /// chữ 14/600; chọn → nền `primary-50` viền `primary-500` + `check` 14.
  static Widget _personChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required Widget avatar,
    required VoidCallback onTap,
  }) => AppOutlineChip(
    label: label,
    selected: selected,
    height: 40,
    padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
    gap: AppSpacing.s2,
    fontSize: 14,
    selectedStrokeWidth: 1,
    selectedWeight: FontWeight.w600,
    selectedTextColor: kColorTextPrimary2E2A27,
    background: kColorSurfaceVariantF7F1EC,
    leading: avatar,
    trailing: selected
        ? Icon(
            LucideIcons.check,
            size: 14,
            color: AppColors.resolve(context, kColorPrimary600C2513F),
          )
        : null,
    onTap: onTap,
  );
}
