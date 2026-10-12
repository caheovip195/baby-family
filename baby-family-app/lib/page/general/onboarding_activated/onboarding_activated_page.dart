import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/onboarding_activated/mobile/onboarding_activated_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-ACT
@RoutePage()
class OnboardingActivatedPage extends BaseHookWidget {
  const OnboardingActivatedPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const OnboardingActivatedMobileView();
  }
}
