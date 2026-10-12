import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/child_edit/mobile/child_edit_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHD-02
@RoutePage()
class ChildEditPage extends BaseHookWidget {
  const ChildEditPage({@PathParam('childId') required this.childId, super.key});

  final String childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return ChildEditMobileView(childId: childId);
  }
}
