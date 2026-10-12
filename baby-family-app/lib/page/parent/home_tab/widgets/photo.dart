part of '../mobile/home_tab_mobile_view.dart';

/// Ảnh asset bo góc dùng trong các khối Trang chủ.
class _Photo extends StatelessWidget {
  const _Photo({
    required this.asset,
    required this.height,
    required this.radius,
    this.width,
    this.overlay,
  });

  final String asset;
  final double height;
  final double? width;
  final double radius;

  /// Lớp phủ (ví dụ “+3”).
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => ColoredBox(
                color: AppColors.resolve(context, kColorSurfaceVariantF7F1EC),
              ),
            ),
            ?overlay,
          ],
        ),
      ),
    );
  }
}
