import 'package:baby_family/page/parent/care_stats/care_stats_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-11 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class CareStatsMobileView extends HookConsumerWidget {
  const CareStatsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(careStatsControllerProvider);
    return AppSkeletonScreen(
      code: 'CARE-11',
      title: context.l10n.careStatsTitle,
    );
  }
}
