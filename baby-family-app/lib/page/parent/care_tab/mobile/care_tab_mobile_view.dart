import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/care/mission.dart';
import 'package:baby_family/data/model/care/mission_template.dart';
import 'package:baby_family/data/model/us/couple_request.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/parent/care_tab/care_tab_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/care_more_sheet.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/mission_card.dart';
import 'package:baby_family/utils/widget/mission_completion_sheet.dart';
import 'package:baby_family/utils/widget/mission_swap_sheet.dart';
import 'package:baby_family/utils/widget/mission_template_tile.dart';
import 'package:baby_family/utils/widget/segmented_tabs.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/care_add_fab.dart';
part '../widgets/care_all_done_banner.dart';
part '../widgets/care_empty_board.dart';
part '../widgets/care_frame.dart';
part '../widgets/care_header.dart';
part '../widgets/care_mission_list.dart';
part '../widgets/care_my_hearts_row.dart';
part '../widgets/care_open_request_row.dart';
part '../widgets/care_partner_note.dart';
part '../widgets/care_tree_card.dart';
part '../widgets/care_week_strip.dart';

/// CARE-01 “Chăm con hôm nay” (Pencil `jhh4V` Của tôi, `qkr1a` Của bạn đời,
/// dark `J0I7c`) + STATE-03 (`ghZZx`). Tab của main shell.
class CareTabMobileView extends HookConsumerWidget {
  const CareTabMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(careTabControllerProvider);
    final board = controller.board;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final header = _CareHeader(controller: controller);
    final partnerTab = controller.tabIndex == 1;

    Widget body;
    if (board == null) {
      body = controller.hasError
          ? Center(child: ErrorState(onRetry: controller.load))
          : const SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.screen),
              child: MemoryListSkeleton(),
            );
    } else if (board.isEmpty && controller.isToday) {
      // STATE-03: không có dải ngày, không có nút thêm (Pencil `ghZZx`).
      return _CareFrame(
        children: [
          _CareHeader(controller: controller, showCalendar: false),
          Expanded(
            child: _CareEmptyBoard(
              controller: controller,
              bottomInset: bottomInset,
            ),
          ),
        ],
      );
    } else {
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          72 + bottomInset,
        ),
        children: [
          _CareTreeCard(
            done: board.doneCount,
            total: board.totalCount,
            onTap: () => context.router.push(const FamilyTreeRoute()),
          ),
          // Tab Của bạn đời (Pencil `qkr1a`) không có dòng lời nhờ / nút thêm.
          if (controller.openRequests.isNotEmpty && !partnerTab) ...[
            const SizedBox(height: AppSpacing.s3),
            _CareOpenRequestRow(
              request: controller.openRequests.first,
              count: controller.openRequests.length,
              fromPartner: controller.isFromPartner(
                controller.openRequests.first,
              ),
              partnerCallName: controller.partnerCallName,
              onTap: () => context.router.push(
                RequestDetailRoute(requestId: controller.openRequests.first.id),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s3),
          SegmentedTabs(
            labels: [
              context.l10n.commonMine,
              context.l10n.carePartnerTab(controller.partnerCallName),
              context.l10n.careTogether,
            ],
            counts: [
              _countLabel(board.mine),
              _countLabel(board.partner),
              _countLabel(board.together),
            ],
            selectedIndex: controller.tabIndex,
            onChanged: controller.selectTab,
          ),
          const SizedBox(height: AppSpacing.s3),
          _CareMissionList(controller: controller),
        ],
      );
    }

    return _CareFrame(
      children: [
        header,
        _CareWeekStrip(controller: controller),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: body),
              if (board != null && !partnerTab)
                PositionedDirectional(
                  end: 17,
                  bottom: 26 + bottomInset,
                  child: _CareAddFab(
                    onTap: () => context.router.push(
                      MissionCreateRoute(childId: controller.subjectId),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static String _countLabel(List<Mission> missions) =>
      '${missions.where((mission) => mission.isDone).length}/${missions.length}';
}

/// Chạm ✓ → CARE-06 → snackbar hoàn tác (mục 7.13.4).
Future<void> _completeMission(
  BuildContext context,
  CareTabController controller,
  Mission mission,
) async {
  final completion = await controller.complete(mission);
  if (completion == null || !context.mounted) {
    return;
  }
  await runMissionCompletionFlow(
    context,
    completion: completion,
    now: controller.now,
    onUndo: () => controller.undo(mission.id),
    onSaveMoment: (note) => controller.saveMoment(mission.id, note: note),
  );
}

/// CARE-05: đổi nhiệm vụ hệ thống của tôi (nhấn giữ thẻ).
Future<void> _openSwap(
  BuildContext context,
  CareTabController controller,
  Mission mission,
) async {
  final option = await controller.swapOptions(mission.id);
  if (!context.mounted) {
    return;
  }
  await showMissionSwapSheet(
    context,
    mission: mission,
    option: option,
    onSwap: (templateId) => controller.swap(mission.id, templateId),
    onRemove: () => controller.removeFromToday(mission.id),
  );
}
