import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/mission_library/mobile/mission_library_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-04
@RoutePage()
class MissionLibraryPage extends BaseHookWidget {
  const MissionLibraryPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const MissionLibraryMobileView();
  }
}
