import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/month_recap/mobile/month_recap_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// REC-03
@RoutePage()
class MonthRecapPage extends BaseHookWidget {
  const MonthRecapPage({@QueryParam('childId') this.childId, super.key});

  final String? childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MonthRecapMobileView(childId: childId);
  }
}
