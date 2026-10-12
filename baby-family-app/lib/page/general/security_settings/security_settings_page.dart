import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/security_settings/mobile/security_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-07
@RoutePage()
class SecuritySettingsPage extends BaseHookWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const SecuritySettingsMobileView();
  }
}
