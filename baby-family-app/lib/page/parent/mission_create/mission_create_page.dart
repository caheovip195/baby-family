import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/mission_create/mobile/mission_create_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-03
@RoutePage()
class MissionCreatePage extends BaseHookWidget {
  const MissionCreatePage({
    @QueryParam('childId') this.childId,
    @QueryParam('templateId') this.templateId,
    super.key,
  });

  final String? childId;
  final String? templateId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MissionCreateMobileView(childId: childId, templateId: templateId);
  }
}
