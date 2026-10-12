import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Thanh tiến độ (Pencil HOME-01 “Today Card”, “Tree Mini”): cao 8, bo 4,
/// nền [trackColor] (mặc định `secondary-100`; trên thẻ cây dùng `surface`),
/// phần đã xong [color] (`secondary-500`).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    required this.value,
    this.height = 8,
    this.color = kColorSecondary5006FAE8E,
    this.trackColor = kColorSecondary100E4F2EA,
    super.key,
  });

  /// 0…1.
  final double value;
  final double height;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);
    return Semantics(
      value: '${(value.clamp(0, 1) * 100).round()}%',
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: AppColors.resolve(context, trackColor)),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value.clamp(0, 1).toDouble(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.resolve(context, color),
                    borderRadius: radius,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
