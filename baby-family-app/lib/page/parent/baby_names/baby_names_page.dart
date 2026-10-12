import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/baby_names/mobile/baby_names_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// PREG-07
@RoutePage()
class BabyNamesPage extends BaseHookWidget {
  const BabyNamesPage({
    @PathParam('pregnancyId') required this.pregnancyId,
    super.key,
  });

  final String pregnancyId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return BabyNamesMobileView(pregnancyId: pregnancyId);
  }
}
