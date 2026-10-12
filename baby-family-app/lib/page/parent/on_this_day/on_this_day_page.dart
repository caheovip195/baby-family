import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/on_this_day/mobile/on_this_day_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-16
@RoutePage()
class OnThisDayPage extends BaseHookWidget {
  const OnThisDayPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const OnThisDayMobileView();
  }
}
