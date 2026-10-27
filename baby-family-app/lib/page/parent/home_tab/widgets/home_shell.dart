part of '../mobile/home_tab_mobile_view.dart';

/// App bar HOME-01/03 + băng offline + nội dung (loading/lỗi).
class _HomeShell extends StatelessWidget {
  const _HomeShell({
    required this.controller,
    required this.offline,
    required this.child,
  });

  final HomeTabController controller;
  final bool offline;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _HomeAppBar(controller: controller),
          if (offline)
            OfflineBanner(
              pendingUploads: controller.pendingSync,
              onRetry: controller.load,
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
