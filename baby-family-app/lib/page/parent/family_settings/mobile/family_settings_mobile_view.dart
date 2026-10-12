import 'package:baby_family/data/model/family/family_settings.dart';
import 'package:baby_family/page/parent/family_settings/family_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_family_cover.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_visibility_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/cover_card.dart';

/// FAM-07 — Cài đặt gia đình (Pencil `gmT8p`). “Ai thấy ký ức mới” mở sheet
/// chọn người xem; múi giờ, ngôn ngữ gợi ý, đổi ảnh bìa và “Xoá gia đình”
/// chưa có màn riêng → “Sắp ra mắt”.
class FamilySettingsMobileView extends HookConsumerWidget {
  const FamilySettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(familySettingsControllerProvider);
    final l10n = context.l10n;
    final settings = controller.settings;
    void comingSoon() => showComingSoonSnackBar(context);

    Future<void> pickVisibility(FamilySettings current) async {
      final picked = await showMemoryVisibilitySheet(
        context,
        current: current.defaultVisibility,
      );
      if (picked != null) {
        await controller.update((s) => s.copyWith(defaultVisibility: picked));
      }
    }

    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (settings == null) {
      body = const SizedBox.shrink();
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
            l10n.familySettingsTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          _CoverCard(
            name: settings.name,
            coverAsset: settings.coverAsset,
            onChange: comingSoon,
          ),
          gap,
          AppTextField(
            label: l10n.famSettingsName,
            initialValue: settings.name,
            onChanged: (value) =>
                controller.update((s) => s.copyWith(name: value)),
          ),
          gap,
          AppCapsLabel(l10n.famSettingsMemoriesSection),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                title: l10n.famSettingsDefaultVisibility,
                subtitle: l10n.famSettingsDefaultVisibilityHint,
                value: memoryVisibilityLabel(l10n, settings.defaultVisibility),
                valueStrong: true,
                onTap: () => pickVisibility(settings),
              ),
              AppSettingsRow.toggle(
                title: l10n.famSettingsApprove,
                subtitle: l10n.famSettingsApproveHint,
                value: settings.approveRelativePhotos,
                onChanged: (value) => controller.update(
                  (s) => s.copyWith(approveRelativePhotos: value),
                ),
              ),
              AppSettingsRow.toggle(
                title: l10n.famSettingsTree,
                value: settings.relativesSeeTree,
                onChanged: (value) => controller.update(
                  (s) => s.copyWith(relativesSeeTree: value),
                ),
              ),
              AppSettingsRow.toggle(
                title: l10n.famSettingsMilestones,
                subtitle: l10n.famSettingsMilestonesHint,
                value: settings.milestoneSuggestions,
                onChanged: (value) => controller.update(
                  (s) => s.copyWith(milestoneSuggestions: value),
                ),
              ),
            ],
          ),
          gap,
          AppCapsLabel(l10n.famSettingsDatesSection),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                title: l10n.famSettingsTimezone,
                value: settings.timezoneLabel,
                onTap: comingSoon,
              ),
              AppSettingsRow.toggle(
                title: l10n.famSettingsLunar,
                value: settings.showLunar,
                onChanged: (value) =>
                    controller.update((s) => s.copyWith(showLunar: value)),
              ),
              AppSettingsRow(
                title: l10n.famSettingsMilestonesBy,
                value: settings.milestonesByLunar
                    ? l10n.famSettingsLunarCalendar
                    : l10n.famSettingsSolarCalendar,
                onTap: () => controller.update(
                  (s) => s.copyWith(milestonesByLunar: !s.milestonesByLunar),
                ),
              ),
              AppSettingsRow(
                title: l10n.famSettingsContentLanguage,
                value: AppLanguage.fromCode(
                  settings.contentLanguage,
                )?.nativeName,
                onTap: comingSoon,
              ),
            ],
          ),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                icon: LucideIcons.trash2,
                iconBackground: kColorPrimary50FFF4F1,
                iconColor: kColorErrorD14B4B,
                title: l10n.famDeleteFamily,
                titleColor: kColorErrorD14B4B,
                titleWeight: FontWeight.w600,
                subtitle: l10n.famDeleteFamilyHint,
                onTap: comingSoon,
              ),
            ],
          ),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
