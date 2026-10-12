import 'package:baby_family/data/model/settings/data_export_job.dart';
import 'package:baby_family/page/general/my_data/my_data_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_caps_label.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_icon_badge.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/app_settings_row.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/export_option.dart';
part '../widgets/export_status_row.dart';
part '../widgets/small_action.dart';

/// SET-08 — Dữ liệu của tôi (Pencil `r8zic4`). “Xuất” bắt đầu bản xuất,
/// “Tải về” (mock) báo đã bắt đầu tải, “Xoá cache” đưa bộ nhớ đệm về 0.
class MyDataMobileView extends HookConsumerWidget {
  const MyDataMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(myDataControllerProvider);
    final l10n = context.l10n;
    final info = controller.info;
    Widget body;
    if (controller.hasError) {
      body = Center(child: ErrorState(onRetry: controller.load));
    } else if (info == null) {
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
      final jobs = controller.activeJobs;
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.s8 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(
            l10n.settingsData,
            style: AppTypography.adapt(context, AppTypography.h1),
          ),
          gap,
          Text(
            l10n.setDataSubtitle,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(height: 1.45),
            ),
          ),
          gap,
          AppCapsLabel(l10n.setExportSection),
          gap,
          AppGroupedList(
            children: [
              _ExportOption(
                icon: LucideIcons.userRound,
                title: l10n.setExportPersonal,
                audience: l10n.setExportPersonalWho,
                description: l10n.setExportPersonalDesc,
                preparing: controller.isPreparing(DataExportKind.personal),
                onExport: () => controller.startExport(DataExportKind.personal),
              ),
              _ExportOption(
                icon: LucideIcons.house,
                iconBackground: kColorPrimary50FFF4F1,
                iconColor: kColorPrimary600C2513F,
                title: l10n.setExportFamily,
                audience: l10n.commonOnlyParents,
                description: l10n.setExportFamilyDesc,
                preparing: controller.isPreparing(DataExportKind.family),
                onExport: () => controller.startExport(DataExportKind.family),
              ),
            ],
          ),
          if (jobs.isNotEmpty) ...[
            gap,
            AppCapsLabel(l10n.setExportStatusSection),
            gap,
            AppGroupedList(
              children: [
                for (final job in jobs)
                  _ExportStatusRow(
                    job: job,
                    onDownload: () =>
                        showAppSnackBar(context, l10n.setDownloadStarted),
                  ),
              ],
            ),
          ],
          gap,
          AppCapsLabel(l10n.setOnDeviceSection),
          gap,
          AppGroupedList(
            children: [
              AppSettingsRow(
                icon: LucideIcons.hardDrive,
                iconTile: 40,
                title: l10n.setCache,
                subtitle: l10n.setCacheSize(info.cacheMb),
                verticalPadding: AppSpacing.s4,
                showChevron: false,
                trailing: _SmallAction(
                  label: l10n.setClearCache,
                  onPressed: controller.clearCache,
                ),
              ),
            ],
          ),
          gap,
          Text(l10n.setCacheHint, style: hintStyle),
        ],
      );
    }
    return BaseScaffold(appBar: const AppTopBar(), body: body);
  }
}
