import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/thanks_compose/mobile/thanks_compose_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-05
@RoutePage()
class ThanksComposePage extends BaseHookWidget {
  const ThanksComposePage({@QueryParam('missionId') this.missionId, super.key});

  final String? missionId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return ThanksComposeMobileView(missionId: missionId);
  }
}
