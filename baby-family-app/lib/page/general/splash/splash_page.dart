import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/general/splash/mobile/splash_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SPL-01 — màn khởi động: tải phiên rồi điều hướng theo `routeForSession`
/// (fresh → Welcome, active → Main shell, circle → CIR-01, expired → SUB-07…).
@RoutePage()
class SplashPage extends BaseHookWidget {
  const SplashPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const SplashMobileView();
  }
}
