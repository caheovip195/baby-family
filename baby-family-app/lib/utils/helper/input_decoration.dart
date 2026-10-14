import 'package:flutter/material.dart';

/// Ô nhập không viền, không nền (chữ nằm trong khung tự vẽ theo Pencil:
/// RPT-01 “Mô tả thêm”, CHD-05b ô tên, CIR-03/04 lời chúc / lời nhắn). Bỏ mọi
/// viền của `inputDecorationTheme` kể cả khi đang focus.
InputDecoration bareInputDecoration({
  String? hint,
  TextStyle? hintStyle,
  int hintMaxLines = 1,
}) =>
    InputDecoration(
      isCollapsed: true,
      filled: false,
      hintText: hint,
      hintStyle: hintStyle,
      hintMaxLines: hintMaxLines,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
