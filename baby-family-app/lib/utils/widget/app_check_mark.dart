import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

/// Ô đánh dấu vuông bo 6 (Pencil CHD-05b “Checkbox” 22 nền `primary-600` +
/// `check` trắng 14; RPT-02 “Checkbox” 20 nền `surface` viền `#9A6A12`).
class AppCheckMark extends StatelessWidget {
  const AppCheckMark({
    required this.checked,
    this.size = 22,
    this.borderColor = kColorBorderEADFD6,
    super.key,
  });

  final bool checked;
  final double size;

  /// Viền khi chưa chọn.
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final active = AppColors.resolve(context, kColorPrimary600C2513F);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: checked
            ? active
            : AppColors.resolve(context, kColorSurfaceFFFFFF),
        borderRadius: BorderRadius.circular(6),
        border: checked
            ? null
            : Border.all(color: AppColors.resolve(context, borderColor)),
      ),
      child: checked
          ? Icon(
              LucideIcons.check,
              size: size * 0.64,
              color: AppColors.onPrimary(context),
            )
          : null,
    );
  }
}
