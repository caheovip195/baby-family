import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/day_story/mobile/day_story_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-01
@RoutePage()
class DayStoryPage extends BaseHookWidget {
  const DayStoryPage({@QueryParam('childId') this.childId, super.key});

  final String? childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return DayStoryMobileView(childId: childId);
  }
}
