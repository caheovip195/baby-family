import 'package:baby_family/data/model/settings/notification_settings.dart';
import 'package:baby_family/page/general/notification_settings/notification_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/quiet_time_range.dart';

/// Icon Lucide theo tên kebab của nhóm thông báo (fixture `icon`).
const _channelIcons = <String, IconData>{
  'images': LucideIcons.images,
  'list-checks': LucideIcons.listChecks,
  'hand-heart': LucideIcons.handHeart,
  'heart': LucideIcons.heart,
  'messages-square': LucideIcons.messagesSquare,
  'sparkles': LucideIcons.sparkles,
  'cake': LucideIcons.cake,
  'calendar-heart': LucideIcons.calendarHeart,
  'users': LucideIcons.users,
  'credit-card': LucideIcons.creditCard,
  'tag': LucideIcons.tag,
};

/// Nhóm thuộc vùng riêng Papa & Mama — ô icon tím (`us-50`/`us-700`).
const _coupleChannels = {'couple', 'bridge'};

/// SET-03 — Thông báo (Pencil `OJ7tk`).
class NotificationSettingsMobileView extends HookConsumerWidget {
  const NotificationSettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(notificationSettingsControllerProvider);
    final settings = controller.settings;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (settings == null) {
      body = const SizedBox.shrink();
    } else {
      body = _content(context, controller, settings);
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }

  Widget _content(
    BuildContext context,
    NotificationSettingsController controller,
    NotificationSettings settings,
  ) {
    final l10n = context.l10n;
    final partner = controller.partnerCallName ?? kValueDefaultCallNameFather;
    void comingSoon() => showComingSoonSnackBar(context);
    const gap = SizedBox(height: AppSpacing.s3);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.settingsNotifications,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        gap,
        AppCapsLabel(l10n.setNotifGroupsSection),
        gap,
        AppGroupedList(
          children: [
            for (final channel in settings.channels)
              AppSettingsRow.toggle(
                icon: _channelIcons[channel.icon] ?? LucideIcons.bell,
                iconTile: 30,
                iconBackground: _coupleChannels.contains(channel.code)
                    ? kColorUs50F6F2FC
                    : kColorSurfaceVariantF7F1EC,
                iconColor: _coupleChannels.contains(channel.code)
                    ? kColorUs7006A549F
                    : kColorTextSecondary6B625B,
                title: channel.title,
                subtitle: channel.hint,
                minHeight: 48,
                verticalPadding: AppSpacing.itemGap,
                value: channel.enabled,
                onChanged: (value) =>
                    controller.toggleChannel(channel.code, value),
              ),
          ],
        ),
        gap,
        AppCapsLabel(l10n.setQuietSection),
        gap,
        AppGroupedList(
          children: [
            AppSettingsRow.toggle(
              title: l10n.setQuietHours,
              subtitle: l10n.setQuietHoursHint,
              minHeight: 48,
              verticalPadding: AppSpacing.itemGap,
              value: settings.quietHours,
              onChanged: controller.setQuietHours,
            ),
            if (settings.quietHours)
              _QuietTimeRange(
                from: settings.quietFrom,
                to: settings.quietTo,
                onTap: comingSoon,
              ),
            AppSettingsRow.toggle(
              title: l10n.setUrgentBypass(partner),
              subtitle: settings.urgentBypassQuiet
                  ? l10n.setUrgentBypassOn
                  : l10n.setUrgentBypassOff(settings.quietTo),
              minHeight: 48,
              verticalPadding: AppSpacing.itemGap,
              value: settings.urgentBypassQuiet,
              onChanged: controller.setUrgentBypass,
            ),
            AppSettingsRow.toggle(
              title: l10n.setHideLockScreen,
              subtitle: l10n.setHideLockScreenHint,
              minHeight: 48,
              verticalPadding: AppSpacing.itemGap,
              value: settings.hideOnLockScreen,
              onChanged: controller.setHideOnLockScreen,
            ),
          ],
        ),
        gap,
        AppCapsLabel(l10n.setRelativesSection),
        gap,
        AppGroupedList(
          children: [
            AppSettingsRow(
              title: l10n.setDigestTime,
              value: settings.relativesDigestTime,
              valueStrong: true,
              minHeight: 48,
              verticalPadding: AppSpacing.itemGap,
              onTap: comingSoon,
            ),
            AppSettingsRow(
              title: l10n.setMutePeople,
              value: l10n.setPeopleCount(settings.mutedPeople),
              minHeight: 48,
              verticalPadding: AppSpacing.itemGap,
              onTap: comingSoon,
            ),
          ],
        ),
      ],
    );
  }
}
