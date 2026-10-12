import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/memories_tab/mobile/memories_tab_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-01
@RoutePage()
class MemoriesTabPage extends BaseHookWidget {
  const MemoriesTabPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const MemoriesTabMobileView();
  }
}
