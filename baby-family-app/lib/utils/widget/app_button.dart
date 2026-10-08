import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/constants/enum.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

import 'loading_progress.dart';

/// Nút chính — cao 52, bo 16, nền `kColorPrimary600C2513F`, chữ trắng.
/// Dùng [AppButton.secondary] cho nút viền, [AppButton.us] trong Papa & Mama.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
  }) : _style = AppButtonStyle.primary;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
  }) : _style = AppButtonStyle.secondary;

  const AppButton.us({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
  }) : _style = AppButtonStyle.us;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final AppButtonStyle _style;

  @override
  Widget build(BuildContext context) {
    final foreground = _style == AppButtonStyle.secondary
        ? kColorPrimary600C2513F
        : kColorWhite;
    final child = isLoading
        ? CircleLoadingProgress(color: foreground)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: AppSpacing.s2),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(color: foreground),
                ),
              ),
            ],
          );
    final action = isLoading ? null : onPressed;
    switch (_style) {
      case AppButtonStyle.secondary:
        return OutlinedButton(onPressed: action, child: child);
      case AppButtonStyle.us:
        return FilledButton(
          onPressed: action,
          style: FilledButton.styleFrom(backgroundColor: kColorUs7006A549F),
          child: child,
        );
      case AppButtonStyle.primary:
        return FilledButton(onPressed: action, child: child);
    }
  }
}
