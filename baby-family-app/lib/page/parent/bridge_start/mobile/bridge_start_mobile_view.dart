import 'package:baby_family/page/parent/bridge_start/bridge_start_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-08 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class BridgeStartMobileView extends HookConsumerWidget {
  const BridgeStartMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(bridgeStartControllerProvider);
    return AppSkeletonScreen(code: 'US-08', title: context.l10n.usBridgeShort);
  }
}
