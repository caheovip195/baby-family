import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/onboarding_pregnancy/mobile/onboarding_pregnancy_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-05a
@RoutePage()
class OnboardingPregnancyPage extends BaseHookWidget {
  const OnboardingPregnancyPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const OnboardingPregnancyMobileView();
  }
}
