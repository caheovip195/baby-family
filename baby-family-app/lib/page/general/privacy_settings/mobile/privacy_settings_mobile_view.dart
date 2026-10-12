import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/settings/privacy_settings.dart';
import 'package:baby_family/page/general/privacy_settings/privacy_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/audience_row.dart';
part '../widgets/stat_tile.dart';
part '../widgets/visibility_option.dart';

/// SET-04 — Quyền riêng tư (Pencil `mD130`). “Xem chi tiết & chỉnh quyền” →
/// FAM-01 (danh sách người thân → FAM-04); “Thiết bị đăng nhập” → SET-07.
class PrivacySettingsMobileView extends HookConsumerWidget {
  const PrivacySettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(privacySettingsControllerProvider);
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
    PrivacySettingsController controller,
    PrivacySettings settings,
  ) {
    final l10n = context.l10n;
    const gap = SizedBox(height: AppSpacing.cardInset);
    final options = [
      (
        MemoryVisibility.onlyMe,
        LucideIcons.lock,
        l10n.commonOnlyYou,
        l10n.setVisOnlyMeHint,
      ),
      (
        MemoryVisibility.parents,
        LucideIcons.heartHandshake,
        l10n.setVisParents,
        l10n.setVisParentsHint,
      ),
      (
        MemoryVisibility.family,
        LucideIcons.house,
        l10n.memoriesFamily,
        l10n.setVisFamilyHint,
      ),
    ];
    String names(List<String> list) => list.join(', ');
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.settingsPrivacy,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        gap,
        AppCapsLabel(l10n.famSettingsDefaultVisibility),
        gap,
        AppGroupedList(
          children: [
            for (final (value, icon, title, hint) in options)
              _VisibilityOption(
                icon: icon,
                title: title,
                hint: hint,
                selected: settings.defaultVisibility == value,
                onTap: () => controller.setDefaultVisibility(value),
              ),
          ],
        ),
        gap,
        Text(
          l10n.setVisibilityHint,
          style: AppTypography.adapt(
            context,
            AppTypography.small.copyWith(
              height: 1.45,
              color: kColorTextTertiary9C928A,
            ),
          ),
        ),
        gap,
        AppCapsLabel(l10n.setDashboardSection),
        gap,
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.setWhoSees,
                style: AppTypography.adapt(
                  context,
                  AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              for (final child in controller.children) ...[
                const SizedBox(height: AppSpacing.itemGap),
                _AudienceRow(
                  color: child.isPregnancy
                      ? kColorUs100EAE2F8
                      : ChildAvatar.colorOf(child),
                  name: child.name,
                  count: controller.relativeCountOf(child.id),
                ),
              ],
              const SizedBox(height: AppSpacing.cardInset),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.resolve(context, kColorBorderEADFD6),
              ),
              const SizedBox(height: AppSpacing.cardInset),
              _StatGrid(
                tiles: [
                  _StatTile(
                    label: l10n.setStatDownload,
                    value: controller.downloadNames.length,
                    unit: names(controller.downloadNames),
                  ),
                  _StatTile(
                    label: l10n.setStatPost,
                    value: controller.postNames.length,
                    unit: names(controller.postNames),
                  ),
                  _StatTile(
                    label: l10n.setStatFamilyMemories,
                    value: settings.familyVisibleMemories,
                    unit: l10n.setStatMemoriesUnit,
                  ),
                  _StatTile(
                    label: l10n.setStatDevices,
                    value: settings.deviceCount,
                    unit: l10n.setStatDevicesUnit,
                    onTap: () =>
                        context.router.push(const SecuritySettingsRoute()),
                  ),
                  _StatTile(
                    label: l10n.setStatAi,
                    value: settings.aiFeatures,
                    unit: l10n.setStatAiUnit,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.cardInset),
              InkWell(
                onTap: () => context.router.push(const FamilyRoute()),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.setOpenPermissions,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.text14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kColorPrimary600C2513F,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: AppColors.resolve(context, kColorPrimary600C2513F),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        gap,
        AppInfoNote(icon: LucideIcons.shieldCheck, text: l10n.setPrivacyNote),
        gap,
        AppGroupedList(
          children: [
            AppSettingsRow(
              icon: LucideIcons.userX,
              title: l10n.setBlocked,
              value: l10n.setPeopleCount(settings.blockedCount),
              onTap: () => showComingSoonSnackBar(context),
            ),
          ],
        ),
      ],
    );
  }
}
