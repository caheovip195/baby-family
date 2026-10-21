import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/family/family_settings.dart';
import 'package:baby_family/data/model/family/timezone_catalog.dart';
import 'package:baby_family/page/parent/family_settings/family_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/constants/values.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_family_cover.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_radio_mark.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_visibility_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
            onChange: kValueUseRemoteSession
                ? () => _pickCover(controller)
                : comingSoon,
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
                onTap: () => _pickTimezone(context, controller),
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
                // Nội dung server viết cho gia đình: vi | en.
                onTap: () => controller.update(
                  (s) => s.copyWith(
                    contentLanguage: s.contentLanguage == 'vi' ? 'en' : 'vi',
                  ),
                ),
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
                onTap: () => context.router.push(const FamilyDeletionRoute()),
              ),
            ],
          ),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}

/// FAM-07: chọn ảnh bìa (photo picker hệ thống, thu nhỏ như ảnh ký ức).
Future<void> _pickCover(FamilySettingsController controller) async {
  final picked = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: kValueUploadImageMaxSide,
    maxHeight: kValueUploadImageMaxSide,
    imageQuality: kValueUploadImageQuality,
  );
  if (picked != null) {
    await controller.update((s) => s.copyWith(coverAsset: picked.path));
  }
}

/// FAM-07: chọn múi giờ từ danh mục server (tìm theo tên/mã IANA).
Future<void> _pickTimezone(
  BuildContext context,
  FamilySettingsController controller,
) async {
  final options = await controller.timezones();
  if (!context.mounted) {
    return;
  }
  if (options.isEmpty) {
    showComingSoonSnackBar(context);
    return;
  }
  final picked = await showAppBottomSheet<TimezoneOption>(
    context,
    builder: (sheetContext) => _TimezoneSheet(
      options: options,
      selectedId: controller.settings?.timezoneId,
    ),
  );
  if (picked != null) {
    await controller.setTimezone(picked);
  }
}

class _TimezoneSheet extends HookWidget {
  const _TimezoneSheet({required this.options, this.selectedId});

  final List<TimezoneOption> options;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final query = useState('');
    final needle = query.value.trim().toLowerCase();
    final shown = [
      for (final option in options)
        if (needle.isEmpty ||
            option.label.toLowerCase().contains(needle) ||
            option.id.toLowerCase().contains(needle))
          option,
    ];
    String offset(int minutes) {
      final sign = minutes < 0 ? '-' : '+';
      final abs = minutes.abs();
      return 'UTC$sign${abs ~/ 60}'
          '${abs % 60 == 0 ? '' : ':${(abs % 60).toString().padLeft(2, '0')}'}';
    }

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.itemGap,
          AppSpacing.screen,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.famSettingsTimezone,
              style: AppTypography.adapt(context, AppTypography.h3),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            AppTextField(
              hint: l10n.famTimezoneSearch,
              onChanged: (value) => query.value = value,
            ),
            const SizedBox(height: AppSpacing.s2),
            Expanded(
              child: ListView.builder(
                itemCount: shown.length,
                itemBuilder: (_, index) {
                  final option = shown[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option.label),
                    subtitle: Text(
                      '${offset(option.offsetMinutes)} · ${option.id}',
                    ),
                    trailing: AppRadioMark(
                      selected: option.id == selectedId,
                      size: 22,
                    ),
                    onTap: () => Navigator.of(context).pop(option),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
