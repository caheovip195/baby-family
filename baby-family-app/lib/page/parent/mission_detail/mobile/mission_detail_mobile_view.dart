import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/mission_detail/mission_detail_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/loading_progress.dart';
import 'package:baby_family/utils/widget/mission_completion_sheet.dart';
import 'package:baby_family/utils/widget/mission_swap_sheet.dart';
import 'package:baby_family/utils/widget/mission_template_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/detail_info_row.dart';

/// CARE-02 — không có frame Pencil: dựng từ thẻ mẫu (CARE-05) + `AppCard`
/// + nút chuẩn. Mở từ thẻ nhiệm vụ ở CARE-01.
class MissionDetailMobileView extends HookConsumerWidget {
  const MissionDetailMobileView({required this.missionId, super.key});

  final String missionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(missionDetailControllerProvider);
    useEffect(() {
      controller.init(missionId);
      return null;
    }, [missionId]);
    final l10n = context.l10n;
    final mission = controller.mission;

    Future<void> complete() async {
      final completion = await controller.complete();
      if (completion == null || !context.mounted) {
        return;
      }
      await runMissionCompletionFlow(
        context,
        completion: completion,
        now: controller.now,
        onUndo: controller.undo,
        onSaveMoment: controller.saveMoment,
      );
    }

    Future<void> swap() async {
      final option = await controller.swapOptions();
      if (!context.mounted || mission == null) {
        return;
      }
      await showMissionSwapSheet(
        context,
        mission: mission,
        option: option,
        onSwap: controller.swap,
        onRemove: controller.removeFromToday,
      );
    }

    Future<void> remove() async {
      final router = context.router;
      await controller.removeFromToday();
      await router.maybePop();
    }

    Widget body;
    if (!controller.loaded) {
      body = const Center(child: CircleLoadingProgress());
    } else if (mission == null) {
      body = Center(child: EmptyState(title: l10n.careMissionNotFound));
    } else {
      final owner = switch (mission.ownerKind) {
        MissionOwnerKind.me => l10n.careMine,
        MissionOwnerKind.partner => controller.partnerCallName,
        MissionOwnerKind.together => l10n.careTogether,
      };
      final names = controller.missionChildren.map((c) => c.name).toList();
      final time = <String>[
        if (mission.dueTime != null) mission.dueTime!,
        if (mission.durationMin != null)
          l10n.careDurationMin(mission.durationMin!),
      ];
      body = ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          MissionTemplateTile(
            icon: missionIcon(mission.icon),
            title: mission.title,
            meta: careMissionMetaText(l10n, mission),
          ),
          const SizedBox(height: AppSpacing.s3),
          AppCard(
            child: Column(
              children: [
                _DetailInfoRow(
                  icon: LucideIcons.user,
                  label: l10n.careOwnerLabel,
                  value: owner,
                ),
                _DetailInfoRow(
                  icon: LucideIcons.baby,
                  label: l10n.careChildLabel,
                  value: names.isEmpty
                      ? l10n.commonAllFamily
                      : names.join(', '),
                ),
                if (time.isNotEmpty)
                  _DetailInfoRow(
                    icon: LucideIcons.clock8,
                    label: l10n.careTimeLabel,
                    value: time.reduce(l10n.commonDotJoin),
                  ),
                _DetailInfoRow(
                  icon: LucideIcons.tag,
                  label: l10n.careCategory(mission.category.name),
                  value: '',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s5),
          if (!controller.isPartner && !mission.isDone)
            AppButton(
              label: mission.ownerKind == MissionOwnerKind.together
                  ? l10n.careDoneTogether
                  : l10n.careComplete,
              icon: LucideIcons.check,
              isLoading: controller.isLoading,
              onPressed: complete,
            ),
          if (controller.canSwap) ...[
            const SizedBox(height: AppSpacing.s3),
            AppButton.secondary(
              label: l10n.careSwapAction,
              icon: LucideIcons.repeat,
              onPressed: swap,
            ),
          ],
          if (controller.isMine && !mission.isDone) ...[
            const SizedBox(height: AppSpacing.s2),
            AppButton.text(
              label: l10n.careRemoveToday,
              icon: LucideIcons.calendarX,
              color: kColorTextSecondary6B625B,
              onPressed: remove,
            ),
          ],
          if (controller.isPartner && mission.isDone)
            AppButton.secondary(
              label: mission.thankedByPartner
                  ? l10n.careThanked
                  : l10n.careThank,
              icon: LucideIcons.heart,
              onPressed: mission.thankedByPartner ? null : controller.thank,
            ),
        ],
      );
    }
    return BaseScaffold(
      appBar: AppTopBar(title: l10n.careDetailTitle),
      body: body,
    );
  }
}
