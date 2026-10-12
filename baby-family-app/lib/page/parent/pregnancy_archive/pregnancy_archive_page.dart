import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/pregnancy_archive/mobile/pregnancy_archive_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// PREG-06
@RoutePage()
class PregnancyArchivePage extends BaseHookWidget {
  const PregnancyArchivePage({
    @PathParam('pregnancyId') required this.pregnancyId,
    super.key,
  });

  final String pregnancyId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return PregnancyArchiveMobileView(pregnancyId: pregnancyId);
  }
}
