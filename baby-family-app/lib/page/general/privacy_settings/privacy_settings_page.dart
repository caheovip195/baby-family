import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/privacy_settings/mobile/privacy_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-04
@RoutePage()
class PrivacySettingsPage extends BaseHookWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const PrivacySettingsMobileView();
  }
}
