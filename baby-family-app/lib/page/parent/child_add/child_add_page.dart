import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/child_add/mobile/child_add_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHD-04
@RoutePage()
class ChildAddPage extends BaseHookWidget {
  const ChildAddPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const ChildAddMobileView();
  }
}
