import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/family.dart';
import 'package:baby_family/data/model/family/member.dart';
import 'package:baby_family/page/general/settings/settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/router/session_route.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_initial_avatar.dart';
import 'package:baby_family/utils/widget/app_page_header.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/profile_card.dart';

/// SET-01 — Cài đặt (Pencil `B5bkt`). Hồ sơ → SET-02, Thông báo → SET-03,
/// Quyền riêng tư → SET-04, Hiển thị & Ngôn ngữ → SET-06, Bảo mật → SET-07,
/// Dữ liệu → SET-08, Gói → SUB-01, Trợ giúp → SET-11, Giới thiệu → SET-12,
/// Xoá tài khoản → SET-09. “AI hỗ trợ” chưa có màn: “Sắp ra mắt”.
class SettingsMobileView extends HookConsumerWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(settingsControllerProvider);
    final l10n = context.l10n;
    final summary = controller.summary;
    void comingSoon() => showComingSoonSnackBar(context);
    void open(PageRouteInfo route) => context.router.push(route);

    Future<void> signOut() async {
      await controller.signOut();
      if (!context.mounted) {
        return;
      }
      await context.router.replaceAll([routeForSession(controller.session)]);
    }

    const gap = SizedBox(height: AppSpacing.s4);
    return BaseScaffold(
      isLoading: controller.isLoading,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.s2,
            AppSpacing.screen,
            AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            AppPageHeader(title: l10n.settingsTitle),
            gap,
            if (controller.me != null)
              _ProfileCard(
                member: controller.me!,
                family: controller.family,
                onTap: () => open(const ProfileSettingsRoute()),
              ),
            gap,
            AppGroupedList(
              children: [
                AppSettingsRow(
                  icon: LucideIcons.bell,
                  title: l10n.settingsNotifications,
                  onTap: () => open(const NotificationSettingsRoute()),
                ),
                AppSettingsRow(
                  icon: LucideIcons.shield,
                  title: l10n.settingsPrivacy,
                  onTap: () => open(const PrivacySettingsRoute()),
                ),
                AppSettingsRow(
                  icon: LucideIcons.sparkles,
                  title: l10n.settingsAi,
                  value: summary.aiRemaining == null || summary.aiTotal == null
                      ? null
                      : l10n.setAiQuota(summary.aiRemaining!, summary.aiTotal!),
                  onTap: comingSoon,
                ),
                AppSettingsRow(
                  icon: LucideIcons.languages,
                  title: l10n.settingsDisplayTitle,
                  value: controller.language.nativeName,
                  onTap: () => open(const DisplaySettingsRoute()),
                ),
              ],
            ),
            gap,
            AppGroupedList(
              children: [
                AppSettingsRow(
                  icon: LucideIcons.lock,
                  title: l10n.settingsSecurity,
                  value: summary.appLockName,
                  onTap: () => open(const SecuritySettingsRoute()),
                ),
                AppSettingsRow(
                  icon: LucideIcons.hardDriveDownload,
                  title: l10n.settingsData,
                  onTap: () => open(const MyDataRoute()),
                ),
                AppSettingsRow(
                  icon: LucideIcons.crown,
                  title: l10n.settingsBilling,
                  value: _planLabel(context, controller.family),
                  onTap: () => open(const PlansRoute()),
                ),
              ],
            ),
            gap,
            AppGroupedList(
              children: [
                AppSettingsRow(
                  icon: LucideIcons.lifeBuoy,
                  title: l10n.settingsHelp,
                  onTap: () => open(const HelpRoute()),
                ),
                AppSettingsRow(
                  icon: LucideIcons.info,
                  title: l10n.settingsAbout,
                  value: controller.appVersion == null
                      ? null
                      : l10n.setVersion(controller.appVersion!),
                  onTap: () => open(const AboutRoute()),
                ),
              ],
            ),
            gap,
            AppGroupedList(
              children: [
                AppSettingsRow(
                  icon: LucideIcons.logOut,
                  title: l10n.settingsLogout,
                  iconBackground: kColorPrimary600Alpha10,
                  iconColor: kColorPrimary600C2513F,
                  titleColor: kColorPrimary600C2513F,
                  showChevron: false,
                  onTap: signOut,
                ),
                AppSettingsRow(
                  icon: LucideIcons.trash2,
                  title: l10n.settingsDeleteAccount,
                  iconBackground: kColorPrimary600Alpha10,
                  iconColor: kColorPrimary600C2513F,
                  titleColor: kColorPrimary600C2513F,
                  showChevron: false,
                  onTap: () => open(const DeleteAccountRoute()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String? _planLabel(BuildContext context, Family? family) {
    if (family == null) {
      return null;
    }
    final l10n = context.l10n;
    return switch (family.plan.state) {
      PlanState.trial => l10n.setPlanTrial,
      PlanState.house => l10n.famPlanHouse,
      PlanState.family => l10n.famPlanFamily,
      PlanState.expired => l10n.setPlanExpired,
    };
  }
}
