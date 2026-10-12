import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/chapter_summary.dart';
import 'package:baby_family/data/model/memory/collection_summary.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/page/parent/memories_tab/memories_tab_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/extension/string.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/memory_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_chip.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/empty_state.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_card.dart';
import 'package:baby_family/utils/widget/memory_grid_tile.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/quote_card.dart';
import 'package:baby_family/utils/widget/underline_tabs.dart';
import 'package:baby_family/utils/widget/voice_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/chapter_card.dart';
part '../widgets/child_header.dart';
part '../widgets/collection_card.dart';
part '../widgets/collections_view.dart';
part '../widgets/memories_app_bar.dart';
part '../widgets/milestone_memory_card.dart';
part '../widgets/photos_grid_view.dart';
part '../widgets/tagged_memory_card.dart';
part '../widgets/timeline_memory.dart';
part '../widgets/timeline_view.dart';

/// MEM-01 Ký ức (Pencil `wtBRl`, tối `bPN4M`): app bar, tab con Dòng thời
/// gian • Ảnh (MEM-02) • Bộ sưu tập (MEM-22 `xVFHt`).
class MemoriesTabMobileView extends HookConsumerWidget {
  const MemoriesTabMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(memoriesTabControllerProvider);
    final l10n = context.l10n;
    final Widget body;
    if (!controller.loaded) {
      body = const Padding(
        padding: EdgeInsets.all(AppSpacing.screen),
        child: MemoryListSkeleton(),
      );
    } else if (controller.hasError) {
      body = ErrorState(onRetry: controller.load);
    } else {
      body = switch (controller.tabIndex) {
        1 => _PhotosGridView(controller: controller),
        2 => _CollectionsView(controller: controller),
        _ => _TimelineView(controller: controller),
      };
    }
    return BaseScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            bottom: false,
            child: _MemoriesAppBar(controller: controller),
          ),
          UnderlineTabs(
            labels: [
              l10n.memoriesTimeline,
              l10n.memoriesPhotos,
              l10n.memoriesCollections,
            ],
            selectedIndex: controller.tabIndex,
            onChanged: controller.selectTab,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// Đệm cuối danh sách: chừa thanh tab của shell (extendBody).
EdgeInsets _listPadding(BuildContext context, {double top = 16}) =>
    EdgeInsets.fromLTRB(
      AppSpacing.screen,
      top,
      AppSpacing.screen,
      AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
    );
