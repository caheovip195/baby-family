import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/home_tab/mobile/home_tab_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// HOME-01
@RoutePage()
class HomeTabPage extends BaseHookWidget {
  const HomeTabPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const HomeTabMobileView();
  }
}
