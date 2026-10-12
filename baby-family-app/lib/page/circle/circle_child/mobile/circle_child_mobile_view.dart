import 'package:baby_family/page/circle/circle_child/circle_child_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-02 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class CircleChildMobileView extends HookConsumerWidget {
  const CircleChildMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(circleChildControllerProvider);
    return AppSkeletonScreen(
      code: 'CIR-02',
      title: context.l10n.circleTabMemories,
      showBack: false,
    );
  }
}
