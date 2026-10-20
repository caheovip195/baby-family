import 'package:baby_family/data/dto/mission_series_info.dart';
import 'package:baby_family/page/parent/mission_settings/mission_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_dialog.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_setting_row.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/level_card.dart';

/// CARE-12 “Cài đặt nhiệm vụ” (Pencil `PY4Zg`).
class MissionSettingsMobileView extends HookConsumerWidget {
  const MissionSettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(missionSettingsControllerProvider);
    final l10n = context.l10n;
    final settings = controller.settings;
    const rowPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.s4,
      vertical: AppSpacing.s3,
    );
    Widget value(String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: AppTypography.adapt(
            context,
            AppTypography.text14.copyWith(
              fontWeight: FontWeight.w700,
              color: kColorPrimary600C2513F,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Icon(
          LucideIcons.chevronRight,
          size: 18,
          color: AppColors.resolve(context, kColorTextTertiary9C928A),
        ),
      ],
    );

    Future<void> pickBoardTime() async {
      final parts = settings.boardTime.split(':');
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.tryParse(parts.first) ?? 7,
          minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
        ),
      );
      if (picked != null) {
        await controller.setBoardTime(
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}',
        );
      }
    }

    Future<void> pickReminder() async {
      final picked = await showAppBottomSheet<MissionReminder>(
        context,
        builder: (sheetContext) => AppBottomSheet(
          title: l10n.careSettingsDefaultReminder,
          gap: 0,
          children: [
            for (final option in MissionReminder.values)
              InkWell(
                onTap: () => Navigator.of(sheetContext).pop(option),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.careReminderShort(option.name),
                          style: AppTypography.adapt(
                            context,
                            AppTypography.body,
                          ),
                        ),
                      ),
                      AppRadioMark(
                        selected: settings.defaultReminder == option,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
      if (picked != null) {
        await controller.setDefaultReminder(picked);
      }
    }

    String seriesSubtitle(MissionSeriesInfo item) {
      // 2024-01-01 là thứ Hai: tên thứ ngắn theo ngôn ngữ đang dùng.
      final weekday = DateFormat.E(context.localeName);
      final days = item.weekdays.isEmpty
          ? l10n.careSeriesDaily
          : [
              for (final day in item.weekdays)
                weekday.format(DateTime(2024, 1, day)),
            ].join(', ');
      final time = item.scheduledTime == null ? '' : ' · ${item.scheduledTime}';
      final paused = item.pausedUntil == null
          ? ''
          : ' · ${l10n.careSeriesPausedUntil(DateFormat('dd/MM', context.localeName).format(item.pausedUntil!))}';
      return '$days$time$paused';
    }

    Future<void> manageSeries(MissionSeriesInfo item) async {
      final action = await showAppBottomSheet<bool>(
        context,
        builder: (sheetContext) => AppBottomSheet(
          title: item.title,
          gap: 0,
          children: [
            for (final (end, label) in [
              (false, l10n.careSeriesPauseWeek),
              (true, l10n.careSeriesEnd),
            ])
              InkWell(
                onTap: () => Navigator.of(sheetContext).pop(end),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      style: AppTypography.adapt(context, AppTypography.body),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
      if (action == null || !context.mounted) {
        return;
      }
      if (action) {
        final confirmed = await AppDialog.show<bool>(
          context: context,
          title: l10n.careSeriesEnd,
          content: l10n.careSeriesEndConfirm,
          actions: [
            AppButton.secondary(
              label: l10n.commonCancel,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            AppButton(
              label: l10n.careSeriesEnd,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
        if (confirmed != true || !context.mounted) {
          return;
        }
      }
      try {
        if (action) {
          await controller.endSeries(item.id);
        } else {
          await controller.pauseSeriesWeek(item.id);
        }
        if (context.mounted) {
          showAppSnackBar(
            context,
            action ? l10n.careSeriesEnded : l10n.careSeriesPaused,
          );
        }
      } on Object catch (error) {
        if (context.mounted) {
          showAppSnackBar(context, actionErrorMessage(error));
        }
      }
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      final categories = settings.categories;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.careSettingsTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          AppCapsLabel(l10n.careSettingsLevelSection),
          const SizedBox(height: AppSpacing.cardInset),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final level in MissionLoadLevel.values) ...[
                  if (level != MissionLoadLevel.light)
                    const SizedBox(width: AppSpacing.s2),
                  Expanded(
                    child: _LevelCard(
                      level: level,
                      selected: settings.level == level,
                      onTap: () => controller.setLevel(level),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.itemGap,
            ),
            decoration: BoxDecoration(
              color: AppColors.resolve(context, kColorUs50F6F2FC),
              borderRadius: BorderRadius.circular(AppRadius.tile),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.users,
                  size: 16,
                  color: AppColors.resolve(context, kColorUs7006A549F),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    l10n.careSettingsLevelNote(
                      controller.partner?.callName ?? '',
                      controller.me?.callName ?? '',
                    ),
                    style: AppTypography.adapt(
                      context,
                      AppTypography.small.copyWith(
                        height: 17 / 12,
                        color: kColorUs7006A549F,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          AppCapsLabel(l10n.careSettingsCategoriesSection),
          const SizedBox(height: AppSpacing.cardInset),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (index, category) in categories.indexed)
                  AppSettingRow(
                    icon: lucideIconByName(category.icon),
                    title: category.title,
                    padding: rowPadding,
                    divider: index < categories.length - 1,
                    onTap: () => controller.toggleCategory(
                      category.code,
                      !category.enabled,
                    ),
                    trailing: AppSwitch(
                      value: category.enabled,
                      onChanged: (value) =>
                          controller.toggleCategory(category.code, value),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          Text(
            l10n.careSettingsCategoriesHint,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(
                height: 17 / 12,
                color: kColorTextTertiary9C928A,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.cardInset),
          AppCapsLabel(l10n.careSettingsTimingSection),
          const SizedBox(height: AppSpacing.cardInset),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                AppSettingRow(
                  icon: LucideIcons.sunrise,
                  title: l10n.careSettingsBoardTime,
                  subtitle: l10n.careSettingsBoardTimeHint(
                    settings.level.perPerson,
                  ),
                  padding: rowPadding,
                  divider: true,
                  onTap: pickBoardTime,
                  trailing: value(settings.boardTime),
                ),
                AppSettingRow(
                  icon: LucideIcons.moon,
                  title: l10n.careSettingsAskAtNight(
                    kValueMissionCarryOverTime,
                  ),
                  subtitle: l10n.careSettingsAskAtNightHint,
                  padding: rowPadding,
                  divider: true,
                  onTap: () => controller.setAskAtNight(!settings.askAtNight),
                  trailing: AppSwitch(
                    value: settings.askAtNight,
                    onChanged: controller.setAskAtNight,
                  ),
                ),
                AppSettingRow(
                  icon: LucideIcons.bellRing,
                  title: l10n.careSettingsDefaultReminder,
                  subtitle: l10n.careSettingsDefaultReminderHint,
                  padding: rowPadding,
                  onTap: pickReminder,
                  trailing: value(
                    l10n.careReminderShort(settings.defaultReminder.name),
                  ),
                ),
              ],
            ),
          ),
          if (controller.series.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.cardInset),
            AppCapsLabel(l10n.careSeriesSection),
            const SizedBox(height: AppSpacing.cardInset),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (index, item) in controller.series.indexed)
                    AppSettingRow(
                      icon: item.pausedUntil == null
                          ? LucideIcons.repeat
                          : LucideIcons.pause,
                      title: item.title,
                      subtitle: seriesSubtitle(item),
                      padding: rowPadding,
                      divider: index < controller.series.length - 1,
                      onTap: item.canManage ? () => manageSeries(item) : null,
                      trailing: item.canManage
                          ? Icon(
                              LucideIcons.chevronRight,
                              size: 18,
                              color: AppColors.resolve(
                                context,
                                kColorTextTertiary9C928A,
                              ),
                            )
                          : null,
                    ),
                ],
              ),
            ),
          ],
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
