import 'package:baby_family/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CircleLoadingProgress extends StatelessWidget {
  const CircleLoadingProgress({
    super.key,
    this.color = kColorPrimary600C2513F,
    this.width = 2,
    this.size = 20,
  });

  final Color? color;
  final double width;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(color: color, strokeWidth: width),
    );
  }
}
