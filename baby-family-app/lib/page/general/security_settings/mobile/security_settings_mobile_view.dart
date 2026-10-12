import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/settings/login_device.dart';
import 'package:baby_family/page/general/security_settings/security_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_dialog.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/device_row.dart';

/// SET-07 — Bảo mật & Thiết bị (Pencil `sJFYE`). “Đăng xuất mọi thiết bị”
/// hỏi lại (AppDialog) rồi đăng xuất cả máy này → Welcome.
class SecuritySettingsMobileView extends HookConsumerWidget {
  const SecuritySettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(securitySettingsControllerProvider);
    final l10n = context.l10n;
    final settings = controller.settings;

    Future<void> signOutAll() async {
      final confirmed = await AppDialog.show<bool>(
        context: context,
        title: l10n.setSignOutAll,
        content: l10n.setSignOutAllHint,
        actions: [
          AppButton.secondary(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton(
            label: l10n.settingsLogout,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
      if (confirmed != true || !context.mounted) {
        return;
      }
      await controller.signOutAll();
      if (!context.mounted) {
        return;
      }
      await context.router.replaceAll([routeForSession(controller.session)]);
    }

    Future<void> signOutDevice(LoginDevice device) async {
      await controller.signOutDevice(device.id);
      if (context.mounted) {
        showAppSnackBar(context, l10n.setDeviceSignedOut(device.name));
      }
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (settings == null) {
      body = const SizedBox.shrink();
    } else {
      const gap = SizedBox(height: AppSpacing.cardInset);
      final hintStyle = AppTypography.adapt(
        context,
        AppTypography.small.copyWith(
          height: 1.45,
          color: kColorTextTertiary9C928A,
        ),
      );
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.settingsSecurity,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          AppCapsLabel(l10n.setAppLockSection),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow.toggle(
                icon: LucideIcons.scanFace,
                title: l10n.setFaceIdLock,
                subtitle: l10n.setFaceIdLockHint,
                value: settings.faceIdLock,
                onChanged: controller.setFaceIdLock,
              ),
              AppSettingsRow(
                icon: LucideIcons.keyRound,
                title: l10n.setBackupPin,
                value: settings.pinSet ? l10n.setPinSet : l10n.setPinNotSet,
                onTap: () => showComingSoonSnackBar(context),
              ),
            ],
          ),
          gap,
          Text(l10n.setPinHint, style: hintStyle),
          gap,
          AppCapsLabel(l10n.setDevicesSection),
          gap,
          AppGroupedList(
            children: [
              for (final device in settings.devices)
                _DeviceRow(
                  device: device,
                  now: controller.now,
                  onSignOut: () => signOutDevice(device),
                ),
            ],
          ),
          gap,
          AppButton.secondary(
            label: l10n.setSignOutAll,
            color: kColorErrorD14B4B,
            borderColor: kColorErrorD14B4B,
            isLoading: controller.isLoading,
            onPressed: signOutAll,
          ),
          gap,
          Text(l10n.setSignOutAllHint, style: hintStyle),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
