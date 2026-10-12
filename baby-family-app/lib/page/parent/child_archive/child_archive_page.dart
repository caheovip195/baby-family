import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/child_archive/mobile/child_archive_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CHD-05
@RoutePage()
class ChildArchivePage extends BaseHookWidget {
  const ChildArchivePage({
    @PathParam('childId') required this.childId,
    super.key,
  });

  final String childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return ChildArchiveMobileView(childId: childId);
  }
}
