import 'package:baby_family/data/model/settings/ai_settings.dart';
import 'package:baby_family/page/general/ai_settings/ai_settings_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/lucide_icon.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:baby_family/utils/widget/app_icon_text_row.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/ai_data_card.dart';
part '../widgets/ai_quota_card.dart';

/// SET-05 — AI hỗ trợ (Pencil `VUDq6`): công tắc chung, lượt AI còn lại,
/// từng tính năng (dữ liệu gửi đi + công tắc), “Dữ liệu gửi đi”, báo cáo nội
/// dung AI. Tắt AI chung → các tính năng mờ đi, không bấm được.
class AiSettingsMobileView extends HookConsumerWidget {
  const AiSettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(aiSettingsControllerProvider);
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
    AiSettingsController controller,
    AiSettings settings,
  ) {
    final l10n = context.l10n;
    final plan = controller.family?.plan.state;
    const gap = SizedBox(height: AppSpacing.cardInset);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Text(
          l10n.settingsAi,
          style: AppTypography.adapt(context, AppTypography.h1),
        ),
        gap,
        Container(
          padding: const EdgeInsets.all(AppSpacing.s4),
          decoration: BoxDecoration(
            color: AppColors.resolve(context, kColorSurfaceFFFFFF),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.resolve(context, kColorBorderEADFD6),
            ),
          ),
          child: Row(
            children: [
              const AppIconBadge(
                icon: LucideIcons.sparkles,
                radius: AppRadius.tile,
                color: kColorAccent100FDF1D6,
                foreground: kColorTextPrimary2E2A27,
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.setAiMaster,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyStrong.copyWith(
                          height: 19 / 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.setAiMasterHint,
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              AppSwitch(
                value: settings.enabled,
                onChanged: controller.setEnabled,
              ),
            ],
          ),
        ),
        gap,
        // Chưa biết quota (bản server chưa có API lượt dùng): ẩn thẻ thay vì
        // “0 / 0 lượt” (BF-20261026-002).
        if (settings.total > 0) ...[
          _AiQuotaCard(
            remaining: settings.remaining,
            total: settings.total,
            renews: settings.renewsAt?.toFormDate(context.localeName),
            planLabel: plan == null ? null : planTitle(l10n, plan),
          ),
          gap,
        ],
        AppCapsLabel(l10n.setAiFeatures),
        gap,
        Opacity(
          opacity: settings.enabled ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !settings.enabled,
            child: AppGroupedList(
              children: [
                for (final feature in settings.features)
                  AppSettingsRow.toggle(
                    icon: lucideIconByName(feature.icon),
                    iconSize: 16,
                    title: feature.title,
                    titleSize: 14,
                    titleWeight: FontWeight.w600,
                    subtitle: feature.sends,
                    subtitleColor: kColorTextTertiary9C928A,
                    value: feature.enabled,
                    onChanged: (value) =>
                        controller.setFeature(feature.code, value),
                  ),
              ],
            ),
          ),
        ),
        gap,
        AppCapsLabel(l10n.setAiDataSection),
        gap,
        const _AiDataCard(),
        gap,
        AppGroupedList(
          children: [
            AppSettingsRow(
              icon: LucideIcons.flag,
              iconSize: 16,
              title: l10n.setAiReport,
              onTap: () => showComingSoonSnackBar(context),
            ),
          ],
        ),
        gap,
        Text(
          l10n.setAiFoot,
          textAlign: TextAlign.center,
          style: AppTypography.adapt(context, AppTypography.small).copyWith(
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
        ),
      ],
    );
  }
}
