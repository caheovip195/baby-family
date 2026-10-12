import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/parent/mission_library/mission_library_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/helper/mission_text.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/app_top_bar.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:baby_family/utils/widget/error_state.dart';
import 'package:baby_family/utils/widget/memory_list_skeleton.dart';
import 'package:baby_family/utils/widget/mission_template_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-04 — không có frame Pencil: dựng từ dòng mẫu của CARE-05
/// (`MissionTemplateTile`). Chạm một mẫu → quay lại CARE-03 với mẫu đó.
class MissionLibraryMobileView extends HookConsumerWidget {
  const MissionLibraryMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(missionLibraryControllerProvider);
    final templates = controller.templates;
    final l10n = context.l10n;
    Widget body;
    if (templates == null) {
      body = controller.hasError
          ? Center(child: ErrorState(onRetry: controller.load))
          : const SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.screen),
              child: MemoryListSkeleton(),
            );
    } else {
      body = ListView.separated(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s1,
          AppSpacing.screen,
          AppSpacing.s6 + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: templates.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.itemGap),
        itemBuilder: (context, index) {
          final template = templates[index];
          return MissionTemplateTile(
            icon: missionIcon(template.icon),
            title: template.title,
            meta: missionTemplateMeta(l10n, template),
            hearts: template.hearts,
            onTap: () => context.router.maybePop(template.id),
          );
        },
      );
    }
    return BaseScaffold(
      appBar: AppTopBar(title: l10n.careLibraryTitle),
      body: body,
    );
  }
}
