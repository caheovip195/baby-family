import 'package:baby_family/page/parent/bridge_next_step/bridge_next_step_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-12 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class BridgeNextStepMobileView extends HookConsumerWidget {
  const BridgeNextStepMobileView({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bridgeNextStepControllerProvider);
    return AppSkeletonScreen(
      code: 'US-12',
      title: context.l10n.usBridgeNextStepTitle,
    );
  }
}
