import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/about/mobile/about_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-12
@RoutePage()
class AboutPage extends BaseHookWidget {
  const AboutPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const AboutMobileView();
  }
}
