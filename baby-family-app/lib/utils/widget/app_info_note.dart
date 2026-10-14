import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Ô ghi chú có icon (Pencil FAM-04/SET-04 “Note”, SET-09 “Note”, SET-09b
/// “Export Tip”): đệm 12, cách 10, bo `radius-md`; icon 18 + chữ 12 (dòng 1.4)
/// `text-secondary`. Mặc định tông tím Papa & Mama (`us-50`/`us-700`).
/// Ghi chú nhiều dòng của batch 3 (SUB-03, SET-13, FAM-08 “Note”): icon 16
/// căn trên ([alignTop]), dòng chữ 1.45 ([lineHeight]).
class AppInfoNote extends StatelessWidget {
  const AppInfoNote({
    required this.icon,
    required this.text,
    this.background = kColorUs50F6F2FC,
    this.iconColor = kColorUs7006A549F,
    this.iconSize = 18,
    this.lineHeight = 1.4,
    this.alignTop = false,
    super.key,
  });

  final IconData icon;
  final String text;
  final Color background;
  final Color iconColor;
  final double iconSize;
  final double lineHeight;
  final bool alignTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.resolve(context, background),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: alignTop
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: alignTop ? 1 : 0),
            child: Icon(
              icon,
              size: iconSize,
              color: AppColors.resolve(context, iconColor),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Text(
              text,
              style: AppTypography.adapt(
                context,
                AppTypography.small.copyWith(height: lineHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
