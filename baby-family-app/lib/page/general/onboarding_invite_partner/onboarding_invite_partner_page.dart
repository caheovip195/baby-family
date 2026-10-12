import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/onboarding_invite_partner/mobile/onboarding_invite_partner_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-07
@RoutePage()
class OnboardingInvitePartnerPage extends BaseHookWidget {
  const OnboardingInvitePartnerPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const OnboardingInvitePartnerMobileView();
  }
}
