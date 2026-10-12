import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/welcome/mobile/welcome_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ONB-01
@RoutePage()
class WelcomePage extends BaseHookWidget {
  const WelcomePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const WelcomeMobileView();
  }
}
