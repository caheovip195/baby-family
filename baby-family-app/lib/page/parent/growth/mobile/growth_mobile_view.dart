import 'dart:math' as math;

import 'package:baby_family/data/model/growth/growth_entry.dart';
import 'package:baby_family/page/parent/growth/growth_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/server_error_message.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_info_note.dart';
import 'package:baby_family/utils/widget/app_picker_field.dart';
import 'package:baby_family/utils/widget/app_tag_pill.dart';
import 'package:baby_family/utils/widget/app_text_action.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/segmented_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/growth_chart.dart';
part '../widgets/growth_entry_sheet.dart';

/// CHD-06 — Tăng trưởng: tiêu đề + tên bé, chọn Cân nặng / Chiều cao, biểu đồ
/// đường của bé, disclaimer, các lần đo (mới nhất trước), nút “Thêm lần đo”.
class GrowthMobileView extends HookConsumerWidget {
  const GrowthMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(growthControllerProvider);
    final l10n = context.l10n;
    useEffect(() {
      Future.microtask(() => controller.init(childId));
      return null;
    }, [childId]);

    void openSheet([GrowthEntry? entry]) => showAppBottomSheet<void>(
      context,
      builder: (_) => _GrowthEntrySheet(controller: controller, entry: entry),
    );

    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError || controller.child == null) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = _content(context, controller, openSheet);
    }
    return BaseScaffold(
      backgroundColor: kColorBgFFFBF7,
      appBar: const AppTopBar(),
      body: body,
      floatingActionButton: controller.loaded && !controller.hasError
          ? FloatingActionButton.extended(
              backgroundColor: kColorPrimary600C2513F,
              foregroundColor: kColorWhite,
              onPressed: openSheet,
              icon: const Icon(LucideIcons.plus),
              label: Text(l10n.growthAdd),
            )
          : null,
    );
  }

  Widget _content(
    BuildContext context,
    GrowthController controller,
    void Function([GrowthEntry? entry]) openSheet,
  ) {
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final secondary = AppColors.resolve(context, kColorTextSecondary6B625B);
    String kg(String value) => l10n.growthKg(value);
    String cm(String value) => l10n.growthCm(value);
    String valueLine(GrowthEntry entry) => [
      if (GrowthController.valueOf(entry, GrowthMetric.weight) case final w?)
        kg(_GrowthChart.number(w, locale)),
      if (GrowthController.valueOf(entry, GrowthMetric.height) case final h?)
        cm(_GrowthChart.number(h, locale)),
    ].join(' · ');
    final items = <Widget>[
      Text(
        l10n.growthTitle,
        style: AppTypography.adapt(
          context,
          AppTypography.display.copyWith(fontSize: 24),
        ),
      ),
      Text(
        controller.child!.name,
        style: AppTypography.adapt(
          context,
          AppTypography.text14.copyWith(color: secondary),
        ),
      ),
      if (controller.entries.isEmpty)
        EmptyState(
          title: l10n.growthEmpty,
          actionLabel: l10n.growthAdd,
          actionIcon: LucideIcons.plus,
          onAction: openSheet,
        )
      else ...[
        SegmentedTabs(
          labels: [l10n.growthWeight, l10n.growthHeight],
          selectedIndex: controller.metric.index,
          onChanged: (index) =>
              controller.setMetric(GrowthMetric.values[index]),
        ),
        AppCard(
          child: _GrowthChart(
            points: controller.points,
            unit: controller.metric == GrowthMetric.weight ? kg : cm,
          ),
        ),
      ],
      AppInfoNote(
        icon: LucideIcons.info,
        text: l10n.growthDisclaimer,
        background: kColorSurfaceVariantF7F1EC,
        iconColor: kColorTextSecondary6B625B,
      ),
      for (final entry in controller.history)
        AppCard(
          onTap: () => openSheet(entry),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.date.toFormDate(locale),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.small.copyWith(color: secondary),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      valueLine(entry),
                      style: AppTypography.adapt(
                        context,
                        AppTypography.bodyStrong,
                      ),
                    ),
                    if (entry.note != null) ...[
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        entry.note!,
                        style: AppTypography.adapt(
                          context,
                          AppTypography.small.copyWith(color: secondary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (entry.pending)
                AppTagPill(
                  label: l10n.growthPending,
                  icon: LucideIcons.cloudOff,
                  dense: true,
                ),
            ],
          ),
        ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.lock,
            size: 12,
            color: AppColors.resolve(context, kColorTextTertiary9C928A),
          ),
          const SizedBox(width: AppSpacing.compact),
          Flexible(
            child: Text(
              l10n.growthPrivacy,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(context, AppTypography.tiny),
            ),
          ),
        ],
      ),
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        96 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.itemGap),
          items[index],
        ],
      ],
    );
  }
}
