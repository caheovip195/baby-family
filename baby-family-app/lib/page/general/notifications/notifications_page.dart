import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/notifications/mobile/notifications_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// NOTI-01
@RoutePage()
class NotificationsPage extends BaseHookWidget {
  const NotificationsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const NotificationsMobileView();
  }
}
