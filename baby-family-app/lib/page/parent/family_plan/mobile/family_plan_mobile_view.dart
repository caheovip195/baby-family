import 'package:baby_family/page/parent/family_plan/family_plan_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SUB-03 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class FamilyPlanMobileView extends HookConsumerWidget {
  const FamilyPlanMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(familyPlanControllerProvider);
    return AppSkeletonScreen(
      code: 'SUB-03',
      title: context.l10n.billingPlanTitle,
    );
  }
}
