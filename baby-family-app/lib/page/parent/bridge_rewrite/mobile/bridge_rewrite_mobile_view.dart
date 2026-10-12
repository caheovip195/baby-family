import 'package:baby_family/page/parent/bridge_rewrite/bridge_rewrite_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-09 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class BridgeRewriteMobileView extends HookConsumerWidget {
  const BridgeRewriteMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bridgeRewriteControllerProvider);
    return AppSkeletonScreen(
      code: 'US-09',
      title: context.l10n.usBridgeRewriteTitle,
    );
  }
}
