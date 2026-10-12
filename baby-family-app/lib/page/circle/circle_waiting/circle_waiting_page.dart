import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_waiting/mobile/circle_waiting_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-WAIT
@RoutePage()
class CircleWaitingPage extends BaseHookWidget {
  const CircleWaitingPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CircleWaitingMobileView();
  }
}
