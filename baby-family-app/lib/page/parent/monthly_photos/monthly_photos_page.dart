import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/monthly_photos/mobile/monthly_photos_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-20
@RoutePage()
class MonthlyPhotosPage extends BaseHookWidget {
  const MonthlyPhotosPage({
    @PathParam('childId') required this.childId,
    super.key,
  });

  final String childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MonthlyPhotosMobileView(childId: childId);
  }
}
