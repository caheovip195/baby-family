import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/family_tree/mobile/family_tree_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-09
@RoutePage()
class FamilyTreePage extends BaseHookWidget {
  const FamilyTreePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const FamilyTreeMobileView();
  }
}
