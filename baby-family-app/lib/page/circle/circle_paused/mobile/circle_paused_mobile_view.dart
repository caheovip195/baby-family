import 'package:baby_family/page/circle/circle_paused/circle_paused_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-05 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class CirclePausedMobileView extends HookConsumerWidget {
  const CirclePausedMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(circlePausedControllerProvider);
    return AppSkeletonScreen(
      code: 'CIR-05',
      title: context.l10n.circlePausedTitle,
      showBack: false,
    );
  }
}
