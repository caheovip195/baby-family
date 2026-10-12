import 'package:baby_family/page/circle/circle_me/circle_me_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-06 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class CircleMeMobileView extends HookConsumerWidget {
  const CircleMeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(circleMeControllerProvider);
    return AppSkeletonScreen(
      code: 'CIR-06',
      title: context.l10n.circleTabMe,
      showBack: false,
    );
  }
}
