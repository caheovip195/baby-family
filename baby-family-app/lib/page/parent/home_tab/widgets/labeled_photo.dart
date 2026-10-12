part of '../mobile/home_tab_mobile_view.dart';

/// Cột ảnh + nhãn ngắn 10/600 (“1 th”, “T20”) của hàng ảnh tháng / ảnh bụng.
/// Không có [asset] → ô chụp tiếp theo: viền 1.5 [accent], nền [emptyColor],
/// nội dung [empty], nhãn 10/700 [accent].
class _LabeledPhoto extends StatelessWidget {
  const _LabeledPhoto({
    required this.label,
    required this.height,
    required this.radius,
    required this.onTap,
    this.asset,
    this.empty,
    this.accent = kColorSecondary7003F7A5C,
    this.emptyBorder = kColorSecondary5006FAE8E,
    this.emptyColor,
  });

  final String label;
  final String? asset;
  final double height;
  final double radius;
  final VoidCallback onTap;
  final Widget? empty;
  final Color accent;
  final Color emptyBorder;
  final Color? emptyColor;

  @override
  Widget build(BuildContext context) {
    final photo = asset;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          if (photo != null)
            _Photo(asset: photo, height: height, radius: radius)
          else
            Container(
              height: height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: emptyColor == null
                    ? null
                    : AppColors.resolve(context, emptyColor!),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: AppColors.resolve(context, emptyBorder),
                  width: 1.5,
                ),
              ),
              child: empty,
            ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.adapt(
              context,
              AppTypography.micro.copyWith(
                fontWeight: photo == null ? FontWeight.w700 : FontWeight.w600,
                color: photo == null ? accent : kColorTextSecondary6B625B,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hàng cột ảnh đều nhau cách 6.
Widget _photoRow(List<Widget> items) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (var index = 0; index < items.length; index++) ...[
      if (index > 0) const SizedBox(width: AppSpacing.compact),
      Expanded(child: items[index]),
    ],
  ],
);
