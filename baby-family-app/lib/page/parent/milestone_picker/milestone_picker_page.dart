import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/milestone_picker/mobile/milestone_picker_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-11
@RoutePage()
class MilestonePickerPage extends BaseHookWidget {
  const MilestonePickerPage({@QueryParam('childId') this.childId, super.key});

  final String? childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MilestonePickerMobileView(childId: childId);
  }
}
