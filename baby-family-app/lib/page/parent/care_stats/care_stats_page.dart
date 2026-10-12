import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/care_stats/mobile/care_stats_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-11
@RoutePage()
class CareStatsPage extends BaseHookWidget {
  const CareStatsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CareStatsMobileView();
  }
}
