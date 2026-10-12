import 'package:baby_family/page/circle/circle_post/circle_post_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-04 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class CirclePostMobileView extends HookConsumerWidget {
  const CirclePostMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(circlePostControllerProvider);
    return AppSkeletonScreen(
      code: 'CIR-04',
      title: context.l10n.circlePostTitle,
      showBack: false,
    );
  }
}
