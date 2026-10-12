import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Ô ghi chú có icon (Pencil FAM-04/SET-04 “Note”, SET-09 “Note”, SET-09b
/// “Export Tip”): đệm 12, cách 10, bo `radius-md`; icon 18 + chữ 12 (dòng 1.4)
/// `text-secondary`. Mặc định tông tím Papa & Mama (`us-50`/`us-700`).
class AppInfoNote extends StatelessWidget {
  const AppInfoNote({
    required this.icon,
    required this.text,
    this.background = kColorUs50F6F2FC,
    this.iconColor = kColorUs7006A549F,
    super.key,
  });

  final IconData icon;
  final String text;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, background),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.resolve(context, iconColor)),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Text(
              text,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
