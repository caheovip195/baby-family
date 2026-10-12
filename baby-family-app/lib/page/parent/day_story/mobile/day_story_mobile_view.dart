import 'package:baby_family/page/parent/day_story/day_story_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-01 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class DayStoryMobileView extends HookConsumerWidget {
  const DayStoryMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dayStoryControllerProvider);
    return AppSkeletonScreen(code: 'REC-01', title: context.l10n.recapDayTitle);
  }
}
