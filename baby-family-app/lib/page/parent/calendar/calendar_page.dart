import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/calendar/mobile/calendar_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-07
@RoutePage()
class CalendarPage extends BaseHookWidget {
  const CalendarPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CalendarMobileView();
  }
}
