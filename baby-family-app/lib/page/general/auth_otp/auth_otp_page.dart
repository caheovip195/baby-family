import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/auth_otp/mobile/auth_otp_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AUTH-03
@RoutePage()
class AuthOtpPage extends BaseHookWidget {
  const AuthOtpPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const AuthOtpMobileView();
  }
}
