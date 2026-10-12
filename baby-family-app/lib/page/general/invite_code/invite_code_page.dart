import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/invite_code/mobile/invite_code_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// INV-05
@RoutePage()
class InviteCodePage extends BaseHookWidget {
  const InviteCodePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const InviteCodeMobileView();
  }
}
