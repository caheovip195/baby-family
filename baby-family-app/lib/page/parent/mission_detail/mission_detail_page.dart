import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/mission_detail/mobile/mission_detail_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-02
@RoutePage()
class MissionDetailPage extends BaseHookWidget {
  const MissionDetailPage({
    @PathParam('missionId') required this.missionId,
    super.key,
  });

  final String missionId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MissionDetailMobileView(missionId: missionId);
  }
}
