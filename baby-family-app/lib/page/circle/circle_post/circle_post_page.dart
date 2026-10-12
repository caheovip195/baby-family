import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_post/mobile/circle_post_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// CIR-04
@RoutePage()
class CirclePostPage extends BaseHookWidget {
  const CirclePostPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CirclePostMobileView();
  }
}
