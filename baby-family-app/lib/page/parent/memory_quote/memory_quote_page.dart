import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/memory_quote/mobile/memory_quote_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-23
@RoutePage()
class MemoryQuotePage extends BaseHookWidget {
  const MemoryQuotePage({@QueryParam('childId') this.childId, super.key});

  final String? childId;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return MemoryQuoteMobileView(childId: childId);
  }
}
