import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/bridge_rewrite/mobile/bridge_rewrite_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-09
@RoutePage()
class BridgeRewritePage extends BaseHookWidget {
  const BridgeRewritePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const BridgeRewriteMobileView();
  }
}
