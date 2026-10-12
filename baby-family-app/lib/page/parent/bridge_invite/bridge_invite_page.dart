import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/bridge_invite/mobile/bridge_invite_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-10
@RoutePage()
class BridgeInvitePage extends BaseHookWidget {
  const BridgeInvitePage({
    @PathParam('sessionId') required this.sessionId,
    super.key,
  });

  final String sessionId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return BridgeInviteMobileView(sessionId: sessionId);
  }
}
