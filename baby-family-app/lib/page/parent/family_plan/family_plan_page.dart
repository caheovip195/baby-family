import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/family_plan/mobile/family_plan_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SUB-03
@RoutePage()
class FamilyPlanPage extends BaseHookWidget {
  const FamilyPlanPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const FamilyPlanMobileView();
  }
}
