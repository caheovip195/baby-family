import 'package:baby_family/page/parent/trash/trash_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-17 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class TrashMobileView extends HookConsumerWidget {
  const TrashMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(trashControllerProvider);
    return AppSkeletonScreen(code: 'MEM-17', title: context.l10n.memTrashTitle);
  }
}
