import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/dto/pregnancy_timeline_week.dart';
import 'package:baby_family/data/model/memory/bump_photo.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/pregnancy/prep_item.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/parent/pregnancy_journey/pregnancy_journey_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/form_date.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_bottom_sheet.dart';
import 'package:baby_family/utils/widget/app_button.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/app_switch.dart';
import 'package:baby_family/utils/widget/app_text_field.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/add_prep_sheet.dart';
part '../widgets/bump_compare_card.dart';
part '../widgets/bump_tab.dart';
part '../widgets/bump_tile.dart';
part '../widgets/edit_pregnancy_sheet.dart';
part '../widgets/journey_header.dart';
part '../widgets/journey_menu_sheet.dart';
part '../widgets/journey_tabs.dart';
part '../widgets/journey_top_bar.dart';
part '../widgets/milestone_card.dart';
part '../widgets/photo_week_label.dart';
part '../widgets/prep_group_card.dart';
part '../widgets/prep_owner_sheet.dart';
part '../widgets/prep_progress_card.dart';
part '../widgets/prep_tab.dart';
part '../widgets/timeline_bump_slot.dart';
part '../widgets/timeline_memory_card.dart';
part '../widgets/timeline_tab.dart';
part '../widgets/ultrasound_card.dart';
part '../widgets/ultrasound_tab.dart';
part '../widgets/week_header.dart';

/// PREG-01 (mXdfI) / PREG-02 (L5bfc) / PREG-03 / PREG-04 (PUD9i) — Hành trình
/// thai kỳ: thanh trên (back · “Hành trình của Bơ” · ⋯), header tuần thai
/// (chỉ tab Dòng thời gian), tab gạch chân tím, nội dung theo tab.
class PregnancyJourneyMobileView extends HookConsumerWidget {
  const PregnancyJourneyMobileView({
    required this.pregnancyId,
    this.tab,
    super.key,
  });

  final String pregnancyId;
  final String? tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(pregnancyJourneyControllerProvider);
    useEffect(() {
      Future.microtask(() => controller.init(pregnancyId, tab));
      return null;
    }, [pregnancyId]);
    final child = controller.child;
    return BaseScaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _JourneyTopBar(
              title: child == null
                  ? ''
                  : context.l10n.pregJourneyTitle(child.name),
              onMenu: child == null
                  ? null
                  : () => _openMenu(context, controller),
            ),
            if (child != null && controller.tab == PregnancyTab.timeline)
              _JourneyHeader(controller: controller),
            _JourneyTabs(
              selected: controller.tab,
              onSelected: controller.selectTab,
            ),
            Expanded(child: _body(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, PregnancyJourneyController controller) {
    if (!controller.isLoaded) {
      if (controller.hasError) {
        return Center(child: ErrorState(onRetry: controller.load));
      }
      return const SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.screen),
        child: MemoryListSkeleton(),
      );
    }
    return switch (controller.tab) {
      PregnancyTab.timeline => _TimelineTab(controller: controller),
      PregnancyTab.bump => _BumpTab(controller: controller),
      PregnancyTab.ultrasound => _UltrasoundTab(controller: controller),
      PregnancyTab.prep => _PrepTab(controller: controller),
    };
  }

  Future<void> _openMenu(
    BuildContext context,
    PregnancyJourneyController controller,
  ) {
    return showAppBottomSheet<void>(
      context,
      builder: (_) => _JourneyMenuSheet(
        onEdit: () => showAppBottomSheet<void>(
          context,
          builder: (_) => _EditPregnancySheet(controller: controller),
        ),
        onArchive: () => context.router.push(
          PregnancyArchiveRoute(pregnancyId: pregnancyId),
        ),
        onBirth: () =>
            context.router.push(BirthRoute(pregnancyId: pregnancyId)),
      ),
    );
  }
}

/// Mở MEM-05 ghi ảnh bụng/siêu âm của thai kỳ (ô “Chụp”).
Future<void> _openComposer(
  BuildContext context,
  String pregnancyId,
  MemoryKind kind,
) async {
  await context.router.push(
    MemoryComposerRoute(kind: kind.name, childId: pregnancyId),
  );
}
