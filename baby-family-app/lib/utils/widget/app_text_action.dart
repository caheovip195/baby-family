import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Nút chữ ở ô phải của `AppTopBar` (Pencil TopBar `qhcBT` slot `U03eeM`: cao
/// 44, đệm ngang 8): “Dừng lại” / “Tạm dừng” 13/700 `us-700` (US-08/09/12),
/// “Bỏ” 14/700 `text-secondary` (REC-01).
class AppTextAction extends StatelessWidget {
  const AppTextAction({
    required this.label,
    required this.onPressed,
    this.color = kColorUs7006A549F,
    this.fontSize = 13,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        height: AppSpacing.iconButton,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.resolve(context, color),
          ),
        ),
      ),
    );
  }
}
