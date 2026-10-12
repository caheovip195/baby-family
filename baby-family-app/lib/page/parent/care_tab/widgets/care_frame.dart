part of '../mobile/care_tab_mobile_view.dart';

/// Nền + vùng an toàn trên của tab (shell vẽ thanh tab ở dưới).
class _CareFrame extends StatelessWidget {
  const _CareFrame({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.resolve(context, kColorBgFFFBF7),
    child: SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    ),
  );
}
