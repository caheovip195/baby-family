part of '../enum.dart';

/// Cỡ chữ trong app (SET-06 “Bình thường / Lớn / Rất lớn” — gợi ý cho ông bà).
/// [scale] nhân với cỡ chữ hệ thống (`appTextScaleProvider`).
enum AppTextSize {
  normal(1),
  large(1.15),
  extraLarge(1.3);

  const AppTextSize(this.scale);

  final double scale;

  /// Mức gần nhất với [value] (giá trị đang lưu trong provider).
  static AppTextSize fromScale(double value) => AppTextSize.values.reduce(
    (best, size) =>
        (size.scale - value).abs() < (best.scale - value).abs() ? size : best,
  );
}
