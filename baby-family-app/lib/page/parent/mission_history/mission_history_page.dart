import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/mission_history/mobile/mission_history_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-08
@RoutePage()
class MissionHistoryPage extends BaseHookWidget {
  const MissionHistoryPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const MissionHistoryMobileView();
  }
}
