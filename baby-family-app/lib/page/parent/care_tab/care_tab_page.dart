import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/care_tab/mobile/care_tab_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-01
@RoutePage()
class CareTabPage extends BaseHookWidget {
  const CareTabPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CareTabMobileView();
  }
}
