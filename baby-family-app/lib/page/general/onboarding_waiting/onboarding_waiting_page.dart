import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/onboarding_waiting/mobile/onboarding_waiting_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-WAIT
@RoutePage()
class OnboardingWaitingPage extends BaseHookWidget {
  const OnboardingWaitingPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const OnboardingWaitingMobileView();
  }
}
