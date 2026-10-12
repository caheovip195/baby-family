import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/auth_profile/mobile/auth_profile_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AUTH-04
@RoutePage()
class AuthProfilePage extends BaseHookWidget {
  const AuthProfilePage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const AuthProfileMobileView();
  }
}
