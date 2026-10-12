import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/plans/mobile/plans_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SUB-01
@RoutePage()
class PlansPage extends BaseHookWidget {
  const PlansPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const PlansMobileView();
  }
}
