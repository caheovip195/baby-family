import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/circle/circle_shell/mobile/circle_shell_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Circle shell người thân: 4 tab Cháu yêu (CIR-01) · Ký ức (CIR-02) ·
/// Đăng ảnh (CIR-04) · Tôi (CIR-06) — Pencil TabBar `LXpog`.
@RoutePage()
class CircleShellPage extends BaseHookWidget {
  const CircleShellPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const CircleShellMobileView();
  }
}
