import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/couple_week/mobile/couple_week_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-14
@RoutePage()
class CoupleWeekPage extends BaseHookWidget {
  const CoupleWeekPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CoupleWeekMobileView();
  }
}
