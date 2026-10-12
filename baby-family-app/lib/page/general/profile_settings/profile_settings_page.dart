import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/profile_settings/mobile/profile_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-02
@RoutePage()
class ProfileSettingsPage extends BaseHookWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const ProfileSettingsMobileView();
  }
}
