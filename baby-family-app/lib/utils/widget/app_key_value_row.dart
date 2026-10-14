import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Dòng “nhãn — giá trị” trong thẻ thông tin (Pencil SUB-03 “Info”, SUB-02
/// “Summary”): nhãn 13 `text-secondary` bên trái, giá trị 13/600
/// `text-primary` căn phải. [valueStyle] thay kiểu giá trị (SUB-02 “Giá”
/// 16/800 Nunito).
class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({
    required this.label,
    required this.value,
    this.valueStyle,
    super.key,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTypography.adapt(
            context,
            AppTypography.caption.copyWith(height: 16 / 13),
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.adapt(
              context,
              valueStyle ??
                  AppTypography.caption.copyWith(
                    height: 16 / 13,
                    fontWeight: FontWeight.w600,
                    color: kColorTextPrimary2E2A27,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
