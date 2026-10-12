import 'package:baby_family/page/parent/pending_invites/pending_invites_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-05 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class PendingInvitesMobileView extends HookConsumerWidget {
  const PendingInvitesMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pendingInvitesControllerProvider);
    return AppSkeletonScreen(
      code: 'FAM-05',
      title: context.l10n.familyPendingInvitesTitle,
    );
  }
}
