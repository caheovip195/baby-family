import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Nút icon vuông 40×40 (Pencil FAM-01 “Settings”, SUB-01 “Close”): nền
/// `surface`, viền `border` 1, bo 12, icon 20 `text-secondary`. Vùng chạm
/// được nới tới 48 (Skill 8).
class AppSquareIconButton extends StatelessWidget {
  const AppSquareIconButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: InkResponse(
          onTap: onPressed,
          radius: AppSpacing.minTouchTarget / 2,
          child: SizedBox.square(
            dimension: AppSpacing.minTouchTarget,
            child: Center(
              child: Container(
                width: AppSpacing.s10,
                height: AppSpacing.s10,
                decoration: BoxDecoration(
                  color: AppColors.resolve(context, kColorSurfaceFFFFFF),
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                  border: Border.all(
                    color: AppColors.resolve(context, kColorBorderEADFD6),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.resolve(context, kColorTextSecondary6B625B),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
