import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/thanks_wall/mobile/thanks_wall_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-06
@RoutePage()
class ThanksWallPage extends BaseHookWidget {
  const ThanksWallPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const ThanksWallMobileView();
  }
}
