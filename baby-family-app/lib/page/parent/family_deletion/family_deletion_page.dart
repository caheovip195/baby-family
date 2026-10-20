import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/family_deletion/mobile/family_deletion_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// FAM-07 “Xoá gia đình” (mục 7.25).
@RoutePage()
class FamilyDeletionPage extends BaseHookWidget {
  const FamilyDeletionPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const FamilyDeletionMobileView();
  }
}
