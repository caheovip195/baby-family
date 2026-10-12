import 'package:baby_family/page/general/ai_settings/ai_settings_controller.dart';
import 'package:baby_family/utils/extension/l10n.dart';
import 'package:baby_family/utils/widget/app_skeleton_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-05 — khung màn hình (foundation batch 3). Agent khu vực thay bằng UI
/// theo Pencil.
class AiSettingsMobileView extends HookConsumerWidget {
  const AiSettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(aiSettingsControllerProvider);
    return AppSkeletonScreen(code: 'SET-05', title: context.l10n.settingsAi);
  }
}
