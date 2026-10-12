import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/auth/mobile/auth_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AUTH-01
@RoutePage()
class AuthPage extends BaseHookWidget {
  const AuthPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const AuthMobileView();
  }
}
