import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/memory_story/mobile/memory_story_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-25
@RoutePage()
class MemoryStoryPage extends BaseHookWidget {
  const MemoryStoryPage({
    @PathParam('childId') required this.childId,
    super.key,
  });

  final String childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MemoryStoryMobileView(childId: childId);
  }
}
