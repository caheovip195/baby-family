import 'package:baby_family/utils/constants/colors.dart';
import 'package:baby_family/utils/helper/theme.dart';
import 'package:flutter/material.dart';

/// Khối xương (Pencil STATE-01 `DovV2`): hình chữ nhật `surface-variant`, bo
/// [radius] (8 cho dòng chữ, tròn cho avatar/chip). Nhấp nháy nhẹ.
class SkeletonBlock extends StatefulWidget {
  const SkeletonBlock({
    this.width,
    this.height = 14,
    this.radius = 8,
    super.key,
  });

  /// null → giãn hết chiều ngang.
  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBlock> createState() => _SkeletonBlockState();
}

class _SkeletonBlockState extends State<SkeletonBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
    lowerBound: 0.55,
    value: 1,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect “reduce motion” (and keeps widget tests / goldens settled).
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
