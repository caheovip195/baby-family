import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Dòng icon + đoạn chữ căn trên (Pencil SUB-02 “Points” check 16
/// `success`, INV-02 “Tip” 18 `primary-600`, SET-05 “Data” 16 `us-700`):
/// cách [gap], chữ 13 dòng [lineHeight] màu [textColor].
class AppIconTextRow extends StatelessWidget {
  const AppIconTextRow({
    required this.icon,
    required this.text,
    this.iconColor = kColorSuccess3E9B6E,
    this.iconSize = 16,
    this.textColor = kColorTextPrimary2E2A27,
    this.lineHeight = 1.4,
    this.gap = AppSpacing.s2,
    super.key,
  });

  final IconData icon;
  final String text;
  final Color iconColor;
  final double iconSize;
  final Color textColor;
  final double lineHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            icon,
            size: iconSize,
            color: AppColors.resolve(context, iconColor),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: Text(
            text,
            style: AppTypography.adapt(
              context,
              AppTypography.caption.copyWith(
                height: lineHeight,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
