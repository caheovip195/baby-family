import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/memory_detail/mobile/memory_detail_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-07
@RoutePage()
class MemoryDetailPage extends BaseHookWidget {
  const MemoryDetailPage({
    @PathParam('memoryId') required this.memoryId,
    super.key,
  });

  final String memoryId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MemoryDetailMobileView(memoryId: memoryId);
  }
}
