import 'package:baby_family/page/parent/upgrade_plan/upgrade_plan_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SUB-04 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class UpgradePlanMobileView extends HookConsumerWidget {
  const UpgradePlanMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(upgradePlanControllerProvider);
    return AppSkeletonScreen(
      code: 'SUB-04',
      title: context.l10n.billingUpgrade,
    );
  }
}
