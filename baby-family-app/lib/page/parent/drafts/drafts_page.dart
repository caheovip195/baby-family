import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/drafts/mobile/drafts_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// MEM-18
@RoutePage()
class DraftsPage extends BaseHookWidget {
  const DraftsPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const DraftsMobileView();
  }
}
