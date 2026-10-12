import 'package:baby_family/page/parent/child_archive/child_archive_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHD-05 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class ChildArchiveMobileView extends HookConsumerWidget {
  const ChildArchiveMobileView({required this.childId, super.key});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(childArchiveControllerProvider);
    return AppSkeletonScreen(
      code: 'CHD-05',
      title: context.l10n.childArchiveTitle,
    );
  }
}
