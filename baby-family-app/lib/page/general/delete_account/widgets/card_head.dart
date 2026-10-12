part of '../mobile/delete_account_mobile_view.dart';

/// Đầu thẻ (Pencil “Head” `avKQO`): ô icon 36 bo 11 (icon 18) + tiêu đề
/// 17/800 Nunito, cách 12.
class _CardHead extends StatelessWidget {
  const _CardHead({
    required this.icon,
    required this.title,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String title;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIconBadge(
          icon: icon,
          size: 36,
          iconSize: 18,
          radius: AppRadius.sm,
          color: background,
          foreground: foreground,
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Text(
            title,
            style: AppTypography.adapt(context, AppTypography.title17),
          ),
        ),
      ],
    );
  }
}
