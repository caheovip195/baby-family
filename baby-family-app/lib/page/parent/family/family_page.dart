import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/family/mobile/family_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-01
@RoutePage()
class FamilyPage extends BaseHookWidget {
  const FamilyPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const FamilyMobileView();
  }
}
