import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/growth/mobile/growth_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHD-06
@RoutePage()
class GrowthPage extends BaseHookWidget {
  const GrowthPage({@PathParam('childId') required this.childId, super.key});

  final String childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return GrowthMobileView(childId: childId);
  }
}
