import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_child/mobile/circle_child_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-02
@RoutePage()
class CircleChildPage extends BaseHookWidget {
  const CircleChildPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CircleChildMobileView();
  }
}
