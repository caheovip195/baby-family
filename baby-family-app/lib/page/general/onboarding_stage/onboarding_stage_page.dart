import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/onboarding_stage/mobile/onboarding_stage_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-04
@RoutePage()
class OnboardingStagePage extends BaseHookWidget {
  const OnboardingStagePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const OnboardingStageMobileView();
  }
}
