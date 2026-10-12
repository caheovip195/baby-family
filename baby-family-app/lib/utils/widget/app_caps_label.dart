import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Nhãn nhóm viết hoa (Pencil FAM-01 “PAPA & MAMA”, SET-06 “NGÔN NGỮ”):
/// 13/700, giãn chữ 0.4, `text-secondary`. Nhận chuỗi l10n thường và tự viết
/// hoa theo ngôn ngữ hiện tại.
class AppCapsLabel extends StatelessWidget {
  const AppCapsLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text.toUpperCase(),
        style: AppTypography.adapt(
          context,
          AppTypography.caption.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: kColorTextSecondary6B625B,
          ),
        ),
      ),
    );
  }
}
