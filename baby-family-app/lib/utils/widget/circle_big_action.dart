import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Nút lớn cho ông bà (Pencil CIR-01 `fMmVj`, CIR-03 “Actions”): cao 64, bo
/// 16, icon 26 + chữ 18/700 — “Thả tim” / “Đã thả tim” / “Gửi lời chúc”.
class CircleBigAction extends StatelessWidget {
  const CircleBigAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.foreground,
    required this.onTap,
    this.onLongPress,
    this.filled = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color foreground;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  /// Đã thả tim: icon tô đầy.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.resolve(context, foreground);
    return Semantics(
      button: true,
      selected: filled,
      child: Material(
        color: AppColors.resolve(context, color),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s2,
                vertical: AppSpacing.s2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 26, color: fg, fill: filled ? 1 : 0),
                  const SizedBox(width: AppSpacing.itemGap),
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTypography.h3.copyWith(
                        fontFamily: AppTypography.bodyFamily,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
