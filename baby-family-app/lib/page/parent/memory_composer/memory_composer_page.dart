import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/memory_composer/mobile/memory_composer_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-05
@RoutePage()
class MemoryComposerPage extends BaseHookWidget {
  const MemoryComposerPage({
    @QueryParam('kind') this.kind,
    @QueryParam('childId') this.childId,
    super.key,
  });

  final String? kind;
  final String? childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MemoryComposerMobileView(kind: kind, childId: childId);
  }
}
