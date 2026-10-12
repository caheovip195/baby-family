part of '../mobile/monthly_camera_mobile_view.dart';

/// Nút/nhãn trên camera (`qMZ7T`, `KuYov`, `X0eGS`): nền `#00000066`, bo
/// tròn, chữ trắng 12–13; [_CameraPill.icon] — nút tròn [size] với icon.
class _CameraPill extends StatelessWidget {
  const _CameraPill({
    required this.label,
    this.icon,
    this.height = 40,
    this.bold = false,
    this.onTap,
  }) : size = null,
       iconSize = 14,
       background = kColorBlackAlpha40,
       _round = false;

  const _CameraPill.icon({
    required IconData this.icon,
    required this.label,
    this.onTap,
    this.iconSize = 20,
    this.size = 40,
    this.background = kColorBlackAlpha40,
  }) : height = 40,
       bold = false,
       _round = true;

  final String label;
  final IconData? icon;
  final double height;
  final double? size;
  final double iconSize;
  final bool bold;
  final Color background;
  final VoidCallback? onTap;
  final bool _round;

  @override
  Widget build(BuildContext context) {
    if (_round) {
      return Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: iconSize, color: kColorWhite),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: height),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s1,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize, color: kColorWhite),
              const SizedBox(width: AppSpacing.s2),
            ],
            Flexible(
              child: Text(
                label,
                style: (bold ? AppTypography.caption : AppTypography.small)
                    .copyWith(
                      fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                      color: kColorWhite,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
