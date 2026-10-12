import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/children/mobile/children_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHD-03
@RoutePage()
class ChildrenPage extends BaseHookWidget {
  const ChildrenPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const ChildrenMobileView();
  }
}
