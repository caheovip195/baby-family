part of '../mobile/calendar_mobile_view.dart';

/// Hàng chấm 5×5 cách 3 (trên ô đang chọn: chấm trắng).
class _CalendarDots extends StatelessWidget {
  const _CalendarDots({required this.dots, this.inverted = false});

  final List<CalendarDot> dots;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, dot) in dots.indexed) ...[
            if (index > 0) const SizedBox(width: 3),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: inverted
                    ? kColorWhite
                    : AppColors.resolve(context, _dotColor(dot)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
