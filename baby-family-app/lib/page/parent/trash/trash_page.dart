import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/trash/mobile/trash_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-17
@RoutePage()
class TrashPage extends BaseHookWidget {
  const TrashPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const TrashMobileView();
  }
}
