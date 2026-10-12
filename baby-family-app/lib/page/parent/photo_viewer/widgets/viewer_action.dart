part of '../mobile/photo_viewer_mobile_view.dart';

/// Nút thanh hành động MEM-08 (`fn1AY`): icon 22 trắng + nhãn 11/500
/// `#FFFFFFCC`, cách 6.
class _ViewerAction extends StatelessWidget {
  const _ViewerAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: filled,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: filled ? kColorPrimary500EE7B67 : kColorWhite,
            ),
            const SizedBox(height: AppSpacing.compact),
            Text(
              label,
              style: AppTypography.tiny.copyWith(
                fontWeight: FontWeight.w500,
                color: kColorWhiteAlpha80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
