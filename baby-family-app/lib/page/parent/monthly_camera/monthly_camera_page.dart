import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/monthly_camera/mobile/monthly_camera_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-21
@RoutePage()
class MonthlyCameraPage extends BaseHookWidget {
  const MonthlyCameraPage({
    @PathParam('childId') required this.childId,
    @QueryParam('month') this.month,
    super.key,
  });

  final String childId;
  final int? month;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MonthlyCameraMobileView(childId: childId, month: month);
  }
}
