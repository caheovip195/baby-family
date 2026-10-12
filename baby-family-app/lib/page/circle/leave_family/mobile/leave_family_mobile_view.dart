import 'package:baby_family/page/circle/leave_family/leave_family_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-10 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class LeaveFamilyMobileView extends HookConsumerWidget {
  const LeaveFamilyMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(leaveFamilyControllerProvider);
    return AppSkeletonScreen(
      code: 'SET-10',
      title: context.l10n.circleLeaveTitle,
    );
  }
}
