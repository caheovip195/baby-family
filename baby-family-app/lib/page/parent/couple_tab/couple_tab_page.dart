import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/couple_tab/mobile/couple_tab_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-01
@RoutePage()
class CoupleTabPage extends BaseHookWidget {
  const CoupleTabPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CoupleTabMobileView();
  }
}
