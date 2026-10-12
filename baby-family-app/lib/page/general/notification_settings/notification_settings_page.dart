import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/notification_settings/mobile/notification_settings_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-03
@RoutePage()
class NotificationSettingsPage extends BaseHookWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const NotificationSettingsMobileView();
  }
}
