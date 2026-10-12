import 'package:baby_family/page/parent/couple_week/couple_week_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-14 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class CoupleWeekMobileView extends HookConsumerWidget {
  const CoupleWeekMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(coupleWeekControllerProvider);
    return AppSkeletonScreen(code: 'US-14', title: context.l10n.usWeekShort);
  }
}
