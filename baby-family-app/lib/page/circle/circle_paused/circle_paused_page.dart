import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_paused/mobile/circle_paused_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-05
@RoutePage()
class CirclePausedPage extends BaseHookWidget {
  const CirclePausedPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CirclePausedMobileView();
  }
}
