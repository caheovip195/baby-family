part of '../mobile/photo_viewer_mobile_view.dart';

/// Chấm trang (`zNW5F`): chấm 6 `#FFFFFF59`, chấm đang xem 8 trắng, cách 6.
class _ViewerDots extends StatelessWidget {
  const _ViewerDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var dot = 0; dot < count; dot++) ...[
          if (dot > 0) const SizedBox(width: AppSpacing.compact),
          Container(
            width: dot == index ? 8 : 6,
            height: dot == index ? 8 : 6,
            decoration: BoxDecoration(
              color: dot == index ? kColorWhite : kColorWhiteAlpha35,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}
