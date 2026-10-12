import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/birth/mobile/birth_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// PREG-05
@RoutePage()
class BirthPage extends BaseHookWidget {
  const BirthPage({
    @PathParam('pregnancyId') required this.pregnancyId,
    super.key,
  });

  final String pregnancyId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return BirthMobileView(pregnancyId: pregnancyId);
  }
}
