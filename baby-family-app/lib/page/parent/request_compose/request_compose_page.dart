import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/request_compose/mobile/request_compose_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// US-03
@RoutePage()
class RequestComposePage extends BaseHookWidget {
  const RequestComposePage({@QueryParam('title') this.title, super.key});

  final String? title;

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return RequestComposeMobileView(title: title);
  }
}
