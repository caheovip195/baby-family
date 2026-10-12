import 'package:baby_family/page/parent/safety_support/safety_support_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-13 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class SafetySupportMobileView extends HookConsumerWidget {
  const SafetySupportMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(safetySupportControllerProvider);
    return AppSkeletonScreen(code: 'US-13', title: context.l10n.usSafetyTitle);
  }
}
