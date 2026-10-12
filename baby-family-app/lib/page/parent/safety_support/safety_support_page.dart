import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/safety_support/mobile/safety_support_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-13
@RoutePage()
class SafetySupportPage extends BaseHookWidget {
  const SafetySupportPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const SafetySupportMobileView();
  }
}
