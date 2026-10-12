import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/weekly_recap/mobile/weekly_recap_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-02
@RoutePage()
class WeeklyRecapPage extends BaseHookWidget {
  const WeeklyRecapPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const WeeklyRecapMobileView();
  }
}
