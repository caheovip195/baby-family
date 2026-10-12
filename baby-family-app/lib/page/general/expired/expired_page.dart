import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/expired/mobile/expired_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SUB-07
@RoutePage()
class ExpiredPage extends BaseHookWidget {
  const ExpiredPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const ExpiredMobileView();
  }
}
