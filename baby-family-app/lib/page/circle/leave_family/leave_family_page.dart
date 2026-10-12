import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/leave_family/mobile/leave_family_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-10
@RoutePage()
class LeaveFamilyPage extends BaseHookWidget {
  const LeaveFamilyPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const LeaveFamilyMobileView();
  }
}
