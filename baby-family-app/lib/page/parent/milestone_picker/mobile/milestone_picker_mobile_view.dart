import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/memory/milestone_option.dart';
import 'package:baby_family/page/parent/milestone_picker/milestone_picker_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_back_title_bar.dart';
import 'package:baby_family/utils/widget/app_grouped_list.dart';
import 'package:baby_family/utils/widget/app_text_input_sheet.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/custom_milestone_button.dart';
part '../widgets/milestone_group_tab.dart';
part '../widgets/milestone_row.dart';
part '../widgets/milestone_search_field.dart';

/// MEM-11 Chọn cột mốc (Pencil `FJGSB`). Chọn một mục → đóng màn và trả
/// [MilestoneOption] cho MEM-05.
class MilestonePickerMobileView extends HookConsumerWidget {
  const MilestonePickerMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(milestonePickerControllerProvider(childId));
    final l10n = context.l10n;
    final Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = _content(context, controller);
    }
    return BaseScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBackTitleBar(
            title: l10n.memChooseMilestone,
            trailing: controller.children.isEmpty
                ? null
                : ChildSwitcher(
                    children: controller.children,
                    selectedId: controller.child?.id,
                    today: controller.today,
                    onChanged: controller.selectChild,
                  ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, MilestonePickerController controller) {
    final l10n = context.l10n;
    final searching = controller.query.trim().isNotEmpty;
    final options = controller.visibleOptions;
    final group = controller.group;
    void pick(MilestoneOption option) => context.router.maybePop(option);
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s1,
        AppSpacing.screen,
        AppSpacing.s5 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        _MilestoneSearchField(onChanged: controller.search),
        const SizedBox(height: AppSpacing.s3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in controller.groups) ...[
                if (item != controller.groups.first)
                  const SizedBox(width: AppSpacing.compact),
                _MilestoneGroupTab(
                  label: '${item.emoji} ${item.title}'.trim(),
                  selected: !searching && item.code == controller.groupCode,
                  onTap: () => controller.selectGroup(item.code),
                ),
              ],
            ],
          ),
        ),
        if (!searching && group != null) ...[
          const SizedBox(height: AppSpacing.s3),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s1),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    group.title,
                    style: AppTypography.adapt(
                      context,
                      AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 25 / 18,
                      ),
                    ),
                  ),
                ),
                Text(
                  l10n.memMilestoneRecordedCount(
                    controller.groupRecorded,
                    controller.groupTotal,
                  ),
                  style: AppTypography.adapt(
                    context,
                    AppTypography.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kColorTextTertiary9C928A,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.s3),
        if (options.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
            child: Text(
              l10n.memMilestoneNoResult,
              textAlign: TextAlign.center,
              style: AppTypography.adapt(context, AppTypography.caption),
            ),
          )
        else
          AppGroupedList(
            children: [
              for (var index = 0; index < options.length; index++)
                _MilestoneRow(
                  option: options[index],
                  index: index,
                  recordedLabel: options[index].recordedAt == null
                      ? null
                      : l10n.memMilestoneRecordedAt(
                          options[index].recordedAt!.toFormDate(
                            l10n.localeName,
                          ),
                        ),
                  onTap: () => pick(options[index]),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.s3),
        _CustomMilestoneButton(
          onTap: () async {
            final title = await showAppTextInputSheet(
              context,
              title: l10n.memMilestoneCustom,
              hint: l10n.memMilestoneCustomHint,
              actionLabel: l10n.commonSave,
            );
            if (title != null) {
              pick(controller.custom(title));
            }
          },
        ),
      ],
    );
  }
}
