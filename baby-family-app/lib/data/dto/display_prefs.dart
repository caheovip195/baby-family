import 'package:flutter/material.dart';

/// SET-06 hiển thị của tôi: giao diện, cỡ chữ (1…2), ngày âm lịch.
class DisplayPrefs {
  const DisplayPrefs({
    this.theme = ThemeMode.system,
    this.textScale = 1,
    this.showLunar = true,
  });

  final ThemeMode theme;
  final double textScale;
  final bool showLunar;
}
