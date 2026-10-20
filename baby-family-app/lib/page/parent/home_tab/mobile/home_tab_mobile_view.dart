import 'package:auto_route/auto_route.dart';
import 'package:baby_family/data/model/care/family_tree.dart';
import 'package:baby_family/data/model/child/child.dart';
import 'package:baby_family/data/model/memory/chapter_summary.dart';
import 'package:baby_family/data/model/memory/memory.dart';
import 'package:baby_family/data/model/memory/milestone_item.dart';
import 'package:baby_family/data/model/memory/week_summary.dart';
import 'package:baby_family/data/model/pregnancy/prep_item.dart';
import 'package:baby_family/data/model/us/mood_checkin.dart';
import 'package:baby_family/data/provider/connectivity.dart';
import 'package:baby_family/gen/assets.gen.dart';
import 'package:baby_family/page/parent/home_tab/home_tab_controller.dart';
import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/extension/date_time.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/app_snack_bar.dart';
import 'package:baby_family/utils/helper/child_age.dart';
import 'package:baby_family/utils/helper/media_image.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/plan_text.dart';
import 'package:baby_family/utils/helper/relative_time.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/router/app_router.dart';
import 'package:baby_family/utils/widget/app_card.dart';
import 'package:baby_family/utils/widget/app_pill_button.dart';
import 'package:baby_family/utils/widget/app_progress_bar.dart';
import 'package:baby_family/utils/widget/child_avatar.dart';
import 'package:baby_family/utils/widget/child_switcher.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_card.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/mission_card.dart';
import 'package:baby_family/utils/widget/offline_banner.dart';
import 'package:baby_family/utils/widget/plan_status_banner.dart';
import 'package:baby_family/utils/widget/quote_card.dart';
import 'package:baby_family/utils/widget/section_header.dart';
import 'package:baby_family/utils/widget/story_ring.dart';
import 'package:baby_family/utils/widget/switch_family_sheet.dart';
import 'package:baby_family/utils/widget/voice_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

part '../widgets/both_tell_card.dart';
part '../widgets/bump_row.dart';
part '../widgets/chapter_card.dart';
part '../widgets/child_cover.dart';
part '../widgets/child_home.dart';
part '../widgets/couple_card.dart';
part '../widgets/family_home.dart';
part '../widgets/firsts_row.dart';
part '../widgets/group_card.dart';
part '../widgets/home_app_bar.dart';
part '../widgets/home_shell.dart';
part '../widgets/labeled_photo.dart';
part '../widgets/monthly_day_card.dart';
part '../widgets/monthly_row.dart';
part '../widgets/names_card.dart';
part '../widgets/photo.dart';
part '../widgets/pregnancy_firsts.dart';
part '../widgets/pregnancy_hero.dart';
part '../widgets/pregnancy_home.dart';
part '../widgets/prep_card.dart';
part '../widgets/prompt_card.dart';
part '../widgets/quick_action_tile.dart';
part '../widgets/story_row.dart';
part '../widgets/today_missions_card.dart';
part '../widgets/tree_mini_card.dart';
part '../widgets/week_card.dart';

/// Khoảng cách giữa các khối nội dung HOME-01/03 (Pencil gap 18) và HOME-02
/// (gap 20).
const _blockGap = AppSpacing.sectionGap;
const _childBlockGap = AppSpacing.s5;

/// Trang chủ: HOME-01 (Cả nhà), HOME-02 (bé đã sinh), HOME-03 (thai kỳ) theo
/// chủ thể chọn ở SW-01. Nằm trong Main shell (thanh tab `extendBody`).
class HomeTabMobileView extends HookConsumerWidget {
  const HomeTabMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(homeTabControllerProvider);
    final offline = ref.watch(isOfflineProvider).value ?? false;
    final subject = controller.subject;
    final Widget body;
    if (!controller.loaded && controller.hasError) {
      body = _HomeShell(
        controller: controller,
        offline: offline,
        child: Center(child: ErrorState(onRetry: controller.load)),
      );
    } else if (!controller.loaded) {
      body = _HomeShell(
        controller: controller,
        offline: offline,
        child: const MemoryListSkeleton(),
      );
    } else if (subject == null) {
      body = _FamilyHome(controller: controller, offline: offline);
    } else if (subject.isPregnancy) {
      body = _PregnancyHome(
        controller: controller,
        pregnancy: subject,
        offline: offline,
      );
    } else {
      body = _ChildHome(controller: controller, child: subject);
    }
    return ColoredBox(
      color: AppColors.resolve(context, kColorBgFFFBF7),
      child: body,
    );
  }
}

/// Khối nội dung cuộn chung: đệm 4/20/24/20 + chừa thanh tab dưới.
List<Widget> _spaced(List<Widget> children, double gap) => [
  for (var index = 0; index < children.length; index++) ...[
    if (index > 0) SizedBox(height: gap),
    children[index],
  ],
];

EdgeInsets _contentPadding(BuildContext context, {double top = 4}) =>
    EdgeInsets.fromLTRB(
      AppSpacing.screen,
      top,
      AppSpacing.screen,
      AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
    );

void _openTab(BuildContext context, MainTab tab) =>
    AutoTabsRouter.of(context).setActiveIndex(tab.index);
