import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/relative_invite/mobile/relative_invite_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-03
@RoutePage()
class RelativeInvitePage extends BaseHookWidget {
  const RelativeInvitePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const RelativeInviteMobileView();
  }
}
