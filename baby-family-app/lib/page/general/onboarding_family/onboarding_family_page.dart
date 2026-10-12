import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/onboarding_family/mobile/onboarding_family_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-06
@RoutePage()
class OnboardingFamilyPage extends BaseHookWidget {
  const OnboardingFamilyPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const OnboardingFamilyMobileView();
  }
}
