import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/auth_phone/mobile/auth_phone_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AUTH-02
@RoutePage()
class AuthPhonePage extends BaseHookWidget {
  const AuthPhonePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const AuthPhoneMobileView();
  }
}
