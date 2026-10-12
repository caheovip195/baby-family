import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/couple_settings/mobile/couple_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-15
@RoutePage()
class CoupleSettingsPage extends BaseHookWidget {
  const CoupleSettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CoupleSettingsMobileView();
  }
}
