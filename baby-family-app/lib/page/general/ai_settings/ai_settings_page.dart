import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/ai_settings/mobile/ai_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-05
@RoutePage()
class AiSettingsPage extends BaseHookWidget {
  const AiSettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const AiSettingsMobileView();
  }
}
