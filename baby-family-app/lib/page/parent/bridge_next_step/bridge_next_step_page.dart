import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/bridge_next_step/mobile/bridge_next_step_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-12
@RoutePage()
class BridgeNextStepPage extends BaseHookWidget {
  const BridgeNextStepPage({
    @PathParam('sessionId') required this.sessionId,
    super.key,
  });

  final String sessionId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return BridgeNextStepMobileView(sessionId: sessionId);
  }
}
