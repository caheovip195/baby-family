import 'package:baby_family/page/parent/drafts/drafts_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-18 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class DraftsMobileView extends HookConsumerWidget {
  const DraftsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(draftsControllerProvider);
    return AppSkeletonScreen(
      code: 'MEM-18',
      title: context.l10n.memDraftsTitle,
    );
  }
}
