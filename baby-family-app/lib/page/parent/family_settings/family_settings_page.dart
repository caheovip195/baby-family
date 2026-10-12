import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/family_settings/mobile/family_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-07
@RoutePage()
class FamilySettingsPage extends BaseHookWidget {
  const FamilySettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const FamilySettingsMobileView();
  }
}
