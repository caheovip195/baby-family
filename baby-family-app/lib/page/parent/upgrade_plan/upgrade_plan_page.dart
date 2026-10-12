import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/upgrade_plan/mobile/upgrade_plan_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SUB-04
@RoutePage()
class UpgradePlanPage extends BaseHookWidget {
  const UpgradePlanPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const UpgradePlanMobileView();
  }
}
