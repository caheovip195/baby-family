import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/my_data/mobile/my_data_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SET-08
@RoutePage()
class MyDataPage extends BaseHookWidget {
  const MyDataPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const MyDataMobileView();
  }
}
