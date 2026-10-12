import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/partner_invite/mobile/partner_invite_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-02
@RoutePage()
class PartnerInvitePage extends BaseHookWidget {
  const PartnerInvitePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const PartnerInviteMobileView();
  }
}
