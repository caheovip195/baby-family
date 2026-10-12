import 'package:baby_family/page/parent/couple_settings/couple_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_dialog.dart';
import 'package:baby_family/utils/widget/app_setting_row.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/retention_segment.dart';
part '../widgets/us_radio.dart';

/// US-15 “Cài đặt Papa & Mama” (Pencil `kVZ2v`).
class CoupleSettingsMobileView extends HookConsumerWidget {
  const CoupleSettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(coupleSettingsControllerProvider);
    final l10n = context.l10n;
    final settings = controller.settings;
    final partner = controller.partnerCallName;
    final usDark = AppColors.resolve(context, kColorUs7006A549F);

    Widget card(List<Widget> rows) => AppCard(
      padding: EdgeInsets.zero,
      borderColor: kColorUs100EAE2F8,
      child: Column(children: rows),
    );
    Widget toggle(bool value, ValueChanged<bool> onChanged) => AppSwitch(
      value: value,
      activeColor: kColorUs5009B85D1,
      onChanged: onChanged,
    );

    Future<void> clearMood() async {
      final confirmed = await AppDialog.show<bool>(
        context: context,
        title: l10n.usSettingsClearMoodConfirm,
        content: l10n.usSettingsClearMoodHint,
        actions: [
          AppButton.secondary(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton(
            label: l10n.commonDelete,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
      if ((confirmed ?? false) && context.mounted) {
        showAppSnackBar(context, l10n.usSettingsClearMoodDone);
      }
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else {
      const gap = SizedBox(height: AppSpacing.cardInset);
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.usSettingsTooltip,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          const SizedBox(height: AppSpacing.compact),
          Row(
            children: [
              Icon(LucideIcons.lock, size: 14, color: usDark),
              const SizedBox(width: AppSpacing.compact),
              Flexible(
                child: Text(
                  l10n.usSettingsScope(partner),
                  style: AppTypography.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: usDark,
                  ),
                ),
              ),
            ],
          ),
          gap,
          AppCapsLabel(l10n.usSettingsCheckinSection),
          gap,
          card([
            for (final (index, mode) in CheckinShareMode.values.indexed)
              AppSettingRow(
                title: l10n.usSettingsShareMode(mode.name, partner),
                subtitle: l10n.usSettingsShareModeHint(mode.name, partner),
                divider: index < CheckinShareMode.values.length - 1,
                onTap: () => controller.setShareMode(mode),
                trailing: _UsRadio(selected: settings.checkinShareMode == mode),
              ),
          ]),
          gap,
          AppCapsLabel(l10n.usSettingsPrivacySection),
          gap,
          card([
            AppSettingRow(
              icon: LucideIcons.bellOff,
              iconColor: kColorUs7006A549F,
              title: l10n.usSettingsHideLock,
              subtitle: l10n.usSettingsHideLockHint,
              divider: true,
              onTap: () =>
                  controller.setHideOnLockScreen(!settings.hideOnLockScreen),
              trailing: toggle(
                settings.hideOnLockScreen,
                controller.setHideOnLockScreen,
              ),
            ),
            AppSettingRow(
              icon: LucideIcons.scanFace,
              iconColor: kColorUs7006A549F,
              title: l10n.usSettingsFaceId,
              subtitle: l10n.usSettingsFaceIdHint,
              onTap: () => controller.setFaceIdLock(!settings.faceIdLock),
              trailing: toggle(settings.faceIdLock, controller.setFaceIdLock),
            ),
          ]),
          gap,
          AppCapsLabel(l10n.usSettingsRequestsSection),
          gap,
          card([
            AppSettingRow(
              icon: LucideIcons.moonStar,
              iconColor: kColorUs7006A549F,
              title: l10n.usSettingsUrgentBypass(partner),
              subtitle: l10n.usSettingsUrgentBypassHint(
                settings.quietFrom,
                settings.quietTo,
              ),
              onTap: () =>
                  controller.setUrgentBypass(!settings.urgentBypassQuiet),
              trailing: toggle(
                settings.urgentBypassQuiet,
                controller.setUrgentBypass,
              ),
            ),
          ]),
          gap,
          AppCapsLabel(l10n.usSettingsBridgeSection),
          gap,
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.cardInset,
            ),
            borderColor: kColorUs100EAE2F8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.history, size: 20, color: usDark),
                    const SizedBox(width: AppSpacing.s3),
                    Expanded(
                      child: Text(
                        l10n.usSettingsBridgeKeep,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.itemGap),
                _RetentionSegment(
                  selected: settings.bridgeRetentionDays,
                  onChanged: controller.setRetention,
                ),
                const SizedBox(height: AppSpacing.itemGap),
                Text(
                  l10n.usSettingsBridgeHint,
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(height: 16 / 12),
                  ),
                ),
              ],
            ),
          ),
          gap,
          AppCapsLabel(l10n.usSettingsDataSection),
          gap,
          card([
            AppSettingRow(
              title: l10n.usSettingsClearMood,
              titleColor: kColorErrorD14B4B,
              subtitle: l10n.usSettingsClearMoodHint,
              onTap: clearMood,
              trailing: Icon(
                LucideIcons.trash2,
                size: 18,
                color: AppColors.resolve(context, kColorErrorD14B4B),
              ),
            ),
          ]),
        ],
      );
    }
    return BaseScaffold(
      backgroundColor: kColorUs50F6F2FC,
      appBar: const AppTopBar(backgroundColor: kColorUs50F6F2FC),
      body: body,
    );
  }
}
