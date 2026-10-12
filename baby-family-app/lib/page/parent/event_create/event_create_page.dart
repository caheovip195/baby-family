import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/event_create/mobile/event_create_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CAL-02
@RoutePage()
class EventCreatePage extends BaseHookWidget {
  const EventCreatePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const EventCreateMobileView();
  }
}
