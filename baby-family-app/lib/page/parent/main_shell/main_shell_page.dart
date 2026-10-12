import 'package:auto_route/auto_route.dart';
import 'package:baby_family/page/application_base.dart';
import 'package:baby_family/page/parent/main_shell/mobile/main_shell_mobile_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Main shell: 4 tab (Trang chủ, Ký ức, Chăm con, Papa & Mama) + FAB tạo
/// nhanh QC-01 (Pencil TabBar `luKhc`, sheet `IWfKB`). Trạng thái từng tab được
/// giữ (AutoTabsRouter).
@RoutePage()
class MainShellPage extends BaseHookWidget {
  const MainShellPage({super.key});

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return const MainShellMobileView();
  }
}
