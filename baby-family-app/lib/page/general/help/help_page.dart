import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/help/mobile/help_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-11
@RoutePage()
class HelpPage extends BaseHookWidget {
  const HelpPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const HelpMobileView();
  }
}
