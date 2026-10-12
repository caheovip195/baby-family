import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_me/mobile/circle_me_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-06
@RoutePage()
class CircleMePage extends BaseHookWidget {
  const CircleMePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CircleMeMobileView();
  }
}
