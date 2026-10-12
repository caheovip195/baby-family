import 'package:baby_family/page/circle/circle_memory_detail/circle_memory_detail_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-03 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class CircleMemoryDetailMobileView extends HookConsumerWidget {
  const CircleMemoryDetailMobileView({required this.memoryId, super.key});

  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(circleMemoryDetailControllerProvider);
    return AppSkeletonScreen(
      code: 'CIR-03',
      title: context.l10n.circleMemoryDetailTitle,
    );
  }
}
