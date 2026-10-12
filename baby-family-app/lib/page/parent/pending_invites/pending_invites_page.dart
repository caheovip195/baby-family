import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/pending_invites/mobile/pending_invites_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-05
@RoutePage()
class PendingInvitesPage extends BaseHookWidget {
  const PendingInvitesPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const PendingInvitesMobileView();
  }
}
