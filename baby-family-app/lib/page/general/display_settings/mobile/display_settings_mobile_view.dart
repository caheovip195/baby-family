import 'package:baby_family/page/general/display_settings/display_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_preference_segment.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_toggle_row.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part '../widgets/language_row.dart';
part '../widgets/text_size_preview.dart';

/// SET-06 — Hiển thị & Ngôn ngữ (Pencil `AoMyv`). Danh sách ngôn ngữ gồm mọi
/// [AppLanguage] (thiết kế vẽ vi/en, cùng kiểu dòng).
class DisplaySettingsMobileView extends HookConsumerWidget {
  const DisplaySettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(displaySettingsControllerProvider);
    final l10n = context.l10n;
    const gap = SizedBox(height: AppSpacing.cardInset);
    const rowPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.s4,
      vertical: AppSpacing.s3,
    );
    return BaseScaffold(
      appBar: const AppTopBar(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.settingsDisplayTitle,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          AppCapsLabel(l10n.settingsLanguage),
          gap,
          AppGroupedList(
            children: [
              for (final language in AppLanguage.values)
                _LanguageRow(
                  language: language,
                  selected: language == controller.language,
                  onTap: () => controller.changeLanguage(language),
                ),
            ],
          ),
          gap,
          Text(
            l10n.settingsLanguageNotice,
            style: AppTypography.adapt(
              context,
              AppTypography.small.copyWith(
                height: 1.45,
                color: kColorTextTertiary9C928A,
              ),
            ),
          ),
          gap,
          AppCapsLabel(l10n.settingsAppearance),
          gap,
          AppPreferenceSegment<ThemeMode>(
            choices: [
              (ThemeMode.light, l10n.settingsLight),
              (ThemeMode.dark, l10n.settingsDark),
              (ThemeMode.system, l10n.settingsSystem),
            ],
            selected: controller.themeMode,
            onChanged: controller.changeTheme,
          ),
          gap,
          AppCapsLabel(l10n.settingsTextSize),
          gap,
          AppPreferenceSegment<AppTextSize>(
            choices: [
              (AppTextSize.normal, l10n.settingsRegular),
              (AppTextSize.large, l10n.settingsLarge),
              (AppTextSize.extraLarge, l10n.settingsExtraLarge),
            ],
            selected: controller.textSize,
            onChanged: controller.changeTextSize,
          ),
          if (controller.previewName != null) ...[
            gap,
            _TextSizePreview(
              text: l10n.setTextPreview(controller.previewName!),
            ),
          ],
          gap,
          AppCapsLabel(l10n.settingsOther),
          gap,
          AppGroupedList(
            children: [
              AppToggleRow(
                title: l10n.settingsLunar,
                subtitle: l10n.settingsLunarHint,
                value: controller.lunarDate,
                onChanged: controller.changeLunarDate,
                padding: rowPadding,
              ),
              AppToggleRow(
                title: l10n.settingsReduceMotion,
                subtitle: l10n.settingsReduceMotionHint,
                value: controller.reduceMotion,
                onChanged: controller.changeReduceMotion,
                padding: rowPadding,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
