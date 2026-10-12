import 'package:baby_family/utils/helper/theme.dart';
import 'package:baby_family/utils/widget/base_scaffold.dart';
import 'package:flutter/material.dart';

/// Khung màn của luồng đăng nhập/onboarding/lời mời (Pencil AUTH-02…ONB-10,
/// INV-05/01, CIR-WAIT): [topBar] (thường là `AppTopBar`) + cột nội dung đệm
/// `[top, 20, 24, 20]` cách nhau [gap]; [actions] luôn nằm sát đáy (sau một
/// khoảng giãn như node “Spacer” của Pencil) và cuộn theo nội dung khi chữ
/// lớn/màn hẹp nên không bao giờ tràn.
class AppStepScaffold extends StatelessWidget {
  const AppStepScaffold({
    required this.children,
    this.actions = const [],
    this.topBar,
    this.gap = AppSpacing.s6,
    this.actionGap = AppSpacing.s2,
    this.topPadding = AppSpacing.s2,
    this.backgroundColor,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    super.key,
  });

  final List<Widget> children;

  /// Nút cuối màn (nút chính, nút phụ, link) — xếp dọc cách nhau [actionGap].
  final List<Widget> actions;
  final PreferredSizeWidget? topBar;

  /// Khoảng cách giữa các khối nội dung (Pencil `Content.gap`).
  final double gap;
  final double actionGap;

  /// Đệm trên của nội dung (8 khi có thanh trên, 16/40 với màn không có).
  final double topPadding;
  final Color? backgroundColor;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return BaseScaffold(
      appBar: topBar,
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: topBar == null,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                topPadding,
                AppSpacing.screen,
                AppSpacing.s6 + bottomInset,
              ),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    for (var i = 0; i < children.length; i++) ...[
                      if (i > 0) SizedBox(height: gap),
                      children[i],
                    ],
                    if (actions.isNotEmpty) ...[
                      SizedBox(height: gap),
                      const Spacer(),
                      SizedBox(height: gap),
                      for (var i = 0; i < actions.length; i++) ...[
                        if (i > 0) SizedBox(height: actionGap),
                        actions[i],
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
