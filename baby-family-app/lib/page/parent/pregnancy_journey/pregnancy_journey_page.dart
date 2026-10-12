import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/pregnancy_journey/mobile/pregnancy_journey_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// PREG-01
@RoutePage()
class PregnancyJourneyPage extends BaseHookWidget {
  const PregnancyJourneyPage({
    @PathParam('pregnancyId') required this.pregnancyId,
    @QueryParam('tab') this.tab,
    super.key,
  });

  final String pregnancyId;
  final String? tab;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return PregnancyJourneyMobileView(pregnancyId: pregnancyId, tab: tab);
  }
}
