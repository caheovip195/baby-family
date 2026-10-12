import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/badges/mobile/badges_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CARE-10
@RoutePage()
class BadgesPage extends BaseHookWidget {
  const BadgesPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const BadgesMobileView();
  }
}
