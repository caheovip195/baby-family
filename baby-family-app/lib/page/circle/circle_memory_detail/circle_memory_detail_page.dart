import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_memory_detail/mobile/circle_memory_detail_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-03
@RoutePage()
class CircleMemoryDetailPage extends BaseHookWidget {
  const CircleMemoryDetailPage({
    @PathParam('memoryId') required this.memoryId,
    super.key,
  });

  final String memoryId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return CircleMemoryDetailMobileView(memoryId: memoryId);
  }
}
