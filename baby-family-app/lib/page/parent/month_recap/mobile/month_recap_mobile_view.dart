import 'package:baby_family/page/parent/month_recap/month_recap_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-03 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class MonthRecapMobileView extends HookConsumerWidget {
  const MonthRecapMobileView({this.childId, super.key});

  final String? childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(monthRecapControllerProvider);
    return AppSkeletonScreen(
      code: 'REC-03',
      title: context.l10n.recapMonthTitle,
    );
  }
}
