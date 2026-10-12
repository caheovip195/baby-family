import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/display_settings/mobile/display_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-06
@RoutePage()
class DisplaySettingsPage extends BaseHookWidget {
  const DisplaySettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const DisplaySettingsMobileView();
  }
}
