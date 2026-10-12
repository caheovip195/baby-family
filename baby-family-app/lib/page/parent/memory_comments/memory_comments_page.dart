import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/memory_comments/mobile/memory_comments_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-10
@RoutePage()
class MemoryCommentsPage extends BaseHookWidget {
  const MemoryCommentsPage({
    @PathParam('memoryId') required this.memoryId,
    super.key,
  });

  final String memoryId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MemoryCommentsMobileView(memoryId: memoryId);
  }
}
