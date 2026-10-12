import 'package:baby_family/page/parent/pending_review/pending_review_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-19 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class PendingReviewMobileView extends HookConsumerWidget {
  const PendingReviewMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pendingReviewControllerProvider);
    return AppSkeletonScreen(
      code: 'MEM-19',
      title: context.l10n.memPendingTitle,
    );
  }
}
