import 'package:baby_family/page/general/blocked_people/blocked_people_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-13 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class BlockedPeopleMobileView extends HookConsumerWidget {
  const BlockedPeopleMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(blockedPeopleControllerProvider);
    return AppSkeletonScreen(
      code: 'SET-13',
      title: context.l10n.settingsBlockedTitle,
    );
  }
}
